
//
// ThermostatCapEvents.swift
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

// MARK: Commands
fileprivate struct Commands {
  /** Indicates that the filter has been changed and that runtimesincefilterchange and dayssincefilterchange should be reset. */
  static let thermostatChangeFilter: String = "therm:changeFilter"
  /** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will set each 2 degrees F from the desired temp.  If the OFF no action should be taken. */
  static let thermostatSetIdealTemperature: String = "therm:SetIdealTemperature"
  /** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
  static let thermostatIncrementIdealTemperature: String = "therm:IncrementIdealTemperature"
  /** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
  static let thermostatDecrementIdealTemperature: String = "therm:DecrementIdealTemperature"
  
}
// MARK: Events
public struct ThermostatEvents {
  /** Notifies the system that a thermostat setpoint has been changed. */
  public static let thermostatSetPointChanged: String = "therm:SetPointChanged"
  }

// MARK: Enumerations

/** The current mode of the HVAC system. */
public enum ThermostatHvacmode: String {
  case off = "OFF"
  case auto = "AUTO"
  case cool = "COOL"
  case heat = "HEAT"
  case eco = "ECO"
}

/** Useful only for 2 stage heat pumps that require a secondary (usually electric) heater when the external temperature is below a certain threshold. */
public enum ThermostatEmergencyheat: String {
  case on = "ON"
  case off = "OFF"
}

/** The current mode of the HVAC system. */
public enum ThermostatControlmode: String {
  case presence = "PRESENCE"
  case manual = "MANUAL"
  case schedulesimple = "SCHEDULESIMPLE"
  case scheduleadvanced = "SCHEDULEADVANCED"
}

/** Indicator of whether the HVAC system is actively running or not.  Interpreted as fan is blowing, not necessarily heating or cooling. */
public enum ThermostatActive: String {
  case running = "RUNNING"
  case notrunning = "NOTRUNNING"
}

// MARK: Requests

/** Indicates that the filter has been changed and that runtimesincefilterchange and dayssincefilterchange should be reset. */
public class ThermostatChangeFilterRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.thermostatChangeFilter
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ThermostatChangeFilterResponse(message)
  }

  
}

public class ThermostatChangeFilterResponse: SessionEvent {
  
}

/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will set each 2 degrees F from the desired temp.  If the OFF no action should be taken. */
public class ThermostatSetIdealTemperatureRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ThermostatSetIdealTemperatureRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.thermostatSetIdealTemperature
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ThermostatSetIdealTemperatureResponse(message)
  }

  // MARK: SetIdealTemperatureRequest Attributes
  struct Attributes {
    /** The target temperature to set. */
    static let temperature: String = "temperature"
 }
  
  /** The target temperature to set. */
  public func setTemperature(_ temperature: Double) {
    attributes[Attributes.temperature] = temperature as AnyObject
  }

  
}

public class ThermostatSetIdealTemperatureResponse: SessionEvent {
  
  
  /** The current mode of the thermostat */
  public enum ThermostatHvacmode: String {
    case auto = "AUTO"
    case heat = "HEAT"
    case cool = "COOL"
    case off = "OFF"
    
  }
  /** True if Ideal Temperature will be set, False if setting specified is out of range */
  public func getResult() -> Bool? {
    return self.attributes["result"] as? Bool
  }
  /** The ideal temperature set on the device.  When in auto mode this should be the midpoint between the cool/heat set point */
  public func getIdealTempSet() -> Double? {
    return self.attributes["idealTempSet"] as? Double
  }
  /** The current mode of the thermostat */
  public func getHvacmode() -> ThermostatHvacmode? {
    guard let attribute = self.attributes["hvacmode"] as? String,
      let enumAttr: ThermostatHvacmode = ThermostatHvacmode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The previous ideal temperature set on the device.  When in auto mode this should be the midpoint between the cool/heat set point */
  public func getPrevIdealTemp() -> Double? {
    return self.attributes["prevIdealTemp"] as? Double
  }
  /** The maximum allowed Set Point temperature on the device for the current HVAC Mode. */
  public func getMaxSetPoint() -> Double? {
    return self.attributes["maxSetPoint"] as? Double
  }
  /** The minimum allowed Set Point temperature on the device for the current HVAC Mode. */
  public func getMinSetPoint() -> Double? {
    return self.attributes["minSetPoint"] as? Double
  }
}

/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
public class ThermostatIncrementIdealTemperatureRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ThermostatIncrementIdealTemperatureRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.thermostatIncrementIdealTemperature
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ThermostatIncrementIdealTemperatureResponse(message)
  }

  // MARK: IncrementIdealTemperatureRequest Attributes
  struct Attributes {
    /** The amount to increment the temperature */
    static let amount: String = "amount"
 }
  
  /** The amount to increment the temperature */
  public func setAmount(_ amount: Double) {
    attributes[Attributes.amount] = amount as AnyObject
  }

  
}

