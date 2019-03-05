
//
// IrrigationZoneCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var irrigationZoneNamespace: String = "irr"
  public static var irrigationZoneName: String = "IrrigationZone"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let irrigationZoneZoneState: String = "irr:zoneState"
  static let irrigationZoneWateringStart: String = "irr:wateringStart"
  static let irrigationZoneWateringDuration: String = "irr:wateringDuration"
  static let irrigationZoneWateringTrigger: String = "irr:wateringTrigger"
  static let irrigationZoneDefaultDuration: String = "irr:defaultDuration"
  static let irrigationZoneZonenum: String = "irr:zonenum"
  static let irrigationZoneZonename: String = "irr:zonename"
  static let irrigationZoneZonecolor: String = "irr:zonecolor"
  static let irrigationZoneWateringRemainingTime: String = "irr:wateringRemainingTime"
  
}

public protocol ArcusIrrigationZoneCapability: class, RxArcusService {
  /** Indicates whether the zone is currently watering or not */
  func getIrrigationZoneZoneState(_ model: DeviceModel) -> IrrigationZoneZoneState?
  /** If watering, the time at which the watering started. Together with wateringDuration this defines a time range during which watering will be acive. */
  func getIrrigationZoneWateringStart(_ model: DeviceModel) -> Date?
  /** If not watering, set to 0. If non-zero, can be used with wateringStart to define a time range during which watering will be active. */
  func getIrrigationZoneWateringDuration(_ model: DeviceModel) -> Int?
  /** If watering, what triggered the watering event */
  func getIrrigationZoneWateringTrigger(_ model: DeviceModel) -> IrrigationZoneWateringTrigger?
  /** The default duration in minutes for scheduling this zone */
  func getIrrigationZoneDefaultDuration(_ model: DeviceModel) -> Int?
  /** The default duration in minutes for scheduling this zone */
  func setIrrigationZoneDefaultDuration(_ defaultDuration: Int, model: DeviceModel)
/** Index of this zone on the system. Should start at 1 so 0 can represent pump or full system. */
  func getIrrigationZoneZonenum(_ model: DeviceModel) -> Int?
  /** Name of the zone on the platform. (&#x27;front yard&#x27;, &#x27;roses&#x27;, etc.) */
  func getIrrigationZoneZonename(_ model: DeviceModel) -> String?
  /** Name of the zone on the platform. (&#x27;front yard&#x27;, &#x27;roses&#x27;, etc.) */
  func setIrrigationZoneZonename(_ zonename: String, model: DeviceModel)
/** Color used to represent the zone on the UI. */
  func getIrrigationZoneZonecolor(_ model: DeviceModel) -> IrrigationZoneZonecolor?
  /** Color used to represent the zone on the UI. */
  func setIrrigationZoneZonecolor(_ zonecolor: IrrigationZoneZonecolor, model: DeviceModel)
/** This attribute was deprecated in the 1.8 release. */
  func getIrrigationZoneWateringRemainingTime(_ model: DeviceModel) -> Int?
  
  
}

extension ArcusIrrigationZoneCapability {
  public func getIrrigationZoneZoneState(_ model: DeviceModel) -> IrrigationZoneZoneState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.irrigationZoneZoneState] as? String,
      let enumAttr: IrrigationZoneZoneState = IrrigationZoneZoneState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getIrrigationZoneWateringStart(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.irrigationZoneWateringStart] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getIrrigationZoneWateringDuration(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationZoneWateringDuration] as? Int
  }
  
  public func getIrrigationZoneWateringTrigger(_ model: DeviceModel) -> IrrigationZoneWateringTrigger? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.irrigationZoneWateringTrigger] as? String,
      let enumAttr: IrrigationZoneWateringTrigger = IrrigationZoneWateringTrigger(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getIrrigationZoneDefaultDuration(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationZoneDefaultDuration] as? Int
  }
  
  public func setIrrigationZoneDefaultDuration(_ defaultDuration: Int, model: DeviceModel) {
    model.set([Attributes.irrigationZoneDefaultDuration: defaultDuration as AnyObject])
  }
  public func getIrrigationZoneZonenum(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationZoneZonenum] as? Int
  }
  
  public func getIrrigationZoneZonename(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationZoneZonename] as? String
  }
  
  public func setIrrigationZoneZonename(_ zonename: String, model: DeviceModel) {
    model.set([Attributes.irrigationZoneZonename: zonename as AnyObject])
  }
  public func getIrrigationZoneZonecolor(_ model: DeviceModel) -> IrrigationZoneZonecolor? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.irrigationZoneZonecolor] as? String,
      let enumAttr: IrrigationZoneZonecolor = IrrigationZoneZonecolor(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setIrrigationZoneZonecolor(_ zonecolor: IrrigationZoneZonecolor, model: DeviceModel) {
    model.set([Attributes.irrigationZoneZonecolor: zonecolor.rawValue as AnyObject])
  }
  public func getIrrigationZoneWateringRemainingTime(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationZoneWateringRemainingTime] as? Int
  }
  
  
}
