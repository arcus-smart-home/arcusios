
//
// SchedulerCapEvents.swift
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
  /** Fires the requested command right now, generally used for testing. */
  static let schedulerFireCommand: String = "scheduler:FireCommand"
  /**  Creates a new schedule which will appear as a new multi-instance object on the Scheduler with the given id. If a schedule with the given id already exists with the same type this will be a no-op.  If a schedule with the same id and a different type exists, this will return an error.           */
  static let schedulerAddWeeklySchedule: String = "scheduler:AddWeeklySchedule"
  /** Deletes this scheduler object and all associated schedules, this is generally not recommended.  If the target object is deleted, this Scheduler will automatically be deleted. */
  static let schedulerDelete: String = "scheduler:Delete"
  
}

// MARK: Enumerations

// MARK: Requests

/** Fires the requested command right now, generally used for testing. */
public class SchedulerFireCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerFireCommandRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.schedulerFireCommand
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
    return SchedulerFireCommandResponse(message)
  }

  // MARK: FireCommandRequest Attributes
  struct Attributes {
    /** The id of the command to fire */
    static let commandId: String = "commandId"
 }
  
  /** The id of the command to fire */
  public func setCommandId(_ commandId: String) {
    attributes[Attributes.commandId] = commandId as AnyObject
  }

  
}

public class SchedulerFireCommandResponse: SessionEvent {
  
}

/**  Creates a new schedule which will appear as a new multi-instance object on the Scheduler with the given id. If a schedule with the given id already exists with the same type this will be a no-op.  If a schedule with the same id and a different type exists, this will return an error.           */
public class SchedulerAddWeeklyScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SchedulerAddWeeklyScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.schedulerAddWeeklySchedule
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
    return SchedulerAddWeeklyScheduleResponse(message)
  }

  // MARK: AddWeeklyScheduleRequest Attributes
  struct Attributes {
    /** The instance id of the schedule to create. */
    static let id: String = "id"
/** Default: id. The group to associate this schedule with, when not specified the id will be used. */
    static let group: String = "group"
 }
  
  /** The instance id of the schedule to create. */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
  /** Default: id. The group to associate this schedule with, when not specified the id will be used. */
  public func setGroup(_ group: String) {
    attributes[Attributes.group] = group as AnyObject
  }

  
}

public class SchedulerAddWeeklyScheduleResponse: SessionEvent {
  
}

/** Deletes this scheduler object and all associated schedules, this is generally not recommended.  If the target object is deleted, this Scheduler will automatically be deleted. */
public class SchedulerDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.schedulerDelete
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
    return SchedulerDeleteResponse(message)
  }

  
}

public class SchedulerDeleteResponse: SessionEvent {
  
}

