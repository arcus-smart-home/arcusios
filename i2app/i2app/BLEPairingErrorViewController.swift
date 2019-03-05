//
//  BLEPairingErrorViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/26/18.
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

struct BLEPairingErrorStrings {
  static let deviceNotFound: String = "No <ShortName>s Were Found"
}

class BLEPairingErrorViewController: ArcusPopupViewController {
  @IBOutlet weak var popupTitleLabel: UILabel!
  @IBOutlet weak var popupDescriptionLabel: UILabel!

  var tryAgainHandler: (() -> Void)?

  var shortName: String?
  var ipcdDeviceType: String?

  // MARK: - IBActions

  @IBAction func tryAgainButtonPressed(_ sender: AnyObject) {
    tryAgainHandler?()
  }

  @IBAction func customerSupportButtonPressed(_ sender: AnyObject) {
    if UIApplication.shared.canOpenURL(Constants.customerSupportPrompt) == true {
      UIApplication.shared.open(Constants.customerSupportPrompt)
    }
  }

  @IBAction func factoryResetStepsButtonPressed(_ sender: AnyObject) {
    guard let shortName = shortName else { return }

    if shortName == Constants.wifiCameraShortName {
      UIApplication.shared.open(NSURL.SupportSwannCameraFactoryReset)
    } else if shortName == Constants.wifiPlugShortName {
      if ipcdDeviceType == Constants.V1DeviceType.greatStarIndoorPlug {
        UIApplication.shared.open(NSURL.SupportGsIndoorFactoryReset)
      } else {
        UIApplication.shared.open(NSURL.SupportGsOutdoorFactoryReset)
      }
    } else if shortName == Constants.hubDeviceName {
      UIApplication.shared.open(NSURL.SupportHubAlreadyPaired)
    }
  }

}

class BLEPairingDeviceNotFoundErrorViewController: BLEPairingErrorViewController {
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let name = shortName {
      popupTitleLabel.text = BLEPairingErrorStrings.deviceNotFound
        .replacingOccurrences(of: "<ShortName>", with: name)
    }
  }
}

class BLEPairingUnableToSendInfoErrorViewController: BLEPairingErrorViewController {
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let name = shortName {
      popupDescriptionLabel.text = popupDescriptionLabel.text?
        .replacingOccurrences(of: "<ShortName>", with: name)
    }
  }
}
