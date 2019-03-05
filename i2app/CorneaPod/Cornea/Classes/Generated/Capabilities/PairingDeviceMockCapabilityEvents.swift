
//
// PairingDeviceMockCapEvents.swift
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
  /** Updates the pairing phase, does not allow the mock to &#x27;go backwards&#x27; */
  static let pairingDeviceMockUpdatePairingPhase: String = "pairdevmock:UpdatePairingPhase"
  
}

// MARK: Errors
public struct PairingDeviceMockUpdatePairingPhaseError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If there is an attempt to revert to a &#x27;previous&#x27; phase. */
    case requestStateInvalid = "request.state.invalid"
    
  }
}
// MARK: Enumerations

// MARK: Requests

/** Updates the pairing phase, does not allow the mock to &#x27;go backwards&#x27; */
public class PairingDeviceMockUpdatePairingPhaseRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PairingDeviceMockUpdatePairingPhaseRequest Enumerations
  /** The phase to set the mock to, or empty / null to progress to the next logical phase for the given type of device. */
  public enum PairingDeviceMockPhase: String {
   case join = "JOIN"
   case connect = "CONNECT"
   case identify = "IDENTIFY"
   case prepare = "PREPARE"
   case configure = "CONFIGURE"
   case failed = "FAILED"
   case paired = "PAIRED"
   
  }
  override init() {
    super.init()
    self.command = Commands.pairingDeviceMockUpdatePairingPhase
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

      let error = PairingDeviceMockUpdatePairingPhaseError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingDeviceMockUpdatePairingPhaseResponse(message)
  }

  // MARK: UpdatePairingPhaseRequest Attributes
  struct Attributes {
    /** The phase to set the mock to, or empty / null to progress to the next logical phase for the given type of device. */
    static let phase: String = "phase"
 }
  
  /** The phase to set the mock to, or empty / null to progress to the next logical phase for the given type of device. */
  public func setPhase(_ phase: String) {
    if let value: PairingDeviceMockPhase = PairingDeviceMockPhase(rawValue: phase) {
      attributes[Attributes.phase] = value.rawValue as AnyObject
    }
  }
  
}

public class PairingDeviceMockUpdatePairingPhaseResponse: SessionEvent {
  
}

