//
//  ArcusNetworkConfig.swift
//  i2app
//
//  Created by Arcus Team on 5/4/18.
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
import RxSwift

/**
 `ArcusNetworkConfig` protocol defines the properties required to implement an `RxSwift` based ViewModel that
 can be used to configure a device's wifi network settings..
 */
protocol ArcusWiFiNetworkConfig {
  // Wifi Network's SSID
  var ssid: Variable<String> { get }
  // Wifi Network Key
  var key: Variable<String> { get }

  // Validation Observable
  var isValid: Observable<Bool> { get }

  // Convenience Getters
  func getSSID() -> String
  func getKey() -> String

  func getValid() -> Bool
}

extension ArcusWiFiNetworkConfig {
  func getSSID() -> String {
    return ssid.value
  }

  func getKey() -> String {
    return key.value
  }

  func getValid() -> Bool {
    return ssid.value.count > 0 && key.value.count > 0
  }
}
