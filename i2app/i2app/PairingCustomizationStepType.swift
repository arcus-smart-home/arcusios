//
//  PairingCustomizationStepType.swift
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

/**
 These values must match those defined by the Pairing Subsystem platform API
 for PairingCustomizationStep Type.
 - https://eyeris.atlassian.net/wiki/spaces/I2D/pages/197394451/Pairing+Subsystem
 */
enum PairingCustomizationStepType: String {
  
  case name = "NAME"
  case favorite = "FAVORITE"
  case rules = "RULES"
  case buttonAssignment = "BUTTON_ASSIGNMENT"
  case contactType = "CONTACT_TYPE"
  case presenceAssignment = "PRESENCE_ASSIGNMENT"
  case schedule = "SCHEDULE"
  case info = "INFO"
  case room = "ROOM"
  case weatherRadioStation = "WEATHER_RADIO_STATION"
  case promonAlarm = "PROMON_ALARM"
  case securityMode = "SECURITY_MODE"
  case stateCountySelect = "STATE_COUNTY_SELECT"
  case otaUpgrade = "OTA_UPGRADE"
  case waterHeater = "WATER_HEATER"
  case complete = "CUSTOMIZATION_COMPLETE"
  case multiButtonAssignment = "MULTI_BUTTON_ASSIGNMENT"
  case irrigationZone = "IRRIGATION_ZONE"
  case multiIrrigationZone = "MULTI_IRRIGATION_ZONE"
  case contactTest = "CONTACT_TEST"
  
}
