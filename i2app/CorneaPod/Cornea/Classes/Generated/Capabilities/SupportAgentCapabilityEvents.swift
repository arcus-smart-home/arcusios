
//
// SupportAgentCapEvents.swift
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
  /** Lists all agents */
  static let supportAgentListAgents: String = "supportagent:ListAgents"
  /** Create a support agent */
  static let supportAgentCreateSupportAgent: String = "supportagent:CreateSupportAgent"
  /** Find a support agent by their id */
  static let supportAgentFindAgentById: String = "supportagent:FindAgentById"
  /** Find a support agent by their email address */
  static let supportAgentFindAgentByEmail: String = "supportagent:FindAgentByEmail"
  /** Removes an agent */
  static let supportAgentDeleteAgent: String = "supportagent:DeleteAgent"
  /** Manually locks an agent, keeping them from logging in */
  static let supportAgentLockAgent: String = "supportagent:LockAgent"
  /** Unlocks an agent, allowing them to login */
  static let supportAgentUnlockAgent: String = "supportagent:UnlockAgent"
  /** Resets an agent&#x27;s password */
  static let supportAgentResetAgentPassword: String = "supportagent:ResetAgentPassword"
  /** allows inserts and updates of user preferences */
  static let supportAgentEditPreferences: String = "supportagent:EditPreferences"
  
}

// MARK: Enumerations

// MARK: Requests

/** Lists all agents */
public class SupportAgentListAgentsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.supportAgentListAgents
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
    return SupportAgentListAgentsResponse(message)
  }

  
}

public class SupportAgentListAgentsResponse: SessionEvent {
  
  
  /** The list of agents */
  public func getAgents() -> [Any]? {
    return self.attributes["agents"] as? [Any]
  }
}

/** Create a support agent */
public class SupportAgentCreateSupportAgentRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportAgentCreateSupportAgentRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportAgentCreateSupportAgent
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
    return SupportAgentCreateSupportAgentResponse(message)
  }

  // MARK: CreateSupportAgentRequest Attributes
  struct Attributes {
    /** Email address of the agent */
    static let email: String = "email"
/** First name of the agent */
    static let firstName: String = "firstName"
/** Last name of the agent */
    static let lastName: String = "lastName"
/** Support tier of the agent */
    static let supportTier: String = "supportTier"
/** Password of the agent */
    static let password: String = "password"
/** Mobile number of the agent */
    static let mobileNumber: String = "mobileNumber"
/** Location of the agent */
    static let currLocation: String = "currLocation"
/** Location of the agent */
    static let currLocationTimeZone: String = "currLocationTimeZone"
 }
  
  /** Email address of the agent */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
  /** First name of the agent */
  public func setFirstName(_ firstName: String) {
    attributes[Attributes.firstName] = firstName as AnyObject
  }

  
  /** Last name of the agent */
  public func setLastName(_ lastName: String) {
    attributes[Attributes.lastName] = lastName as AnyObject
  }

  
  /** Support tier of the agent */
  public func setSupportTier(_ supportTier: String) {
    attributes[Attributes.supportTier] = supportTier as AnyObject
  }

  
  /** Password of the agent */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
  /** Mobile number of the agent */
  public func setMobileNumber(_ mobileNumber: String) {
    attributes[Attributes.mobileNumber] = mobileNumber as AnyObject
  }

  
  /** Location of the agent */
  public func setCurrLocation(_ currLocation: String) {
    attributes[Attributes.currLocation] = currLocation as AnyObject
  }

  
  /** Location of the agent */
  public func setCurrLocationTimeZone(_ currLocationTimeZone: String) {
    attributes[Attributes.currLocationTimeZone] = currLocationTimeZone as AnyObject
  }

  
}

public class SupportAgentCreateSupportAgentResponse: SessionEvent {
  
}

/** Find a support agent by their id */
public class SupportAgentFindAgentByIdRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.supportAgentFindAgentById
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
    return SupportAgentFindAgentByIdResponse(message)
  }

  
}

public class SupportAgentFindAgentByIdResponse: SessionEvent {
  
}

/** Find a support agent by their email address */
public class SupportAgentFindAgentByEmailRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportAgentFindAgentByEmailRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportAgentFindAgentByEmail
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
    return SupportAgentFindAgentByEmailResponse(message)
  }

  // MARK: FindAgentByEmailRequest Attributes
  struct Attributes {
    /** Email address of the agent */
    static let email: String = "email"
 }
  
  /** Email address of the agent */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
}

public class SupportAgentFindAgentByEmailResponse: SessionEvent {
  
}

/** Removes an agent */
public class SupportAgentDeleteAgentRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.supportAgentDeleteAgent
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
    return SupportAgentDeleteAgentResponse(message)
  }

  
}

public class SupportAgentDeleteAgentResponse: SessionEvent {
  
}

/** Manually locks an agent, keeping them from logging in */
public class SupportAgentLockAgentRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.supportAgentLockAgent
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
    return SupportAgentLockAgentResponse(message)
  }

  
}

public class SupportAgentLockAgentResponse: SessionEvent {
  
}

/** Unlocks an agent, allowing them to login */
public class SupportAgentUnlockAgentRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.supportAgentUnlockAgent
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
    return SupportAgentUnlockAgentResponse(message)
  }

  
}

public class SupportAgentUnlockAgentResponse: SessionEvent {
  
}

/** Resets an agent&#x27;s password */
public class SupportAgentResetAgentPasswordRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportAgentResetAgentPasswordRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportAgentResetAgentPassword
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
    return SupportAgentResetAgentPasswordResponse(message)
  }

  // MARK: ResetAgentPasswordRequest Attributes
  struct Attributes {
    /** Email address of the agent */
    static let email: String = "email"
/** New password for the agent */
    static let newPassword: String = "newPassword"
 }
  
  /** Email address of the agent */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
  /** New password for the agent */
  public func setNewPassword(_ newPassword: String) {
    attributes[Attributes.newPassword] = newPassword as AnyObject
  }

  
}

public class SupportAgentResetAgentPasswordResponse: SessionEvent {
  
}

/** allows inserts and updates of user preferences */
public class SupportAgentEditPreferencesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportAgentEditPreferencesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportAgentEditPreferences
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
    return SupportAgentEditPreferencesResponse(message)
  }

  // MARK: EditPreferencesRequest Attributes
  struct Attributes {
    /** Email address of the agent */
    static let email: String = "email"
/** preference valuse */
    static let prefValues: String = "prefValues"
 }
  
  /** Email address of the agent */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
  /** preference valuse */
  public func setPrefValues(_ prefValues: [String: String]) {
    attributes[Attributes.prefValues] = prefValues as AnyObject
  }

  
}

public class SupportAgentEditPreferencesResponse: SessionEvent {
  
}

