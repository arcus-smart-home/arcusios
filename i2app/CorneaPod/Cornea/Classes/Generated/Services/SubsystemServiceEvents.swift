
//
// SubsystemServiceEvents.swift
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
  /** Lists all subsystems available for a given place */
  public static let subsystemServiceListSubsystems: String = "subs:ListSubsystems"
  /** Flushes and reloads all the subsystems at the active given place, intended for testing */
  public static let subsystemServiceReload: String = "subs:Reload"
  
}

// MARK: Requests

/** Lists all subsystems available for a given place */
public class SubsystemServiceListSubsystemsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SubsystemServiceListSubsystemsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.subsystemServiceListSubsystems
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
    return SubsystemServiceListSubsystemsResponse(message)
  }
  // MARK: ListSubsystemsRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class SubsystemServiceListSubsystemsResponse: SessionEvent {
  
  
  /** The subsystems */
  public func getSubsystems() -> [Any]? {
    return self.attributes["subsystems"] as? [Any]
  }
}

/** Flushes and reloads all the subsystems at the active given place, intended for testing */
public class SubsystemServiceReloadRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.subsystemServiceReload
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
    return SubsystemServiceReloadResponse(message)
  }
  
}

public class SubsystemServiceReloadResponse: SessionEvent {
  
}

