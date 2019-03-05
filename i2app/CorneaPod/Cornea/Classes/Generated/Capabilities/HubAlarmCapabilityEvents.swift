
//
// HubAlarmCapEvents.swift
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
  /** Puts the hub local alarm into an &#x27;active&#x27; state. */
  static let hubAlarmActivate: String = "hubalarm:Activate"
  /** Puts the subsystem into a &#x27;suspended&#x27; state. */
  static let hubAlarmSuspend: String = "hubalarm:Suspend"
  /** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
  static let hubAlarmArm: String = "hubalarm:Arm"
  /** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
  static let hubAlarmDisarm: String = "hubalarm:Disarm"
  /** Triggers the PANIC alarm. */
  static let hubAlarmPanic: String = "hubalarm:Panic"
  /** Issued by the platform when an incident has been fully canceled so the hub will clear out the current incident and related triggers. */
  static let hubAlarmClearIncident: String = "hubalarm:ClearIncident"
  
}
// MARK: Events
public struct HubAlarmEvents {
  /** Issued by alarm subsystem to the hub if a user verifies an alarm. */
  public static let hubAlarmVerified: String = "hubalarm:Verified"
  }

// MARK: Errors
public struct HubAlarmArmError: ArcusError {
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
    
  }
}
// MARK: Enumerations

/** The current state of the hub local alarm subsystem. */
public enum HubAlarmState: String {
  case suspended = "SUSPENDED"
  case active = "ACTIVE"
}

/** The combined state of the alarm across all alerts. */
public enum HubAlarmAlarmState: String {
  case inactive = "INACTIVE"
  case ready = "READY"
  case prealert = "PREALERT"
  case alerting = "ALERTING"
  case clearing = "CLEARING"
}

/** The state of the security alarm. */
public enum HubAlarmSecurityMode: String {
  case inactive = "INACTIVE"
  case disarmed = "DISARMED"
  case on = "ON"
  case partial = "PARTIAL"
}

/** The current state of this alert. */
public enum HubAlarmSecurityAlertState: String {
  case inactive = "INACTIVE"
  case pending_clear = "PENDING_CLEAR"
  case disarmed = "DISARMED"
  case arming = "ARMING"
  case ready = "READY"
  case prealert = "PREALERT"
  case alert = "ALERT"
  case clearing = "CLEARING"
}

/** The current state of this alert. */
public enum HubAlarmPanicAlertState: String {
  case inactive = "INACTIVE"
  case pending_clear = "PENDING_CLEAR"
  case disarmed = "DISARMED"
  case arming = "ARMING"
  case ready = "READY"
  case prealert = "PREALERT"
  case alert = "ALERT"
  case clearing = "CLEARING"
}

/** The current state of this alert. */
public enum HubAlarmSmokeAlertState: String {
  case inactive = "INACTIVE"
  case pending_clear = "PENDING_CLEAR"
  case disarmed = "DISARMED"
  case arming = "ARMING"
  case ready = "READY"
  case prealert = "PREALERT"
  case alert = "ALERT"
  case clearing = "CLEARING"
}

/** The current state of this alert. */
public enum HubAlarmCoAlertState: String {
  case inactive = "INACTIVE"
  case pending_clear = "PENDING_CLEAR"
  case disarmed = "DISARMED"
  case arming = "ARMING"
  case ready = "READY"
  case prealert = "PREALERT"
  case alert = "ALERT"
  case clearing = "CLEARING"
}

/** The current state of this alert. */
public enum HubAlarmWaterAlertState: String {
  case inactive = "INACTIVE"
  case pending_clear = "PENDING_CLEAR"
  case disarmed = "DISARMED"
  case arming = "ARMING"
  case ready = "READY"
  case prealert = "PREALERT"
  case alert = "ALERT"
  case clearing = "CLEARING"
}

// MARK: Requests

/** Puts the hub local alarm into an &#x27;active&#x27; state. */
public class HubAlarmActivateRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubAlarmActivate
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
    return HubAlarmActivateResponse(message)
  }

  
}

public class HubAlarmActivateResponse: SessionEvent {
  
}

/** Puts the subsystem into a &#x27;suspended&#x27; state. */
public class HubAlarmSuspendRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubAlarmSuspend
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
    return HubAlarmSuspendResponse(message)
  }

  
}

public class HubAlarmSuspendResponse: SessionEvent {
  
}

