
//
// SpaceHeaterCap.swift
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
  public static var spaceHeaterNamespace: String = "spaceheater"
  public static var spaceHeaterName: String = "SpaceHeater"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let spaceHeaterSetpoint: String = "spaceheater:setpoint"
  static let spaceHeaterMinsetpoint: String = "spaceheater:minsetpoint"
  static let spaceHeaterMaxsetpoint: String = "spaceheater:maxsetpoint"
  static let spaceHeaterHeatstate: String = "spaceheater:heatstate"
  
}

public protocol ArcusSpaceHeaterCapability: class, RxArcusService {
  /** The desired temperature when the unit is running, maps to heatsetpoint in  thermostat. May also be used to set the target temperature. */
  func getSpaceHeaterSetpoint(_ model: DeviceModel) -> Double?
  /** The desired temperature when the unit is running, maps to heatsetpoint in  thermostat. May also be used to set the target temperature. */
  func setSpaceHeaterSetpoint(_ setpoint: Double, model: DeviceModel)
/** The minimum temperature that can be placed in setpoint. */
  func getSpaceHeaterMinsetpoint(_ model: DeviceModel) -> Double?
  /** The maximum temperature that can be placed in setpoint. */
  func getSpaceHeaterMaxsetpoint(_ model: DeviceModel) -> Double?
  /** The current mode of the device, maps to OFF, HEAT in thermostat:mode. */
  func getSpaceHeaterHeatstate(_ model: DeviceModel) -> SpaceHeaterHeatstate?
  /** The current mode of the device, maps to OFF, HEAT in thermostat:mode. */
  func setSpaceHeaterHeatstate(_ heatstate: SpaceHeaterHeatstate, model: DeviceModel)

  
}

extension ArcusSpaceHeaterCapability {
  public func getSpaceHeaterSetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.spaceHeaterSetpoint] as? Double
  }
  
  public func setSpaceHeaterSetpoint(_ setpoint: Double, model: DeviceModel) {
    model.set([Attributes.spaceHeaterSetpoint: setpoint as AnyObject])
  }
  public func getSpaceHeaterMinsetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.spaceHeaterMinsetpoint] as? Double
  }
  
  public func getSpaceHeaterMaxsetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.spaceHeaterMaxsetpoint] as? Double
  }
  
  public func getSpaceHeaterHeatstate(_ model: DeviceModel) -> SpaceHeaterHeatstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.spaceHeaterHeatstate] as? String,
      let enumAttr: SpaceHeaterHeatstate = SpaceHeaterHeatstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSpaceHeaterHeatstate(_ heatstate: SpaceHeaterHeatstate, model: DeviceModel) {
    model.set([Attributes.spaceHeaterHeatstate: heatstate.rawValue as AnyObject])
  }
  
}
