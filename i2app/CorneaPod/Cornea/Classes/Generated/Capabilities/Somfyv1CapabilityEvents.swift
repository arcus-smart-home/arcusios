
//
// Somfyv1CapEvents.swift
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
  /** Move the Blinds or Shade to a pre-programmed OPEN position. */
  static let somfyv1GoToOpen: String = "somfyv1:GoToOpen"
  /** Move the Blinds or Shade to a pre-programmed CLOSED position. */
  static let somfyv1GoToClosed: String = "somfyv1:GoToClosed"
  /** Move the Blinds or Shade to a pre-programmed FAVORITE position. */
  static let somfyv1GoToFavorite: String = "somfyv1:GoToFavorite"
  
}

// MARK: Enumerations

/** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
public enum Somfyv1Type: String {
  case shade = "SHADE"
  case blind = "BLIND"
}

/** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
public enum Somfyv1Reversed: String {
  case normal = "NORMAL"
  case reversed = "REVERSED"
}

/** The current state (position) of the Blinds or Shade reported by the bridge. */
public enum Somfyv1Currentstate: String {
  case open = "OPEN"
  case closed = "CLOSED"
}

// MARK: Requests

/** Move the Blinds or Shade to a pre-programmed OPEN position. */
public class Somfyv1GoToOpenRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.somfyv1GoToOpen
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
    return Somfyv1GoToOpenResponse(message)
  }

  
}

public class Somfyv1GoToOpenResponse: SessionEvent {
  
}

/** Move the Blinds or Shade to a pre-programmed CLOSED position. */
public class Somfyv1GoToClosedRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.somfyv1GoToClosed
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
    return Somfyv1GoToClosedResponse(message)
  }

  
}

public class Somfyv1GoToClosedResponse: SessionEvent {
  
}

/** Move the Blinds or Shade to a pre-programmed FAVORITE position. */
public class Somfyv1GoToFavoriteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.somfyv1GoToFavorite
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
    return Somfyv1GoToFavoriteResponse(message)
  }

  
}

public class Somfyv1GoToFavoriteResponse: SessionEvent {
  
}

