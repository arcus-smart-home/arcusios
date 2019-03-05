
//
// WiFiScanCapEvents.swift
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
  /** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
  static let wiFiScanStartWifiScan: String = "wifiscan:StartWifiScan"
  /** Ends any active WiFiScan. If no scan is active, this is a no-op. */
  static let wiFiScanEndWifiScan: String = "wifiscan:EndWifiScan"
  
}
// MARK: Events
public struct WiFiScanEvents {
  /** Drivers should return a complete list of all BSSIDs found during the lifetime of the scan, not just those BSSIDs which are newly observed at the time of event generation. */
  public static let wiFiScanWiFiScanResults: String = "wifiscan:WiFiScanResults"
  }


// MARK: Requests

/** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
public class WiFiScanStartWifiScanRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: WiFiScanStartWifiScanRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.wiFiScanStartWifiScan
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
    return WiFiScanStartWifiScanResponse(message)
  }

  // MARK: StartWifiScanRequest Attributes
  struct Attributes {
    /** The number of seconds to scan unless endWifiScan() is called. */
    static let timeout: String = "timeout"
 }
  
  /** The number of seconds to scan unless endWifiScan() is called. */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
}

public class WiFiScanStartWifiScanResponse: SessionEvent {
  
}

/** Ends any active WiFiScan. If no scan is active, this is a no-op. */
public class WiFiScanEndWifiScanRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.wiFiScanEndWifiScan
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
    return WiFiScanEndWifiScanResponse(message)
  }

  
}

public class WiFiScanEndWifiScanResponse: SessionEvent {
  
}

