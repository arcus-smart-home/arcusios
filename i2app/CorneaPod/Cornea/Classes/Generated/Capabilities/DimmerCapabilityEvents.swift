
//
// DimmerCapEvents.swift
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
  /** Sets a rampingtarget and a rampingtime for the dimmer. Brightness must be 0..100, seconds must be a positive integer. */
  static let dimmerRampBrightness: String = "dim:RampBrightness"
  /** Increments the brightness of the dimmer by a given amount. */
  static let dimmerIncrementBrightness: String = "dim:IncrementBrightness"
  /** Decrements the brightness of the dimmer by a given amount. */
  static let dimmerDecrementBrightness: String = "dim:DecrementBrightness"
  
}

// MARK: Enumerations

// MARK: Requests

/** Sets a rampingtarget and a rampingtime for the dimmer. Brightness must be 0..100, seconds must be a positive integer. */
public class DimmerRampBrightnessRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DimmerRampBrightnessRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.dimmerRampBrightness
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
    return DimmerRampBrightnessResponse(message)
  }

  // MARK: RampBrightnessRequest Attributes
  struct Attributes {
    /** Brightness percentage within the range of 0..100 */
    static let brightness: String = "brightness"
/** Number of seconds to reach desired brightness; must be a positive integer */
    static let seconds: String = "seconds"
 }
  
  /** Brightness percentage within the range of 0..100 */
  public func setBrightness(_ brightness: Int) {
    attributes[Attributes.brightness] = brightness as AnyObject
  }

  
  /** Number of seconds to reach desired brightness; must be a positive integer */
  public func setSeconds(_ seconds: Int) {
    attributes[Attributes.seconds] = seconds as AnyObject
  }

  
}

public class DimmerRampBrightnessResponse: SessionEvent {
  
}

/** Increments the brightness of the dimmer by a given amount. */
public class DimmerIncrementBrightnessRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DimmerIncrementBrightnessRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.dimmerIncrementBrightness
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
    return DimmerIncrementBrightnessResponse(message)
  }

  // MARK: IncrementBrightnessRequest Attributes
  struct Attributes {
    /** The amount to increase the brightness as a percentage from 0 to 100 */
    static let amount: String = "amount"
 }
  
  /** The amount to increase the brightness as a percentage from 0 to 100 */
  public func setAmount(_ amount: Int) {
    attributes[Attributes.amount] = amount as AnyObject
  }

  
}

public class DimmerIncrementBrightnessResponse: SessionEvent {
  
}

/** Decrements the brightness of the dimmer by a given amount. */
public class DimmerDecrementBrightnessRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DimmerDecrementBrightnessRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.dimmerDecrementBrightness
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
    return DimmerDecrementBrightnessResponse(message)
  }

  // MARK: DecrementBrightnessRequest Attributes
  struct Attributes {
    /** The amount to decrease the brightness as a percentage from 0 to 100 */
    static let amount: String = "amount"
 }
  
  /** The amount to decrease the brightness as a percentage from 0 to 100 */
  public func setAmount(_ amount: Int) {
    attributes[Attributes.amount] = amount as AnyObject
  }

  
}

public class DimmerDecrementBrightnessResponse: SessionEvent {
  
}

