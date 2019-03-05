
//
// SubsystemCapEvents.swift
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
  /** Puts the subsystem into an &#x27;active&#x27; state, this only applies to previously suspended subsystems, see Place#AddSubsystem(subsystemType: String) for adding new subsystems to a place. */
  static let subsystemActivate: String = "subs:Activate"
  /** Puts the subsystem into a &#x27;suspended&#x27; state. */
  static let subsystemSuspend: String = "subs:Suspend"
  /** Removes the subsystem and all data from the associated place. */
  static let subsystemDelete: String = "subs:Delete"
  /** Returns a list of all the history log entries associated with this subsystem */
  static let subsystemListHistoryEntries: String = "subs:ListHistoryEntries"
  
}

// MARK: Enumerations

/** Indicates the current state of a subsystem.  A SUSPENDED subsystem will not collect any new data or enable associated rules, but may still allow previously collected data to be viewed. */
public enum SubsystemState: String {
  case active = "ACTIVE"
  case suspended = "SUSPENDED"
}

// MARK: Requests

/** Puts the subsystem into an &#x27;active&#x27; state, this only applies to previously suspended subsystems, see Place#AddSubsystem(subsystemType: String) for adding new subsystems to a place. */
public class SubsystemActivateRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.subsystemActivate
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
    return SubsystemActivateResponse(message)
  }

  
}

public class SubsystemActivateResponse: SessionEvent {
  
}

/** Puts the subsystem into a &#x27;suspended&#x27; state. */
public class SubsystemSuspendRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.subsystemSuspend
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
    return SubsystemSuspendResponse(message)
  }

  
}

public class SubsystemSuspendResponse: SessionEvent {
  
}

/** Removes the subsystem and all data from the associated place. */
public class SubsystemDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.subsystemDelete
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
    return SubsystemDeleteResponse(message)
  }

  
}

public class SubsystemDeleteResponse: SessionEvent {
  
}

/** Returns a list of all the history log entries associated with this subsystem */
public class SubsystemListHistoryEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SubsystemListHistoryEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.subsystemListHistoryEntries
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
    return SubsystemListHistoryEntriesResponse(message)
  }

  // MARK: ListHistoryEntriesRequest Attributes
  struct Attributes {
    /** The maximum number of events to return (defaults to 10) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results */
    static let token: String = "token"
/** Whether or not incidents should be included in history, defaults to false for backwards compatibility */
    static let includeIncidents: String = "includeIncidents"
 }
  
  /** The maximum number of events to return (defaults to 10) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
  /** Whether or not incidents should be included in history, defaults to false for backwards compatibility */
  public func setIncludeIncidents(_ includeIncidents: Bool) {
    attributes[Attributes.includeIncidents] = includeIncidents as AnyObject
  }

  
}

public class SubsystemListHistoryEntriesResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this subsystem */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

