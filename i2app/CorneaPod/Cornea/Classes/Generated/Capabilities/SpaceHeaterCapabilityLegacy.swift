
//
// SpaceHeaterCapabilityLegacy.swift
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

public class SpaceHeaterCapabilityLegacy: NSObject, ArcusSpaceHeaterCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SpaceHeaterCapabilityLegacy  = SpaceHeaterCapabilityLegacy()
  
  static let SpaceHeaterHeatstateOFF: String = SpaceHeaterHeatstate.off.rawValue
  static let SpaceHeaterHeatstateON: String = SpaceHeaterHeatstate.on.rawValue
  

  
  public static func getSetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let setpoint: Double = capability.getSpaceHeaterSetpoint(model) else {
      return nil
    }
    return NSNumber(value: setpoint)
  }
  
  public static func setSetpoint(_ setpoint: Double, model: DeviceModel) {
    
    
    capability.setSpaceHeaterSetpoint(setpoint, model: model)
  }
  
  public static func getMinsetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let minsetpoint: Double = capability.getSpaceHeaterMinsetpoint(model) else {
      return nil
    }
    return NSNumber(value: minsetpoint)
  }
  
  public static func getMaxsetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let maxsetpoint: Double = capability.getSpaceHeaterMaxsetpoint(model) else {
      return nil
    }
    return NSNumber(value: maxsetpoint)
  }
  
  public static func getHeatstate(_ model: DeviceModel) -> String? {
    return capability.getSpaceHeaterHeatstate(model)?.rawValue
  }
  
  public static func setHeatstate(_ heatstate: String, model: DeviceModel) {
    guard let heatstate: SpaceHeaterHeatstate = SpaceHeaterHeatstate(rawValue: heatstate) else { return }
    
    capability.setSpaceHeaterHeatstate(heatstate, model: model)
  }
  
}
