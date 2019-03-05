
//
// WaterHeaterCapabilityLegacy.swift
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

public class WaterHeaterCapabilityLegacy: NSObject, ArcusWaterHeaterCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: WaterHeaterCapabilityLegacy  = WaterHeaterCapabilityLegacy()
  
  static let WaterHeaterHotwaterlevelLOW: String = WaterHeaterHotwaterlevel.low.rawValue
  static let WaterHeaterHotwaterlevelMEDIUM: String = WaterHeaterHotwaterlevel.medium.rawValue
  static let WaterHeaterHotwaterlevelHIGH: String = WaterHeaterHotwaterlevel.high.rawValue
  

  
  public static func getHeatingstate(_ model: DeviceModel) -> NSNumber? {
    guard let heatingstate: Bool = capability.getWaterHeaterHeatingstate(model) else {
      return nil
    }
    return NSNumber(value: heatingstate)
  }
  
  public static func getMaxsetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let maxsetpoint: Double = capability.getWaterHeaterMaxsetpoint(model) else {
      return nil
    }
    return NSNumber(value: maxsetpoint)
  }
  
  public static func getSetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let setpoint: Double = capability.getWaterHeaterSetpoint(model) else {
      return nil
    }
    return NSNumber(value: setpoint)
  }
  
  public static func setSetpoint(_ setpoint: Double, model: DeviceModel) {
    
    
    capability.setWaterHeaterSetpoint(setpoint, model: model)
  }
  
  public static func getHotwaterlevel(_ model: DeviceModel) -> String? {
    return capability.getWaterHeaterHotwaterlevel(model)?.rawValue
  }
  
}
