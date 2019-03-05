//
//  PairingTimeoutViewController.swift
//  i2app
//
//  Arcus Team on 2/26/18.
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

protocol PairingTimeoutDelegate: class {
  /// Invoked when the user taps the top button on the timeout popup
  func onTimeoutTopButtonTapped(_ sender: Any?)
  
  /// Invoked when the user taps the bottom button on the timeout popup
  func onTimeoutBottomButtonTapped(_ sender: Any?)
}

class PairingTimeoutViewController: ArcusPopupViewController {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var topButton: ScleraButton!
  @IBOutlet weak var bottomButton: ScleraButton!

  weak var delegate: PairingTimeoutDelegate?
  
  var titleText: String = "Pairing Has Timed Out"
  var subtitleText: String = "Do you want to keep searching for new devices?"
  var topButtonTitle: String = "YES, KEEP SEARCHING"
  var bottomButtonTitle: String = "NO, VIEW MY DEVICES"
  
  // Hint sent to PairingTimeoutDelegate when top/bottom button clicked
  var topButtonSender: Any?
  var bottomButtonSender: Any?

  override public func viewDidLoad() {
    super.viewDidLoad()
  
    titleLabel.text = titleText
    subtitleLabel.text = subtitleText
    topButton.setTitle(topButtonTitle, for: .normal)
    bottomButton.setTitle(bottomButtonTitle, for: .normal)
  }

  @IBAction func onKeepSearching(_ sender: Any) {
    delegate?.onTimeoutTopButtonTapped(topButtonSender)
  }
  
  @IBAction func onViewDevices(_ sender: Any) {
    delegate?.onTimeoutBottomButtonTapped(bottomButtonSender)
  }
  
  @IBAction func dismiss(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
