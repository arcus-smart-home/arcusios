//
//  WifiSSIDViewModel.swift
//  i2app
//
//  Created by Arcus Team on 7/17/18.
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

enum WiFiConnectionStatus {
  case secure
  case unsecure
  case white
}

enum WiFiConnectionStrength: Int {
  case one
  case two
  case three
  case four
  case five
}

struct WifiSSIDViewModel {
  var strength: WiFiConnectionStrength
  var status: WiFiConnectionStatus
  var ssid: String //display name of the wifi
  
  var imageName: String {
    get {
      switch self.status {
      case .secure:
        return "wi-fi_lock_\(strength)"
      case .unsecure:
        return "wi-fi_unsecured_white_\(strength)"
      case .white:
        return "wi-fi_white_\(strength)"
      }
    }
  }
}
