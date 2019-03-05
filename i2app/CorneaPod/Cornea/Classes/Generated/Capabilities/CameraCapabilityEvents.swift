
//
// CameraCapEvents.swift
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
  /** Informs the camera to start streaming to some destination */
  static let cameraStartStreaming: String = "camera:StartStreaming"
  
}

// MARK: Enumerations

/** Constant bit rate or variable bit rate */
public enum CameraBitratetype: String {
  case cbr = "cbr"
  case vbr = "vbr"
}

/** Reflects the mode of IR LED on the camera. */
public enum CameraIrLedMode: String {
  case on = "ON"
  case off = "OFF"
  case auto = "AUTO"
}

// MARK: Requests

/** Informs the camera to start streaming to some destination */
public class CameraStartStreamingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CameraStartStreamingRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.cameraStartStreaming
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
    return CameraStartStreamingResponse(message)
  }

  // MARK: StartStreamingRequest Attributes
  struct Attributes {
    /** The url to stream to */
    static let url: String = "url"
/** The username to authenticate with */
    static let username: String = "username"
/** The password to authenticate with */
    static let password: String = "password"
/** The maximum time in seconds to stream */
    static let maxDuration: String = "maxDuration"
/** True if a live stream is being started, false otherwise.  This is for drivers where the streaming method is different from the live streaming method.  Drivers that treat these the same may ignore this attributes.  If not provided assume false. */
    static let stream: String = "stream"
 }
  
  /** The url to stream to */
  public func setUrl(_ url: String) {
    attributes[Attributes.url] = url as AnyObject
  }

  
  /** The username to authenticate with */
  public func setUsername(_ username: String) {
    attributes[Attributes.username] = username as AnyObject
  }

  
  /** The password to authenticate with */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
  /** The maximum time in seconds to stream */
  public func setMaxDuration(_ maxDuration: Int) {
    attributes[Attributes.maxDuration] = maxDuration as AnyObject
  }

  
  /** True if a live stream is being started, false otherwise.  This is for drivers where the streaming method is different from the live streaming method.  Drivers that treat these the same may ignore this attributes.  If not provided assume false. */
  public func setStream(_ stream: Bool) {
    attributes[Attributes.stream] = stream as AnyObject
  }

  
}

public class CameraStartStreamingResponse: SessionEvent {
  
}

