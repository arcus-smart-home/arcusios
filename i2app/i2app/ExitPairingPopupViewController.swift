//
//  ExitPairingPopupViewController.swift
//  i2app
//
//  Created by Arcus Team on 2/22/18.
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
import Cornea

/// Protocol to handle the user actions of ExitPairingPopupViewController
@objc protocol ExitPairingPopupDelegate {

  /// Get rid of the popup, don't go back though
  func dismissExitPairingPopup()

  /// the user wants to leave pairing, pop the nav stack
  func shouldExitPairing()

  /// function to handle the case that the user wishes to see paired devices
  func shouldViewPairedDevices()
}

/// A popup that displays when the user attempts to exit pairing but a device is still can be configured
/// See "PairingCatalog.storyboard"
class ExitPairingPopupViewController: ArcusPopupViewController {

  weak var delegate: ExitPairingPopupDelegate?

  @IBAction func dismiss(_ sender: Any) {
    delegate?.dismissExitPairingPopup()
  }

  @IBAction func shouldExitPressed(_ sender: Any) {
    delegate?.shouldExitPairing()
  }

  @IBAction func viewPairedDevicesPressed(_ sender: Any) {
    delegate?.shouldViewPairedDevices()
  }
}
