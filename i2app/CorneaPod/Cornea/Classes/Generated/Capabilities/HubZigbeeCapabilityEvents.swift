
//
// HubZigbeeCapEvents.swift
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
  /** Perform a reset of the Zigbee chip */
  static let hubZigbeeReset: String = "hubzigbee:Reset"
  /** Perform an environment scan using the Zigbee chip */
  static let hubZigbeeScan: String = "hubzigbee:Scan"
  /** Get the Zigbee chip configuration information */
  static let hubZigbeeGetConfig: String = "hubzigbee:GetConfig"
  /** Get the current low-level statistics tracked by the Zigbee chip */
  static let hubZigbeeGetStats: String = "hubzigbee:GetStats"
  /** Get the node descriptor of a node in the Zigbee network */
  static let hubZigbeeGetNodeDesc: String = "hubzigbee:GetNodeDesc"
  /** Get the active endpoints of a node in the Zigbee network */
  static let hubZigbeeGetActiveEp: String = "hubzigbee:GetActiveEp"
  /** Get the simple descriptor of a node in the Zigbee network */
  static let hubZigbeeGetSimpleDesc: String = "hubzigbee:GetSimpleDesc"
  /** Get the power descriptor of a node in the Zigbee network */
  static let hubZigbeeGetPowerDesc: String = "hubzigbee:GetPowerDesc"
  /** Identify a node in the Zigbee network */
  static let hubZigbeeIdentify: String = "hubzigbee:Identify"
  /** Remove a node from the Zigbee network */
  static let hubZigbeeRemove: String = "hubzigbee:Remove"
  /** Factory reset the Zigbee stack, removing all paired devices in the process. */
  static let hubZigbeeFactoryReset: String = "hubzigbee:FactoryReset"
  /** Restore the Zigbee network to an exact state. */
  static let hubZigbeeFormNetwork: String = "hubzigbee:FormNetwork"
  /** Run the migration fix proceedure */
  static let hubZigbeeFixMigration: String = "hubzigbee:FixMigration"
  /** Get information about the current state of the network. */
  static let hubZigbeeNetworkInformation: String = "hubzigbee:NetworkInformation"
  /** Pairs a device using a pre-shared link key. */
  static let hubZigbeePairingLinkKey: String = "hubzigbee:PairingLinkKey"
  /** Pairs a device using a pre-shared install code. */
  static let hubZigbeePairingInstallCode: String = "hubzigbee:PairingInstallCode"
  
}

// MARK: Enumerations

/** The power mode used by the Zigbee chip */
public enum HubZigbeePowermode: String {
  case hubZigbeeDefault = "DEFAULT"
  case boost = "BOOST"
  case alternate = "ALTERNATE"
  case boost_and_alternate = "BOOST_AND_ALTERNATE"
}

/** The Zigbee network state */
public enum HubZigbeeState: String {
  case up = "UP"
  case down = "DOWN"
  case join_failed = "JOIN_FAILED"
  case move_failed = "MOVE_FAILED"
}

// MARK: Requests

/** Perform a reset of the Zigbee chip */
public class HubZigbeeResetRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeResetRequest Enumerations
  /** The type of reset to be performed */
  public enum HubZigbeeType: String {
   case soft = "SOFT"
   case hard = "HARD"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubZigbeeReset
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
    return HubZigbeeResetResponse(message)
  }

  // MARK: ResetRequest Attributes
  struct Attributes {
    /** The type of reset to be performed */
    static let type: String = "type"
 }
  
  /** The type of reset to be performed */
  public func setType(_ type: String) {
    if let value: HubZigbeeType = HubZigbeeType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
}

public class HubZigbeeResetResponse: SessionEvent {
  
  
  /** True if the reset was initiated, false otherwise. */
  public func getStatus() -> Bool? {
    return self.attributes["status"] as? Bool
  }
}

/** Perform an environment scan using the Zigbee chip */
public class HubZigbeeScanRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeScan
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
    return HubZigbeeScanResponse(message)
  }

  
}

