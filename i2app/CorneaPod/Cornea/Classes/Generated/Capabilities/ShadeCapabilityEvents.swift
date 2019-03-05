
//
// ShadeCapEvents.swift
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
  /** Move the shade to a pre-programmed OPEN position. */
  static let shadeGoToOpen: String = "shade:GoToOpen"
  /** Move the shade to a pre-programmed CLOSED position. */
  static let shadeGoToClosed: String = "shade:GoToClosed"
  /** Move the shade to a pre-programmed FAVORITE position. */
  static let shadeGoToFavorite: String = "shade:GoToFavorite"
  
}

// MARK: Enumerations

/** Reflects the current state of the shade.  Obstruction implying that something is preventing the opening or closing of the shade. */
public enum ShadeShadestate: String {
  case ok = "OK"
  case obstruction = "OBSTRUCTION"
}

// MARK: Requests

/** Move the shade to a pre-programmed OPEN position. */
public class ShadeGoToOpenRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.shadeGoToOpen
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
    return ShadeGoToOpenResponse(message)
  }

  
}

public class ShadeGoToOpenResponse: SessionEvent {
  
}

/** Move the shade to a pre-programmed CLOSED position. */
public class ShadeGoToClosedRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.shadeGoToClosed
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
    return ShadeGoToClosedResponse(message)
  }

  
}

public class ShadeGoToClosedResponse: SessionEvent {
  
}

/** Move the shade to a pre-programmed FAVORITE position. */
public class ShadeGoToFavoriteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.shadeGoToFavorite
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
    return ShadeGoToFavoriteResponse(message)
  }

  
}

public class ShadeGoToFavoriteResponse: SessionEvent {
  
}

