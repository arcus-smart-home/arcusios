//
//  DashboardWaterProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/5/17.
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

protocol DashboardWaterProvider {
  // MARK: Extended
  func fetchDashboardWater()
}

extension DashboardWaterProvider where Self: DashboardProvider {
  func fetchDashboardWater() {
    let viewModel = DashboardWaterViewModel()

    if let controller: WaterSubsystemController = SubsystemsController.sharedInstance().waterController {
      if controller.allWaterDeviceAddresses().count > 0 {
        viewModel.isEnabled = true

        let waterDevices: [DeviceModel]? = controller.allWaterDevices()
        var valve: DeviceModel?

        if waterDevices != nil {
          for device in waterDevices! where device.deviceType == .waterValve {
            valve = device
          }
        }

        if valve != nil && ValveCapability.getValvestateFrom(valve) == kEnumValveValvestateCLOSED {
          viewModel.waterInfo = NSLocalizedString("Shut Off", comment: "")
        } else {
          let waterHeater: DeviceModel? = controller.primaryWaterHeater()
          let waterSoftner: DeviceModel? = controller.primaryWaterSoftener()
          var saltPencentage: Double?
          var setPoint: Int = 0
          var hotWaterLevel: String = ""
          var isHeating: Bool = false

          if let waterSoftner: DeviceModel = waterSoftner {
            if WaterSoftenerCapability.getSaltLevelEnabled(from: waterSoftner) {
              let currentSaltLevel = WaterSoftenerCapability.getCurrentSaltLevel(from: waterSoftner)
              let maxSaltLevel = WaterSoftenerCapability.getMaxSaltLevel(from: waterSoftner)
              saltPencentage = floor((Double(currentSaltLevel) * 100.0) / Double(maxSaltLevel))
            }
          }

          if let waterHeater: DeviceModel = waterHeater {
            setPoint = DeviceController.getWaterHeaterSetPoint(waterHeater)
            if let waterLevel = WaterHeaterCapability.getHotwaterlevelFrom(waterHeater) {
              hotWaterLevel = waterLevel
            }
            isHeating = WaterHeaterCapability.getHeatingstateFrom(waterHeater)
          }



          if let saltPencentage: Double = saltPencentage, saltPencentage <= 25.0 &&
            (waterHeater == nil || hotWaterLevel == kEnumWaterHeaterHotwaterlevelHIGH) {
            viewModel.saltPercentage = String(format:"%.0f", saltPencentage)
          } else if waterHeater != nil {
            viewModel.waterInfo = "\(setPoint)°"
            viewModel.onIndicator = isHeating

            if setPoint <= 60 {
              viewModel.target = NSLocalizedString("Low Target", comment: "")
            } else {
              switch hotWaterLevel {
              case kEnumWaterHeaterHotwaterlevelLOW:
                viewModel.target = NSLocalizedString("No Hot Water", comment: "")
              case kEnumWaterHeaterHotwaterlevelMEDIUM:
                viewModel.target = NSLocalizedString("Limited", comment: "")
              case kEnumWaterHeaterHotwaterlevelHIGH:
                viewModel.target = NSLocalizedString("Available", comment: "")
              default:
                viewModel.target = ""
              }
            }
          }
        }
      }
    }
    self.storeViewModel(viewModel)
  }
}