public class HubZigbeeScanResponse: SessionEvent {
  
  
  /** The configuration values in use by the Zigbee chip. */
  public func getScans() -> [[String: String]]? {
    return self.attributes["scans"] as? [[String: String]]
  }
}

/** Get the Zigbee chip configuration information */
public class HubZigbeeGetConfigRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeGetConfig
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
    return HubZigbeeGetConfigResponse(message)
  }

  
}

public class HubZigbeeGetConfigResponse: SessionEvent {
  
  
  /** The configuration values in use by the Zigbee chip. */
  public func getConfig() -> [String: String]? {
    return self.attributes["config"] as? [String: String]
  }
}

/** Get the current low-level statistics tracked by the Zigbee chip */
public class HubZigbeeGetStatsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeGetStats
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
    return HubZigbeeGetStatsResponse(message)
  }

  
}

public class HubZigbeeGetStatsResponse: SessionEvent {
  
  
  /** The current statistics as maintained by the Zigbee bridge. */
  public func getStats() -> [String: Int]? {
    return self.attributes["stats"] as? [String: Int]
  }
}

/** Get the node descriptor of a node in the Zigbee network */
public class HubZigbeeGetNodeDescRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeGetNodeDescRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeGetNodeDesc
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
    return HubZigbeeGetNodeDescResponse(message)
  }

  // MARK: GetNodeDescRequest Attributes
  struct Attributes {
    /** The network address of the node. */
    static let nwk: String = "nwk"
 }
  
  /** The network address of the node. */
  public func setNwk(_ nwk: Int) {
    attributes[Attributes.nwk] = nwk as AnyObject
  }

  
}

public class HubZigbeeGetNodeDescResponse: SessionEvent {
  
  
  /** The node descriptor of the node. */
  public func getDesc() -> [String: String]? {
    return self.attributes["desc"] as? [String: String]
  }
}

/** Get the active endpoints of a node in the Zigbee network */
public class HubZigbeeGetActiveEpRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeGetActiveEpRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeGetActiveEp
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
    return HubZigbeeGetActiveEpResponse(message)
  }

  // MARK: GetActiveEpRequest Attributes
  struct Attributes {
    /** The network address of the node. */
    static let nwk: String = "nwk"
 }
  
  /** The network address of the node. */
  public func setNwk(_ nwk: Int) {
    attributes[Attributes.nwk] = nwk as AnyObject
  }

  
}

public class HubZigbeeGetActiveEpResponse: SessionEvent {
  
  
  /** The set of active endpoints on the node. */
  public func getEndpoints() -> [Int]? {
    return self.attributes["endpoints"] as? [Int]
  }
}

/** Get the simple descriptor of a node in the Zigbee network */
public class HubZigbeeGetSimpleDescRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeGetSimpleDescRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeGetSimpleDesc
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
    return HubZigbeeGetSimpleDescResponse(message)
  }

  // MARK: GetSimpleDescRequest Attributes
  struct Attributes {
    /** The network address of the node. */
    static let nwk: String = "nwk"
/** The endpoint identifier on the node. */
    static let ep: String = "ep"
 }
  
  /** The network address of the node. */
  public func setNwk(_ nwk: Int) {
    attributes[Attributes.nwk] = nwk as AnyObject
  }

  
  /** The endpoint identifier on the node. */
  public func setEp(_ ep: Int) {
    attributes[Attributes.ep] = ep as AnyObject
  }

  
}

public class HubZigbeeGetSimpleDescResponse: SessionEvent {
  
  
  /** The simple descriptor of the node&#x27;s endpoint. */
  public func getDesc() -> [String: String]? {
    return self.attributes["desc"] as? [String: String]
  }
}

/** Get the power descriptor of a node in the Zigbee network */
public class HubZigbeeGetPowerDescRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeGetPowerDescRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeGetPowerDesc
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
    return HubZigbeeGetPowerDescResponse(message)
  }

  // MARK: GetPowerDescRequest Attributes
  struct Attributes {
    /** The network address of the node. */
    static let nwk: String = "nwk"
 }
  
  /** The network address of the node. */
  public func setNwk(_ nwk: Int) {
    attributes[Attributes.nwk] = nwk as AnyObject
  }

  
}

