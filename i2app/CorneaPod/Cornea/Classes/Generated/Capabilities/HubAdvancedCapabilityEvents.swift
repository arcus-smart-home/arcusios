
//
// HubAdvancedCapEvents.swift
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
  /** Restarts the Arcus Agent */
  static let hubAdvancedRestart: String = "hubadv:Restart"
  /** Reboots the hub */
  static let hubAdvancedReboot: String = "hubadv:Reboot"
  /** Requests that the hub update its firmware */
  static let hubAdvancedFirmwareUpdate: String = "hubadv:FirmwareUpdate"
  /** Request to tell the hub to factory reset.  This should remove all personal data from the hub */
  static let hubAdvancedFactoryReset: String = "hubadv:FactoryReset"
  /** Get a list of known device protocol addresses. */
  static let hubAdvancedGetKnownDevices: String = "hubadv:GetKnownDevices"
  /** Get a list of known device protocol addresses. */
  static let hubAdvancedGetDeviceInfo: String = "hubadv:GetDeviceInfo"
  
}
// MARK: Events
public struct HubAdvancedEvents {
  /** Sent when a hub comes online.  This may be very specific to the given protocol and require client interpretation. */
  public static let hubAdvancedFirmwareUpgradeProcess: String = "hubadv:FirmwareUpgradeProcess"
  /** Event sent from the platform to the hub informing it that it needs to deregister (boot all devices and factory reset) */
  public static let hubAdvancedDeregister: String = "hubadv:Deregister"
  /** Event sent from the platform to the hub informing it that it should start uploading camera preview snapshots up to the server. If the hub is already publishing snapshots, it should increment some counter for the number of requests it has received but not start new uploads so when StopCameraPreviews is issued it will know when it is safe to stop uploading. */
  public static let hubAdvancedStartUploadingCameraPreviews: String = "hubadv:StartUploadingCameraPreviews"
  /** Event sent from the platform to the hub informing it to stop uploading camera previews.  This should decrement the counter of the PublishCameraPreviews (to account for multiple user sessions) and when it is zero should stop uploading. */
  public static let hubAdvancedStopUploadingCameraPreviews: String = "hubadv:StopUploadingCameraPreviews"
  /** Event sent when an unpaired or unvetted device is removed from the hub. */
  public static let hubAdvancedUnpairedDeviceRemoved: String = "hubadv:UnpairedDeviceRemoved"
  /** An event indicating that a hub needs attention */
  public static let hubAdvancedAttention: String = "hubadv:Attention"
  }

// MARK: Enumerations

/** The reason for the last hub restart. */
public enum HubAdvancedLastRestartReason: String {
  case unknown = "UNKNOWN"
  case firmware_update = "FIRMWARE_UPDATE"
  case requested = "REQUESTED"
  case soft_reset = "SOFT_RESET"
  case factory_reset = "FACTORY_RESET"
  case gateway_failure = "GATEWAY_FAILURE"
  case migration = "MIGRATION"
  case backup_restore = "BACKUP_RESTORE"
  case watchdog = "WATCHDOG"
}

// MARK: Requests

/** Restarts the Arcus Agent */
public class HubAdvancedRestartRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubAdvancedRestart
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
    return HubAdvancedRestartResponse(message)
  }

  
}

public class HubAdvancedRestartResponse: SessionEvent {
  
}

/** Reboots the hub */
public class HubAdvancedRebootRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubAdvancedReboot
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
    return HubAdvancedRebootResponse(message)
  }

  
}

public class HubAdvancedRebootResponse: SessionEvent {
  
}

