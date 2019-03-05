
//
// CameraPTZCapEvents.swift
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
  /** Moves the camera to its home position */
  static let cameraPTZGotoHome: String = "cameraptz:GotoHome"
  /** Moves the camera to an absolute position */
  static let cameraPTZGotoAbsolute: String = "cameraptz:GotoAbsolute"
  /** Moves the camera to a relative position */
  static let cameraPTZGotoRelative: String = "cameraptz:GotoRelative"
  
}

// MARK: Enumerations

// MARK: Requests

/** Moves the camera to its home position */
public class CameraPTZGotoHomeRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.cameraPTZGotoHome
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
    return CameraPTZGotoHomeResponse(message)
  }

  
}

public class CameraPTZGotoHomeResponse: SessionEvent {
  
}

/** Moves the camera to an absolute position */
public class CameraPTZGotoAbsoluteRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CameraPTZGotoAbsoluteRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.cameraPTZGotoAbsolute
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
    return CameraPTZGotoAbsoluteResponse(message)
  }

  // MARK: GotoAbsoluteRequest Attributes
  struct Attributes {
    /** Absolute pan position */
    static let pan: String = "pan"
/** Absolute tilt position */
    static let tilt: String = "tilt"
/** Absolute zoom value */
    static let zoom: String = "zoom"
 }
  
  /** Absolute pan position */
  public func setPan(_ pan: Int) {
    attributes[Attributes.pan] = pan as AnyObject
  }

  
  /** Absolute tilt position */
  public func setTilt(_ tilt: Int) {
    attributes[Attributes.tilt] = tilt as AnyObject
  }

  
  /** Absolute zoom value */
  public func setZoom(_ zoom: Int) {
    attributes[Attributes.zoom] = zoom as AnyObject
  }

  
}

public class CameraPTZGotoAbsoluteResponse: SessionEvent {
  
}

/** Moves the camera to a relative position */
public class CameraPTZGotoRelativeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CameraPTZGotoRelativeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.cameraPTZGotoRelative
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
    return CameraPTZGotoRelativeResponse(message)
  }

  // MARK: GotoRelativeRequest Attributes
  struct Attributes {
    /** Relative pan position */
    static let deltaPan: String = "deltaPan"
/** Relative tilt position */
    static let deltaTilt: String = "deltaTilt"
/** Relative zoom value */
    static let deltaZoom: String = "deltaZoom"
 }
  
  /** Relative pan position */
  public func setDeltaPan(_ deltaPan: Int) {
    attributes[Attributes.deltaPan] = deltaPan as AnyObject
  }

  
  /** Relative tilt position */
  public func setDeltaTilt(_ deltaTilt: Int) {
    attributes[Attributes.deltaTilt] = deltaTilt as AnyObject
  }

  
  /** Relative zoom value */
  public func setDeltaZoom(_ deltaZoom: Int) {
    attributes[Attributes.deltaZoom] = deltaZoom as AnyObject
  }

  
}

public class CameraPTZGotoRelativeResponse: SessionEvent {
  
}

