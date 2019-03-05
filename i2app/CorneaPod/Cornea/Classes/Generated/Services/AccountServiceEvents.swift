
//
// AccountServiceEvents.swift
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
  /** Creates an initial account, which includes the billing account, account owning person, default place, login credentials and default authorization grants */
  public static let accountServiceCreateAccount: String = "account:CreateAccount"
  
}

// MARK: Requests

/** Creates an initial account, which includes the billing account, account owning person, default place, login credentials and default authorization grants */
public class AccountServiceCreateAccountRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountServiceCreateAccountRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountServiceCreateAccount
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
    return AccountServiceCreateAccountResponse(message)
  }
  // MARK: CreateAccountRequest Attributes
  struct Attributes {
    /** The email address of the account owning person */
    static let email: String = "email"
/** The password of the account owning person */
    static let password: String = "password"
/** If the account owner would like to receive notifications via email */
    static let optin: String = "optin"
/** If the session created after create account is a public session */
    static let isPublic: String = "isPublic"
/** Person attributes */
    static let person: String = "person"
/** Place attributes */
    static let place: String = "place"
 }
  
  /** The email address of the account owning person */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
  /** The password of the account owning person */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
  /** If the account owner would like to receive notifications via email */
  public func setOptin(_ optin: String) {
    attributes[Attributes.optin] = optin as AnyObject
  }

  
  /** If the session created after create account is a public session */
  public func setIsPublic(_ isPublic: String) {
    attributes[Attributes.isPublic] = isPublic as AnyObject
  }

  
  /** Person attributes */
  public func setPerson(_ person: Any) {
    guard let model = person as? ArcusModel else { return }
    attributes[Attributes.person] = model.get() as AnyObject
    
  }

  
  /** Place attributes */
  public func setPlace(_ place: Any) {
    guard let model = place as? ArcusModel else { return }
    attributes[Attributes.place] = model.get() as AnyObject
    
  }

  
}

public class AccountServiceCreateAccountResponse: SessionEvent {
  
  
  /** The instance of AccountModel created for the new registration */
  public func getAccount() -> Any? {
    return self.attributes["account"]
  }
  /** The instance of PersonModel created for the account owning person */
  public func getPerson() -> Any? {
    return self.attributes["person"]
  }
  /** The instance of PlaceModel created for the default place */
  public func getPlace() -> Any? {
    return self.attributes["place"]
  }
}

