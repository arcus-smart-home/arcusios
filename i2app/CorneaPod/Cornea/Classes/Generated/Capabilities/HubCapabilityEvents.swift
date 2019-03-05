
//
// HubCapEvents.swift
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
  /** Lists all devices associated with this account */
  static let hubPairingRequest: String = "hub:PairingRequest"
  /** Lists all devices associated with this account */
  static let hubUnpairingRequest: String = "hub:UnpairingRequest"
  /** Lists all hubs associated with this account */
  static let hubListHubs: String = "hub:ListHubs"
  /** Resets all log levels to their normal values. */
  static let hubResetLogLevels: String = "hub:ResetLogLevels"
  /** Sets the log level of for the specified scope, or the root log level if no scope is specified. */
  static let hubSetLogLevel: String = "hub:SetLogLevel"
  /** Gets recent logs from the hub. */
  static let hubGetLogs: String = "hub:GetLogs"
  /** Starts streaming logs to the platform for the specified amount of time. */
  static let hubStreamLogs: String = "hub:StreamLogs"
  /** Gets all key/value pairs describing the hub&#x27;s configuration. */
  static let hubGetConfig: String = "hub:GetConfig"
  /** Gets all key/value pairs describing the hub&#x27;s configuration. */
  static let hubSetConfig: String = "hub:SetConfig"
  /** Remove/Deactivate the hub. */
  static let hubDelete: String = "hub:Delete"
  
}
// MARK: Events
public struct HubEvents {
  /** Sent when a hub comes online.  This may be very specific to the given protocol and require client interpretation. */
  public static let hubHubConnected: String = "hub:HubConnected"
  /** Sent when a hub goes offline.  This may be very specific to the given protocol and require client interpretation. */
  public static let hubHubDisconnected: String = "hub:HubDisconnected"
  /** Indicates that a device has been found during the pairing process. */
  public static let hubDeviceFound: String = "hub:DeviceFound"
  }

// MARK: Enumerations

/** State of the hub */
public enum HubState: String {
  case normal = "NORMAL"
  case pairing = "PAIRING"
  case unpairing = "UNPAIRING"
  case down = "DOWN"
}

/** The registration state of the hub */
public enum HubRegistrationState: String {
  case registered = "REGISTERED"
  case unregistered = "UNREGISTERED"
  case orphaned = "ORPHANED"
}

// MARK: Requests

/** Lists all devices associated with this account */
public class HubPairingRequestRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubPairingRequestRequest Enumerations
  /** Whether pairing should start or stop */
  public enum HubActionType: String {
   case start_pairing = "START_PAIRING"
   case stop_pairing = "STOP_PAIRING"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubPairingRequest
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
    return HubPairingRequestResponse(message)
  }

  // MARK: PairingRequestRequest Attributes
  struct Attributes {
    /** Whether pairing should start or stop */
    static let actionType: String = "actionType"
/** The amount of time in milliseconds for which the place will be able to add devices */
    static let timeout: String = "timeout"
 }
  
  /** Whether pairing should start or stop */
  public func setActionType(_ actionType: String) {
    if let value: HubActionType = HubActionType(rawValue: actionType) {
      attributes[Attributes.actionType] = value.rawValue as AnyObject
    }
  }
  
  /** The amount of time in milliseconds for which the place will be able to add devices */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
}

public class HubPairingRequestResponse: SessionEvent {
  
}

/** Lists all devices associated with this account */
public class HubUnpairingRequestRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubUnpairingRequestRequest Enumerations
  /** Whether pairing should start or stop */
  public enum HubActionType: String {
   case start_unpairing = "START_UNPAIRING"
   case stop_unpairing = "STOP_UNPAIRING"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubUnpairingRequest
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
    return HubUnpairingRequestResponse(message)
  }

  // MARK: UnpairingRequestRequest Attributes
  struct Attributes {
    /** Whether pairing should start or stop */
    static let actionType: String = "actionType"
/** The amount of time in milliseconds for which the place will be able to add devices. */
    static let timeout: String = "timeout"
/** The namespace of the protocol of the device expected to be removed. By default no device is expected to be removed. */
    static let hubProtocol: String = "protocol"
/** The protocolId of the device expected to be removed. By default no device is expected to be removed. */
    static let protocolId: String = "protocolId"
/** True if the expected device is to be forcefully unpaired. Defaults to false. */
    static let force: String = "force"
 }
  
  /** Whether pairing should start or stop */
  public func setActionType(_ actionType: String) {
    if let value: HubActionType = HubActionType(rawValue: actionType) {
      attributes[Attributes.actionType] = value.rawValue as AnyObject
    }
  }
  
  /** The amount of time in milliseconds for which the place will be able to add devices. */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
  /** The namespace of the protocol of the device expected to be removed. By default no device is expected to be removed. */
  public func setProtocol(_ hubProtocol: String) {
    attributes[Attributes.hubProtocol] = hubProtocol as AnyObject
  }

  
  /** The protocolId of the device expected to be removed. By default no device is expected to be removed. */
  public func setProtocolId(_ protocolId: String) {
    attributes[Attributes.protocolId] = protocolId as AnyObject
  }

  
  /** True if the expected device is to be forcefully unpaired. Defaults to false. */
  public func setForce(_ force: Bool) {
    attributes[Attributes.force] = force as AnyObject
  }

  
}

public class HubUnpairingRequestResponse: SessionEvent {
  
}

/** Lists all hubs associated with this account */
public class HubListHubsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubListHubs
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
    return HubListHubsResponse(message)
  }

  
}

