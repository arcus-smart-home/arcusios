
//
// SecuritySubsystemCapEvents.swift
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
  static let securitySubsystemPanic: String = "subsecurity:Panic"
  /** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If any devices associated with the alarm mode are triggered, this will return an error with code &#x27;TriggeredDevices&#x27;. */
  static let securitySubsystemArm: String = "subsecurity:Arm"
  /** Attempts to arm the alarm into the request mode, bypassing any triggered devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If all devices in the requested mode are faulted, this will return an error. */
  static let securitySubsystemArmBypassed: String = "subsecurity:ArmBypassed"
  /** This call acknowledges the alarm and indicates the given user is taking responsibility for dealing with it.  This will stop call tree processing but not stop the alerts. */
  static let securitySubsystemAcknowledge: String = "subsecurity:Acknowledge"
  /** Requests that the alarm be returned to the disarmed state.  If the alarm is currently in Alert then this will acknowledge the alarm (if it was not previously acknowledged) and transition to CLEARING. */
  static let securitySubsystemDisarm: String = "subsecurity:Disarm"
  
}
// MARK: Events
public struct SecuritySubsystemEvents {
  /** Fired when the alarmState from ARMING to ARMED.  This event is not re-sent when the system goes from SOAKING to ARMED. */
  public static let securitySubsystemArmed: String = "subsecurity:Armed"
  /** Fired when alarmState switches from ARMED to ALERTING. */
  public static let securitySubsystemAlert: String = "subsecurity:Alert"
  /** Fired when alarmState switches to DISARMED. */
  public static let securitySubsystemDisarmed: String = "subsecurity:Disarmed"
  }

// MARK: Enumerations

/** Indicates the current state of the alarm:     DISARMED - The alarm is currently DISARMED.  Note that any devices in the triggered or warning state may prevent the alarm from going to fully armed.     ARMING - The alarm is in the process of arming, delaying giving users a chance to leave the house.     ARMED - Indicate the alarm is armed and any security device may trigger an alarm.  See armedDevices to determine which devices might trigger the alarm.     ALERT - The alarm is &#x27;going off&#x27;.  Any sirens are triggered, the call tree is activated, etc.     CLEARING - The alarm has been acknowledged and the system is waiting for all devices to no longer be triggered at which point it will return to DISARMED     SOAKING - An armed secuirty device has triggered the alarm and the system is waiting for the alarm to be disarmed. */
public enum SecuritySubsystemAlarmState: String {
  case disarmed = "DISARMED"
  case arming = "ARMING"
  case armed = "ARMED"
  case alert = "ALERT"
  case clearing = "CLEARING"
  case soaking = "SOAKING"
}

/** If the alarmState is &#x27;DISARMED&#x27; this will be OFF.  Otherwise it will be id of the alarmMode which is currently active. */
public enum SecuritySubsystemAlarmMode: String {
  case off = "OFF"
  case on = "ON"
  case partial = "PARTIAL"
}

/** The reason the current alert was raised */
public enum SecuritySubsystemCurrentAlertCause: String {
  case alarm = "ALARM"
  case panic = "PANIC"
  case none = "NONE"
}

/** The current state of acknowledgement:     PENDING - Arcus is attempting to notify the user that an alarm has been triggered     ACKNOWLEDGED - One of the persons from the call tree has acknowledged the alarm     FAILED - No one acknowledged the alarm but no one was available to acknowledged it. */
public enum SecuritySubsystemLastAcknowledgement: String {
  case never = "NEVER"
  case pending = "PENDING"
  case acknowledged = "ACKNOWLEDGED"
  case failed = "FAILED"
}

// MARK: Requests

/** Immediately puts the alarm into ALERT mode and record the lastAlertCause as PANIC.  If it is in ALERT this will have no affect.  If it is in any other state this will return an error.The cause will be recorded as the lastAlertCause. */
public class SecuritySubsystemPanicRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SecuritySubsystemPanicRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.securitySubsystemPanic
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
    return SecuritySubsystemPanicResponse(message)
  }

  // MARK: PanicRequest Attributes
  struct Attributes {
    /**  */
    static let silent: String = "silent"
 }
  
  /**  */
  public func setSilent(_ silent: Bool) {
    attributes[Attributes.silent] = silent as AnyObject
  }

  
}

public class SecuritySubsystemPanicResponse: SessionEvent {
  
}

/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If any devices associated with the alarm mode are triggered, this will return an error with code &#x27;TriggeredDevices&#x27;. */
public class SecuritySubsystemArmRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SecuritySubsystemArmRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.securitySubsystemArm
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
    return SecuritySubsystemArmResponse(message)
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

public class SecuritySubsystemArmResponse: SessionEvent {
  
  
  /**  */
  public func getDelaySec() -> Int? {
    return self.attributes["delaySec"] as? Int
  }
}

/** Attempts to arm the alarm into the request mode, bypassing any triggered devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If all devices in the requested mode are faulted, this will return an error. */
public class SecuritySubsystemArmBypassedRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SecuritySubsystemArmBypassedRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.securitySubsystemArmBypassed
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
    return SecuritySubsystemArmBypassedResponse(message)
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

public class SecuritySubsystemArmBypassedResponse: SessionEvent {
  
  
  /**  */
  public func getDelaySec() -> Int? {
    return self.attributes["delaySec"] as? Int
  }
}

/** This call acknowledges the alarm and indicates the given user is taking responsibility for dealing with it.  This will stop call tree processing but not stop the alerts. */
public class SecuritySubsystemAcknowledgeRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.securitySubsystemAcknowledge
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
    return SecuritySubsystemAcknowledgeResponse(message)
  }

  
}

public class SecuritySubsystemAcknowledgeResponse: SessionEvent {
  
}

/** Requests that the alarm be returned to the disarmed state.  If the alarm is currently in Alert then this will acknowledge the alarm (if it was not previously acknowledged) and transition to CLEARING. */
public class SecuritySubsystemDisarmRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.securitySubsystemDisarm
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
    return SecuritySubsystemDisarmResponse(message)
  }

  
}

public class SecuritySubsystemDisarmResponse: SessionEvent {
  
}

