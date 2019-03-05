
//
// HubZwaveCapEvents.swift
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
  /** Clears out the ZWave controller, effectively unpairing all devices.  Will also change the zwave chip&#x27;s home id. */
  static let hubZwaveFactoryReset: String = "hubzwave:FactoryReset"
  /** Perform a reset of the Z-Wave chip */
  static let hubZwaveReset: String = "hubzwave:Reset"
  /** Forces the Z-Wave chip into the primary controller role. */
  static let hubZwaveForcePrimary: String = "hubzwave:ForcePrimary"
  /** Forces the Z-Wave chip into the secondary controller role. */
  static let hubZwaveForceSecondary: String = "hubzwave:ForceSecondary"
  /** Get information about the current state of the network. */
  static let hubZwaveNetworkInformation: String = "hubzwave:NetworkInformation"
  /** Performs a network wide heal of the Z-Wave network. WARNING: This interferes with normal operation of the Z-Wave controller for the duration of the healing process. */
  static let hubZwaveHeal: String = "hubzwave:Heal"
  /** Cancels any Z-Wave network heal that might be in progress. */
  static let hubZwaveCancelHeal: String = "hubzwave:CancelHeal"
  /** Attempts to remove a zombie node from the Z-Wave chip&#x27;s node list. */
  static let hubZwaveRemoveZombie: String = "hubzwave:RemoveZombie"
  /** Attempts to associate with a node using the given groups. */
  static let hubZwaveAssociate: String = "hubzwave:Associate"
  /** Attempts to re-assign return routes to a node. */
  static let hubZwaveAssignReturnRoutes: String = "hubzwave:AssignReturnRoutes"
  
}
// MARK: Events
public struct HubZwaveEvents {
  /** Indicates that the requested Z-Wave network heal operation has completed. */
  public static let hubZwaveHealComplete: String = "hubzwave:HealComplete"
  }

// MARK: Enumerations

/** Current state of the network. */
public enum HubZwaveState: String {
  case hubZwaveInit = "INIT"
  case normal = "NORMAL"
  case pairing = "PAIRING"
  case unpairing = "UNPAIRING"
}

/** An indication of the reason the last Z-Wave network heal was finished. */
public enum HubZwaveHealFinishReason: String {
  case success = "SUCCESS"
  case cancel = "CANCEL"
  case terminated = "TERMINATED"
}

// MARK: Requests

/** Clears out the ZWave controller, effectively unpairing all devices.  Will also change the zwave chip&#x27;s home id. */
public class HubZwaveFactoryResetRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveFactoryReset
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
    return HubZwaveFactoryResetResponse(message)
  }

  
}

public class HubZwaveFactoryResetResponse: SessionEvent {
  
}

/** Perform a reset of the Z-Wave chip */
public class HubZwaveResetRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZwaveResetRequest Enumerations
  /** The type of reset to be performed */
  public enum HubZwaveType: String {
   case soft = "SOFT"
   case hard = "HARD"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubZwaveReset
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
    return HubZwaveResetResponse(message)
  }

  // MARK: ResetRequest Attributes
  struct Attributes {
    /** The type of reset to be performed */
    static let type: String = "type"
 }
  
  /** The type of reset to be performed */
  public func setType(_ type: String) {
    if let value: HubZwaveType = HubZwaveType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
}

public class HubZwaveResetResponse: SessionEvent {
  
  
  /** True if the reset was initiated, false otherwise. */
  public func getStatus() -> Bool? {
    return self.attributes["status"] as? Bool
  }
}

/** Forces the Z-Wave chip into the primary controller role. */
public class HubZwaveForcePrimaryRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveForcePrimary
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
    return HubZwaveForcePrimaryResponse(message)
  }

  
}

public class HubZwaveForcePrimaryResponse: SessionEvent {
  
}

/** Forces the Z-Wave chip into the secondary controller role. */
public class HubZwaveForceSecondaryRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveForceSecondary
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
    return HubZwaveForceSecondaryResponse(message)
  }

  
}

