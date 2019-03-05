
//
// DeviceConnectionCapEvents.swift
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
  /** Sent when a device exists on the platform but is not reported by the hub. */
  static let deviceConnectionLostDevice: String = "devconn:LostDevice"
  
}

// MARK: Enumerations

/** Reflects the state of the connection to this device. If the device has intermediate connectivity states at the protocol level, it must be marked as offline until it can be fully controlled by the platform */
public enum DeviceConnectionState: String {
  case online = "ONLINE"
  case offline = "OFFLINE"
}

/** Reflects the status of the connection to this device. */
public enum DeviceConnectionStatus: String {
  case online = "ONLINE"
  case flapping = "FLAPPING"
  case lost = "LOST"
}

// MARK: Requests

/** Sent when a device exists on the platform but is not reported by the hub. */
public class DeviceConnectionLostDeviceRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.deviceConnectionLostDevice
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
    return DeviceConnectionLostDeviceResponse(message)
  }

  
}

public class DeviceConnectionLostDeviceResponse: SessionEvent {
  
}

