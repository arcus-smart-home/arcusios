
//
// SupportAgentLogEntryCapEvents.swift
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
  /** Log something an agent did */
  static let supportAgentLogEntryCreateAgentLogEntry: String = "salogentry:CreateAgentLogEntry"
  /** Lists audit logs within a time range */
  static let supportAgentLogEntryListAgentLogEntries: String = "salogentry:ListAgentLogEntries"
  
}

// MARK: Enumerations

// MARK: Requests

/** Log something an agent did */
public class SupportAgentLogEntryCreateAgentLogEntryRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportAgentLogEntryCreateAgentLogEntryRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportAgentLogEntryCreateAgentLogEntry
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
    return SupportAgentLogEntryCreateAgentLogEntryResponse(message)
  }

  // MARK: CreateAgentLogEntryRequest Attributes
  struct Attributes {
    /** ID of agent */
    static let agentId: String = "agentId"
/** ID of account */
    static let accountId: String = "accountId"
/** what occurred */
    static let action: String = "action"
/** set of parameters */
    static let parameters: String = "parameters"
/** ID of customer */
    static let userId: String = "userId"
/** ID of device */
    static let deviceId: String = "deviceId"
/** ID of place */
    static let placeId: String = "placeId"
 }
  
  /** ID of agent */
  public func setAgentId(_ agentId: String) {
    attributes[Attributes.agentId] = agentId as AnyObject
  }

  
  /** ID of account */
  public func setAccountId(_ accountId: String) {
    attributes[Attributes.accountId] = accountId as AnyObject
  }

  
  /** what occurred */
  public func setAction(_ action: String) {
    attributes[Attributes.action] = action as AnyObject
  }

  
  /** set of parameters */
  public func setParameters(_ parameters: [String]) {
    attributes[Attributes.parameters] = parameters as AnyObject
  }

  
  /** ID of customer */
  public func setUserId(_ userId: String) {
    attributes[Attributes.userId] = userId as AnyObject
  }

  
  /** ID of device */
  public func setDeviceId(_ deviceId: String) {
    attributes[Attributes.deviceId] = deviceId as AnyObject
  }

  
  /** ID of place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class SupportAgentLogEntryCreateAgentLogEntryResponse: SessionEvent {
  
}

/** Lists audit logs within a time range */
public class SupportAgentLogEntryListAgentLogEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportAgentLogEntryListAgentLogEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportAgentLogEntryListAgentLogEntries
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
    return SupportAgentLogEntryListAgentLogEntriesResponse(message)
  }

  // MARK: ListAgentLogEntriesRequest Attributes
  struct Attributes {
    /** ID of agent */
    static let agentId: String = "agentId"
/** Earliest date for logs. Format is yyyy-MM-dd HH:mm:ss */
    static let startDate: String = "startDate"
/** Latest date for logs. Format is yyyy-MM-dd HH:mm:ss */
    static let endDate: String = "endDate"
 }
  
  /** ID of agent */
  public func setAgentId(_ agentId: String) {
    attributes[Attributes.agentId] = agentId as AnyObject
  }

  
  /** Earliest date for logs. Format is yyyy-MM-dd HH:mm:ss */
  public func setStartDate(_ startDate: String) {
    attributes[Attributes.startDate] = startDate as AnyObject
  }

  
  /** Latest date for logs. Format is yyyy-MM-dd HH:mm:ss */
  public func setEndDate(_ endDate: String) {
    attributes[Attributes.endDate] = endDate as AnyObject
  }

  
}

public class SupportAgentLogEntryListAgentLogEntriesResponse: SessionEvent {
  
  
  /** The list of audit logs */
  public func getAuditLogs() -> [Any]? {
    return self.attributes["auditLogs"] as? [Any]
  }
}

