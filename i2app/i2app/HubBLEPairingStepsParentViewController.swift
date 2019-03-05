//
//  HubBLEPairingStepsParentViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/16/18.
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
import Cornea
import RxSwift
import RxCocoa
import CoreBluetooth

class HubBLEPairingStepsParentViewController: UIViewController,
  BackButtonDelegate,
  HubBLEPairingStepsPagerDelegate,
  PairingStepsCustomStepDelegate,
  BLEPairingPresenterProtocol,
ArcusHubBLEPairingCompletionPresenter {
  var ipcdDeviceType: String?

  func handlePairingError(_ error: (Error)) -> String {
    if let error = error as? BLEPairingError {
      return error.popupSegueIdentifier().rawValue
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

  // MARK: ArcusHubBLEPairingCompletionPresenter
  var customStepDelegate: PairingStepsCustomStepDelegate {
    return self
  }
  var hubId: Variable<String?> = Variable<String?>(nil)
  var hubModelProvider: ArcusModelProvider<HubModel>?
  var shouldTransitionToPairing: Variable<Bool> = Variable<Bool>(false)
  var shouldTransitionToPostPairing: Variable<Bool> = Variable<Bool>(false)
  
  fileprivate var pagerController: HubBLEPairingStepsPagerViewController?

  var presenter: BLEPairingPresenterProtocol {
    return self
  }

  var delegate: PairingStepsCustomStepDelegate {
    return self
  }
  
  @IBOutlet weak var purpleButton: ScleraButton!

  var disposeBag = DisposeBag()

  // MARK: PairingStepsCustomStepDelegate
  var deviceName: String? = Constants.hubDeviceName
  var deviceShortName: String? = Constants.hubDeviceName
  var loadingStatus: Variable<String> = Variable<String>("")
  var loadingTitle: Variable<String> = Variable<String>("")
  var pagingEnabled: Variable<Bool> = Variable<Bool>(true)
  var shouldAttemptPairing: Variable<Bool> = Variable<Bool>(false)
  var stepsMovedBackSubject: PublishSubject<Int> = PublishSubject<Int>()
  var isLoading: Variable<Bool> = Variable<Bool>(false)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    addScleraBackButton(delegate: self)
    navigationItem.title = Constants.hubDeviceName
    addScleraStyleToNavigationTitle()
    pagerController?.setPages(stepViewControllers)
    bindOnNextPressed()
    bindStepChanges()
    bindTransitionToPairing()
    bindShouldAttemptPairing()
  }

  func bindOnNextPressed() {
    purpleButton.rx.tap.asObservable()
      .throttle(1, latest: false, scheduler: MainScheduler.instance)
      .subscribe( onNext: { [unowned self] _ in
        if !(self.pagerController?.goNextPage() ?? false) {
          self.shouldAttemptPairing.value = true
        }
      })
      .disposed(by:disposeBag)
  }

  func bindStepChanges() {

    pagingEnabled
      .asObservable()
      .bind(to: purpleButton.rx.isEnabled)
      .disposed(by: disposeBag)

    pagingEnabled
      .asObservable()
      .subscribe(
        onNext: { [pagerController] enabled in
          if enabled {
            pagerController?.enablePaging()
          } else {
            pagerController?.disablePaging()
          }
      }).disposed(by: disposeBag)
  }

  func bindTransitionToPairing() {
    shouldTransitionToPairing.asObservable()
      .filter{ return $0 } // only do work if true
      .take(1) // only transition once
      .do(onNext: { [unowned self] _ in
        self.dismissPopup { [unowned self] _ in
          self.performSegue(withIdentifier: HubPairingSegues.search.rawValue, sender: self)
        }
      })
      .subscribe()
      .disposed(by: disposeBag)
  }
  
  lazy var stepViewControllers: [HubBLEPairingInstructionViewController] = {
    let config = BLEPairingClient(CBCentralManager(), searchFilter: Constants.bleHubFilter)
    var vcs = [HubBLEPairingInstructionViewController]()

    if var bleOnStep = BLEPairingAvailabilityViewController.createFromStoryboard()
      as? BLEPairingAvailabilityViewController {
      bleOnStep.customStepDelegate = self
      bleOnStep.bleClient = config
      vcs.append(bleOnStep)
    }

    if var scanStep = BLEPairingDeviceDiscoveryViewController.createFromStoryboard()
      as? BLEPairingDeviceDiscoveryViewController {
      scanStep.customStepDelegate = self
      scanStep.bleClient = config
      vcs.append(scanStep)
    }

    if var wifiStep = BLEPairingAvailableNetworksViewController.createFromStoryboard()
      as? BLEPairingAvailableNetworksViewController {
      wifiStep.customStepDelegate = self
      wifiStep.bleClient = config
      vcs.append(wifiStep)
    }
    
    if var passwordStep = HubBLEPairingConfigureNetworkViewController.createFromStoryboard()
      as? HubBLEPairingConfigureNetworkViewController {
      passwordStep.presenter = self
      passwordStep.customStepDelegate = self
      passwordStep.parentDelegate = self
      passwordStep.bleClient = config
      vcs.append(passwordStep)
    }
    
    return vcs
  }()
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == HubPairingSegues.pager.rawValue {
      if let pagerController = segue.destination as? HubBLEPairingStepsPagerViewController {
        self.pagerController = pagerController
        self.pagerController?.stepsDelegate = self
        pagerController.setPages(stepViewControllers)
      }
    } else if segue.identifier == HubPairingSegues.search.rawValue {
      if let search = segue.destination as? HubPairingViewController {
        guard let hubId = self.hubId.value else {
          DDLogError("FATAL ERROR: Current Hub Model Updated but hubID and " +
            "HubModel have not been set before segue to download steps")
          ApplicationRoutingService.defaultService.showDashboard()
          return
        }
        let config = [HubPairingNodeKey.HubId: hubId]
        search.config = config
        let blePresenter = HubBLEPostPairingPresenter(hubId: hubId,
                                                      delegate: search)
        search.presenter = blePresenter
      }
    } else if segue.identifier == HubPairingSegues.youtube.rawValue {
      if let youTubePlayer = segue.destination as? YouTubePlayerViewController {
        youTubePlayer.videoId = kHubV3PairingYoutubeLink
      }
    }
    if let bleErrorPopup = segue.destination as? BLEPairingErrorViewController {
      if segue.identifier == PairingStepSegues.segueToBLENotEnabledErrorPopOver.rawValue {
        bleErrorPopup.tryAgainHandler = { [unowned self] _ in
          self.pagingEnabled.value = true
          self.pagerController?.goToPageIndex(0, completion: nil)
          self.dismissPopup()
        }
      } else if segue.identifier == PairingStepSegues.segueToBLEConnectionLostErrorPopOver.rawValue {
        bleErrorPopup.tryAgainHandler = { [unowned self] _ in
          self.pagingEnabled.value = true
          self.pagerController?.goToPageIndex(0, completion: nil)
          self.dismissPopup()
        }
      } else if segue.identifier == PairingStepSegues.segueToBLEConfigFailedErrorPopOver.rawValue {
        bleErrorPopup.tryAgainHandler = { [unowned self] _ in
          self.dismissPopup()
        }
      } else {
        bleErrorPopup.tryAgainHandler = { [unowned self] _ in
          self.dismissPopup()
        }
      }
    }
    if let bleErrorPopup = segue.destination as? HubBLEPairingErrorViewController {
      if let shortName = deviceShortName {
        bleErrorPopup.shortName = shortName
      }
      bleErrorPopup.tryAgainHandler = { [unowned self] _ in
        self.pagingEnabled.value = true
        self.pagerController?.goToPageIndex(0, completion: nil)
        self.dismissPopup(nil)
      }
    }
    if let bleErrorPopup = segue.destination as? BLEPairingDeviceNotFoundErrorViewController {
      if let shortName = deviceShortName {
        bleErrorPopup.shortName = shortName
      }
      bleErrorPopup.tryAgainHandler = { [unowned self] _ in
        self.dismissPopup(nil)
      }
    }
    if let bleConnectingPopup = segue.destination as? BLEPairingLoadingPopUpViewController {
      bleConnectingPopup.loadingTitle = loadingTitle
      bleConnectingPopup.loadingStatus = loadingStatus
    }
  }

  // MARK: BackButtonDelegate
  
  func onBackButtonPressed() {
    // Attempt to navigate to previous page; if that fails, pop the nav stack
    if !(pagerController?.goPreviousPage() ?? false) {
      navigationController?.popViewController(animated: true)
    }
  }

  // MARK: HubBLEPairingStepsPagerDelegate

  func pageDidChange(_ index: Int, direction: UIPageViewControllerNavigationDirection) {
    stepsMovedBackSubject.onNext(index)
  }

  // MARK: - PairingStepsCustomStepDelegate

  func attemptAdvanceToNextStep() {
    purpleButton.sendActions(for: .touchUpInside)
  }

  func customPairingCompleted() {
   self.shouldTransitionToPairing.value = true
  }

  func showPopupWithSegue(_ indentifier: String) {
    if let presentedViewController = presentedViewController,
      !presentedViewController.isKind(of: HubBLEPairingErrorViewController.self) {
      presentedViewController.dismiss(animated: true, completion: {
        self.performSegue(withIdentifier: indentifier, sender: self)
      })
    } else {
      performSegue(withIdentifier: indentifier, sender: self)
    }
  }

  func dismissPopup(_ completion: (() -> Void)? = nil) {
    presentedViewController?.dismiss(animated: true, completion: completion)
  }
}
