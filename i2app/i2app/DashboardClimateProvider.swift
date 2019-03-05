//
//  DashboardClimateProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/1/17.
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

import Cornea

protocol DashboardClimateProvider {
  // MARK: Extended
  func fetchDashboardClimate()
}

extension DashboardClimateProvider where Self: DashboardProvider {
  func fetchDashboardClimate() {
    let climateData = DashboardClimateViewModel()

    if let controller: ClimateSubSystemController = SubsystemsController.sharedInstance().climateController {
      let primaryTemperatureAddress: String? = controller.primaryTempDeviceId()

      var isEmpty: Bool = false
      if primaryTemperatureAddress != nil {
        isEmpty = primaryTemperatureAddress!.isEmpty
      }

      if controller.allDeviceIds.count > 0 || !isEmpty {
        climateData.isEnabled = true
        guard let primaryTemperatureAddress: String = controller.primaryTempDeviceId() else { return }
        guard let primaryDeviceModel = RxCornea.shared.modelCache?
          .fetchModel(primaryTemperatureAddress) as? DeviceModel else { return }

        let temperature: Int = DeviceController.getTemperatureFor(primaryDeviceModel)
        if temperature != NSNotFound {
          climateData.temperature = "\(temperature)°"
        }

        let humidity: Double = controller.humidity()
        if humidity > 0.0 {
          climateData.humidity = "\(Int(humidity))"
        }

        let currentMode: String? = ThermostatCapability.getHvacmodeFrom(primaryDeviceModel)

        let coolSet: Int = DeviceController.getThermostatCoolSetPoint(for: primaryDeviceModel)
        let heatSet: Int = DeviceController.getThermostatHeatSetPoint(for: primaryDeviceModel)

        if currentMode != nil {
          if currentMode == kEnumThermostatHvacmodeAUTO {
            if coolSet != NSNotFound && heatSet != NSNotFound {
              climateData.temperatureRange = "\(heatSet)° - \(coolSet)°"
            }
          } else if currentMode == kEnumThermostatHvacmodeOFF {
            climateData.temperatureRange = ""
          } else if currentMode == kEnumThermostatHvacmodeCOOL {
            climateData.temperatureRange = "\(coolSet)°"
          } else if currentMode == kEnumThermostatHvacmodeHEAT {
            climateData.temperatureRange = "\(heatSet)°"
          }
        }
      }

      self.storeViewModel(climateData)
    }
  }
}
