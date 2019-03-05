//
//  AdvancedPairingPopupViewController.swift
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

@objc protocol AdvancedPairingPopupDelegate {

  /// Cancel, Get rid of the popup
  func dismissAdvancedPairingPopup()

  /// function to handle the case that the user wishes to start Advanced Pairing
  func shouldViewAdvancedPairing()
}

/// A popup that confirms the user wants to navigate to the pairing view or not
/// See "PairingCatalog.storyboard"
class AdvancedPairingPopupViewController: ArcusPopupViewController {

  weak var delegate: AdvancedPairingPopupDelegate?

  @IBAction func dismiss(_ sender: Any) {
    delegate?.dismissAdvancedPairingPopup()
  }

  @IBAction func okayPressed(_ sender: Any) {
    delegate?.shouldViewAdvancedPairing()
  }
}
