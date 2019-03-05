//
//  HubBLEPairingConfigureNetworkViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/17/18.
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
import RxSwiftExt

class HubBLEPairingConfigureNetworkViewController: BLEPairingConfigureNetworkViewController,
  StoryboardCreatable,
  ArcusHubBLEPairingPresenter {

  static var storyboardName: String = HubPairingStoryboardName
  static var storyboardIdentifier: String = "HubBLEPairingConfigureNetworkViewController"

  weak var parentDelegate: (HubBLEPairingStepsPagerDelegate & ArcusHubBLEPairingCompletionPresenter)?

  // MARK - OffsetScrollViewKeyboardAnimatable
  @IBOutlet weak var keyboardAnimationView: UIScrollView!
  var keyboardAnimatableShowObserver: Any?
  var keyboardAnimatableHideObserver: Any?

  override func handlePairingError(_ error: (Error)) -> String {
    if let error = error as? BLEPairingError {
      return error.popupSegueIdentifier().rawValue
    } else if let error = error as? PlaceRegisterHubV2Error  {
      if error.code == PlaceRegisterHubV2ResponseConstants.ErrorRegisterAlreadyRegistered {
        return HubPairingSegues.e01Popup.rawValue
      } else if error.code == PlaceRegisterHubV2ResponseConstants.ErrorRegisterOrphandedHub {
        return HubPairingSegues.e02Popup.rawValue
      }
    }
    return PairingStepSegues.segueToBLEConfigFailedErrorPopOver.rawValue
  }

  override func bindAttemptPairing() {
    attemptPairingObserver?.dispose()
    guard let delegate = customStepDelegate else { return }
    attemptPairingObserver = delegate.shouldAttemptPairing
      .asObservable()
      .filterMap { [unowned self] shouldAttempt in
        guard shouldAttempt == true else { return .ignore }
        return self.validateAttempt()
      }
      .do(onNext: { [unowned self] _ in
        self.showConnectingPopup()
        self.isBLEConnectedSegueObserver?.dispose()
      })
      .delay(0.01, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.asyncInstance)
      .flatMap { [unowned self] (network, key) in
        return self.configureDeviceForPairing(network, key: key)
      }
      .filterMap { [unowned self] status -> RxSwiftExt.FilterMap<HubIdPlaceModel> in
        guard status == .connected,
          let serial = self.deviceSerial.value,
          let currentPlace = self.currentPlace
         else {
          return .ignore
        }
        return .map(HubIdPlaceModel(hubId: serial, currentPlace: currentPlace))
      }
      .take(1)
      .do(onNext: { [unowned self] _ in
        self.showPairingPopup()
      })
      .flatMap { [unowned self] hubPlace in
        return self.pairHub(hubId: hubPlace.hubId, place: hubPlace.currentPlace)
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak delegate, weak parentDelegate] _ in
        parentDelegate?.hubId.value = self.deviceSerial.value
        delegate?.loadingStatus.value = ""
        delegate?.customPairingCompleted()
      }, onError: { [unowned self, weak delegate]  error in
        DDLogInfo("onError Config Process. \(error)")
        if let error = error as? BLEPairingError,
          error.errorType == .badPassword {
          self.keyTextField.text = ""
        }
        delegate?.pagingEnabled.value = false
        let errorSegue = self.handlePairingError(error)
        delegate?.shouldAttemptPairing.value = false
        self.bleClient.configStatus.value = .intial
        delegate?.loadingStatus.value = ""
        delegate?.showPopupWithSegue(errorSegue)
        self.bindConnectedDevice()
        self.bindAttemptPairingWithDelay()
      }, onDisposed: { _ in
        DDLogDebug("Disposed attemptPairingObserver")
      })
    attemptPairingObserver?.disposed(by: disposeBag)

  }

  override func showConnectingPopup() {
    customStepDelegate?.loadingTitle.value = BLEPairingConnectingStrings.connectingTitle
    customStepDelegate?.loadingStatus.value = BLEPairingConnectingStrings.connectingWifi
    customStepDelegate?.showPopupWithSegue(PairingStepSegues.segueToBLELoadingPopOver.rawValue)
  }

  func showPairingPopup() {
    customStepDelegate?.loadingTitle.value = BLEPairingConnectingStrings.connectingTitle
    customStepDelegate?.loadingStatus.value = BLEPairingConnectingStrings.connectingArcus
  }

  private func bindAttemptPairingWithDelay() {
    Observable<Int>
      .timer(0.01, scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self] _ in
        self.bindAttemptPairing()
      })
      .disposed(by: disposeBag)
  }


}
