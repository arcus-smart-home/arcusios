//
//  HubBLEPairingErrorViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/27/18.
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

class HubBLEPairingErrorViewController: BLEPairingErrorViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    if let name = shortName, let text = popupTitleLabel.text {
      popupTitleLabel.text = text.replacingOccurrences(of: "<ShortName>", with: name)
    }
  }

  @IBAction override func customerSupportButtonPressed(_ sender: AnyObject) {
    if UIApplication.shared.canOpenURL(Constants.customerSupportPrompt) == true {
      UIApplication.shared.open(Constants.customerSupportPrompt)
    }
  }

  @IBAction override func factoryResetStepsButtonPressed(_ sender: AnyObject) {
    guard let shortName = shortName else { return }

    if shortName == Constants.hubDeviceName {
      UIApplication.shared.open(NSURL.SupportHubAlreadyPaired)
    }
  }
}
