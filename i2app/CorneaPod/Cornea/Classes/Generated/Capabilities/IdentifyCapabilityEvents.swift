
//
// IdentifyCapEvents.swift
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
  /** Causes this device to identify itself by blinking an LED or playing a sound.  This method should not return a response to a request until the device has started its notification.  It is expected notification will last for a short period of time, and this call will be repeated often.  A second call to Identify while the device is already actively identifying itself should be a no-op and return immediately. */
  static let identifyIdentify: String = "ident:Identify"
  
}


// MARK: Requests

/** Causes this device to identify itself by blinking an LED or playing a sound.  This method should not return a response to a request until the device has started its notification.  It is expected notification will last for a short period of time, and this call will be repeated often.  A second call to Identify while the device is already actively identifying itself should be a no-op and return immediately. */
public class IdentifyIdentifyRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.identifyIdentify
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
    return IdentifyIdentifyResponse(message)
  }

  
}

public class IdentifyIdentifyResponse: SessionEvent {
  
}

