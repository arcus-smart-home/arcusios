//
//  WSSExternalSettingsInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/2/18.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt
import Cornea

class WSSExternalSettingsInfoViewController: UIViewController, WSSPairingPresenter {
  // MARK: - WSSPairingPresenter Properties
  var client: WSSConfigurator = RxSwannSmartSwitchConfigClient()
  var pairingSubsystemProvider: ArcusModelProvider<SubsystemModel> = {
    let modelCache = RxCornea.shared.modelCache as! RxArcusModelCache
    return ArcusModelProvider<SubsystemModel>(SubsystemCache.sharedInstance.pairingSubsystem(),
                                             modelCache: modelCache)!
  }()
  var config: ArcusWiFiNetworkConfig = WSSNetworkConfig()
  var disposeBag: DisposeBag = DisposeBag()

  // MARK: - PairingStepsPresenter
  fileprivate var step: ArcusPairingStepViewModel?
  fileprivate var presenter: PairingStepsPresenter?

  weak var customStepDelegate: PairingStepsCustomStepDelegate?

  var pairingEnabled: Variable<Bool> = Variable<Bool>(true)

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: PairingStepsPresenter) -> WSSExternalSettingsInfoViewController? {
    let storyboard = UIStoryboard(name: "WifiSmartSwitchPairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "WSSExternalSettingsInfoViewController")
      as? WSSExternalSettingsInfoViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel,
        let config = step.config as? ArcusWiFiNetworkConfig {
        vc.config = config
      }
      return vc
    }
    return nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set the PairingStepsCustomStepDelegate
    if let presenterDelegate = presenter?.customStepDelegate as? PairingStepsCustomStepDelegate {
      customStepDelegate = presenterDelegate
    }

    // Configure Rx Observers and Bindings.
    configureBindings()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if pairingEnabled.value == true {
      // Prevent the app from routing away from this VC while attempting pairing.
      CorneaController.suspendRouting(true)

      // Disconnect the session's socket, but prevent session from becoming inaactive.
      RxCornea.shared.session?.suspend()
    }

    // Disable paging until the user backgrounds the app.
    pairingEnabled.value = false
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if isMovingFromParentViewController {
      // Re-enable paging.
      pairingEnabled.value = true

      // Re-enable the current session
      if let session = RxCornea.shared.session as? RxSwiftSession {
        session.resumeSession().subscribe(onSuccess: { _ in
          // Re-enable Application Routing.
          CorneaController.suspendRouting(false)
        }).disposed(by: disposeBag)
      }
    }
  }

  // MARK: - Configuration/Binding Methods

  func configureBindings() {
    observeApplicationEvents(ApplicationServiceEventPublisher.shared)

    bindPagingEnabled()
    bindAttemptPairing()
  }

  private func bindPagingEnabled() {
    if let delegate = customStepDelegate {
      pairingEnabled
        .asObservable()
        .bind(to: delegate.pagingEnabled)
        .disposed(by: disposeBag)
    }
  }

  private func bindAttemptPairing() {
    if let delegate = customStepDelegate {
      delegate.shouldAttemptPairing
        .asObservable()
        .subscribe(onNext: { [weak self, config] attemptPairing in
          if attemptPairing {
            self?.attemptPairing(config)
          }
        }).disposed(by: disposeBag)
    }
  }

  // MARK: - IBActions

  @IBAction func needHelpPressed(_ sender: AnyObject) {
    UIApplication.shared.openURL(NSURL.SupportWifiSmartSwitch)
  }

  fileprivate func handlePairingError(_ error: (Error)) -> String {
    if let error = error as? WSSConfigError, error.type == .badMessage {
      // Show Connection Error if Switch returns a badmessage Response.
      return PairingStepSegues.segueToWSSCheckWifiErrorPopover.rawValue
    } else if let error = error as? ClientError {
      if error.code == "request.destination.notfound" {
        // If the Device was not found, show Connection Error.
       return PairingStepSegues.segueToWSSConnectionErrorPopover.rawValue
      } else if error.code == "request.invalid" {
        // If the Device has already been claimed, show Already Claimed Error.
        return PairingStepSegues.segueToWSSDeviceClaimedErrorPopover.rawValue
      }
    }
    return PairingStepSegues.segueToWSSConnectionErrorPopover.rawValue
  }

  func attemptPairing(_ config: ArcusWiFiNetworkConfig) {
    // Show Loading PopUp
    customStepDelegate?.showPopupWithSegue(PairingStepSegues.segueToWSSConnectingPopover.rawValue)

    // Attempt to configure/register/pair the WSS.
    pairSwitch(ssid: config.getSSID(), key: config.getKey())
      .timeout(5 * 60, scheduler: ConcurrentDispatchQueueScheduler(qos: .utility))
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onSuccess: { [customStepDelegate] _ in
          // Complete pairing, and advance to Pairing Cart.
          customStepDelegate?.customPairingCompleted()
      },
        onError: { [weak self] error in
          guard let strongSelf = self,
            let delegate = strongSelf.customStepDelegate else {
            DDLogError("Fatal Error in WSS Pairing, no delegate")
            ApplicationRoutingService.defaultService.showDashboard()
            return
          }
          strongSelf.pairingEnabled.value = false
          let errorSegue = strongSelf.handlePairingError(error)
          delegate.showPopupWithSegue(errorSegue)
      })
      .disposed(by: disposeBag)
  }
}

extension WSSExternalSettingsInfoViewController: ArcusApplicationServiceProtocol {
  func serviceDidEnterBackground(_ event: ArcusApplicationServiceEvent) {
    if !pairingEnabled.value {
      // Prevent the app from routing away from this VC while attempting pairing.
      CorneaController.suspendRouting(true)

      // Disconnect the session's socket, but prevent session from becoming inaactive.
      RxCornea.shared.session?.suspend()

      pairingEnabled.value = true
    }
  }
}
