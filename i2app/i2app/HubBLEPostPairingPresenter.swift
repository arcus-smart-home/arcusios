//
//  HubBLEPostPairingPresenter.swift
//  i2app
//
//  Created by Arcus Team on 7/18/18.
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

import Foundation
import RxSwift
import Cornea

class HubBLEPostPairingPresenter: HubPairingPresenterProtocol {
  
  var progressTimer: HubPairingTimer?
  
  var timeoutTimer: HubPairingTimer?
  
  var pairingTimer: HubPairingTimer?
  
  var requestSending: Bool = false
  
  var disposeBag: DisposeBag = DisposeBag()
  
  /// delegate of the presenter
  var delegate: HubPairingDelegate?
  
  /// The Hub Id actively pairing
  var hubId: String
  
  var pairingState: HubPairingState = .notStarted
  
  init(hubId: String, delegate: HubPairingDelegate) {
    self.hubId = hubId
    self.delegate = delegate
  }
  
  deinit {
    pairingTimer?.cancelUpdate()
    pairingTimer = nil
    timeoutTimer?.cancelUpdate()
    timeoutTimer = nil
    progressTimer?.cancelUpdate()
    progressTimer = nil
  }
  
  /// the delegate can call this function to start the pairing process
  /// This presenter will check for downloading and applying only
  /// Main thread only
  func startProcess() {
    hubNeedsUpdate()
    observeCurrentHubModel()
    self.pairingTimer =
      HubPairingTimer(delegate: self,
                      timeout: HubPairingConfig.pairingTimeout,
                      updateInterval: HubPairingConfig.pairingUpdateInterval)
    self.pairingTimer?.startUpdates()

  }
  
  /// The main Button was Pressed
  /// Must be called on the Main Thread. Only the delegate should call this function on a button press.
  /// Main thread only because it has direct access to UIKit classes (normally a no no for presenters)
  func buttonPressed() {
    self.delegate?.callSupport()
  }
  
  /// Segue to be performed if the user presses Exit (based on the state of the presenter)
  func exitPopupSegue() -> HubPairingSegues? {
    switch pairingState {
    case .updateAvailable:
      return .downloadInProgressExitPopup
    case .applyingUpdate:
      return .applyInProgressExitPopup
    case  .downloadFailed:
      return .downloadFailedExitPopup
    case .installFailed:
      return .installFailedExitPopup
    default:
      return nil
    }
  }
}

