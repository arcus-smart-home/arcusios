
//
// DeviceMockCapEvents.swift
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
  /** Sets the attributes on the mock device */
  static let deviceMockSetAttributes: String = "devmock:SetAttributes"
  /** Causes the device to connect */
  static let deviceMockConnect: String = "devmock:Connect"
  /** Causes the device to disconnect */
  static let deviceMockDisconnect: String = "devmock:Disconnect"
  
}


// MARK: Requests

/** Sets the attributes on the mock device */
public class DeviceMockSetAttributesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DeviceMockSetAttributesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.deviceMockSetAttributes
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
    return DeviceMockSetAttributesResponse(message)
  }

  // MARK: SetAttributesRequest Attributes
  struct Attributes {
    /** Attributes to set on the device */
    static let attrs: String = "attrs"
 }
  
  /** Attributes to set on the device */
  public func setAttrs(_ attrs: [String: Any]) {
    attributes[Attributes.attrs] = attrs as AnyObject
  }

  
}

public class DeviceMockSetAttributesResponse: SessionEvent {
  
}

/** Causes the device to connect */
public class DeviceMockConnectRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.deviceMockConnect
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
    return DeviceMockConnectResponse(message)
  }

  
}

public class DeviceMockConnectResponse: SessionEvent {
  
}

/** Causes the device to disconnect */
public class DeviceMockDisconnectRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.deviceMockDisconnect
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
    return DeviceMockDisconnectResponse(message)
  }

  
}

public class DeviceMockDisconnectResponse: SessionEvent {
  
}

