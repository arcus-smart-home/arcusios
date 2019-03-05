
//
// AccountMigrationCapEvents.swift
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
  /** Creates a new V2 billing account for the user based on their V1 service level */
  static let accountMigrationMigrateBillingAccount: String = "accountmig:MigrateBillingAccount"
  
}


// MARK: Requests

/** Creates a new V2 billing account for the user based on their V1 service level */
public class AccountMigrationMigrateBillingAccountRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountMigrationMigrateBillingAccountRequest Enumerations
  /** The current v1 service level translated into the V2 enumeration */
  public enum AccountMigrationServiceLevel: String {
   case basic = "BASIC"
   case premium = "PREMIUM"
   
  }
  override init() {
    super.init()
    self.command = Commands.accountMigrationMigrateBillingAccount
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
    return AccountMigrationMigrateBillingAccountResponse(message)
  }

  // MARK: MigrateBillingAccountRequest Attributes
  struct Attributes {
    /** Billing token recevied from ReCurly */
    static let billingToken: String = "billingToken"
/** Place ID to associate the initial subscription to */
    static let placeID: String = "placeID"
/** The current v1 service level translated into the V2 enumeration */
    static let serviceLevel: String = "serviceLevel"
 }
  
  /** Billing token recevied from ReCurly */
  public func setBillingToken(_ billingToken: String) {
    attributes[Attributes.billingToken] = billingToken as AnyObject
  }

  
  /** Place ID to associate the initial subscription to */
  public func setPlaceID(_ placeID: String) {
    attributes[Attributes.placeID] = placeID as AnyObject
  }

  
  /** The current v1 service level translated into the V2 enumeration */
  public func setServiceLevel(_ serviceLevel: String) {
    if let value: AccountMigrationServiceLevel = AccountMigrationServiceLevel(rawValue: serviceLevel) {
      attributes[Attributes.serviceLevel] = value.rawValue as AnyObject
    }
  }
  
}

public class AccountMigrationMigrateBillingAccountResponse: SessionEvent {
  
}

