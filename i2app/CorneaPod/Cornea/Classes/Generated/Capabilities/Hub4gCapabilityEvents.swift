
//
// Hub4gCapEvents.swift
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
  /** Get 4G dongle information */
  static let hub4gGetInfo: String = "hub4g:GetInfo"
  /** Reset 4g connection statistics */
  static let hub4gResetStatistics: String = "hub4g:ResetStatistics"
  /** Get 4g connection statistics */
  static let hub4gGetStatistics: String = "hub4g:GetStatistics"
  
}

// MARK: Enumerations

/** Current state of 4g connection */
public enum Hub4gConnectionState: String {
  case connecting = "CONNECTING"
  case connected = "CONNECTED"
  case disconnecting = "DISCONNECTING"
  case disconnected = "DISCONNECTED"
}

// MARK: Requests

/** Get 4G dongle information */
public class Hub4gGetInfoRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hub4gGetInfo
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
    return Hub4gGetInfoResponse(message)
  }

  
}

public class Hub4gGetInfoResponse: SessionEvent {
  
  
  /** The 4G dongle information */
  public func getInfo() -> String? {
    return self.attributes["info"] as? String
  }
}

/** Reset 4g connection statistics */
public class Hub4gResetStatisticsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hub4gResetStatistics
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
    return Hub4gResetStatisticsResponse(message)
  }

  
}

public class Hub4gResetStatisticsResponse: SessionEvent {
  
}

/** Get 4g connection statistics */
public class Hub4gGetStatisticsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hub4gGetStatistics
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
    return Hub4gGetStatisticsResponse(message)
  }

  
}

public class Hub4gGetStatisticsResponse: SessionEvent {
  
  
  /** The sample */
  public func getSample() -> Any? {
    return self.attributes["sample"]
  }
}

