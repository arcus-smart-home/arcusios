
//
// PersonServiceEvents.swift
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
  /** Requests the platform to generate a password reset token and notify the user */
  public static let personServiceSendPasswordReset: String = "person:SendPasswordReset"
  /** Resets the users password */
  public static let personServiceResetPassword: String = "person:ResetPassword"
  /** Changes the password for the given person */
  public static let personServiceChangePassword: String = "person:ChangePassword"
  
}

// MARK: Requests

/** Requests the platform to generate a password reset token and notify the user */
public class PersonServiceSendPasswordResetRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonServiceSendPasswordResetRequest Enumerations
  /** The method by which the user will be notified of their reset token */
  public enum PersonServiceMethod: String {
   case email = "email"
   case ivr = "ivr"
   
  }
  override init() {
    super.init()
    self.command = Commands.personServiceSendPasswordReset
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
    return PersonServiceSendPasswordResetResponse(message)
  }
  // MARK: SendPasswordResetRequest Attributes
  struct Attributes {
    /** The email address of the person */
    static let email: String = "email"
/** The method by which the user will be notified of their reset token */
    static let method: String = "method"
 }
  
  /** The email address of the person */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
  /** The method by which the user will be notified of their reset token */
  public func setMethod(_ method: String) {
    if let value = PersonServiceMethod(rawValue: method) {
      attributes[Attributes.method] = value.rawValue as AnyObject
    }
  }
  
}

public class PersonServiceSendPasswordResetResponse: SessionEvent {
  
}

/** Resets the users password */
public class PersonServiceResetPasswordRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonServiceResetPasswordRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personServiceResetPassword
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
    return PersonServiceResetPasswordResponse(message)
  }
  // MARK: ResetPasswordRequest Attributes
  struct Attributes {
    /** The email address of the person */
    static let email: String = "email"
/** The token the user received via email or ivr */
    static let token: String = "token"
/** The new password */
    static let password: String = "password"
 }
  
  /** The email address of the person */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
  /** The token the user received via email or ivr */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
  /** The new password */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
}

public class PersonServiceResetPasswordResponse: SessionEvent {
  
}

/** Changes the password for the given person */
public class PersonServiceChangePasswordRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonServiceChangePasswordRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personServiceChangePassword
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
    return PersonServiceChangePasswordResponse(message)
  }
  // MARK: ChangePasswordRequest Attributes
  struct Attributes {
    /** Users current password */
    static let currentPassword: String = "currentPassword"
/** Users new password */
    static let newPassword: String = "newPassword"
/** Users Email Address */
    static let emailAddress: String = "emailAddress"
 }
  
  /** Users current password */
  public func setCurrentPassword(_ currentPassword: String) {
    attributes[Attributes.currentPassword] = currentPassword as AnyObject
  }

  
  /** Users new password */
  public func setNewPassword(_ newPassword: String) {
    attributes[Attributes.newPassword] = newPassword as AnyObject
  }

  
  /** Users Email Address */
  public func setEmailAddress(_ emailAddress: String) {
    attributes[Attributes.emailAddress] = emailAddress as AnyObject
  }

  
}

public class PersonServiceChangePasswordResponse: SessionEvent {
  
  
  /** Password change success indicator */
  public func getSuccess() -> Bool? {
    return self.attributes["success"] as? Bool
  }
}

