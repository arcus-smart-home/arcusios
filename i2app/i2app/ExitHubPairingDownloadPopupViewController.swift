//
//  ExitHubPairingDownloadPopupViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/6/18.
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

/// Protocol to handle the user actions of ExitHubPairingDownloadPopupViewController
@objc protocol ExitHubPairingPopupDelegate {

  /// Get rid of the popup, don't go back though
  func dismissExitPairingPopup()

  /// the user wants to leave hub pairing, display the dashboard
  func shouldExitPairing()
}

class ExitHubPairingDownloadPopupViewController: ArcusPopupViewController {

  weak var delegate: ExitHubPairingPopupDelegate?

  @IBAction func dismiss(_ sender: Any) {
    delegate?.dismissExitPairingPopup()
  }

  @IBAction func shouldExitPressed(_ sender: Any) {
    delegate?.shouldExitPairing()
  }

}
