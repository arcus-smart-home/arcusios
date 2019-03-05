
//
// SchedulerServiceEvents.swift
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
  /** Lists all the schedulers for a given place. */
  public static let schedulerServiceListSchedulers: String = "scheduler:ListSchedulers"
  /** Creates a new Scheduler or returns the existing scheduler for target.  Generally this is used when there is no Scheduler in ListSchedulers for the given object. */
  public static let schedulerServiceGetScheduler: String = "scheduler:GetScheduler"
  /** Fires the requested command right now, generally used for testing. */
  public static let schedulerServiceFireCommand: String = "scheduler:FireCommand"
  /**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
  public static let schedulerServiceScheduleCommands: String = "scheduler:ScheduleCommands"
  /**  This is a convenience for Scheduler#GetScheduler(target)#AddSchedule(schedule, &#x27;WEEKLY&#x27;)#ScheduleWeeklyEvent(time, messageType, attributeMap). Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
  public static let schedulerServiceScheduleWeeklyCommand: String = "scheduler:ScheduleWeeklyCommand"
  /**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#UpdateWeeklyEvent(commandId, time, attributes). Updates schedule for an existing scheduled event.   */
  public static let schedulerServiceUpdateWeeklyCommand: String = "scheduler:UpdateWeeklyCommand"
  /**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#DeleteCommand(comandId). Deletes any occurrence of the specified command from the week.   */
  public static let schedulerServiceDeleteCommand: String = "scheduler:DeleteCommand"
  
}

// MARK: Requests

/** Lists all the schedulers for a given place. */
public class SchedulerServiceListSchedulersRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerServiceListSchedulersRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.schedulerServiceListSchedulers
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
    return SchedulerServiceListSchedulersResponse(message)
  }
  // MARK: ListSchedulersRequest Attributes
  struct Attributes {
    /** The id of the place to list the schedulers for. */
    static let placeId: String = "placeId"
/** if the results should include schedule for each day of the week.  Default value is true. */
    static let includeWeekdays: String = "includeWeekdays"
 }
  
  /** The id of the place to list the schedulers for. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** if the results should include schedule for each day of the week.  Default value is true. */
  public func setIncludeWeekdays(_ includeWeekdays: Bool) {
    attributes[Attributes.includeWeekdays] = includeWeekdays as AnyObject
  }

  
}

public class SchedulerServiceListSchedulersResponse: SessionEvent {
  
  
  /** The subsystems */
  public func getSchedulers() -> [Any]? {
    return self.attributes["schedulers"] as? [Any]
  }
}

/** Creates a new Scheduler or returns the existing scheduler for target.  Generally this is used when there is no Scheduler in ListSchedulers for the given object. */
public class SchedulerServiceGetSchedulerRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerServiceGetSchedulerRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.schedulerServiceGetScheduler
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
    return SchedulerServiceGetSchedulerResponse(message)
  }
  // MARK: GetSchedulerRequest Attributes
  struct Attributes {
    /** The address of the thing to schedule. */
    static let target: String = "target"
 }
  
  /** The address of the thing to schedule. */
  public func setTarget(_ target: String) {
    attributes[Attributes.target] = target as AnyObject
  }

  
}

public class SchedulerServiceGetSchedulerResponse: SessionEvent {
  
  
  /** A scheduler object that may be used to create schedules for the given target. */
  public func getScheduler() -> Any? {
    return self.attributes["scheduler"]
  }
}

/** Fires the requested command right now, generally used for testing. */
public class SchedulerServiceFireCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerServiceFireCommandRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.schedulerServiceFireCommand
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
    return SchedulerServiceFireCommandResponse(message)
  }
  // MARK: FireCommandRequest Attributes
  struct Attributes {
    /** The address of the thing to schedule. */
    static let target: String = "target"
/** The id of the command to fire */
    static let commandId: String = "commandId"
 }
  
  /** The address of the thing to schedule. */
  public func setTarget(_ target: String) {
    attributes[Attributes.target] = target as AnyObject
  }

  
  /** The id of the command to fire */
  public func setCommandId(_ commandId: String) {
    attributes[Attributes.commandId] = commandId as AnyObject
  }

  
}

public class SchedulerServiceFireCommandResponse: SessionEvent {
  
}

/**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
public class SchedulerServiceScheduleCommandsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerServiceScheduleCommandsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.schedulerServiceScheduleCommands
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
    return SchedulerServiceScheduleCommandsResponse(message)
  }
  // MARK: ScheduleCommandsRequest Attributes
  struct Attributes {
    /** The address of the thing to schedule. */
    static let target: String = "target"
/** The group for the schedules if they are being created.  If they already exist and are part of a different group, this will return an error */
    static let group: String = "group"
