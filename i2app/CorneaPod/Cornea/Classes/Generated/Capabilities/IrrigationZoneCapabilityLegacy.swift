
//
// IrrigationZoneCapabilityLegacy.swift
//
// Generated on 20/09/18
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

import Foundation
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class IrrigationZoneCapabilityLegacy: NSObject, ArcusIrrigationZoneCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: IrrigationZoneCapabilityLegacy  = IrrigationZoneCapabilityLegacy()
  
  static let IrrigationZoneZoneStateWATERING: String = IrrigationZoneZoneState.watering.rawValue
  static let IrrigationZoneZoneStateNOT_WATERING: String = IrrigationZoneZoneState.not_watering.rawValue
  
  static let IrrigationZoneWateringTriggerMANUAL: String = IrrigationZoneWateringTrigger.manual.rawValue
  static let IrrigationZoneWateringTriggerSCHEDULED: String = IrrigationZoneWateringTrigger.scheduled.rawValue
  
  static let IrrigationZoneZonecolorLIGHTRED: String = IrrigationZoneZonecolor.lightred.rawValue
  static let IrrigationZoneZonecolorDARKRED: String = IrrigationZoneZonecolor.darkred.rawValue
  static let IrrigationZoneZonecolorORANGE: String = IrrigationZoneZonecolor.orange.rawValue
  static let IrrigationZoneZonecolorYELLOW: String = IrrigationZoneZonecolor.yellow.rawValue
  static let IrrigationZoneZonecolorLIGHTGREEN: String = IrrigationZoneZonecolor.lightgreen.rawValue
  static let IrrigationZoneZonecolorDARKGREEN: String = IrrigationZoneZonecolor.darkgreen.rawValue
  static let IrrigationZoneZonecolorLIGHTBLUE: String = IrrigationZoneZonecolor.lightblue.rawValue
  static let IrrigationZoneZonecolorDARKBLUE: String = IrrigationZoneZonecolor.darkblue.rawValue
  static let IrrigationZoneZonecolorVIOLET: String = IrrigationZoneZonecolor.violet.rawValue
  static let IrrigationZoneZonecolorWHITE: String = IrrigationZoneZonecolor.white.rawValue
  static let IrrigationZoneZonecolorGREY: String = IrrigationZoneZonecolor.grey.rawValue
  static let IrrigationZoneZonecolorBLACK: String = IrrigationZoneZonecolor.black.rawValue
  

  
  public static func getZoneState(_ model: DeviceModel) -> String? {
    return capability.getIrrigationZoneZoneState(model)?.rawValue
  }
  
  public static func getWateringStart(_ model: DeviceModel) -> Date? {
    guard let wateringStart: Date = capability.getIrrigationZoneWateringStart(model) else {
      return nil
    }
    return wateringStart
  }
  
  public static func getWateringDuration(_ model: DeviceModel) -> NSNumber? {
    guard let wateringDuration: Int = capability.getIrrigationZoneWateringDuration(model) else {
      return nil
    }
    return NSNumber(value: wateringDuration)
  }
  
  public static func getWateringTrigger(_ model: DeviceModel) -> String? {
    return capability.getIrrigationZoneWateringTrigger(model)?.rawValue
  }
  
  public static func getDefaultDuration(_ model: DeviceModel) -> NSNumber? {
    guard let defaultDuration: Int = capability.getIrrigationZoneDefaultDuration(model) else {
      return nil
    }
    return NSNumber(value: defaultDuration)
  }
  
  public static func setDefaultDuration(_ defaultDuration: Int, model: DeviceModel) {
    
    
    capability.setIrrigationZoneDefaultDuration(defaultDuration, model: model)
  }
  
  public static func getZonenum(_ model: DeviceModel) -> NSNumber? {
    guard let zonenum: Int = capability.getIrrigationZoneZonenum(model) else {
      return nil
    }
    return NSNumber(value: zonenum)
  }
  
  public static func getZonename(_ model: DeviceModel) -> String? {
    return capability.getIrrigationZoneZonename(model)
  }
  
  public static func setZonename(_ zonename: String, model: DeviceModel) {
    
    
    capability.setIrrigationZoneZonename(zonename, model: model)
  }
  
  public static func getZonecolor(_ model: DeviceModel) -> String? {
    return capability.getIrrigationZoneZonecolor(model)?.rawValue
  }
  
  public static func setZonecolor(_ zonecolor: String, model: DeviceModel) {
    guard let zonecolor: IrrigationZoneZonecolor = IrrigationZoneZonecolor(rawValue: zonecolor) else { return }
    
    capability.setIrrigationZoneZonecolor(zonecolor, model: model)
  }
  
  public static func getWateringRemainingTime(_ model: DeviceModel) -> NSNumber? {
    guard let wateringRemainingTime: Int = capability.getIrrigationZoneWateringRemainingTime(model) else {
      return nil
    }
    return NSNumber(value: wateringRemainingTime)
  }
  
}
