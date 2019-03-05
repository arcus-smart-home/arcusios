//
//  BLEPairingDontSeeNetworkViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/19/18.
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

class BLEPairingDontSeeNetworkViewController: UIViewController {
  @IBOutlet weak var listLabel: UILabel!

  var shortName: String = "device"
  var ipcdDeviceType: String = ""
  // MARK - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavBarTitle("Wi-Fi Network")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    listLabel.text = listLabel.text?.replacingOccurrences(of: "<ShortName>",
                                                          with: shortName)
  }

  // MARK - IBActions

  @IBAction func needHelpButtonPressed(_ sender: AnyObject) {
    if shortName == Constants.wifiCameraShortName {
      UIApplication.shared.open(NSURL.SupportSwannCameraWifiNeedHelp)
    } else if shortName == Constants.wifiPlugShortName {
      if ipcdDeviceType == Constants.V1DeviceType.greatStarIndoorPlug {
        UIApplication.shared.open(NSURL.SupportGsIndoorWifiNeedHelp)
      } else {
        UIApplication.shared.open(NSURL.SupportGsOutdoorWifiNeedHelp)
      }
    } else if shortName == Constants.hubDeviceName {
      UIApplication.shared.open(NSURL.SupportV3HubWifiNeedHelp)
    }
  }

  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }

}
