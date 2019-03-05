//
//  PairingStepsCustomStepDelegate.swift
//  i2app
//
//  Created by Arcus Team on 5/4/18.
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

/**
 `PairingStepsCustomStepDelegate` is a delegate protocol used by `PairingStepParentViewController` to
 allow custom pairing steps to perform certain actions not defined by a normal Pairing Tutorial Step.
 */
protocol PairingStepsCustomStepDelegate: class {
  /**
   `deviceName` is already a property on `PairingStepsParentViewController`.
   Adding to `PairingStepsCustomStepDelegate` to allow child VCs easy access to the displayed navigation
   title.
   */
  var deviceName: String? { get set }

  /**
   Short name of the current device.
   */
  var deviceShortName: String? { get set }

  /**
   V1DeviceType of the current device.
   */
  var ipcdDeviceType: String? { get set }

  /**
   Can be used by a custom pairing step to to communicate to the `PairingStepsCustomStepDelegate`
   the current loading title.  Currently used in conjunction with showing the "Searching"/"Loading" Popup.
   */
  var loadingTitle: Variable<String> { get }

  /**
   Can be used by a custom pairing step to to communicate to the `PairingStepsCustomStepDelegate`
   the current loading status.  Currently used in conjunction with showing the "Searching"/"Loading" Popup.
   */
  var loadingStatus: Variable<String> { get }

  /**
   Can be used by a custom pairing step to to tell the `PairingStepsCustomStepDelegate` to enable/disable
   paging & the next button.
   */
  var pagingEnabled: Variable<Bool> { get }

  /**
   Can be used by `PairingStepsCustomStepDelegate` to tell a custom pairing step to attempt pairing.
   i.e. On the final step of WiFi Smart Switch pairing, this will begin configuration of the switch.
   */
  var shouldAttemptPairing: Variable<Bool> { get }

  /**
   Can be used by `PairingStepsCustomStepDelegate` to tell a custom pairing step that the
   parent did move back a step via the back button or pageController.
   */
  var stepsMovedBackSubject: PublishSubject<Int> { get }

  /**
   This method can be used by a custom pairing step to tell the `PairingStepsCustomStepDelegate` to
   attempt to advance to the next step.  i.e. Can be called by `UITextField textFieldShouldReturn()`.
   */
  func attemptAdvanceToNextStep()

  /**
   This method can be used by a custom pairing step to tell the `PairingStepsCustomStepDelegate` to show
   an `ArcusPopupViewController` via segue.

   - Parameters:
   - identifier: The segue identifier.
   */
  func showPopupWithSegue(_ indentifier: String)

  /**
   Used by a custom pairing step to tell the `PairingStepsCustomStepDelegate` to dismiss the visible
   `PairingStepsCustomStepDelegate`.

   - Parameters:
   - completion: Optional closure to execute on completion of dismissal of `ArcusPopupViewController`.
   */

  func dismissPopup(_ completion: (() -> Void)?)

  /**
   Used by a custom pairing step to tell the `PairingStepsCustomStepDelegate` that custom pairing steps
   have been completed.  This will result in segue to the `PairingCartViewController`.
   */
  func customPairingCompleted()
}