/** A list of commands to insert/update/delete.  The referenced schedule ids will be created if needed.  If the id is null this will be considered an insert, if the id is populated and there are days this will be an update, if there is an id and no days it will be a delete. */
    static let commands: String = "commands"
 }
  
  /** The address of the thing to schedule. */
  public func setTarget(_ target: String) {
    attributes[Attributes.target] = target as AnyObject
  }

  
  /** The group for the schedules if they are being created.  If they already exist and are part of a different group, this will return an error */
  public func setGroup(_ group: String) {
    attributes[Attributes.group] = group as AnyObject
  }

  
  /** A list of commands to insert/update/delete.  The referenced schedule ids will be created if needed.  If the id is null this will be considered an insert, if the id is populated and there are days this will be an update, if there is an id and no days it will be a delete. */
  public func setCommands(_ commands: [Any]) {
    attributes[Attributes.commands] = commands as AnyObject
  }

  
}

public class SchedulerServiceScheduleCommandsResponse: SessionEvent {
  
  
  /** The address of the scheduler that was created / modified. */
  public func getSchedulerAddress() -> String? {
    return self.attributes["schedulerAddress"] as? String
  }
  /** The ids of the commands that were created / modified / deleted. */
  public func getCommandIds() -> [String]? {
    return self.attributes["commandIds"] as? [String]
  }
}

/**  This is a convenience for Scheduler#GetScheduler(target)#AddSchedule(schedule, &#x27;WEEKLY&#x27;)#ScheduleWeeklyEvent(time, messageType, attributeMap). Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
public class SchedulerServiceScheduleWeeklyCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerServiceScheduleWeeklyCommandRequest Enumerations
  /** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
  public enum SchedulerServiceMode: String {
   case absolute = "ABSOLUTE"
   case sunrise = "SUNRISE"
   case sunset = "SUNSET"
   
  }
  override init() {
    super.init()
    self.command = Commands.schedulerServiceScheduleWeeklyCommand
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
    return SchedulerServiceScheduleWeeklyCommandResponse(message)
  }
  // MARK: ScheduleWeeklyCommandRequest Attributes
  struct Attributes {
    /** The address of the thing to schedule. */
    static let target: String = "target"
/** The name of the schedule to update or create. */
    static let schedule: String = "schedule"
/** The days of the week that this command should be run on.  There must be at least one day in this set. */
    static let days: String = "days"
/** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
    static let mode: String = "mode"
/** The time of day formatted as HH:MM using a 24-hour clock, in place-local time (see Place#TimeZone), that the command should be sent. */
    static let time: String = "time"
/** This will always be 0 if the mode is set to ABSOLUTE.  If mode is set to SUNRISE or SUNSET this will be the offset / delta from sunrise or sunset that the event should run at.  A negative number means the event should happen before sunrise/sunset, a postive means after. */
    static let offsetMinutes: String = "offsetMinutes"
/** Default: base:SetAttributes. Type of message to be sent. */
    static let messageType: String = "messageType"
/** The attributes to send with the request. */
    static let schedulerServiceAttributes: String = "attributes"
 }
  
  /** The address of the thing to schedule. */
  public func setTarget(_ target: String) {
    attributes[Attributes.target] = target as AnyObject
  }

  
  /** The name of the schedule to update or create. */
  public func setSchedule(_ schedule: String) {
    attributes[Attributes.schedule] = schedule as AnyObject
  }

  
  /** The days of the week that this command should be run on.  There must be at least one day in this set. */
  public func setDays(_ days: [String]) {
    attributes[Attributes.days] = days as AnyObject
  }

  
  /** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
  public func setMode(_ mode: String) {
    if let value = SchedulerServiceMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** The time of day formatted as HH:MM using a 24-hour clock, in place-local time (see Place#TimeZone), that the command should be sent. */
  public func setTime(_ time: String) {
    attributes[Attributes.time] = time as AnyObject
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
  public func setAttributes(_ schedulerServiceAttributes: [String: Any]) {
    attributes[Attributes.schedulerServiceAttributes] = schedulerServiceAttributes as AnyObject
  }

  
}

public class SchedulerServiceScheduleWeeklyCommandResponse: SessionEvent {
  
  
  /** The address of the scheduler that was created / modified. */
  public func getSchedulerAddress() -> String? {
    return self.attributes["schedulerAddress"] as? String
  }
  /** The id of the command that was created or modified. */
  public func getCommandId() -> String? {
    return self.attributes["commandId"] as? String
  }
}

