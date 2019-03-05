
//
// ThermostatCap.swift
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
  public static var thermostatNamespace: String = "therm"
  public static var thermostatName: String = "Thermostat"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let thermostatCoolsetpoint: String = "therm:coolsetpoint"
  static let thermostatHeatsetpoint: String = "therm:heatsetpoint"
  static let thermostatMinsetpoint: String = "therm:minsetpoint"
  static let thermostatMaxsetpoint: String = "therm:maxsetpoint"
  static let thermostatSetpointseparation: String = "therm:setpointseparation"
  static let thermostatHvacmode: String = "therm:hvacmode"
  static let thermostatSupportedmodes: String = "therm:supportedmodes"
  static let thermostatSupportsAuto: String = "therm:supportsAuto"
  static let thermostatFanmode: String = "therm:fanmode"
  static let thermostatMaxfanspeed: String = "therm:maxfanspeed"
  static let thermostatAutofanspeed: String = "therm:autofanspeed"
  static let thermostatEmergencyheat: String = "therm:emergencyheat"
  static let thermostatControlmode: String = "therm:controlmode"
  static let thermostatFiltertype: String = "therm:filtertype"
  static let thermostatFilterlifespanruntime: String = "therm:filterlifespanruntime"
  static let thermostatFilterlifespandays: String = "therm:filterlifespandays"
  static let thermostatRuntimesincefilterchange: String = "therm:runtimesincefilterchange"
  static let thermostatDayssincefilterchange: String = "therm:dayssincefilterchange"
  static let thermostatActive: String = "therm:active"
  
}

public protocol ArcusThermostatCapability: class, RxArcusService {
  /** The desired low temperature when the HVAC unit is in cooling or auto mode. May also be used to set the target temperature. */
  func getThermostatCoolsetpoint(_ model: DeviceModel) -> Double?
  /** The desired low temperature when the HVAC unit is in cooling or auto mode. May also be used to set the target temperature. */
  func setThermostatCoolsetpoint(_ coolsetpoint: Double, model: DeviceModel)
/** The desired high temperature when the HVAC unit is in heating or auto mode. May also be used to set the target temperature. */
  func getThermostatHeatsetpoint(_ model: DeviceModel) -> Double?
  /** The desired high temperature when the HVAC unit is in heating or auto mode. May also be used to set the target temperature. */
  func setThermostatHeatsetpoint(_ heatsetpoint: Double, model: DeviceModel)
/** The minimum setpoint for the thermostat, inclusive.  The heatsetpoint can&#x27;t be set below this and the coolsetpoint can&#x27;t be set below minsetpoint + setpointseparation. */
  func getThermostatMinsetpoint(_ model: DeviceModel) -> Double?
  /** The maximum setpoint for the thermostat, inclusive.  The coolsetpoint can&#x27;t be set above this and the heatsetpoint can&#x27;t be set above maxsetpoint - setpointseparation. */
  func getThermostatMaxsetpoint(_ model: DeviceModel) -> Double?
  /** The heatsetpoint and coolsetpoint should be kept apart by at least this many degrees.  If only heatsetpoint or coolsetpoint are changed then the driver must automatically adjust the other setpoint if needed.  If both are specified and within setpointseparation of each other the driver may adjust either setpoint as needed to maintain the proper amount of separation. */
  func getThermostatSetpointseparation(_ model: DeviceModel) -> Double?
  /** The current mode of the HVAC system. */
  func getThermostatHvacmode(_ model: DeviceModel) -> ThermostatHvacmode?
  /** The current mode of the HVAC system. */
  func setThermostatHvacmode(_ hvacmode: ThermostatHvacmode, model: DeviceModel)
/** Modes supported by this thermostat */
  func getThermostatSupportedmodes(_ model: DeviceModel) -> [String]?
  /** Whether or not the thermostat supports AUTO mode.  If not present, assume true */
  func getThermostatSupportsAuto(_ model: DeviceModel) -> Bool?
  /** Current fan mode setting. */
  func getThermostatFanmode(_ model: DeviceModel) -> Int?
  /** Current fan mode setting. */
  func setThermostatFanmode(_ fanmode: Int, model: DeviceModel)
/** The maximum speed supported by the fan. */
  func getThermostatMaxfanspeed(_ model: DeviceModel) -> Int?
  /** Set the speed of the fan when in auto mode. */
  func getThermostatAutofanspeed(_ model: DeviceModel) -> Int?
  /** Useful only for 2 stage heat pumps that require a secondary (usually electric) heater when the external temperature is below a certain threshold. */
  func getThermostatEmergencyheat(_ model: DeviceModel) -> ThermostatEmergencyheat?
  /** Useful only for 2 stage heat pumps that require a secondary (usually electric) heater when the external temperature is below a certain threshold. */
  func setThermostatEmergencyheat(_ emergencyheat: ThermostatEmergencyheat, model: DeviceModel)
/** The current mode of the HVAC system. */
  func getThermostatControlmode(_ model: DeviceModel) -> ThermostatControlmode?
  /** The current mode of the HVAC system. */
  func setThermostatControlmode(_ controlmode: ThermostatControlmode, model: DeviceModel)
/** Placeholder for user to enter filter type like 16x25x1. */
  func getThermostatFiltertype(_ model: DeviceModel) -> String?
  /** Placeholder for user to enter filter type like 16x25x1. */
  func setThermostatFiltertype(_ filtertype: String, model: DeviceModel)
/** Placeholder for user to enter life span (in runtime hours) of the filter. */
  func getThermostatFilterlifespanruntime(_ model: DeviceModel) -> Int?
  /** Placeholder for user to enter life span (in runtime hours) of the filter. */
  func setThermostatFilterlifespanruntime(_ filterlifespanruntime: Int, model: DeviceModel)
/** Placeholder for user to enter life span (in total days) of the filter. */
  func getThermostatFilterlifespandays(_ model: DeviceModel) -> Int?
  /** Placeholder for user to enter life span (in total days) of the filter. */
  func setThermostatFilterlifespandays(_ filterlifespandays: Int, model: DeviceModel)
/** Number of hours of runtime since the last filter change. */
  func getThermostatRuntimesincefilterchange(_ model: DeviceModel) -> Int?
  /** Number of days elapsed since the last filter change. */
  func getThermostatDayssincefilterchange(_ model: DeviceModel) -> Int?
  /** Indicator of whether the HVAC system is actively running or not.  Interpreted as fan is blowing, not necessarily heating or cooling. */
  func getThermostatActive(_ model: DeviceModel) -> ThermostatActive?
  
