
//
// VentCapabilityLegacy.swift
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

public class VentCapabilityLegacy: NSObject, ArcusVentCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: VentCapabilityLegacy  = VentCapabilityLegacy()
  
  static let VentVentstateOK: String = VentVentstate.ok.rawValue
  static let VentVentstateOBSTRUCTION: String = VentVentstate.obstruction.rawValue
  

  
  public static func getVentstate(_ model: DeviceModel) -> String? {
    return capability.getVentVentstate(model)?.rawValue
  }
  
  public static func getLevel(_ model: DeviceModel) -> NSNumber? {
    guard let level: Int = capability.getVentLevel(model) else {
      return nil
    }
    return NSNumber(value: level)
  }
  
  public static func setLevel(_ level: Int, model: DeviceModel) {
    
    
    capability.setVentLevel(level, model: model)
  }
  
  public static func getAirpressure(_ model: DeviceModel) -> NSNumber? {
    guard let airpressure: Double = capability.getVentAirpressure(model) else {
      return nil
    }
    return NSNumber(value: airpressure)
  }
  
}
