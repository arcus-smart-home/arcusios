
//
// DayNightSensorCap.swift
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
  public static var dayNightSensorNamespace: String = "daynight"
  public static var dayNightSensorName: String = "DayNightSensor"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let dayNightSensorMode: String = "daynight:mode"
  static let dayNightSensorModechanged: String = "daynight:modechanged"
  
}

public protocol ArcusDayNightSensorCapability: class, RxArcusService {
  /** Indicates whether sensor believes it is day or night */
  func getDayNightSensorMode(_ model: DeviceModel) -> DayNightSensorMode?
  /** UTC date time of last mode change */
  func getDayNightSensorModechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusDayNightSensorCapability {
  public func getDayNightSensorMode(_ model: DeviceModel) -> DayNightSensorMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.dayNightSensorMode] as? String,
      let enumAttr: DayNightSensorMode = DayNightSensorMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getDayNightSensorModechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.dayNightSensorModechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
