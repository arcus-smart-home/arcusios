
//
// PetDoorCapEvents.swift
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
  /** Remove a pet token from the pet door to prevent further access. */
  static let petDoorRemoveToken: String = "petdoor:RemoveToken"
  
}
// MARK: Events
public struct PetDoorEvents {
  /** Fired when a pet token is added to the pet door. */
  public static let petDoorTokenAdded: String = "petdoor:TokenAdded"
  /** Fired when a pet token is removed from the pet door. */
  public static let petDoorTokenRemoved: String = "petdoor:TokenRemoved"
  /** Fired when a token is used to unlock the pet door. */
  public static let petDoorTokenUsed: String = "petdoor:TokenUsed"
  }

// MARK: Enumerations

/** Lock state of the door, to override the doorlock lockstate. */
public enum PetDoorLockstate: String {
  case locked = "LOCKED"
  case unlocked = "UNLOCKED"
  case auto = "AUTO"
}

/** Direction a pet last passed through the smart pet door. */
public enum PetDoorDirection: String {
  case petDoorIn = "IN"
  case out = "OUT"
}

// MARK: Requests

/** Remove a pet token from the pet door to prevent further access. */
public class PetDoorRemoveTokenRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PetDoorRemoveTokenRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.petDoorRemoveToken
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
    return PetDoorRemoveTokenResponse(message)
  }

  // MARK: RemoveTokenRequest Attributes
  struct Attributes {
    /** The ID of the token to remove from the pet door */
    static let tokenId: String = "tokenId"
 }
  
  /** The ID of the token to remove from the pet door */
  public func setTokenId(_ tokenId: Int) {
    attributes[Attributes.tokenId] = tokenId as AnyObject
  }

  
}

public class PetDoorRemoveTokenResponse: SessionEvent {
  
  
  /** True or false, the key was removed. */
  public func getRemoved() -> Bool? {
    return self.attributes["removed"] as? Bool
  }
}

