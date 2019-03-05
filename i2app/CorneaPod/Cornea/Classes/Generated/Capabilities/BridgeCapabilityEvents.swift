
//
// BridgeCapEvents.swift
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
  /** Puts bridge into pairing mode for timeout seconds.  Any devices seen while not in pairing mode will be immediately paired as well as any new devices discovered within the timeout period */
  static let bridgeStartPairing: String = "bridge:StartPairing"
  /** Removes the bridge from pairing mode. */
  static let bridgeStopPairing: String = "bridge:StopPairing"
  
}

// MARK: Enumerations

/** The current pairing state of the bridge device.  PAIRING indicates that any new devices seen will be paired, UNPAIRING that devices are being removed and IDLE means neither */
public enum BridgePairingState: String {
  case pairing = "PAIRING"
  case unpairing = "UNPAIRING"
  case idle = "IDLE"
}

// MARK: Requests

/** Puts bridge into pairing mode for timeout seconds.  Any devices seen while not in pairing mode will be immediately paired as well as any new devices discovered within the timeout period */
public class BridgeStartPairingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: BridgeStartPairingRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.bridgeStartPairing
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
    return BridgeStartPairingResponse(message)
  }

  // MARK: StartPairingRequest Attributes
  struct Attributes {
    /** Amount of time that the bridge device will stay in pairing mode in milliseconds. */
    static let timeout: String = "timeout"
 }
  
  /** Amount of time that the bridge device will stay in pairing mode in milliseconds. */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
}

public class BridgeStartPairingResponse: SessionEvent {
  
}

/** Removes the bridge from pairing mode. */
public class BridgeStopPairingRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.bridgeStopPairing
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
    return BridgeStopPairingResponse(message)
  }

  
}

public class BridgeStopPairingResponse: SessionEvent {
  
}

