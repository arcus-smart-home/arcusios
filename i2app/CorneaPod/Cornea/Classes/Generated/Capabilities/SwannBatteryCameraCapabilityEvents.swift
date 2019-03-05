
//
// SwannBatteryCameraCapEvents.swift
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
  /** Wakes up the battery camera if it is asleep and tell it to stay awake for the given number of seconds.  If the camera is already awake, this will tell the camera to stay awake for the given number of seconds */
  static let swannBatteryCameraKeepAwake: String = "swannbatterycamera:KeepAwake"
  
}

// MARK: Enumerations

/** Current resolution of the camera. Must appear in resolutionssupported list. */
public enum SwannBatteryCameraMode: String {
  case wlan_configure = "WLAN_CONFIGURE"
  case wlan_reconnect = "WLAN_RECONNECT"
  case notify = "NOTIFY"
  case softap = "SOFTAP"
  case recording = "RECORDING"
  case streaming = "STREAMING"
  case upgrade = "UPGRADE"
  case reset = "RESET"
  case unconfig = "UNCONFIG"
  case asleep = "ASLEEP"
  case unknown = "UNKNOWN"
}

/** How long to sleep between motion detection. */
public enum SwannBatteryCameraMotionDetectSleep: String {
  case min = "Min"
  case _30s = "30s"
  case _1m = "1m"
  case _3m = "3m"
  case _5m = "5m"
}

// MARK: Requests

/** Wakes up the battery camera if it is asleep and tell it to stay awake for the given number of seconds.  If the camera is already awake, this will tell the camera to stay awake for the given number of seconds */
public class SwannBatteryCameraKeepAwakeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SwannBatteryCameraKeepAwakeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.swannBatteryCameraKeepAwake
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
    return SwannBatteryCameraKeepAwakeResponse(message)
  }

  // MARK: KeepAwakeRequest Attributes
  struct Attributes {
    /** The number of seconds to keep the camera awake */
    static let seconds: String = "seconds"
 }
  
  /** The number of seconds to keep the camera awake */
  public func setSeconds(_ seconds: Int) {
    attributes[Attributes.seconds] = seconds as AnyObject
  }

  
}

public class SwannBatteryCameraKeepAwakeResponse: SessionEvent {
  
}

