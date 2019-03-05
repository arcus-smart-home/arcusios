//
//  ConfirmExitPairingViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/11/18.
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

protocol ConfirmExitPairingDelegate: class {
  /// "SEARCH FOR DEVICES" pressed
  func confirmExitPairingTopButtonPressed()

  /// "GO TO DASHBOARD" pressed
  func confirmExitPairingBottomButtonPressed()
}

/// Simple Popup to confirm that a user wants to exit pairing a little early
/// The view's layout is located in PairingCart.storyboard
class ConfirmExitPairingViewController: ArcusPopupViewController {

  weak var delegate: ConfirmExitPairingDelegate?

  @IBAction func dismissPopup(_ sender: Any) {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }

  @IBAction func onTopButtonPressed(_ sender: Any) {
    delegate?.confirmExitPairingTopButtonPressed()
    presentingViewController?.dismiss(animated: true, completion: nil)
  }

  @IBAction func onBottomButtonPressed(_ sender: Any) {
    presentingViewController?.dismiss(animated: true, completion: {
      self.delegate?.confirmExitPairingBottomButtonPressed()
    })
  }

}
