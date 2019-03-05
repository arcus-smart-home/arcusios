//
//  NestThermostatOperationController.swift
//  i2app
//
//  Created by  Arcus Team on 7/5/17.
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

protocol NestThermostatOperationController {
  
  // MARK: Extended
  
  func hasLeaf(_ model: DeviceModel) -> Bool
  func isTemperatureLocked(_ model: DeviceModel) -> Bool
  func getLockTemperatureMin(_ model: DeviceModel) -> Double
  func getLockTemperatureMax(_ model: DeviceModel) -> Double
  func getErrors(_ model: DeviceModel) -> [AnyHashable: Any]?
}

extension NestThermostatOperationController {

  func getErrors(_ model: DeviceModel) -> [AnyHashable: Any]? {
    return DeviceAdvancedCapability.getErrorsFrom(model)
  }

  func hasLeaf(_ model: DeviceModel) -> Bool {
    return NestThermostatCapability.getHasleafFrom(model)
  }
  
  func isTemperatureLocked(_ model: DeviceModel) -> Bool {
    return NestThermostatCapability.getLockedFrom(model)
  }
  
  func getLockTemperatureMin(_ model: DeviceModel) -> Double {
    return NestThermostatCapability.getLockedtempminFrom(model)
  }
  
  func getLockTemperatureMax(_ model: DeviceModel) -> Double {
    return NestThermostatCapability.getLockedtempmaxFrom(model)
  }
  
}
