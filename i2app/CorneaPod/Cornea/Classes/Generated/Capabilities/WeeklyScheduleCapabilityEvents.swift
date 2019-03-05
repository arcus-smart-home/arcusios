
//
// WeeklyScheduleCapEvents.swift
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
  /**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event.      */
  static let weeklyScheduleScheduleWeeklyCommand: String = "schedweek:ScheduleWeeklyCommand"
  /** Updates schedule for an existing scheduled command. */
  static let weeklyScheduleUpdateWeeklyCommand: String = "schedweek:UpdateWeeklyCommand"
  
}

// MARK: Enumerations

// MARK: Requests

/**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event.      */
public class WeeklyScheduleScheduleWeeklyCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: WeeklyScheduleScheduleWeeklyCommandRequest Enumerations
  /** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
  public enum WeeklyScheduleMode: String {
   case absolute = "ABSOLUTE"
   case sunrise = "SUNRISE"
   case sunset = "SUNSET"
   
  }
  override init() {
    super.init()
    self.command = Commands.weeklyScheduleScheduleWeeklyCommand
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
    return WeeklyScheduleScheduleWeeklyCommandResponse(message)
  }

  // MARK: ScheduleWeeklyCommandRequest Attributes
  struct Attributes {
    /** The days of the week that this command should be run on.  There must be at least one day in this set. */
    static let days: String = "days"
/** The time of day formatted as HH:MM:SS using a 24-hour clock, in place-local time (see Place#TimeZone), that the command should be sent.  This may not be set if mode is SUNRISE or SUNSET, this must be set of mode is ABSOLUTE or unspecified. */
    static let time: String = "time"
/** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
    static let mode: String = "mode"
/** This will always be 0 if the mode is set to ABSOLUTE.  If mode is set to SUNRISE or SUNSET this will be the offset / delta from sunrise or sunset that the event should run at.  A negative number means the event should happen before sunrise/sunset, a postive means after. */
    static let offsetMinutes: String = "offsetMinutes"
/** Default: base:SetAttributes. Type of message to be sent. */
    static let messageType: String = "messageType"
/** The attributes to send with the request. */
    static let weeklyScheduleAttributes: String = "attributes"
 }
  
  /** The days of the week that this command should be run on.  There must be at least one day in this set. */
  public func setDays(_ days: [String]) {
    attributes[Attributes.days] = days as AnyObject
  }

  
  /** The time of day formatted as HH:MM:SS using a 24-hour clock, in place-local time (see Place#TimeZone), that the command should be sent.  This may not be set if mode is SUNRISE or SUNSET, this must be set of mode is ABSOLUTE or unspecified. */
  public func setTime(_ time: String) {
    attributes[Attributes.time] = time as AnyObject
  }

  
  /** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
  public func setMode(_ mode: String) {
    if let value: WeeklyScheduleMode = WeeklyScheduleMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** This will always be 0 if the mode is set to ABSOLUTE.  If mode is set to SUNRISE or SUNSET this will be the offset / delta from sunrise or sunset that the event should run at.  A negative number means the event should happen before sunrise/sunset, a postive means after. */
  public func setOffsetMinutes(_ offsetMinutes: Int) {
    attributes[Attributes.offsetMinutes] = offsetMinutes as AnyObject
  }

  
  /** Default: base:SetAttributes. Type of message to be sent. */
  public func setMessageType(_ messageType: String) {
    attributes[Attributes.messageType] = messageType as AnyObject
  }

  
  /** The attributes to send with the request. */
  public func setAttributes(_ weeklyScheduleAttributes: [String: Any]) {
    attributes[Attributes.weeklyScheduleAttributes] = weeklyScheduleAttributes as AnyObject
  }

  
}

public class WeeklyScheduleScheduleWeeklyCommandResponse: SessionEvent {
  
  
  /** The id of the command that was created or modified. */
  public func getCommandId() -> String? {
    return self.attributes["commandId"] as? String
  }
}

/** Updates schedule for an existing scheduled command. */
public class WeeklyScheduleUpdateWeeklyCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: WeeklyScheduleUpdateWeeklyCommandRequest Enumerations
  /** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
  public enum WeeklyScheduleMode: String {
   case absolute = "ABSOLUTE"
   case sunrise = "SUNRISE"
   case sunset = "SUNSET"
   
  }
  override init() {
    super.init()
    self.command = Commands.weeklyScheduleUpdateWeeklyCommand
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
    return WeeklyScheduleUpdateWeeklyCommandResponse(message)
  }

  // MARK: UpdateWeeklyCommandRequest Attributes
  struct Attributes {
    /** The id of the command to update. Only the specified fields will be changed. */
    static let commandId: String = "commandId"
/** If specified it will update the schedule to only run on the requested days. */
    static let days: String = "days"
/** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
    static let mode: String = "mode"
/** This will always be 0 if the mode is set to ABSOLUTE.  If mode is set to SUNRISE or SUNSET this will be the offset / delta from sunrise or sunset that the event should run at.  A negative number means the event should happen before sunrise/sunset, a postive means after. */
    static let offsetMinutes: String = "offsetMinutes"
/** If specified it will update the time of each instance of this event. */
    static let time: String = "time"
/** Default: base:SetAttributes. Type of message to be sent. */
    static let messageType: String = "messageType"
/** If specified it will update the attributes to be included in the message. */
    static let weeklyScheduleAttributes: String = "attributes"
 }
  
  /** The id of the command to update. Only the specified fields will be changed. */
  public func setCommandId(_ commandId: String) {
    attributes[Attributes.commandId] = commandId as AnyObject
  }

  
  /** If specified it will update the schedule to only run on the requested days. */
  public func setDays(_ days: [String]) {
    attributes[Attributes.days] = days as AnyObject
  }

  
  /** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
  public func setMode(_ mode: String) {
    if let value: WeeklyScheduleMode = WeeklyScheduleMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** This will always be 0 if the mode is set to ABSOLUTE.  If mode is set to SUNRISE or SUNSET this will be the offset / delta from sunrise or sunset that the event should run at.  A negative number means the event should happen before sunrise/sunset, a postive means after. */
  public func setOffsetMinutes(_ offsetMinutes: Int) {
    attributes[Attributes.offsetMinutes] = offsetMinutes as AnyObject
  }

  
  /** If specified it will update the time of each instance of this event. */
  public func setTime(_ time: String) {
    attributes[Attributes.time] = time as AnyObject
  }

  
  /** Default: base:SetAttributes. Type of message to be sent. */
  public func setMessageType(_ messageType: String) {
    attributes[Attributes.messageType] = messageType as AnyObject
  }

  
  /** If specified it will update the attributes to be included in the message. */
  public func setAttributes(_ weeklyScheduleAttributes: [String: Any]) {
    attributes[Attributes.weeklyScheduleAttributes] = weeklyScheduleAttributes as AnyObject
  }

  
}

public class WeeklyScheduleUpdateWeeklyCommandResponse: SessionEvent {
  
}

