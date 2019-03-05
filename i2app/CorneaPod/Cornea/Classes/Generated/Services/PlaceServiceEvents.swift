
//
// PlaceServiceEvents.swift
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
  public static let placeServiceListTimezones: String = "place:ListTimezones"
  /** Validates the place&#x27;s address. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
  public static let placeServiceValidateAddress: String = "place:ValidateAddress"
  
}

// MARK: Requests

/** Creates an initial account, which includes the billing account, account owning person, default place, login credentials and default authorization grants */
public class PlaceServiceListTimezonesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeServiceListTimezones
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
    return PlaceServiceListTimezonesResponse(message)
  }
  
}

public class PlaceServiceListTimezonesResponse: SessionEvent {
  
  
  /** The available time zones in the system. */
  public func getTimezones() -> [Any]? {
    return self.attributes["timezones"] as? [Any]
  }
}

/** Validates the place&#x27;s address. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
public class PlaceServiceValidateAddressRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceServiceValidateAddressRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeServiceValidateAddress
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
    return PlaceServiceValidateAddressResponse(message)
  }
  // MARK: ValidateAddressRequest Attributes
  struct Attributes {
    /** Optional identifier or the place to validate */
    static let placeId: String = "placeId"
/** If specified this address will be validated instead of the default place address. */
    static let streetAddress: String = "streetAddress"
 }
  
  /** Optional identifier or the place to validate */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** If specified this address will be validated instead of the default place address. */
  public func setStreetAddress(_ streetAddress: Any) {
    attributes[Attributes.streetAddress] = streetAddress as AnyObject
  }

  
}

public class PlaceServiceValidateAddressResponse: SessionEvent {
  
  
  /** True if the given address is recognized, false otherwise. */
  public func getValid() -> Bool? {
    return self.attributes["valid"] as? Bool
  }
  /** A list of validated addresses that are similar to the place&#x27;s address. */
  public func getSuggestions() -> [Any]? {
    return self.attributes["suggestions"] as? [Any]
  }
}

