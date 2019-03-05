//
//  ThermostatControlViewModel.swift
//  i2app
//
//  Created by Arcus Team on 6/25/17.
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

enum ThermostatMode {
  case heat
  case cool
  case auto
  case eco
  case off

  func title() -> String {
    switch self {
    case .heat:
      return "HEAT"
    case .cool:
      return "COOL"
    case .auto:
      return "AUTO"
    case .eco:
      return "ECO"
    case .off:
      return "OFF"
    }
  }
}

struct ThermostatControlViewModel {
  var temperatureLimitLow: Int = 0
  var temperatureLimitHigh: Int = 0
  var setpointSeparation: Int = 0

  var isTemperatureLocked = false
  var temperatureLockMin: Int?
  var temperatureLockMax: Int?
  
  var currentTemperature: Int = 0
  var humidity: Int?

  var heatSetpoint: Int = 0
  var coolSetpoint: Int = 0
  
  var iconImageName: String?
  var customAutoModeText: String?
  
  var mode: ThermostatMode = .off
}