/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
public class HubAlarmArmRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAlarmArmRequest Enumerations
  /** The mode the alarm is being armed in */
  public enum HubAlarmMode: String {
   case on = "ON"
   case partial = "PARTIAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubAlarmArm
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

      let error = HubAlarmArmError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return HubAlarmArmResponse(message)
  }

  // MARK: ArmRequest Attributes
  struct Attributes {
    /** The mode the alarm is being armed in */
    static let mode: String = "mode"
/** True if arming in bypass mode */
    static let bypassed: String = "bypassed"
/** The amount of time an alarm device must be triggering for before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
    static let entranceDelaySecs: String = "entranceDelaySecs"
/** The amount of time before the alarm is fully armed.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
    static let exitDelaySecs: String = "exitDelaySecs"
/** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
    static let alarmSensitivityDeviceCount: String = "alarmSensitivityDeviceCount"
/** Hub and keypad make sounds when arming.&lt;br/&gt;&lt;b&gt;Default: true&lt;/b&gt; */
    static let silent: String = "silent"
/** When true only notifications will be sent, alert devices will not be triggered. */
    static let soundsEnabled: String = "soundsEnabled"
/** The addresses of the devices that are participating in this alarm. */
    static let activeDevices: String = "activeDevices"
/** The person arming the security alarm or empty if being armed via keypad or a rule */
    static let armedBy: String = "armedBy"
/** The address of the keypad, rule, scene, or app the security alarm was armed from. */
    static let armedFrom: String = "armedFrom"
 }
  
  /** The mode the alarm is being armed in */
  public func setMode(_ mode: String) {
    if let value: HubAlarmMode = HubAlarmMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** True if arming in bypass mode */
  public func setBypassed(_ bypassed: Bool) {
    attributes[Attributes.bypassed] = bypassed as AnyObject
  }

  
  /** The amount of time an alarm device must be triggering for before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
  public func setEntranceDelaySecs(_ entranceDelaySecs: Int) {
    attributes[Attributes.entranceDelaySecs] = entranceDelaySecs as AnyObject
  }

  
  /** The amount of time before the alarm is fully armed.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
  public func setExitDelaySecs(_ exitDelaySecs: Int) {
    attributes[Attributes.exitDelaySecs] = exitDelaySecs as AnyObject
  }

  
  /** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
  public func setAlarmSensitivityDeviceCount(_ alarmSensitivityDeviceCount: Int) {
    attributes[Attributes.alarmSensitivityDeviceCount] = alarmSensitivityDeviceCount as AnyObject
  }

  
  /** Hub and keypad make sounds when arming.&lt;br/&gt;&lt;b&gt;Default: true&lt;/b&gt; */
  public func setSilent(_ silent: Bool) {
    attributes[Attributes.silent] = silent as AnyObject
  }

  
  /** When true only notifications will be sent, alert devices will not be triggered. */
  public func setSoundsEnabled(_ soundsEnabled: Bool) {
    attributes[Attributes.soundsEnabled] = soundsEnabled as AnyObject
  }

  
  /** The addresses of the devices that are participating in this alarm. */
  public func setActiveDevices(_ activeDevices: [String]) {
    attributes[Attributes.activeDevices] = activeDevices as AnyObject
  }

  
  /** The person arming the security alarm or empty if being armed via keypad or a rule */
  public func setArmedBy(_ armedBy: String) {
    attributes[Attributes.armedBy] = armedBy as AnyObject
  }

  
  /** The address of the keypad, rule, scene, or app the security alarm was armed from. */
  public func setArmedFrom(_ armedFrom: String) {
    attributes[Attributes.armedFrom] = armedFrom as AnyObject
  }

  
}

public class HubAlarmArmResponse: SessionEvent {
  
  
  /** The time at which the security system will be armed. */
  public func getSecurityArmTime() -> Date? {
    return self.attributes["securityArmTime"] as? Date
  }
}

/** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
public class HubAlarmDisarmRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAlarmDisarmRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAlarmDisarm
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
    return HubAlarmDisarmResponse(message)
  }

  // MARK: DisarmRequest Attributes
  struct Attributes {
    /** Address of the person that disarmed or cancelled the incident. */
    static let disarmedBy: String = "disarmedBy"
/** The address of the keypad, rule, scene, or app the security alarm was disarmed from. */
    static let disarmedFrom: String = "disarmedFrom"
 }
  
  /** Address of the person that disarmed or cancelled the incident. */
  public func setDisarmedBy(_ disarmedBy: String) {
    attributes[Attributes.disarmedBy] = disarmedBy as AnyObject
  }

  
  /** The address of the keypad, rule, scene, or app the security alarm was disarmed from. */
  public func setDisarmedFrom(_ disarmedFrom: String) {
    attributes[Attributes.disarmedFrom] = disarmedFrom as AnyObject
  }

  
}

public class HubAlarmDisarmResponse: SessionEvent {
  
}

/** Triggers the PANIC alarm. */
public class HubAlarmPanicRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAlarmPanicRequest Enumerations
  /** Triggering Event */
  public enum HubAlarmEvent: String {
   case rule = "RULE"
   case verified_alarm = "VERIFIED_ALARM"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubAlarmPanic
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
    return HubAlarmPanicResponse(message)
  }

  // MARK: PanicRequest Attributes
  struct Attributes {
    /** Address of the trigger source */
    static let source: String = "source"
/** Triggering Event */
    static let event: String = "event"
 }
  
  /** Address of the trigger source */
  public func setSource(_ source: String) {
    attributes[Attributes.source] = source as AnyObject
  }

  
  /** Triggering Event */
  public func setEvent(_ event: String) {
    if let value: HubAlarmEvent = HubAlarmEvent(rawValue: event) {
      attributes[Attributes.event] = value.rawValue as AnyObject
    }
  }
  
}

public class HubAlarmPanicResponse: SessionEvent {
  
}

/** Issued by the platform when an incident has been fully canceled so the hub will clear out the current incident and related triggers. */
public class HubAlarmClearIncidentRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubAlarmClearIncident
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
    return HubAlarmClearIncidentResponse(message)
  }

  
}

public class HubAlarmClearIncidentResponse: SessionEvent {
  
}