/** Requests that the hub update its firmware */
public class HubAdvancedFirmwareUpdateRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAdvancedFirmwareUpdateRequest Enumerations
  /** The urgency of the upgrade.  NORMAL is whenever next cycles permit.  URGENT means now.  BELOW_MINIMUM is indicates that the current firmware is below platform min and to upgrade immediately. */
  public enum HubAdvancedPriority: String {
   case normal = "NORMAL"
   case urgent = "URGENT"
   case below_minimum = "BELOW_MINIMUM"
   
  }/** The type of firmware being updated. */
  public enum HubAdvancedType: String {
   case firmware = "FIRMWARE"
   case agent = "AGENT"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubAdvancedFirmwareUpdate
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
    return HubAdvancedFirmwareUpdateResponse(message)
  }

  // MARK: FirmwareUpdateRequest Attributes
  struct Attributes {
    /** The URL of the firmware */
    static let url: String = "url"
/** The urgency of the upgrade.  NORMAL is whenever next cycles permit.  URGENT means now.  BELOW_MINIMUM is indicates that the current firmware is below platform min and to upgrade immediately. */
    static let priority: String = "priority"
/** The type of firmware being updated. */
    static let type: String = "type"
/** Whether to show the LED for firmware update or not. */
    static let showLed: String = "showLed"
 }
  
  /** The URL of the firmware */
  public func setUrl(_ url: String) {
    attributes[Attributes.url] = url as AnyObject
  }

  
  /** The urgency of the upgrade.  NORMAL is whenever next cycles permit.  URGENT means now.  BELOW_MINIMUM is indicates that the current firmware is below platform min and to upgrade immediately. */
  public func setPriority(_ priority: String) {
    if let value: HubAdvancedPriority = HubAdvancedPriority(rawValue: priority) {
      attributes[Attributes.priority] = value.rawValue as AnyObject
    }
  }
  
  /** The type of firmware being updated. */
  public func setType(_ type: String) {
    if let value: HubAdvancedType = HubAdvancedType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
  /** Whether to show the LED for firmware update or not. */
  public func setShowLed(_ showLed: Bool) {
    attributes[Attributes.showLed] = showLed as AnyObject
  }

  
}

public class HubAdvancedFirmwareUpdateResponse: SessionEvent {
  
  
  /** A status indicating status of the firmware update */
  public enum HubAdvancedStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the firmware update */
  public func getStatus() -> HubAdvancedStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAdvancedStatus = HubAdvancedStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Request to tell the hub to factory reset.  This should remove all personal data from the hub */
public class HubAdvancedFactoryResetRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubAdvancedFactoryReset
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
    return HubAdvancedFactoryResetResponse(message)
  }

  
}

public class HubAdvancedFactoryResetResponse: SessionEvent {
  
}

/** Get a list of known device protocol addresses. */
public class HubAdvancedGetKnownDevicesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAdvancedGetKnownDevicesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAdvancedGetKnownDevices
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
    return HubAdvancedGetKnownDevicesResponse(message)
  }

  // MARK: GetKnownDevicesRequest Attributes
  struct Attributes {
    /** The set of protocols that should be returned */
    static let protocols: String = "protocols"
 }
  
  /** The set of protocols that should be returned */
  public func setProtocols(_ protocols: [String]) {
    attributes[Attributes.protocols] = protocols as AnyObject
  }

  
}

public class HubAdvancedGetKnownDevicesResponse: SessionEvent {
  
  
  /** The list of protocol addresses known to the hub. */
  public func getDevices() -> [String]? {
    return self.attributes["devices"] as? [String]
  }
}

/** Get a list of known device protocol addresses. */
public class HubAdvancedGetDeviceInfoRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAdvancedGetDeviceInfoRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAdvancedGetDeviceInfo
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
    return HubAdvancedGetDeviceInfoResponse(message)
  }

  // MARK: GetDeviceInfoRequest Attributes
  struct Attributes {
    /** The protocol address of the device to get the device information from. */
    static let protocolAddress: String = "protocolAddress"
 }
  
  /** The protocol address of the device to get the device information from. */
  public func setProtocolAddress(_ protocolAddress: String) {
    attributes[Attributes.protocolAddress] = protocolAddress as AnyObject
  }

  
}

public class HubAdvancedGetDeviceInfoResponse: SessionEvent {
  
  
  /** Alway true. */
  public func getStatus() -> Bool? {
    return self.attributes["status"] as? Bool
  }
}

