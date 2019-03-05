
//
// IcstMessageCapEvents.swift
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
  /** Add a message */
  static let icstMessageCreateMessage: String = "icstmsg:CreateMessage"
  /** Lists messages within a time range */
  static let icstMessageListMessagesForTimeframe: String = "icstmsg:ListMessagesForTimeframe"
  
}

// MARK: Enumerations

// MARK: Requests

/** Add a message */
public class IcstMessageCreateMessageRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IcstMessageCreateMessageRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.icstMessageCreateMessage
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
    return IcstMessageCreateMessageResponse(message)
  }

  // MARK: CreateMessageRequest Attributes
  struct Attributes {
    /** unique id */
    static let id: String = "id"
/** MOTD or URGENT */
    static let messageType: String = "messageType"
/** ID of agent that created the message */
    static let agent: String = "agent"
/** message to share */
    static let message: String = "message"
/** empty or set of agent uuids */
    static let recipients: String = "recipients"
/** The date the message expires (end-of-day), empty if URGENT or MOTD expires same day it was created. */
    static let expiration: String = "expiration"
 }
  
  /** unique id */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
  /** MOTD or URGENT */
  public func setMessageType(_ messageType: String) {
    attributes[Attributes.messageType] = messageType as AnyObject
  }

  
  /** ID of agent that created the message */
  public func setAgent(_ agent: String) {
    attributes[Attributes.agent] = agent as AnyObject
  }

  
  /** message to share */
  public func setMessage(_ message: String) {
    attributes[Attributes.message] = message as AnyObject
  }

  
  /** empty or set of agent uuids */
  public func setRecipients(_ recipients: [String]) {
    attributes[Attributes.recipients] = recipients as AnyObject
  }

  
  /** The date the message expires (end-of-day), empty if URGENT or MOTD expires same day it was created. */
  public func setExpiration(_ expiration: Date) {
    let expiration: Double = expiration.millisecondsSince1970
    attributes[Attributes.expiration] = expiration as AnyObject
  }

  
}

public class IcstMessageCreateMessageResponse: SessionEvent {
  
}

/** Lists messages within a time range */
public class IcstMessageListMessagesForTimeframeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IcstMessageListMessagesForTimeframeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.icstMessageListMessagesForTimeframe
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
    return IcstMessageListMessagesForTimeframeResponse(message)
  }

  // MARK: ListMessagesForTimeframeRequest Attributes
  struct Attributes {
    /** MOTD or URGENT */
    static let messageType: String = "messageType"
/** empty or ID of agent for finding messages created by a particular agent */
    static let agent: String = "agent"
/** Earliest date for messages. Format is yyyy-MM-dd HH:mm:ss */
    static let startDate: String = "startDate"
/** Latest date for messages. Format is yyyy-MM-dd HH:mm:ss */
    static let endDate: String = "endDate"
/** token for paging results */
    static let token: String = "token"
/** max 1000, default 50 */
    static let limit: String = "limit"
 }
  
  /** MOTD or URGENT */
  public func setMessageType(_ messageType: String) {
    attributes[Attributes.messageType] = messageType as AnyObject
  }

  
  /** empty or ID of agent for finding messages created by a particular agent */
  public func setAgent(_ agent: String) {
    attributes[Attributes.agent] = agent as AnyObject
  }

  
  /** Earliest date for messages. Format is yyyy-MM-dd HH:mm:ss */
  public func setStartDate(_ startDate: String) {
    attributes[Attributes.startDate] = startDate as AnyObject
  }

  
  /** Latest date for messages. Format is yyyy-MM-dd HH:mm:ss */
  public func setEndDate(_ endDate: String) {
    attributes[Attributes.endDate] = endDate as AnyObject
  }

  
  /** token for paging results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
  /** max 1000, default 50 */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
}

public class IcstMessageListMessagesForTimeframeResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The list of messages */
  public func getMessages() -> [Any]? {
    return self.attributes["messages"] as? [Any]
  }
}

