
//
// NestThermostatCap.swift
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
  public static var nestThermostatNamespace: String = "nesttherm"
  public static var nestThermostatName: String = "NestThermostat"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let nestThermostatHasleaf: String = "nesttherm:hasleaf"
  static let nestThermostatRoomname: String = "nesttherm:roomname"
  static let nestThermostatLocked: String = "nesttherm:locked"
  static let nestThermostatLockedtempmin: String = "nesttherm:lockedtempmin"
  static let nestThermostatLockedtempmax: String = "nesttherm:lockedtempmax"
  
}

public protocol ArcusNestThermostatCapability: class, RxArcusService {
  /** Updated to reflect whether nest thermostat is showing a leaf (read from Nest platform) */
  func getNestThermostatHasleaf(_ model: DeviceModel) -> Bool?
  /** Name of the room this nest thermostat is located in */
  func getNestThermostatRoomname(_ model: DeviceModel) -> String?
  /** Updated to reflect whether nest thermostat is is locked to allow sets only within a particular temperature range */
  func getNestThermostatLocked(_ model: DeviceModel) -> Bool?
  /** The minimum temperature that the nest thermostat can be set to when locked is true. */
  func getNestThermostatLockedtempmin(_ model: DeviceModel) -> Double?
  /** The maximum temperature that the nest thermostat can be set to when locked is true. */
  func getNestThermostatLockedtempmax(_ model: DeviceModel) -> Double?
  
  
}

extension ArcusNestThermostatCapability {
  public func getNestThermostatHasleaf(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.nestThermostatHasleaf] as? Bool
  }
  
  public func getNestThermostatRoomname(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.nestThermostatRoomname] as? String
  }
  
  public func getNestThermostatLocked(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.nestThermostatLocked] as? Bool
  }
  
  public func getNestThermostatLockedtempmin(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.nestThermostatLockedtempmin] as? Double
  }
  
  public func getNestThermostatLockedtempmax(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.nestThermostatLockedtempmax] as? Double
  }
  
  
}
