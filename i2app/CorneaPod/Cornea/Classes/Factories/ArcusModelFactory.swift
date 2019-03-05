//
//  ArcusModelFactory.swift
//  i2app
//
//  Created by Arcus Team on 8/29/17.
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

public protocol ArcusModelFactory: ArcusFactory {
  /**
   Build model from attributes.
   
   - Parameters:
   - attributes: Dictionary of attributes to create model.
   
   - Returns: `ArcusModel` created from attributes.
   */
  func build(_ attributes: [String: AnyObject]) -> ArcusModel
}

extension ArcusModelFactory {
  public func build(_ attributes: [String: AnyObject]) -> ArcusModel {
    let baseModel = Model(attributes: attributes)
    
    if let modelType = baseModel.getType() {
      switch modelType {
      case Constants.accountNamespace:
        return AccountModel(attributes: attributes)
      case Constants.alarmIncidentNamespace:
        return AlarmIncidentModel(attributes: attributes)
      case Constants.alarmNamespace:
        return AlarmModel(attributes: attributes)
      case Constants.cameraStatusNamespace:
        return CameraStatusModel(attributes: attributes)
      case Constants.deviceNamespace:
        return DeviceModel(attributes: attributes)
      case Constants.pairingDeviceNamespace:
        return PairingDeviceModel(attributes: attributes)
      case Constants.hubAlarmNamespace:
        return HubAlarmModel(attributes: attributes)
      case Constants.hubNamespace:
        return HubModel(attributes: attributes)
      case Constants.hubZwaveNamespace:
        return HubZwaveModel(attributes: attributes)
      case Constants.mobileDeviceNamespace:
        return MobileDeviceModel(attributes: attributes)
      case Constants.personNamespace:
        return PersonModel(attributes: attributes)
      case Constants.placeNamespace:
        return PlaceModel(attributes: attributes)
      case Constants.populationNamespace:
        return PopulationModel(attributes: attributes)
      case Constants.productCatalogNamespace:
        return ProductCatalogModel(attributes: attributes)
      case Constants.productNamespace:
        return ProductModel(attributes: attributes)
      case Constants.proMonitoringSettingsNamespace:
        return ProMonitoringSettingsModel(attributes: attributes)
      case Constants.recordingNamespace:
        return RecordingModel(attributes: attributes)
      case Constants.ruleNamespace:
        return RuleModel(attributes: attributes)
      case Constants.sceneNamespace:
        return SceneModel(attributes: attributes)
      case Constants.scheduleNamespace:
        return ScheduleModel(attributes: attributes)
      case Constants.schedulerNamespace:
        return SchedulerModel(attributes: attributes)
      case Constants.subsystemNamespace:
        return SubsystemModel(attributes: attributes)
      default:
        return baseModel
      }
    }
    return baseModel
  }
}