public class HubZigbeeGetPowerDescResponse: SessionEvent {
  
  
  /** The power description of the node. */
  public func getDesc() -> [String: String]? {
    return self.attributes["desc"] as? [String: String]
  }
}

/** Identify a node in the Zigbee network */
public class HubZigbeeIdentifyRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeIdentifyRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeIdentify
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
    return HubZigbeeIdentifyResponse(message)
  }

  // MARK: IdentifyRequest Attributes
  struct Attributes {
    /** The network address of the node to be identified. */
    static let eui64: String = "eui64"
/** The network address of the node to be identified. */
    static let duration: String = "duration"
 }
  
  /** The network address of the node to be identified. */
  public func setEui64(_ eui64: Int) {
    attributes[Attributes.eui64] = eui64 as AnyObject
  }

  
  /** The network address of the node to be identified. */
  public func setDuration(_ duration: Int) {
    attributes[Attributes.duration] = duration as AnyObject
  }

  
}

public class HubZigbeeIdentifyResponse: SessionEvent {
  
}

/** Remove a node from the Zigbee network */
public class HubZigbeeRemoveRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeRemoveRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeRemove
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
    return HubZigbeeRemoveResponse(message)
  }

  // MARK: RemoveRequest Attributes
  struct Attributes {
    /** The EUI64 of the node to be removed. */
    static let eui64: String = "eui64"
 }
  
  /** The EUI64 of the node to be removed. */
  public func setEui64(_ eui64: Int) {
    attributes[Attributes.eui64] = eui64 as AnyObject
  }

  
}

public class HubZigbeeRemoveResponse: SessionEvent {
  
}

/** Factory reset the Zigbee stack, removing all paired devices in the process. */
public class HubZigbeeFactoryResetRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeFactoryReset
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
    return HubZigbeeFactoryResetResponse(message)
  }

  
}

public class HubZigbeeFactoryResetResponse: SessionEvent {
  
  
  /** True if the reset was initiated, false otherwise. */
  public func getStatus() -> Bool? {
    return self.attributes["status"] as? Bool
  }
}

/** Restore the Zigbee network to an exact state. */
public class HubZigbeeFormNetworkRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeeFormNetworkRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeFormNetwork
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
    return HubZigbeeFormNetworkResponse(message)
  }

  // MARK: FormNetworkRequest Attributes
  struct Attributes {
    /** The eui64 to use for the restored hub */
    static let eui64: String = "eui64"
/** The panid to use for the restored hub */
    static let panId: String = "panId"
/** The extended panid to use for the restored hub */
    static let extPanId: String = "extPanId"
/** The channel to use for the restored hub */
    static let channel: String = "channel"
/** The base64 encoded network key to use for the restored hub */
    static let nwkkey: String = "nwkkey"
/** The network frame counter to use for the restored hub */
    static let nwkfc: String = "nwkfc"
/** The aps frame counter to use for the restored hub */
    static let apsfc: String = "apsfc"
/** The updateid to use for the restored hub */
    static let updateid: String = "updateid"
 }
  
  /** The eui64 to use for the restored hub */
  public func setEui64(_ eui64: Int) {
    attributes[Attributes.eui64] = eui64 as AnyObject
  }

  
  /** The panid to use for the restored hub */
  public func setPanId(_ panId: Int) {
    attributes[Attributes.panId] = panId as AnyObject
  }

  
  /** The extended panid to use for the restored hub */
  public func setExtPanId(_ extPanId: Int) {
    attributes[Attributes.extPanId] = extPanId as AnyObject
  }

  
  /** The channel to use for the restored hub */
  public func setChannel(_ channel: Int) {
    attributes[Attributes.channel] = channel as AnyObject
  }

  
  /** The base64 encoded network key to use for the restored hub */
  public func setNwkkey(_ nwkkey: String) {
    attributes[Attributes.nwkkey] = nwkkey as AnyObject
  }

  
  /** The network frame counter to use for the restored hub */
  public func setNwkfc(_ nwkfc: Int) {
    attributes[Attributes.nwkfc] = nwkfc as AnyObject
  }

  
  /** The aps frame counter to use for the restored hub */
  public func setApsfc(_ apsfc: Int) {
    attributes[Attributes.apsfc] = apsfc as AnyObject
  }

  
  /** The updateid to use for the restored hub */
  public func setUpdateid(_ updateid: Int) {
    attributes[Attributes.updateid] = updateid as AnyObject
  }

  
}

