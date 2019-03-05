//
//  CBManagerState+Description.swift
//  i2app
//
//  Created by Arcus Team on 6/25/18.
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

import CoreBluetooth

extension CBManagerState: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .unknown:
      return "State unknown, update imminent."
    case .resetting:
      return "The connection with the system service was momentarily lost, update imminent."
    case .unsupported:
      return "The platform doesn't support the Bluetooth Low Energy Central/Client role."
    case .unauthorized:
      return "The application is not authorized to use the Bluetooth Low Energy role."
    case .poweredOff:
      return "Bluetooth is currently powered off."
    case .poweredOn:
      return "Bluetooth is currently powered on and available to use."
    }
  }
}
