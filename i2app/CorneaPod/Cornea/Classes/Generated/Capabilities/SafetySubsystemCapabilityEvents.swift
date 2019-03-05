
//
// SafetySubsystemCapEvents.swift
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
  /** Immediately puts the alarm into ALERT mode IF it is in READY.  The cause will be recorded as the lastAlertCause. */
  static let safetySubsystemTrigger: String = "subsafety:Trigger"
  /** Immediately clear and cancel the active alarm. */
  static let safetySubsystemClear: String = "subsafety:Clear"
  
}

// MARK: Enumerations

/** Indicates the current state of the alarm:         - READY - The alarm is active and watching for safety alerts         - WARN - The alarm is active, but one or more of the safety sensors has low battery or connectivity issues that could potentially cause an alarm to be missed         - SOAKING - One or more safety devices have triggered, but not a sufficient amount of time or devices to set off the whole system.         - ALERT - A safety device has triggered an alarm         - CLEARING - A request has been made to CLEAR the alarm, but there are still devices triggering an alarm. */
public enum SafetySubsystemAlarm: String {
  case ready = "READY"
  case warn = "WARN"
  case soaking = "SOAKING"
  case alert = "ALERT"
  case clearing = "CLEARING"
}

/** Indicates the whether any devices that can provide a smoke pre-alert are alerting         - READY - The alarm is active and watching for safety alerts         - ALERT - A safety device has triggered a prealarm */
public enum SafetySubsystemSmokePreAlert: String {
  case ready = "READY"
  case alert = "ALERT"
}

// MARK: Requests

/** Immediately puts the alarm into ALERT mode IF it is in READY.  The cause will be recorded as the lastAlertCause. */
public class SafetySubsystemTriggerRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SafetySubsystemTriggerRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.safetySubsystemTrigger
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
    return SafetySubsystemTriggerResponse(message)
  }

  // MARK: TriggerRequest Attributes
  struct Attributes {
    /**  */
    static let cause: String = "cause"
 }
  
  /**  */
  public func setCause(_ cause: String) {
    attributes[Attributes.cause] = cause as AnyObject
  }

  
}

public class SafetySubsystemTriggerResponse: SessionEvent {
  
}

/** Immediately clear and cancel the active alarm. */
public class SafetySubsystemClearRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.safetySubsystemClear
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
    return SafetySubsystemClearResponse(message)
  }

  
}

public class SafetySubsystemClearResponse: SessionEvent {
  
}

