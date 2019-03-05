//
//  PairingCustomizationViewControllerFactory.swift
//  i2app
//
//  Created by Arcus Team on 2/28/18.
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

class PairingCustomizationViewControllerFactory {
  
  static func viewController(forStepType stepType: PairingCustomizationStepType)
    -> (UIViewController & PairingCustomizationStepPresenter)? {
    
    switch stepType {
    case .name:
      return NameDeviceViewController.create()
    case .favorite:
      return FavoriteDeviceViewController.create()
    case .contactType:
      return ContactUseSelectionViewController.create()
    case .info:
      return PairingInfomercialViewController.create()
    case .presenceAssignment:
      return PresenceAssignmentViewController.create()
    case .weatherRadioStation:
      return WeatherRadioStationViewController.create()
    case .securityMode:
      return SecurityModeViewController.create()
    case .promonAlarm:
      return PromonAlarmCustomizationViewController.create()
    case .waterHeater:
      return WaterHeaterCustomizationViewController.create()
    case .room:
      return RoomSelectionViewController.create()
    case .stateCountySelect:
      return ChooseCountyViewController.create()
    case .irrigationZone:
      return IrrigationSingleCustomizationViewController.create()
    case .multiIrrigationZone:
      return IrrigationMultiCustomizeViewController.create()
    case .multiButtonAssignment:
      return MultiButtonCustomizationViewController.create()
    case .otaUpgrade:
      return OTAUpgradeViewController.create()
    case .contactTest:
      return ContactTestViewController.create()
    default:
      return nil
    }
  }
  
}