public class HubZwaveForceSecondaryResponse: SessionEvent {
  
}

/** Get information about the current state of the network. */
public class HubZwaveNetworkInformationRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveNetworkInformation
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
    return HubZwaveNetworkInformationResponse(message)
  }

  
}

public class HubZwaveNetworkInformationResponse: SessionEvent {
  
  
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
  /** A list of zombie node ids on the chip. */
  public func getZombies() -> Any? {
    return self.attributes["zombies"]
  }
  /** A gzipped and base64 encoded network graph */
  public func getGraph() -> String? {
    return self.attributes["graph"] as? String
  }
}

/** Performs a network wide heal of the Z-Wave network. WARNING: This interferes with normal operation of the Z-Wave controller for the duration of the healing process. */
public class HubZwaveHealRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZwaveHealRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveHeal
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
    return HubZwaveHealResponse(message)
  }

  // MARK: HealRequest Attributes
  struct Attributes {
    /** True if the network optimization process to block control of Z-Wave devices. */
    static let block: String = "block"
/** The time at which the network wide heal should be run (null or java epoch mean immediately) */
    static let time: String = "time"
 }
  
  /** True if the network optimization process to block control of Z-Wave devices. */
  public func setBlock(_ block: Bool) {
    attributes[Attributes.block] = block as AnyObject
  }

  
  /** The time at which the network wide heal should be run (null or java epoch mean immediately) */
  public func setTime(_ time: Date) {
    let time: Double = time.millisecondsSince1970
    attributes[Attributes.time] = time as AnyObject
  }

  
}

public class HubZwaveHealResponse: SessionEvent {
  
}

/** Cancels any Z-Wave network heal that might be in progress. */
public class HubZwaveCancelHealRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveCancelHeal
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
    return HubZwaveCancelHealResponse(message)
  }

  
}

public class HubZwaveCancelHealResponse: SessionEvent {
  
}

/** Attempts to remove a zombie node from the Z-Wave chip&#x27;s node list. */
public class HubZwaveRemoveZombieRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZwaveRemoveZombieRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveRemoveZombie
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
    return HubZwaveRemoveZombieResponse(message)
  }

  // MARK: RemoveZombieRequest Attributes
  struct Attributes {
    /** The node id of the node to remove. This node must be zombie. */
    static let node: String = "node"
 }
  
  /** The node id of the node to remove. This node must be zombie. */
  public func setNode(_ node: Int) {
    attributes[Attributes.node] = node as AnyObject
  }

  
}

public class HubZwaveRemoveZombieResponse: SessionEvent {
  
}

/** Attempts to associate with a node using the given groups. */
public class HubZwaveAssociateRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZwaveAssociateRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveAssociate
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
    return HubZwaveAssociateResponse(message)
  }

  // MARK: AssociateRequest Attributes
  struct Attributes {
    /** The node id of the node to associate with. */
    static let node: String = "node"
/** The set of groups to associate with. */
    static let groups: String = "groups"
 }
  
  /** The node id of the node to associate with. */
  public func setNode(_ node: Int) {
    attributes[Attributes.node] = node as AnyObject
  }

  
  /** The set of groups to associate with. */
  public func setGroups(_ groups: [Int]) {
    attributes[Attributes.groups] = groups as AnyObject
  }

  
}

public class HubZwaveAssociateResponse: SessionEvent {
  
}

/** Attempts to re-assign return routes to a node. */
public class HubZwaveAssignReturnRoutesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubZwaveAssignReturnRoutesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubZwaveAssignReturnRoutes
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
    return HubZwaveAssignReturnRoutesResponse(message)
  }

  // MARK: AssignReturnRoutesRequest Attributes
  struct Attributes {
    /** The node id of the node to associate with. */
    static let node: String = "node"
 }
  
  /** The node id of the node to associate with. */
  public func setNode(_ node: Int) {
    attributes[Attributes.node] = node as AnyObject
  }

  
}

public class HubZwaveAssignReturnRoutesResponse: SessionEvent {
  
}

