//
//  WSSConfigurator.swift
//  i2app
//
//  Created by Arcus Team on 5/20/18.
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
 `WSSConfigError` errors used when attempting to config the WiFi Smart Switch with
 `RxSwannSmartSwitchConfigClient`.
 */
struct WSSConfigError: Error {
  public init(type: ErrorType) {
    self.type = type
  }

  public enum ErrorType {
    case unknown
    case connectFailed
    case badMessage
  }

  public let type: ErrorType
}

/**
 `WSSConfigurator` protocol defines the methods required to configure a WiFi Smart Switch.
 */
protocol WSSConfigurator {
  /**
   Attempt to configure a WiFi Smart Switch's Network Settings.

   - Parameters:
   - ssid: The network to connect to.
   - key: The network key.

   - Returns: Observable `Single<String>` that onSuccess will return the mac address needed to register the
   device with the platform.
   */
  func provisionSwitch(_ ssid: String, key: String) -> Single<String>
}