public class ThermostatIncrementIdealTemperatureResponse: SessionEvent {
  
  
  /** The current mode of the thermostat */
  public enum ThermostatHvacmode: String {
    case auto = "AUTO"
    case heat = "HEAT"
    case cool = "COOL"
    case off = "OFF"
    
  }
  /** True if Ideal Temperature will be incremented, False if increase would move temperature setting out of range */
  public func getResult() -> Bool? {
    return self.attributes["result"] as? Bool
  }
  /** The ideal temperature set on the device.  When in auto mode this should be the midpoint between the cool/heat set point */
  public func getIdealTempSet() -> Double? {
    return self.attributes["idealTempSet"] as? Double
  }
  /** The current mode of the thermostat */
  public func getHvacmode() -> ThermostatHvacmode? {
    guard let attribute = self.attributes["hvacmode"] as? String,
      let enumAttr: ThermostatHvacmode = ThermostatHvacmode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The previous ideal temperature set on the device.  When in auto mode this should be the midpoint between the cool/heat set point */
  public func getPrevIdealTemp() -> Double? {
    return self.attributes["prevIdealTemp"] as? Double
  }
  /** The maximum allowed Set Point temperature on the device for the current HVAC Mode. */
  public func getMaxSetPoint() -> Double? {
    return self.attributes["maxSetPoint"] as? Double
  }
  /** The minimum allowed Set Point temperature on the device for the current HVAC Mode. */
  public func getMinSetPoint() -> Double? {
    return self.attributes["minSetPoint"] as? Double
  }
}

/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
public class ThermostatDecrementIdealTemperatureRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ThermostatDecrementIdealTemperatureRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.thermostatDecrementIdealTemperature
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ThermostatDecrementIdealTemperatureResponse(message)
  }

  // MARK: DecrementIdealTemperatureRequest Attributes
  struct Attributes {
    /** The amount to decrement the temperature */
    static let amount: String = "amount"
 }
  
  /** The amount to decrement the temperature */
  public func setAmount(_ amount: Double) {
    attributes[Attributes.amount] = amount as AnyObject
  }

  
}

public class ThermostatDecrementIdealTemperatureResponse: SessionEvent {
  
  
  /** The current mode of the thermostat */
  public enum ThermostatHvacmode: String {
    case auto = "AUTO"
    case heat = "HEAT"
    case cool = "COOL"
    case off = "OFF"
    
  }
  /** True if Ideal Temperature will be decreased, False if decrease would move temperature setting out of range */
  public func getResult() -> Bool? {
    return self.attributes["result"] as? Bool
  }
  /** The ideal temperature set on the device.  When in auto mode this should be the midpoint between the cool/heat set point */
  public func getIdealTempSet() -> Double? {
    return self.attributes["idealTempSet"] as? Double
  }
  /** The current mode of the thermostat */
  public func getHvacmode() -> ThermostatHvacmode? {
    guard let attribute = self.attributes["hvacmode"] as? String,
      let enumAttr: ThermostatHvacmode = ThermostatHvacmode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The previous ideal temperature set on the device.  When in auto mode this should be the midpoint between the cool/heat set point */
  public func getPrevIdealTemp() -> Double? {
    return self.attributes["prevIdealTemp"] as? Double
  }
  /** The maximum allowed Set Point temperature on the device for the current HVAC Mode. */
  public func getMaxSetPoint() -> Double? {
    return self.attributes["maxSetPoint"] as? Double
  }
  /** The minimum allowed Set Point temperature on the device for the current HVAC Mode. */
  public func getMinSetPoint() -> Double? {
    return self.attributes["minSetPoint"] as? Double
  }
}

