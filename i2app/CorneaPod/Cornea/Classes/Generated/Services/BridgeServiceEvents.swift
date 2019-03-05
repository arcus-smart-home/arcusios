
//
// BridgeServiceEvents.swift
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
  /** Assigns a place to the device with the specified id provided the device is online. */
  public static let bridgeServiceRegisterDevice: String = "bridgesvc:RegisterDevice"
  /** Removes the device with the specified id. */
  public static let bridgeServiceRemoveDevice: String = "bridgesvc:RemoveDevice"
  
}

// MARK: Requests

/** Assigns a place to the device with the specified id provided the device is online. */
public class BridgeServiceRegisterDeviceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: BridgeServiceRegisterDeviceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.bridgeServiceRegisterDevice
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
    return BridgeServiceRegisterDeviceResponse(message)
  }
  // MARK: RegisterDeviceRequest Attributes
  struct Attributes {
    /** Identifying attributes of the device. */
    static let attrs: String = "attrs"
 }
  
  /** Identifying attributes of the device. */
  public func setAttrs(_ attrs: [String: String]) {
    attributes[Attributes.attrs] = attrs as AnyObject
  }

  
}

public class BridgeServiceRegisterDeviceResponse: SessionEvent {
  
}

/** Removes the device with the specified id. */
public class BridgeServiceRemoveDeviceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: BridgeServiceRemoveDeviceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.bridgeServiceRemoveDevice
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
    return BridgeServiceRemoveDeviceResponse(message)
  }
  // MARK: RemoveDeviceRequest Attributes
  struct Attributes {
    /** The identifier for the device. */
    static let id: String = "id"
/** The account id of the device */
    static let accountId: String = "accountId"
/** The place id of the device */
    static let placeId: String = "placeId"
 }
  
  /** The identifier for the device. */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
  /** The account id of the device */
  public func setAccountId(_ accountId: String) {
    attributes[Attributes.accountId] = accountId as AnyObject
  }

  
  /** The place id of the device */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class BridgeServiceRemoveDeviceResponse: SessionEvent {
  
}