public class HubZigbeeFormNetworkResponse: SessionEvent {
  
  
  /** True if the reset was initiated, false otherwise. */
  public func getStatus() -> Bool? {
    return self.attributes["status"] as? Bool
  }
}

/** Run the migration fix proceedure */
public class HubZigbeeFixMigrationRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeFixMigration
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
    return HubZigbeeFixMigrationResponse(message)
  }

  
}

public class HubZigbeeFixMigrationResponse: SessionEvent {
  
  
  /** True if the restore was initiated, false otherwise. */
  public func getStatus() -> Bool? {
    return self.attributes["status"] as? Bool
  }
}

/** Get information about the current state of the network. */
public class HubZigbeeNetworkInformationRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeeNetworkInformation
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
    return HubZigbeeNetworkInformationResponse(message)
  }

  
}

public class HubZigbeeNetworkInformationResponse: SessionEvent {
  
  
  /** The current metrics per node. */
  public func getMetrics() -> Any? {
    return self.attributes["metrics"]
  }
  /** The current neighbors per node. */
  public func getNeighbors() -> Any? {
    return self.attributes["neighbors"]
  }
  /** The current routing table per node. */
  public func getRouting() -> Any? {
    return self.attributes["routing"]
  }
  /** The current route used by the controller per node. */
  public func getRoute() -> Any? {
    return self.attributes["route"]
  }
}

/** Pairs a device using a pre-shared link key. */
public class HubZigbeePairingLinkKeyRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeePairingLinkKeyRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeePairingLinkKey
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
    return HubZigbeePairingLinkKeyResponse(message)
  }

  // MARK: PairingLinkKeyRequest Attributes
  struct Attributes {
    /** ASCII Hex encoded EUID of the device to pair. */
    static let euid: String = "euid"
/** ASCII Hex encodeed preshared link key of the device to pair. */
    static let linkkey: String = "linkkey"
/** The amount of time in milliseconds for which the place will be able to add devices */
    static let timeout: String = "timeout"
 }
  
  /** ASCII Hex encoded EUID of the device to pair. */
  public func setEuid(_ euid: String) {
    attributes[Attributes.euid] = euid as AnyObject
  }

  
  /** ASCII Hex encodeed preshared link key of the device to pair. */
  public func setLinkkey(_ linkkey: String) {
    attributes[Attributes.linkkey] = linkkey as AnyObject
  }

  
  /** The amount of time in milliseconds for which the place will be able to add devices */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
}

public class HubZigbeePairingLinkKeyResponse: SessionEvent {
  
}

/** Pairs a device using a pre-shared install code. */
public class HubZigbeePairingInstallCodeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZigbeePairingInstallCodeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZigbeePairingInstallCode
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
    return HubZigbeePairingInstallCodeResponse(message)
  }

  // MARK: PairingInstallCodeRequest Attributes
  struct Attributes {
    /** ASCII Hex encoded EUID of the device to pair. */
    static let euid: String = "euid"
/** ASCII Hex encodeed install code of the device to pair. */
    static let installcode: String = "installcode"
/** The amount of time in milliseconds for which the place will be able to add devices */
    static let timeout: String = "timeout"
 }
  
  /** ASCII Hex encoded EUID of the device to pair. */
  public func setEuid(_ euid: String) {
    attributes[Attributes.euid] = euid as AnyObject
  }

  
  /** ASCII Hex encodeed install code of the device to pair. */
  public func setInstallcode(_ installcode: String) {
    attributes[Attributes.installcode] = installcode as AnyObject
  }

  
  /** The amount of time in milliseconds for which the place will be able to add devices */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
}

public class HubZigbeePairingInstallCodeResponse: SessionEvent {
  
}

