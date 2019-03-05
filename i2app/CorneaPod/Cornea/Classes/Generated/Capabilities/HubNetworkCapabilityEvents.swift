
//
// HubNetworkCapEvents.swift
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
  /** Gets the routing table for the active netowrk interface. */
  static let hubNetworkGetRoutingTable: String = "hubnet:GetRoutingTable"
  
}

// MARK: Enumerations

/** Name of the primary network interface. */
public enum HubNetworkType: String {
  case eth = "ETH"
  case _3g = "3G"
  case wifi = "WIFI"
}

// MARK: Requests

/** Gets the routing table for the active netowrk interface. */
public class HubNetworkGetRoutingTableRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubNetworkGetRoutingTable
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
    return HubNetworkGetRoutingTableResponse(message)
  }

  
}

public class HubNetworkGetRoutingTableResponse: SessionEvent {
  
}

