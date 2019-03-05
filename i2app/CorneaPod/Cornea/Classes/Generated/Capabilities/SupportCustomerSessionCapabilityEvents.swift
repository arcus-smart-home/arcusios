
//
// SupportCustomerSessionCapEvents.swift
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
  /** Create a support customer session */
  static let supportCustomerSessionStartSession: String = "suppcustsession:StartSession"
  /** Find the active support customer session (if any) by account id and agent id */
  static let supportCustomerSessionFindActiveSession: String = "suppcustsession:FindActiveSession"
  /** Find all support customer sessions for an account (active and closed) by account id */
  static let supportCustomerSessionListSessions: String = "suppcustsession:ListSessions"
  /** Closes a session */
  static let supportCustomerSessionCloseSession: String = "suppcustsession:CloseSession"
  
}

// MARK: Enumerations

// MARK: Requests

/** Create a support customer session */
public class SupportCustomerSessionStartSessionRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportCustomerSessionStartSessionRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportCustomerSessionStartSession
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
    return SupportCustomerSessionStartSessionResponse(message)
  }

  // MARK: StartSessionRequest Attributes
  struct Attributes {
    /** Agent UUID */
    static let agent: String = "agent"
/** Account UUID */
    static let account: String = "account"
/** caller UUID */
    static let caller: String = "caller"
/** Origin of session (inbound, outbound, email) */
    static let origin: String = "origin"
 }
  
  /** Agent UUID */
  public func setAgent(_ agent: String) {
    attributes[Attributes.agent] = agent as AnyObject
  }

  
  /** Account UUID */
  public func setAccount(_ account: String) {
    attributes[Attributes.account] = account as AnyObject
  }

  
  /** caller UUID */
  public func setCaller(_ caller: String) {
    attributes[Attributes.caller] = caller as AnyObject
  }

  
  /** Origin of session (inbound, outbound, email) */
  public func setOrigin(_ origin: String) {
    attributes[Attributes.origin] = origin as AnyObject
  }

  
}

public class SupportCustomerSessionStartSessionResponse: SessionEvent {
  
}

/** Find the active support customer session (if any) by account id and agent id */
public class SupportCustomerSessionFindActiveSessionRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportCustomerSessionFindActiveSessionRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportCustomerSessionFindActiveSession
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
    return SupportCustomerSessionFindActiveSessionResponse(message)
  }

  // MARK: FindActiveSessionRequest Attributes
  struct Attributes {
    /** Agent UUID */
    static let agent: String = "agent"
/** Account UUID */
    static let account: String = "account"
 }
  
  /** Agent UUID */
  public func setAgent(_ agent: String) {
    attributes[Attributes.agent] = agent as AnyObject
  }

  
  /** Account UUID */
  public func setAccount(_ account: String) {
    attributes[Attributes.account] = account as AnyObject
  }

  
}

public class SupportCustomerSessionFindActiveSessionResponse: SessionEvent {
  
}

/** Find all support customer sessions for an account (active and closed) by account id */
public class SupportCustomerSessionListSessionsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportCustomerSessionListSessionsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportCustomerSessionListSessions
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
    return SupportCustomerSessionListSessionsResponse(message)
  }

  // MARK: ListSessionsRequest Attributes
  struct Attributes {
    /** Account UUID */
    static let account: String = "account"
 }
  
  /** Account UUID */
  public func setAccount(_ account: String) {
    attributes[Attributes.account] = account as AnyObject
  }

  
}

public class SupportCustomerSessionListSessionsResponse: SessionEvent {
  
}

/** Closes a session */
public class SupportCustomerSessionCloseSessionRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.supportCustomerSessionCloseSession
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
    return SupportCustomerSessionCloseSessionResponse(message)
  }

  
}

public class SupportCustomerSessionCloseSessionResponse: SessionEvent {
  
}

