
//
// HubWiFiCapEvents.swift
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
  /** Attempts to connect to the access point with the given properties. */
  static let hubWiFiWiFiConnect: String = "hubwifi:WiFiConnect"
  /** Disconnects from current access point. USE WITH CAUTION. */
  static let hubWiFiWiFiDisconnect: String = "hubwifi:WiFiDisconnect"
  /** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
  static let hubWiFiWiFiStartScan: String = "hubwifi:WiFiStartScan"
  /** Ends any active WiFiScan. If no scan is active, this is a no-op. */
  static let hubWiFiWiFiEndScan: String = "hubwifi:WiFiEndScan"
  
}
// MARK: Events
public struct HubWiFiEvents {
  /** Drivers s hould return a complete list of all BSSIDs found during the lifetime of the scan, not just those BSSIDs which are newly observed at the time of event generation. */
  public static let hubWiFiWiFiScanResults: String = "hubwifi:WiFiScanResults"
  }

// MARK: Enumerations

/** Indicates whether or not this device has a WiFi connection to an access point. */
public enum HubWiFiWifiState: String {
  case connected = "CONNECTED"
  case disconnected = "DISCONNECTED"
}

/** Security of connection. */
public enum HubWiFiWifiSecurity: String {
  case none = "NONE"
  case wep = "WEP"
  case wpa_psk = "WPA_PSK"
  case wpa2_psk = "WPA2_PSK"
  case wpa_enterprise = "WPA_ENTERPRISE"
  case wpa2_enterprise = "WPA2_ENTERPRISE"
}

// MARK: Requests

/** Attempts to connect to the access point with the given properties. */
public class HubWiFiWiFiConnectRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubWiFiWiFiConnectRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubWiFiWiFiConnect
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
    return HubWiFiWiFiConnectResponse(message)
  }

  // MARK: WiFiConnectRequest Attributes
  struct Attributes {
    /** SSID of base station connected to. */
    static let ssid: String = "ssid"
/** BSSID of base station connected to. */
    static let bssid: String = "bssid"
/** Security of connection. */
    static let security: String = "security"
/** Security key. */
    static let key: String = "key"
 }
  
  /** SSID of base station connected to. */
  public func setSsid(_ ssid: String) {
    attributes[Attributes.ssid] = ssid as AnyObject
  }

  
  /** BSSID of base station connected to. */
  public func setBssid(_ bssid: String) {
    attributes[Attributes.bssid] = bssid as AnyObject
  }

  
  /** Security of connection. */
  public func setSecurity(_ security: String) {
    attributes[Attributes.security] = security as AnyObject
  }

  
  /** Security key. */
  public func setKey(_ key: String) {
    attributes[Attributes.key] = key as AnyObject
  }

  
}

public class HubWiFiWiFiConnectResponse: SessionEvent {
  
  
  /** A status indicating status of the wireless connect */
  public enum HubWiFiStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the wireless connect */
  public func getStatus() -> HubWiFiStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubWiFiStatus = HubWiFiStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Disconnects from current access point. USE WITH CAUTION. */
public class HubWiFiWiFiDisconnectRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubWiFiWiFiDisconnect
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
    return HubWiFiWiFiDisconnectResponse(message)
  }

  
}

public class HubWiFiWiFiDisconnectResponse: SessionEvent {
  
  
  /** A status indicating status of the wireless connect */
  public enum HubWiFiStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the wireless connect */
  public func getStatus() -> HubWiFiStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubWiFiStatus = HubWiFiStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
public class HubWiFiWiFiStartScanRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubWiFiWiFiStartScanRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubWiFiWiFiStartScan
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
    return HubWiFiWiFiStartScanResponse(message)
  }

  // MARK: WiFiStartScanRequest Attributes
  struct Attributes {
    /** The number of seconds to scan unless endWifiScan() is called. */
    static let timeout: String = "timeout"
 }
  
  /** The number of seconds to scan unless endWifiScan() is called. */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
}

public class HubWiFiWiFiStartScanResponse: SessionEvent {
  
}

/** Ends any active WiFiScan. If no scan is active, this is a no-op. */
public class HubWiFiWiFiEndScanRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubWiFiWiFiEndScan
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
    return HubWiFiWiFiEndScanResponse(message)
  }

  
}

public class HubWiFiWiFiEndScanResponse: SessionEvent {
  
}

