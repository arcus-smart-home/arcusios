
//
// AlarmSubsystemCapEvents.swift
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
  /** Immediately puts the alarm into ALERT mode and record the lastAlertCause as PANIC.  If it is in ALERT this will have no affect.  If it is in any other state this will return an error.The cause will be recorded as the lastAlertCause. */
  static let alarmSubsystemListIncidents: String = "subalarm:ListIncidents"
  /** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
  static let alarmSubsystemArm: String = "subalarm:Arm"
  /** Attempts to arm the alarm into the requested mode, excluding any offline or currently tripped devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
  static let alarmSubsystemArmBypassed: String = "subalarm:ArmBypassed"
  /** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
  static let alarmSubsystemDisarm: String = "subalarm:Disarm"
  /** Triggers the PANIC alarm. */
  static let alarmSubsystemPanic: String = "subalarm:Panic"
  /** . */
  static let alarmSubsystemSetProvider: String = "subalarm:SetProvider"
  
}

// MARK: Errors
public struct AlarmSubsystemArmError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If there are not enough devices for the given mode. */
    case securityInsufficientDevices = "security.insufficientDevices"
    /**  If there are devices currently tripped or offline that would otherwise participate.  In this case the error description will be a comma separated list of devices that need to be bypassed in order to arm. */
    case securityTriggeredDevices = "security.triggeredDevices"
    /** If the alarm is armed into a different mode or is currently in INACTIVE, PREALERT or CLEARING state.  This means this call may be repeated while in ARMING or READY states. */
    case securityInvalidState = "security.invalidState"
    /** If the alarm provider has been set to hub but no hub is associated with the place. */
    case securityNoHub = "security.noHub"
    /** If hub local alarms are enabled and the hub is still in the process of being disarmed, preventing it from re-arming. */
    case securityHubDisarming = "security.hubDisarming"
    
  }
}
// MARK: Errors
public struct AlarmSubsystemArmBypassedError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If there are not enough devices for the given mode. */
    case securityInsufficientDevices = "security.insufficientDevices"
    /** If the alarm is armed into a different mode or is currently in INACTIVE, PREALERT or CLEARING state.  This means this call may be repeated while in ARMING or READY states. */
    case securityInvalidState = "security.invalidState"
    /** If the alarm provider has been set to hub but no hub is associated with the place. */
    case securityNoHub = "security.noHub"
    /** If hub local alarms are enabled and the hub is still in the process of being disarmed, preventing it from re-arming. */
    case securityHubDisarming = "security.hubDisarming"
    
  }
}
// MARK: Errors
public struct AlarmSubsystemSetProviderError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If the given alarm subsystem implementation is the current alarm subsystem implementation. */
    case alarmProviderAlreadySet = "alarm.providerAlreadySet"
    /** If the alarm subsystem provider cannot be changed because of the current alarm subsystem&#x27;s state (for instance, current subsystem is alarming). */
    case alarmCannotChangeInCurrentState = "alarm.cannotChangeInCurrentState"
    /** Can not change to HUB provider because the hub OS version does not meet the minimum. */
    case hubBelowMinFw = "hub.belowMinFw"
    
  }
}
// MARK: Enumerations

/** The combined state of the alarm across all alerts. */
public enum AlarmSubsystemAlarmState: String {
  case inactive = "INACTIVE"
  case ready = "READY"
  case prealert = "PREALERT"
  case alerting = "ALERTING"
  case clearing = "CLEARING"
}

/** The state of the security alarm. */
public enum AlarmSubsystemSecurityMode: String {
  case inactive = "INACTIVE"
  case disarmed = "DISARMED"
  case on = "ON"
  case partial = "PARTIAL"
}

/** The provider of the alarming implementation. Defaults to PLATFORM. */
public enum AlarmSubsystemAlarmProvider: String {
  case platform = "PLATFORM"
  case hub = "HUB"
}

/** The provider of the alarming implementation that was requested. Defaults to HUB */
public enum AlarmSubsystemRequestedAlarmProvider: String {
  case platform = "PLATFORM"
  case hub = "HUB"
}

// MARK: Requests

/** Immediately puts the alarm into ALERT mode and record the lastAlertCause as PANIC.  If it is in ALERT this will have no affect.  If it is in any other state this will return an error.The cause will be recorded as the lastAlertCause. */
public class AlarmSubsystemListIncidentsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.alarmSubsystemListIncidents
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
    return AlarmSubsystemListIncidentsResponse(message)
  }

  
}

public class AlarmSubsystemListIncidentsResponse: SessionEvent {
  
  
  /**  */
  public func getIncidents() -> [Any]? {
    return self.attributes["incidents"] as? [Any]
  }
}

/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
public class AlarmSubsystemArmRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AlarmSubsystemArmRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.alarmSubsystemArm
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

      let error = AlarmSubsystemArmError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return AlarmSubsystemArmResponse(message)
  }

  // MARK: ArmRequest Attributes
  struct Attributes {
    /**  */
    static let mode: String = "mode"
 }
  
  /**  */
  public func setMode(_ mode: String) {
    attributes[Attributes.mode] = mode as AnyObject
  }

  
}

public class AlarmSubsystemArmResponse: SessionEvent {
  
  
  /**  */
  public func getDelaySec() -> Int? {
    return self.attributes["delaySec"] as? Int
  }
}

/** Attempts to arm the alarm into the requested mode, excluding any offline or currently tripped devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
public class AlarmSubsystemArmBypassedRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AlarmSubsystemArmBypassedRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.alarmSubsystemArmBypassed
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

      let error = AlarmSubsystemArmBypassedError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return AlarmSubsystemArmBypassedResponse(message)
  }

  // MARK: ArmBypassedRequest Attributes
  struct Attributes {
    /**  */
    static let mode: String = "mode"
 }
  
  /**  */
  public func setMode(_ mode: String) {
    attributes[Attributes.mode] = mode as AnyObject
  }

  
}

public class AlarmSubsystemArmBypassedResponse: SessionEvent {
  
  
  /**  */
  public func getDelaySec() -> Int? {
    return self.attributes["delaySec"] as? Int
  }
}

/** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
public class AlarmSubsystemDisarmRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.alarmSubsystemDisarm
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
    return AlarmSubsystemDisarmResponse(message)
  }

  
}

public class AlarmSubsystemDisarmResponse: SessionEvent {
  
}

/** Triggers the PANIC alarm. */
public class AlarmSubsystemPanicRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.alarmSubsystemPanic
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
    return AlarmSubsystemPanicResponse(message)
  }

  
}

public class AlarmSubsystemPanicResponse: SessionEvent {
  
}

/** . */
public class AlarmSubsystemSetProviderRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AlarmSubsystemSetProviderRequest Enumerations
  /**  */
  public enum AlarmSubsystemProvider: String {
   case platform = "PLATFORM"
   case hub = "HUB"
   
  }
  override init() {
    super.init()
    self.command = Commands.alarmSubsystemSetProvider
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

      let error = AlarmSubsystemSetProviderError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return AlarmSubsystemSetProviderResponse(message)
  }

  // MARK: SetProviderRequest Attributes
  struct Attributes {
    /**  */
    static let provider: String = "provider"
 }
  
  /**  */
  public func setProvider(_ provider: String) {
    if let value: AlarmSubsystemProvider = AlarmSubsystemProvider(rawValue: provider) {
      attributes[Attributes.provider] = value.rawValue as AnyObject
    }
  }
  
}

public class AlarmSubsystemSetProviderResponse: SessionEvent {
  
}

