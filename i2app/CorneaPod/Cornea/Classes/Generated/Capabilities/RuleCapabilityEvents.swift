
//
// RuleCapEvents.swift
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
  /** Enables the rule if it is disabled */
  static let ruleEnable: String = "rule:Enable"
  /** Disables the rule if it is enabled */
  static let ruleDisable: String = "rule:Disable"
  /** Updates the context for the rule */
  static let ruleUpdateContext: String = "rule:UpdateContext"
  /** Deletes the rule */
  static let ruleDelete: String = "rule:Delete"
  /** Returns a list of all the history log entries associated with this rule */
  static let ruleListHistoryEntries: String = "rule:ListHistoryEntries"
  
}

// MARK: Enumerations

/** The current state of the rule */
public enum RuleState: String {
  case enabled = "ENABLED"
  case disabled = "DISABLED"
}

// MARK: Requests

/** Enables the rule if it is disabled */
public class RuleEnableRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.ruleEnable
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
    return RuleEnableResponse(message)
  }

  
}

public class RuleEnableResponse: SessionEvent {
  
}

/** Disables the rule if it is enabled */
public class RuleDisableRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.ruleDisable
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
    return RuleDisableResponse(message)
  }

  
}

public class RuleDisableResponse: SessionEvent {
  
}

/** Updates the context for the rule */
public class RuleUpdateContextRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleUpdateContextRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleUpdateContext
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
    return RuleUpdateContextResponse(message)
  }

  // MARK: UpdateContextRequest Attributes
  struct Attributes {
    /** New context values to update */
    static let context: String = "context"
/** New template identifier to update */
    static let template: String = "template"
 }
  
  /** New context values to update */
  public func setContext(_ context: Any) {
    attributes[Attributes.context] = context as AnyObject
  }

  
  /** New template identifier to update */
  public func setTemplate(_ template: String) {
    attributes[Attributes.template] = template as AnyObject
  }

  
}

public class RuleUpdateContextResponse: SessionEvent {
  
}

/** Deletes the rule */
public class RuleDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.ruleDelete
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
    return RuleDeleteResponse(message)
  }

  
}

public class RuleDeleteResponse: SessionEvent {
  
}

/** Returns a list of all the history log entries associated with this rule */
public class RuleListHistoryEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleListHistoryEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleListHistoryEntries
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
    return RuleListHistoryEntriesResponse(message)
  }

  // MARK: ListHistoryEntriesRequest Attributes
  struct Attributes {
    /** The maximum number of events to return (defaults to 10) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results */
    static let token: String = "token"
 }
  
  /** The maximum number of events to return (defaults to 10) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
}

public class RuleListHistoryEntriesResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this rule */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

