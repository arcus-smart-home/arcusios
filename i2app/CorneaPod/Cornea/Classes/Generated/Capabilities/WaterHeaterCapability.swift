
//
// WaterHeaterCap.swift
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
  public static var waterHeaterNamespace: String = "waterheater"
  public static var waterHeaterName: String = "WaterHeater"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let waterHeaterHeatingstate: String = "waterheater:heatingstate"
  static let waterHeaterMaxsetpoint: String = "waterheater:maxsetpoint"
  static let waterHeaterSetpoint: String = "waterheater:setpoint"
  static let waterHeaterHotwaterlevel: String = "waterheater:hotwaterlevel"
  
}

public protocol ArcusWaterHeaterCapability: class, RxArcusService {
  /** Indicates if system is currently heating water through an element. */
  func getWaterHeaterHeatingstate(_ model: DeviceModel) -> Bool?
  /** This is the maximum temperature as set on the device. It can be changed on the device and it will report that here. */
  func getWaterHeaterMaxsetpoint(_ model: DeviceModel) -> Double?
  /** This is the user-defined setpoint of desired hotwater. The setting cannot be above the (max) setpoint set on the hardware. */
  func getWaterHeaterSetpoint(_ model: DeviceModel) -> Double?
  /** This is the user-defined setpoint of desired hotwater. The setting cannot be above the (max) setpoint set on the hardware. */
  func setWaterHeaterSetpoint(_ setpoint: Double, model: DeviceModel)
/** How much hot water is available. */
  func getWaterHeaterHotwaterlevel(_ model: DeviceModel) -> WaterHeaterHotwaterlevel?
  
  
}

extension ArcusWaterHeaterCapability {
  public func getWaterHeaterHeatingstate(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterHeaterHeatingstate] as? Bool
  }
  
  public func getWaterHeaterMaxsetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterHeaterMaxsetpoint] as? Double
  }
  
  public func getWaterHeaterSetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterHeaterSetpoint] as? Double
  }
  
  public func setWaterHeaterSetpoint(_ setpoint: Double, model: DeviceModel) {
    model.set([Attributes.waterHeaterSetpoint: setpoint as AnyObject])
  }
  public func getWaterHeaterHotwaterlevel(_ model: DeviceModel) -> WaterHeaterHotwaterlevel? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.waterHeaterHotwaterlevel] as? String,
      let enumAttr: WaterHeaterHotwaterlevel = WaterHeaterHotwaterlevel(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
}