public class HubListHubsResponse: SessionEvent {
  
  
  /** The list of hubs associated with this account */
  public func getHubs() -> [Any]? {
    return self.attributes["hubs"] as? [Any]
  }
}

/** Resets all log levels to their normal values. */
public class HubResetLogLevelsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubResetLogLevels
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
    return HubResetLogLevelsResponse(message)
  }

  
}

public class HubResetLogLevelsResponse: SessionEvent {
  
}

/** Sets the log level of for the specified scope, or the root log level if no scope is specified. */
public class HubSetLogLevelRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSetLogLevelRequest Enumerations
  /** The log level to set the scope to use */
  public enum HubLevel: String {
   case trace = "TRACE"
   case debug = "DEBUG"
   case info = "INFO"
   case warn = "WARN"
   case error = "ERROR"
   
  }/** The logging scope affected by the log level, ROOT if none is specified. */
  public enum HubScope: String {
   case root = "ROOT"
   case agent = "AGENT"
   case zigbee = "ZIGBEE"
   case zwave = "ZWAVE"
   case ble = "BLE"
   case sercomm = "SERCOMM"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubSetLogLevel
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
    return HubSetLogLevelResponse(message)
  }

  // MARK: SetLogLevelRequest Attributes
  struct Attributes {
    /** The log level to set the scope to use */
    static let level: String = "level"
/** The logging scope affected by the log level, ROOT if none is specified. */
    static let scope: String = "scope"
 }
  
  /** The log level to set the scope to use */
  public func setLevel(_ level: String) {
    if let value: HubLevel = HubLevel(rawValue: level) {
      attributes[Attributes.level] = value.rawValue as AnyObject
    }
  }
  
  /** The logging scope affected by the log level, ROOT if none is specified. */
  public func setScope(_ scope: String) {
    if let value: HubScope = HubScope(rawValue: scope) {
      attributes[Attributes.scope] = value.rawValue as AnyObject
    }
  }
  
}

public class HubSetLogLevelResponse: SessionEvent {
  
}

/** Gets recent logs from the hub. */
public class HubGetLogsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubGetLogs
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
    return HubGetLogsResponse(message)
  }

  
}

public class HubGetLogsResponse: SessionEvent {
  
  
  /** Recent log statements from the hub, gzip compressed, and base 64 encoded. */
  public func getLogs() -> String? {
    return self.attributes["logs"] as? String
  }
}

/** Starts streaming logs to the platform for the specified amount of time. */
public class HubStreamLogsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubStreamLogsRequest Enumerations
  /** The log severity and higher that should be streamed. */
  public enum HubSeverity: String {
   case trace = "TRACE"
   case debug = "DEBUG"
   case info = "INFO"
   case warn = "WARN"
   case error = "ERROR"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubStreamLogs
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
    return HubStreamLogsResponse(message)
  }

  // MARK: StreamLogsRequest Attributes
  struct Attributes {
    /** The amount of time to stream logs in milliseconds. */
    static let duration: String = "duration"
/** The log severity and higher that should be streamed. */
    static let severity: String = "severity"
 }
  
  /** The amount of time to stream logs in milliseconds. */
  public func setDuration(_ duration: Int) {
    attributes[Attributes.duration] = duration as AnyObject
  }

  
  /** The log severity and higher that should be streamed. */
  public func setSeverity(_ severity: String) {
    if let value: HubSeverity = HubSeverity(rawValue: severity) {
      attributes[Attributes.severity] = value.rawValue as AnyObject
    }
  }
  
}

public class HubStreamLogsResponse: SessionEvent {
  
}

/** Gets all key/value pairs describing the hub&#x27;s configuration. */
public class HubGetConfigRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubGetConfigRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubGetConfig
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
    return HubGetConfigResponse(message)
  }

  // MARK: GetConfigRequest Attributes
  struct Attributes {
    /** A flag indicating if default values should be reported. */
    static let defaults: String = "defaults"
/** A regular expression used to select keys to include in the response. */
    static let matching: String = "matching"
 }
  
  /** A flag indicating if default values should be reported. */
  public func setDefaults(_ defaults: Bool) {
    attributes[Attributes.defaults] = defaults as AnyObject
  }

  
  /** A regular expression used to select keys to include in the response. */
  public func setMatching(_ matching: String) {
    attributes[Attributes.matching] = matching as AnyObject
  }

  
}

public class HubGetConfigResponse: SessionEvent {
  
  
  /** Key/value pairs for the hub configuration. */
  public func getConfig() -> [String: String]? {
    return self.attributes["config"] as? [String: String]
  }
}

/** Gets all key/value pairs describing the hub&#x27;s configuration. */
public class HubSetConfigRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSetConfigRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSetConfig
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
    return HubSetConfigResponse(message)
  }

  // MARK: SetConfigRequest Attributes
  struct Attributes {
    /** Key/value pairs to set in the hub configuration. */
    static let config: String = "config"
 }
  
  /** Key/value pairs to set in the hub configuration. */
  public func setConfig(_ config: [String: String]) {
    attributes[Attributes.config] = config as AnyObject
  }

  
}

public class HubSetConfigResponse: SessionEvent {
  
  
  /** Key/value that could not be set. */
  public func getFailed() -> [String: String]? {
    return self.attributes["failed"] as? [String: String]
  }
}

/** Remove/Deactivate the hub. */
public class HubDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubDelete
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
    return HubDeleteResponse(message)
  }

  
}

public class HubDeleteResponse: SessionEvent {
  
}

