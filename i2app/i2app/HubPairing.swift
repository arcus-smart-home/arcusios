//
//  HubPairing.swift
//  i2app
//
//  Created by Arcus Team on 4/2/18.
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

internal let HubPairingStoryboardName: String = "HubPairing"

extension Constants {
  static let hubDeviceName = "Wi-Fi Smart Hub"
}

internal enum HubPairingSegues: String {
  case pager
  case youtube
  case wifiPairing
  case search
  case downloadInProgressExitPopup
  case downloadFailedExitPopup
  case applyInProgressExitPopup
  case installFailedExitPopup
  case name
  case complete
  case successKit
  case unwind
  case e01Popup
  case e02Popup
}

internal enum HubV3PairingSegues: String {
  case pager
  case settingsBluetooth
  case search
}

internal enum HubV3PairingMethod {
  case ethernet
  case wifi
}

internal enum HubVersion {
  case version2
  case version3
}
