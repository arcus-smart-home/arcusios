
//
// InvitationServiceEvents.swift
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
  /** Finds an invitation by its code and invitee email */
  public static let invitationServiceGetInvitation: String = "invite:GetInvitation"
  /** Creates a new person/login and associates them with the place from the invitation */
  public static let invitationServiceAcceptInvitationCreateLogin: String = "invite:AcceptInvitationCreateLogin"
  
}

// MARK: Requests

/** Finds an invitation by its code and invitee email */
public class InvitationServiceGetInvitationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: InvitationServiceGetInvitationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.invitationServiceGetInvitation
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
    return InvitationServiceGetInvitationResponse(message)
  }
  // MARK: GetInvitationRequest Attributes
  struct Attributes {
    /** The invitation code */
    static let code: String = "code"
/** The email address the invite was sent too */
    static let inviteeEmail: String = "inviteeEmail"
 }
  
  /** The invitation code */
  public func setCode(_ code: String) {
    attributes[Attributes.code] = code as AnyObject
  }

  
  /** The email address the invite was sent too */
  public func setInviteeEmail(_ inviteeEmail: String) {
    attributes[Attributes.inviteeEmail] = inviteeEmail as AnyObject
  }

  
}

public class InvitationServiceGetInvitationResponse: SessionEvent {
  
  
  /** The invitation */
  public func getInvitation() -> Any? {
    return self.attributes["invitation"]
  }
}

/** Creates a new person/login and associates them with the place from the invitation */
public class InvitationServiceAcceptInvitationCreateLoginRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: InvitationServiceAcceptInvitationCreateLoginRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.invitationServiceAcceptInvitationCreateLogin
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
    return InvitationServiceAcceptInvitationCreateLoginResponse(message)
  }
  // MARK: AcceptInvitationCreateLoginRequest Attributes
  struct Attributes {
    /** The person you would like to create with person to this place. */
    static let person: String = "person"
/** The login password for this person. */
    static let password: String = "password"
/** The invitation code */
    static let code: String = "code"
/** The email the invitation was sent to, which does nto have to be same as the email the login is created with. */
    static let inviteeEmail: String = "inviteeEmail"
 }
  
  /** The person you would like to create with person to this place. */
  public func setPerson(_ person: Any) {
    guard let model = person as? ArcusModel else { return }
    attributes[Attributes.person] = model.get() as AnyObject
    
  }

  
  /** The login password for this person. */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
  /** The invitation code */
  public func setCode(_ code: String) {
    attributes[Attributes.code] = code as AnyObject
  }

  
  /** The email the invitation was sent to, which does nto have to be same as the email the login is created with. */
  public func setInviteeEmail(_ inviteeEmail: String) {
    attributes[Attributes.inviteeEmail] = inviteeEmail as AnyObject
  }

  
}

public class InvitationServiceAcceptInvitationCreateLoginResponse: SessionEvent {
  
  
  /** The instance of the PersonModel created for the person */
  public func getPerson() -> Any? {
    return self.attributes["person"]
  }
}