  /** Indicates that the filter has been changed and that runtimesincefilterchange and dayssincefilterchange should be reset. */
  func requestThermostatChangeFilter(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will set each 2 degrees F from the desired temp.  If the OFF no action should be taken. */
  func requestThermostatSetIdealTemperature(_  model: DeviceModel, temperature: Double)
   throws -> Observable<ArcusSessionEvent>/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
  func requestThermostatIncrementIdealTemperature(_  model: DeviceModel, amount: Double)
   throws -> Observable<ArcusSessionEvent>/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
  func requestThermostatDecrementIdealTemperature(_  model: DeviceModel, amount: Double)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusThermostatCapability {
  public func getThermostatCoolsetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatCoolsetpoint] as? Double
  }
  
  public func setThermostatCoolsetpoint(_ coolsetpoint: Double, model: DeviceModel) {
    model.set([Attributes.thermostatCoolsetpoint: coolsetpoint as AnyObject])
  }
  public func getThermostatHeatsetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatHeatsetpoint] as? Double
  }
  
  public func setThermostatHeatsetpoint(_ heatsetpoint: Double, model: DeviceModel) {
    model.set([Attributes.thermostatHeatsetpoint: heatsetpoint as AnyObject])
  }
  public func getThermostatMinsetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatMinsetpoint] as? Double
  }
  
  public func getThermostatMaxsetpoint(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatMaxsetpoint] as? Double
  }
  
  public func getThermostatSetpointseparation(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatSetpointseparation] as? Double
  }
  
  public func getThermostatHvacmode(_ model: DeviceModel) -> ThermostatHvacmode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.thermostatHvacmode] as? String,
      let enumAttr: ThermostatHvacmode = ThermostatHvacmode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setThermostatHvacmode(_ hvacmode: ThermostatHvacmode, model: DeviceModel) {
    model.set([Attributes.thermostatHvacmode: hvacmode.rawValue as AnyObject])
  }
  public func getThermostatSupportedmodes(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatSupportedmodes] as? [String]
  }
  
  public func getThermostatSupportsAuto(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatSupportsAuto] as? Bool
  }
  
  public func getThermostatFanmode(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatFanmode] as? Int
  }
  
  public func setThermostatFanmode(_ fanmode: Int, model: DeviceModel) {
    model.set([Attributes.thermostatFanmode: fanmode as AnyObject])
  }
  public func getThermostatMaxfanspeed(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatMaxfanspeed] as? Int
  }
  
  public func getThermostatAutofanspeed(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatAutofanspeed] as? Int
  }
  
  public func getThermostatEmergencyheat(_ model: DeviceModel) -> ThermostatEmergencyheat? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.thermostatEmergencyheat] as? String,
      let enumAttr: ThermostatEmergencyheat = ThermostatEmergencyheat(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setThermostatEmergencyheat(_ emergencyheat: ThermostatEmergencyheat, model: DeviceModel) {
    model.set([Attributes.thermostatEmergencyheat: emergencyheat.rawValue as AnyObject])
  }
  public func getThermostatControlmode(_ model: DeviceModel) -> ThermostatControlmode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.thermostatControlmode] as? String,
      let enumAttr: ThermostatControlmode = ThermostatControlmode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setThermostatControlmode(_ controlmode: ThermostatControlmode, model: DeviceModel) {
    model.set([Attributes.thermostatControlmode: controlmode.rawValue as AnyObject])
  }
  public func getThermostatFiltertype(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatFiltertype] as? String
  }
  
  public func setThermostatFiltertype(_ filtertype: String, model: DeviceModel) {
    model.set([Attributes.thermostatFiltertype: filtertype as AnyObject])
  }
  public func getThermostatFilterlifespanruntime(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatFilterlifespanruntime] as? Int
  }
  
  public func setThermostatFilterlifespanruntime(_ filterlifespanruntime: Int, model: DeviceModel) {
    model.set([Attributes.thermostatFilterlifespanruntime: filterlifespanruntime as AnyObject])
  }
  public func getThermostatFilterlifespandays(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatFilterlifespandays] as? Int
  }
  
  public func setThermostatFilterlifespandays(_ filterlifespandays: Int, model: DeviceModel) {
    model.set([Attributes.thermostatFilterlifespandays: filterlifespandays as AnyObject])
  }
  public func getThermostatRuntimesincefilterchange(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatRuntimesincefilterchange] as? Int
  }
  
  public func getThermostatDayssincefilterchange(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.thermostatDayssincefilterchange] as? Int
  }
  
  public func getThermostatActive(_ model: DeviceModel) -> ThermostatActive? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.thermostatActive] as? String,
      let enumAttr: ThermostatActive = ThermostatActive(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
  public func requestThermostatChangeFilter(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: ThermostatChangeFilterRequest = ThermostatChangeFilterRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestThermostatSetIdealTemperature(_  model: DeviceModel, temperature: Double)
   throws -> Observable<ArcusSessionEvent> {
    let request: ThermostatSetIdealTemperatureRequest = ThermostatSetIdealTemperatureRequest()
    request.source = model.address
    
    
    
    request.setTemperature(temperature)
    
    return try sendRequest(request)
  }
  
  public func requestThermostatIncrementIdealTemperature(_  model: DeviceModel, amount: Double)
   throws -> Observable<ArcusSessionEvent> {
    let request: ThermostatIncrementIdealTemperatureRequest = ThermostatIncrementIdealTemperatureRequest()
    request.source = model.address
    
    
    
    request.setAmount(amount)
    
    return try sendRequest(request)
  }
  
  public func requestThermostatDecrementIdealTemperature(_  model: DeviceModel, amount: Double)
   throws -> Observable<ArcusSessionEvent> {
    let request: ThermostatDecrementIdealTemperatureRequest = ThermostatDecrementIdealTemperatureRequest()
    request.source = model.address
    
    
    
    request.setAmount(amount)
    
    return try sendRequest(request)
  }
  
}
