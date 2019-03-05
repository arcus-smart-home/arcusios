
//
// HubKitCapEvents.swift
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
  /** Set the kit items for the hub. */
  static let hubKitSetKit: String = "hubkit:SetKit"
  
}

// MARK: Enumerations

/** Type of kit that this hub is a part of. */
public enum HubKitType: String {
  case none = "NONE"
  case test = "TEST"
  case promon = "PROMON"
}

// MARK: Requests

/** Set the kit items for the hub. */
public class HubKitSetKitRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubKitSetKitRequest Enumerations
  /** Type of kit that this hub is a part of. */
  public enum HubKitType: String {
   case none = "NONE"
   case test = "TEST"
   case promon = "PROMON"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubKitSetKit
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
    return HubKitSetKitResponse(message)
  }

  // MARK: SetKitRequest Attributes
  struct Attributes {
    /** Type of kit that this hub is a part of. */
    static let type: String = "type"
/** List of devices in the kit that this hub is a part of. */
    static let devices: String = "devices"
 }
  
  /** Type of kit that this hub is a part of. */
  public func setType(_ type: String) {
    if let value: HubKitType = HubKitType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
  /** List of devices in the kit that this hub is a part of. */
  public func setDevices(_ devices: [Any]) {
    attributes[Attributes.devices] = devices as AnyObject
  }

  
}

public class HubKitSetKitResponse: SessionEvent {
  
}

