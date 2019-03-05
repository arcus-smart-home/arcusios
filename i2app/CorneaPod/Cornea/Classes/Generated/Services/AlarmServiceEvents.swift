
//
// AlarmServiceEvents.swift
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
  /** Issued by the alarm subsystem when a new alert is added to an incident. */
  public static let alarmServiceAddAlarm: String = "alarmservice:AddAlarm"
  /** Issued by the alarm subsystem when the alarm has been cleared */
  public static let alarmServiceCancelAlert: String = "alarmservice:CancelAlert"
  
}

// MARK: Requests

/** Issued by the alarm subsystem when a new alert is added to an incident. */
public class AlarmServiceAddAlarmRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AlarmServiceAddAlarmRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.alarmServiceAddAlarm
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
    return AlarmServiceAddAlarmResponse(message)
  }
  // MARK: AddAlarmRequest Attributes
  struct Attributes {
    /** The newly added alarm */
    static let alarm: String = "alarm"
/** The list of alarms in the current state */
    static let alarms: String = "alarms"
/** The triggers associated with the newly added alarm. */
    static let triggers: String = "triggers"
 }
  
  /** The newly added alarm */
  public func setAlarm(_ alarm: String) {
    attributes[Attributes.alarm] = alarm as AnyObject
  }

  
  /** The list of alarms in the current state */
  public func setAlarms(_ alarms: [String]) {
    attributes[Attributes.alarms] = alarms as AnyObject
  }

  
  /** The triggers associated with the newly added alarm. */
  public func setTriggers(_ triggers: [Any]) {
    attributes[Attributes.triggers] = triggers as AnyObject
  }

  
}

public class AlarmServiceAddAlarmResponse: SessionEvent {
  
}

/** Issued by the alarm subsystem when the alarm has been cleared */
public class AlarmServiceCancelAlertRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AlarmServiceCancelAlertRequest Enumerations
  /** How the user (actor header) cancelled the alarm(s) */
  public enum AlarmServiceMethod: String {
   case keypad = "KEYPAD"
   case app = "APP"
   
  }
  override init() {
    super.init()
    self.command = Commands.alarmServiceCancelAlert
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
    return AlarmServiceCancelAlertResponse(message)
  }
  // MARK: CancelAlertRequest Attributes
  struct Attributes {
    /** How the user (actor header) cancelled the alarm(s) */
    static let method: String = "method"
/** The list of alarms that have been cancelled */
    static let alarms: String = "alarms"
 }
  
  /** How the user (actor header) cancelled the alarm(s) */
  public func setMethod(_ method: String) {
    if let value = AlarmServiceMethod(rawValue: method) {
      attributes[Attributes.method] = value.rawValue as AnyObject
    }
  }
  
  /** The list of alarms that have been cancelled */
  public func setAlarms(_ alarms: [String]) {
    attributes[Attributes.alarms] = alarms as AnyObject
  }

  
}

public class AlarmServiceCancelAlertResponse: SessionEvent {
  
}

