
//
// ScheduleCapEvents.swift
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
  /** Deletes this Schedule and removes any scheduled commands. */
  static let scheduleDelete: String = "sched:Delete"
  /** Deletes any occurrences of the scheduled command from this Schedule. */
  static let scheduleDeleteCommand: String = "sched:DeleteCommand"
  
}

// MARK: Enumerations

// MARK: Requests

/** Deletes this Schedule and removes any scheduled commands. */
public class ScheduleDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.scheduleDelete
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
    return ScheduleDeleteResponse(message)
  }

  
}

public class ScheduleDeleteResponse: SessionEvent {
  
}

/** Deletes any occurrences of the scheduled command from this Schedule. */
public class ScheduleDeleteCommandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ScheduleDeleteCommandRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.scheduleDeleteCommand
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
    return ScheduleDeleteCommandResponse(message)
  }

  // MARK: DeleteCommandRequest Attributes
  struct Attributes {
    /** The id of the command to delete. */
    static let commandId: String = "commandId"
 }
  
  /** The id of the command to delete. */
  public func setCommandId(_ commandId: String) {
    attributes[Attributes.commandId] = commandId as AnyObject
  }

  
}

public class ScheduleDeleteCommandResponse: SessionEvent {
  
}

