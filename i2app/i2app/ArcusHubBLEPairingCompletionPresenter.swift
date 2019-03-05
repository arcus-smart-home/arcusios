//
//  HubBLEPairingPresenter.swift
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

import Foundation
import RxSwift
import Cornea

/// Helper Type to link a hub Id and a current place and pass it down a reactive chain as a tuple
typealias HubIdPlaceModel = (hubId: String, currentPlace: PlaceModel)

protocol ArcusHubBLEPairingCompletionPresenter: class, ArcusHubBLEPairingPresenter, ArcusHubCapability {

  var customStepDelegate: PairingStepsCustomStepDelegate { get }

  /// extended to be `RxCornea.shared.settings?.currentPlace`
  var currentPlace: PlaceModel? { get }

  /// The Hub Id actively pairing
  var hubId: Variable<String?> { get set }

  /// Variable when set to true should attempt pairing once, if set will be set to false after a short time
  var shouldAttemptPairing: Variable<Bool> { get }

  /// This observer is completed when the Hub Pairing has started and the view should continue to
  /// any post pairing views
  var shouldTransitionToPostPairing: Variable<Bool> { get }

  func handlePairingError(_ error: (Error)) -> String
}

extension ArcusHubBLEPairingCompletionPresenter {

  /// Sane Default to RxCornea
  var currentPlace: PlaceModel? {
    return currentSettings?.currentPlace
  }

  /// Helper to expose RxCornea.shared.settings
  var currentSettings: (ArcusSettings & RxSwiftSettings)? {
    if let settings = RxCornea.shared.settings as? ArcusSettings & RxSwiftSettings {
      return settings
    }
    return nil
  }

  func bindShouldAttemptPairing() {
    self.currentSettings?.eventObservable
      .observeOn(MainScheduler.asyncInstance)
      .filter({
        // swiftlint:disable:next force_cast
        return $0 is CurrentHubChangeEvent && ($0 as! CurrentHubChangeEvent).currentHub != nil
      })
      .map({
        return ($0 as! CurrentHubChangeEvent).currentHub as! HubModel
      })
      .do(onNext: { [weak self] hub in
        self?.hubId.value = self?.getHubId(hub)
        self?.shouldTransitionToPostPairing.value = true
      })
      .subscribe()
      .disposed(by: disposeBag)
  }

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
}
