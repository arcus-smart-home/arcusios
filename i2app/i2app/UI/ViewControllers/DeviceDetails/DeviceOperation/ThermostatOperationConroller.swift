//
//  ThermostatOperationConroller.swift
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
import PromiseKit

protocol ThermostatOperationController {

  // MARK: Extended

  func set(coolSetpoint: Double, onModel model: DeviceModel) -> PMKPromise
  func set(heatSetpoint: Double, onModel model: DeviceModel) -> PMKPromise
  func set(mode: String, onModel model: DeviceModel) -> PMKPromise
  func getCurrentTemperature(_ model: DeviceModel) -> Double
  func getCoolSetpoint(_ model: DeviceModel) -> Double
  func getHeatSetpoint(_ model: DeviceModel) -> Double
  func getMinSetpoint(_ model: DeviceModel) -> Double
  func getMaxSetpoint(_ model: DeviceModel) -> Double
  func getSetpointSeparation(_ model: DeviceModel) -> Double
  func getHVacMode(_ model: DeviceModel) -> String?
  func getSupportedModes(_ model: DeviceModel) -> [Any]
  func getHumidity(_ model: DeviceModel) -> Double?
}

extension ThermostatOperationController {

  func set(coolSetpoint: Double, onModel model: DeviceModel) -> PMKPromise {
    ThermostatCapability.setCoolsetpoint(coolSetpoint, on: model)
    return model.commit()
  }

  func set(heatSetpoint: Double, onModel model: DeviceModel) -> PMKPromise {
    ThermostatCapability.setHeatsetpoint(heatSetpoint, on: model)
    return model.commit()
  }

  func set(mode: String, onModel model: DeviceModel) -> PMKPromise {
    ThermostatCapability.setHvacmode(mode, on: model)
    return model.commit()
  }
  
  func getMinSetpoint(_ model: DeviceModel) -> Double {
    guard model.getAttribute(kAttrThermostatMinsetpoint) != nil else {
      return 1.67 // Celsius
    }
    
    return ThermostatCapability.getMinsetpointFrom(model)
  }
  
  func getMaxSetpoint(_ model: DeviceModel) -> Double {
    guard model.getAttribute(kAttrThermostatMaxsetpoint) != nil else {
      return 35 // Celsius
    }
    
    return ThermostatCapability.getMaxsetpointFrom(model)
  }
  
  func getSetpointSeparation(_ model: DeviceModel) -> Double {
    guard model.getAttribute(kAttrThermostatSetpointseparation) != nil else {
      return 1.67 // Celsius
    }
    
    return ThermostatCapability.getSetpointseparationFrom(model)
  }

  func getCurrentTemperature(_ model: DeviceModel) -> Double {
    return TemperatureCapability.getTemperatureFrom(model)
  }

  func getCoolSetpoint(_ model: DeviceModel) -> Double {
    return ThermostatCapability.getCoolsetpointFrom(model)
  }

  func getHeatSetpoint(_ model: DeviceModel) -> Double {
    return ThermostatCapability.getHeatsetpointFrom(model)
  }

  func getHVacMode(_ model: DeviceModel) -> String? {
    return ThermostatCapability.getHvacmodeFrom(model)
  }

  func getSupportedModes(_ model: DeviceModel) -> [Any] {
    let modes = ThermostatCapability.getSupportedmodesFrom(model)

    guard let supportedModes = modes, supportedModes.count > 0 else {

      if model.deviceType == .thermostatNest {
        return [
          kEnumThermostatHvacmodeHEAT,
          kEnumThermostatHvacmodeCOOL,
          kEnumThermostatHvacmodeAUTO,
          kAttrThermostatHvacmode,
          kAttrThermostatHvacmode
        ]
      } else {
        return [
          kEnumThermostatHvacmodeHEAT,
          kEnumThermostatHvacmodeCOOL,
          kEnumThermostatHvacmodeAUTO,
          kAttrThermostatHvacmode
        ]
      }
    }
    
    return supportedModes
  }

  func getHumidity(_ model: DeviceModel) -> Double? {
    guard model.getAttribute(kAttrRelativeHumidityHumidity) != nil else {
      return nil
    }
    
    return RelativeHumidityCapability.getHumidityFrom(model)
  }

}
