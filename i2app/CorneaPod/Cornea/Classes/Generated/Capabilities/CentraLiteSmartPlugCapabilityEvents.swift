
//
// CentraLiteSmartPlugCapEvents.swift
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
  /** Causes the Z-Wave side of the device to enter into learn mode for the specified duration. */
  static let centraLiteSmartPlugSetLearnMode: String = "centralitesmartplug:SetLearnMode"
  /** Causes the Z-Wave side of the device to send a NIF frame. */
  static let centraLiteSmartPlugSendNif: String = "centralitesmartplug:SendNif"
  /** Causes the Z-Wave side of the device to reset. */
  static let centraLiteSmartPlugReset: String = "centralitesmartplug:Reset"
  /** Attempt to pair the Z-Wave side of the device. */
  static let centraLiteSmartPlugPair: String = "centralitesmartplug:Pair"
  /** Attempt to determine the Z-Wave side node and home id. */
  static let centraLiteSmartPlugQuery: String = "centralitesmartplug:Query"
  
}

// MARK: Enumerations

// MARK: Requests

/** Causes the Z-Wave side of the device to enter into learn mode for the specified duration. */
public class CentraLiteSmartPlugSetLearnModeRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.centraLiteSmartPlugSetLearnMode
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
    return CentraLiteSmartPlugSetLearnModeResponse(message)
  }

  
}

public class CentraLiteSmartPlugSetLearnModeResponse: SessionEvent {
  
}

/** Causes the Z-Wave side of the device to send a NIF frame. */
public class CentraLiteSmartPlugSendNifRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.centraLiteSmartPlugSendNif
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
    return CentraLiteSmartPlugSendNifResponse(message)
  }

  
}

public class CentraLiteSmartPlugSendNifResponse: SessionEvent {
  
}

/** Causes the Z-Wave side of the device to reset. */
public class CentraLiteSmartPlugResetRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.centraLiteSmartPlugReset
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
    return CentraLiteSmartPlugResetResponse(message)
  }

  
}

public class CentraLiteSmartPlugResetResponse: SessionEvent {
  
}

/** Attempt to pair the Z-Wave side of the device. */
public class CentraLiteSmartPlugPairRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.centraLiteSmartPlugPair
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
    return CentraLiteSmartPlugPairResponse(message)
  }

  
}

public class CentraLiteSmartPlugPairResponse: SessionEvent {
  
}

/** Attempt to determine the Z-Wave side node and home id. */
public class CentraLiteSmartPlugQueryRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.centraLiteSmartPlugQuery
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
    return CentraLiteSmartPlugQueryResponse(message)
  }

  
}

public class CentraLiteSmartPlugQueryResponse: SessionEvent {
  
}

