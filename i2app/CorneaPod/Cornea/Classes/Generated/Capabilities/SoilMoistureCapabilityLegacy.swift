
//
// SoilMoistureCapabilityLegacy.swift
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

public class SoilMoistureCapabilityLegacy: NSObject, ArcusSoilMoistureCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SoilMoistureCapabilityLegacy  = SoilMoistureCapabilityLegacy()
  
  static let SoilMoistureSoiltypeNORMAL: String = SoilMoistureSoiltype.normal.rawValue
  static let SoilMoistureSoiltypeSANDY: String = SoilMoistureSoiltype.sandy.rawValue
  static let SoilMoistureSoiltypeCLAY: String = SoilMoistureSoiltype.clay.rawValue
  

  
  public static func getWatercontent(_ model: DeviceModel) -> NSNumber? {
    guard let watercontent: Double = capability.getSoilMoistureWatercontent(model) else {
      return nil
    }
    return NSNumber(value: watercontent)
  }
  
  public static func getSoiltype(_ model: DeviceModel) -> String? {
    return capability.getSoilMoistureSoiltype(model)?.rawValue
  }
  
  public static func setSoiltype(_ soiltype: String, model: DeviceModel) {
    guard let soiltype: SoilMoistureSoiltype = SoilMoistureSoiltype(rawValue: soiltype) else { return }
    
    capability.setSoilMoistureSoiltype(soiltype, model: model)
  }
  
  public static func getWatercontentupdated(_ model: DeviceModel) -> Date? {
    guard let watercontentupdated: Date = capability.getSoilMoistureWatercontentupdated(model) else {
      return nil
    }
    return watercontentupdated
  }
  
}