/**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#UpdateWeeklyEvent(commandId, time, attributes). Updates schedule for an existing scheduled event.   */
public class SchedulerServiceUpdateWeeklyCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerServiceUpdateWeeklyCommandRequest Enumerations
  /** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
  public enum SchedulerServiceMode: String {
   case absolute = "ABSOLUTE"
   case sunrise = "SUNRISE"
   case sunset = "SUNSET"
   
  }
  override init() {
    super.init()
    self.command = Commands.schedulerServiceUpdateWeeklyCommand
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
    return SchedulerServiceUpdateWeeklyCommandResponse(message)
  }
  // MARK: UpdateWeeklyCommandRequest Attributes
  struct Attributes {
    /** The address of the thing being scheduled. */
    static let target: String = "target"
/** The name of the schedule being modified. */
    static let schedule: String = "schedule"
/** The id of the command to update. Only the specified fields will be changed. */
    static let commandId: String = "commandId"
/** If specified it will update the schedule to only run on the requested days. */
    static let days: String = "days"
/** What mode this command is scheduled in:     ABSOLUTE - The time reported in time will be used.     SUNRISE - The command will execute at local sunrise + offsetMin.  The time reported in the time field will be the calculated run time for today.     SUNSET - The command will execute at local sunset + offsetMin. The time reported in the time field will be the calculated run time for today. */
    static let mode: String = "mode"
/** The time of day formatted as HH:MM using a 24-hour clock, in place-local time (see Place#TimeZone), that the command should be sent. */
    static let time: String = "time"
/** This will always be 0 if the mode is set to ABSOLUTE.  If mode is set to SUNRISE or SUNSET this will be the offset / delta from sunrise or sunset that the event should run at.  A negative number means the event should happen before sunrise/sunset, a postive means after. */
    static let offsetMinutes: String = "offsetMinutes"
/** Default: base:SetAttributes. Type of message to be sent. */
    static let messageType: String = "messageType"
/** If specified it will update the attributes to be included in the message. */
    static let schedulerServiceAttributes: String = "attributes"
 }
  
  /** The address of the thing being scheduled. */
  public func setTarget(_ target: String) {
    attributes[Attributes.target] = target as AnyObject
  }

  
  /** The name of the schedule being modified. */
  public func setSchedule(_ schedule: String) {
    attributes[Attributes.schedule] = schedule as AnyObject
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
    if let value = SchedulerServiceMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** The time of day formatted as HH:MM using a 24-hour clock, in place-local time (see Place#TimeZone), that the command should be sent. */
  public func setTime(_ time: String) {
    attributes[Attributes.time] = time as AnyObject
  }

  
  /** This will always be 0 if the mode is set to ABSOLUTE.  If mode is set to SUNRISE or SUNSET this will be the offset / delta from sunrise or sunset that the event should run at.  A negative number means the event should happen before sunrise/sunset, a postive means after. */
  public func setOffsetMinutes(_ offsetMinutes: Int) {
    attributes[Attributes.offsetMinutes] = offsetMinutes as AnyObject
  }

  
  /** Default: base:SetAttributes. Type of message to be sent. */
  public func setMessageType(_ messageType: String) {
    attributes[Attributes.messageType] = messageType as AnyObject
  }

  
  /** If specified it will update the attributes to be included in the message. */
  public func setAttributes(_ schedulerServiceAttributes: [String: Any]) {
    attributes[Attributes.schedulerServiceAttributes] = schedulerServiceAttributes as AnyObject
  }

  
}

public class SchedulerServiceUpdateWeeklyCommandResponse: SessionEvent {
  
}

/**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#DeleteCommand(comandId). Deletes any occurrence of the specified command from the week.   */
public class SchedulerServiceDeleteCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerServiceDeleteCommandRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.schedulerServiceDeleteCommand
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
    return SchedulerServiceDeleteCommandResponse(message)
  }
  // MARK: DeleteCommandRequest Attributes
  struct Attributes {
    /** The address of the thing being scheduled. */
    static let target: String = "target"
/** The name of the schedule being modified. */
    static let schedule: String = "schedule"
/** The id of the command to update. Only the specified fields will be changed. */
    static let commandId: String = "commandId"
 }
  
  /** The address of the thing being scheduled. */
  public func setTarget(_ target: String) {
    attributes[Attributes.target] = target as AnyObject
  }

  
  /** The name of the schedule being modified. */
  public func setSchedule(_ schedule: String) {
    attributes[Attributes.schedule] = schedule as AnyObject
  }

  
  /** The id of the command to update. Only the specified fields will be changed. */
  public func setCommandId(_ commandId: String) {
    attributes[Attributes.commandId] = commandId as AnyObject
  }

  
}

public class SchedulerServiceDeleteCommandResponse: SessionEvent {
  
}

