
//
// HubSercommCapEvents.swift
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
  /** Get camera password for hub */
  static let hubSercommGetCameraPassword: String = "hubsercomm:getCameraPassword"
  /** Pair a camera to the hub */
  static let hubSercommPair: String = "hubsercomm:pair"
  /** Reset a camera back to factory defaults */
  static let hubSercommReset: String = "hubsercomm:reset"
  /** Reboot a camera */
  static let hubSercommReboot: String = "hubsercomm:reboot"
  /** Configure a camera */
  static let hubSercommConfig: String = "hubsercomm:config"
  /** Upgrade firmware on camera */
  static let hubSercommUpgrade: String = "hubsercomm:upgrade"
  /** Get current state of camera */
  static let hubSercommGetState: String = "hubsercomm:getState"
  /** Get current firmware version on camera */
  static let hubSercommGetVersion: String = "hubsercomm:getVersion"
  /** Get current day/night setting of camera */
  static let hubSercommGetDayNight: String = "hubsercomm:getDayNight"
  /** Get IPv4 address of camera */
  static let hubSercommGetIPAddress: String = "hubsercomm:getIPAddress"
  /** Get model of camera */
  static let hubSercommGetModel: String = "hubsercomm:getModel"
  /** Get camera information and configuration */
  static let hubSercommGetInfo: String = "hubsercomm:getInfo"
  /** Get camera attributes */
  static let hubSercommGetAttrs: String = "hubsercomm:getAttrs"
  /** Start motion detection on camera. */
  static let hubSercommMotionDetectStart: String = "hubsercomm:motionDetectStart"
  /** Stop motion detection on a camera. */
  static let hubSercommMotionDetectStop: String = "hubsercomm:motionDetectStop"
  /** Start video streaming on camera. */
  static let hubSercommVideoStreamStart: String = "hubsercomm:videoStreamStart"
  /** Stop video streaming on a camera. */
  static let hubSercommVideoStreamStop: String = "hubsercomm:videoStreamStop"
  /** Start scan for wireless access points */
  static let hubSercommWifiScanStart: String = "hubsercomm:wifiScanStart"
  /** End scan for wireless access points */
  static let hubSercommWifiScanEnd: String = "hubsercomm:wifiScanEnd"
  /** Connect to a wireless network */
  static let hubSercommWifiConnect: String = "hubsercomm:wifiConnect"
  /** Disconnect from a wireless network. */
  static let hubSercommWifiDisconnect: String = "hubsercomm:wifiDisconnect"
  /** Get current wireless attributes */
  static let hubSercommWifiGetAttrs: String = "hubsercomm:wifiGetAttrs"
  /** Get camera custom attributes */
  static let hubSercommGetCustomAttrs: String = "hubsercomm:getCustomAttrs"
  /** Set camera custom attributes */
  static let hubSercommSetCustomAttrs: String = "hubsercomm:setCustomAttrs"
  /** Remove camera from database, remove if necessary */
  static let hubSercommPurgeCamera: String = "hubsercomm:purgeCamera"
  /** Get camera Pan/Tilt/Zoom attributes */
  static let hubSercommPtzGetAttrs: String = "hubsercomm:ptzGetAttrs"
  /** Move camera to home position */
  static let hubSercommPtzGotoHome: String = "hubsercomm:ptzGotoHome"
  /** Move camera to absolute position */
  static let hubSercommPtzGotoAbsolute: String = "hubsercomm:ptzGotoAbsolute"
  /** Move camera to relative position */
  static let hubSercommPtzGotoRelative: String = "hubsercomm:ptzGotoRelative"
  
}
// MARK: Events
public struct HubSercommEvents {
  /** Sent when the status of a camera firmware upgrade changes. */
  public static let hubSercommCameraUpgradeStatus: String = "hubsercomm:CameraUpgradeStatus"
  /** Sent when the status of a camera pairing changes. */
  public static let hubSercommCameraPairingStatus: String = "hubsercomm:CameraPairingStatus"
  /** Results of wireless access point scan. */
  public static let hubSercommWifiScanResults: String = "hubsercomm:WifiScanResults"
  }

// MARK: Enumerations

// MARK: Requests

/** Get camera password for hub */
public class HubSercommGetCameraPasswordRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetCameraPassword
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
    return HubSercommGetCameraPasswordResponse(message)
  }

  
}

public class HubSercommGetCameraPasswordResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** Current per-hub camera password */
  public func getPassword() -> String? {
    return self.attributes["password"] as? String
  }
}

/** Pair a camera to the hub */
public class HubSercommPairRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommPairRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommPair
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
    return HubSercommPairResponse(message)
  }

  // MARK: pairRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommPairResponse: SessionEvent {
  
  
  /** A status indicating status of the pairing */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the pairing */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Reset a camera back to factory defaults */
public class HubSercommResetRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommResetRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommReset
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
    return HubSercommResetResponse(message)
  }

  // MARK: resetRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommResetResponse: SessionEvent {
  
  
  /** A status indicating status of the reset */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the reset */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Reboot a camera */
public class HubSercommRebootRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommRebootRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommReboot
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
    return HubSercommRebootResponse(message)
  }

  // MARK: rebootRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommRebootResponse: SessionEvent {
  
  
  /** A status indicating status of the reboot */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the reboot */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Configure a camera */
public class HubSercommConfigRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommConfigRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommConfig
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
    return HubSercommConfigResponse(message)
  }

  // MARK: configRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** Parameters to set on camera */
    static let params: String = "params"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** Parameters to set on camera */
  public func setParams(_ params: String) {
    attributes[Attributes.params] = params as AnyObject
  }

  
}

public class HubSercommConfigResponse: SessionEvent {
  
  
  /** A status indicating status of the configuration */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the configuration */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Upgrade firmware on camera */
public class HubSercommUpgradeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommUpgradeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommUpgrade
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
    return HubSercommUpgradeResponse(message)
  }

  // MARK: upgradeRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** URL of firmware image to install */
    static let url: String = "url"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** URL of firmware image to install */
  public func setUrl(_ url: String) {
    attributes[Attributes.url] = url as AnyObject
  }

  
}

public class HubSercommUpgradeResponse: SessionEvent {
  
  
  /** A status indicating status of the upgrade */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the upgrade */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Get current state of camera */
public class HubSercommGetStateRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetStateRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetState
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
    return HubSercommGetStateResponse(message)
  }

  // MARK: getStateRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommGetStateResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** Current state of camera */
  public enum HubSercommState: String {
    case uninitialized = "UNINITIALIZED"
    case initialized = "INITIALIZED"
    case paired = "PAIRED"
    case not_owned = "NOT_OWNED"
    case installing = "INSTALLING"
    case installed = "INSTALLED"
    case install_reboot = "INSTALL_REBOOT"
    case install_error = "INSTALL_ERROR"
    case disconnected = "DISCONNECTED"
    case retry = "RETRY"
    case reset = "RESET"
    case pairing = "PAIRING"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** Current state of camera */
  public func getState() -> HubSercommState? {
    guard let attribute = self.attributes["state"] as? String,
      let enumAttr: HubSercommState = HubSercommState(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Get current firmware version on camera */
public class HubSercommGetVersionRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetVersionRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetVersion
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
    return HubSercommGetVersionResponse(message)
  }

  // MARK: getVersionRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommGetVersionResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** Camera firmware version */
  public func getVersion() -> String? {
    return self.attributes["version"] as? String
  }
}

/** Get current day/night setting of camera */
public class HubSercommGetDayNightRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetDayNightRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetDayNight
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
    return HubSercommGetDayNightResponse(message)
  }

  // MARK: getDayNightRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommGetDayNightResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** Camera day or night status */
  public enum HubSercommDayNight: String {
    case day = "DAY"
    case night = "NIGHT"
    case unknown = "UNKNOWN"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** Camera day or night status */
  public func getDayNight() -> HubSercommDayNight? {
    guard let attribute = self.attributes["dayNight"] as? String,
      let enumAttr: HubSercommDayNight = HubSercommDayNight(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Get IPv4 address of camera */
public class HubSercommGetIPAddressRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetIPAddressRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetIPAddress
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
    return HubSercommGetIPAddressResponse(message)
  }

  // MARK: getIPAddressRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommGetIPAddressResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The IPv4 address of the camera */
  public func getIpAddress() -> String? {
    return self.attributes["ipAddress"] as? String
  }
}

/** Get model of camera */
public class HubSercommGetModelRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetModelRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetModel
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
    return HubSercommGetModelResponse(message)
  }

  // MARK: getModelRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommGetModelResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The model name of the camera */
  public func getModel() -> String? {
    return self.attributes["model"] as? String
  }
}

/** Get camera information and configuration */
public class HubSercommGetInfoRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetInfoRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetInfo
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
    return HubSercommGetInfoResponse(message)
  }

  // MARK: getInfoRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** The parameter group for camera configuration. */
    static let group: String = "group"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** The parameter group for camera configuration. */
  public func setGroup(_ group: String) {
    attributes[Attributes.group] = group as AnyObject
  }

  
}

public class HubSercommGetInfoResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The camera information or configuration */
  public func getInfo() -> String? {
    return self.attributes["info"] as? String
  }
}

/** Get camera attributes */
public class HubSercommGetAttrsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetAttrsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetAttrs
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
    return HubSercommGetAttrsResponse(message)
  }

  // MARK: getAttrsRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommGetAttrsResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The camera attributes data */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Start motion detection on camera. */
public class HubSercommMotionDetectStartRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommMotionDetectStartRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommMotionDetectStart
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
    return HubSercommMotionDetectStartResponse(message)
  }

  // MARK: motionDetectStartRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** The URL to post to when motion occurs. */
    static let url: String = "url"
/** The HTTP username for the post URL. */
    static let username: String = "username"
/** The HTTP password for the post URL. */
    static let password: String = "password"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** The URL to post to when motion occurs. */
  public func setUrl(_ url: String) {
    attributes[Attributes.url] = url as AnyObject
  }

  
  /** The HTTP username for the post URL. */
  public func setUsername(_ username: String) {
    attributes[Attributes.username] = username as AnyObject
  }

  
  /** The HTTP password for the post URL. */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
}

public class HubSercommMotionDetectStartResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Stop motion detection on a camera. */
public class HubSercommMotionDetectStopRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommMotionDetectStopRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommMotionDetectStop
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
    return HubSercommMotionDetectStopResponse(message)
  }

  // MARK: motionDetectStopRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommMotionDetectStopResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Start video streaming on camera. */
public class HubSercommVideoStreamStartRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommVideoStreamStartRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommVideoStreamStart
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
    return HubSercommVideoStreamStartResponse(message)
  }

  // MARK: videoStreamStartRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** The address of the video server. */
    static let hubSercommAddress: String = "address"
/** The HTTP username for the post URL. */
    static let username: String = "username"
/** The HTTP password for the post URL. */
    static let password: String = "password"
/** The duration of the video streaming. */
    static let duration: String = "duration"
/** The pre-capture video setting. */
    static let precapture: String = "precapture"
/** The video streaming format. */
    static let format: String = "format"
/** The video resolution. */
    static let resolution: String = "resolution"
/** The video quality type. */
    static let quality_type: String = "quality_type"
/** The video bitrate. */
    static let bitrate: String = "bitrate"
/** The video quality. */
    static let quality: String = "quality"
/** The video framerate. */
    static let framerate: String = "framerate"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** The address of the video server. */
  public func setAddress(_ hubSercommAddress: String) {
    attributes[Attributes.hubSercommAddress] = hubSercommAddress as AnyObject
  }

  
  /** The HTTP username for the post URL. */
  public func setUsername(_ username: String) {
    attributes[Attributes.username] = username as AnyObject
  }

  
  /** The HTTP password for the post URL. */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
  /** The duration of the video streaming. */
  public func setDuration(_ duration: Int) {
    attributes[Attributes.duration] = duration as AnyObject
  }

  
  /** The pre-capture video setting. */
  public func setPrecapture(_ precapture: Int) {
    attributes[Attributes.precapture] = precapture as AnyObject
  }

  
  /** The video streaming format. */
  public func setFormat(_ format: Int) {
    attributes[Attributes.format] = format as AnyObject
  }

  
  /** The video resolution. */
  public func setResolution(_ resolution: Int) {
    attributes[Attributes.resolution] = resolution as AnyObject
  }

  
  /** The video quality type. */
  public func setQuality_type(_ quality_type: Int) {
    attributes[Attributes.quality_type] = quality_type as AnyObject
  }

  
  /** The video bitrate. */
  public func setBitrate(_ bitrate: Int) {
    attributes[Attributes.bitrate] = bitrate as AnyObject
  }

  
  /** The video quality. */
  public func setQuality(_ quality: Int) {
    attributes[Attributes.quality] = quality as AnyObject
  }

  
  /** The video framerate. */
  public func setFramerate(_ framerate: Int) {
    attributes[Attributes.framerate] = framerate as AnyObject
  }

  
}

public class HubSercommVideoStreamStartResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Stop video streaming on a camera. */
public class HubSercommVideoStreamStopRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommVideoStreamStopRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommVideoStreamStop
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
    return HubSercommVideoStreamStopResponse(message)
  }

  // MARK: videoStreamStopRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommVideoStreamStopResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Start scan for wireless access points */
public class HubSercommWifiScanStartRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommWifiScanStartRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommWifiScanStart
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
    return HubSercommWifiScanStartResponse(message)
  }

  // MARK: wifiScanStartRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommWifiScanStartResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** End scan for wireless access points */
public class HubSercommWifiScanEndRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommWifiScanEndRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommWifiScanEnd
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
    return HubSercommWifiScanEndResponse(message)
  }

  // MARK: wifiScanEndRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommWifiScanEndResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Connect to a wireless network */
public class HubSercommWifiConnectRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommWifiConnectRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommWifiConnect
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
    return HubSercommWifiConnectResponse(message)
  }

  // MARK: wifiConnectRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** The ssid of the wireless network. */
    static let ssid: String = "ssid"
/** The security type of the wireless network. */
    static let security: String = "security"
/** The authentication key of the wireless network. */
    static let key: String = "key"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** The ssid of the wireless network. */
  public func setSsid(_ ssid: String) {
    attributes[Attributes.ssid] = ssid as AnyObject
  }

  
  /** The security type of the wireless network. */
  public func setSecurity(_ security: String) {
    attributes[Attributes.security] = security as AnyObject
  }

  
  /** The authentication key of the wireless network. */
  public func setKey(_ key: String) {
    attributes[Attributes.key] = key as AnyObject
  }

  
}

public class HubSercommWifiConnectResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Disconnect from a wireless network. */
public class HubSercommWifiDisconnectRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommWifiDisconnectRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommWifiDisconnect
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
    return HubSercommWifiDisconnectResponse(message)
  }

  // MARK: wifiDisconnectRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommWifiDisconnectResponse: SessionEvent {
  
  
  /** A status indicating status of the disconnect */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the disconnect */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Get current wireless attributes */
public class HubSercommWifiGetAttrsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommWifiGetAttrsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommWifiGetAttrs
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
    return HubSercommWifiGetAttrsResponse(message)
  }

  // MARK: wifiGetAttrsRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommWifiGetAttrsResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** Wireless attributes data */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Get camera custom attributes */
public class HubSercommGetCustomAttrsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommGetCustomAttrsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommGetCustomAttrs
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
    return HubSercommGetCustomAttrsResponse(message)
  }

  // MARK: getCustomAttrsRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommGetCustomAttrsResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The camera custom attributes data */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Set camera custom attributes */
public class HubSercommSetCustomAttrsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommSetCustomAttrsRequest Enumerations
  /** The IR LED mode */
  public enum HubSercommIrLedMode: String {
   case on = "ON"
   case off = "OFF"
   case auto = "AUTO"
   
  }/** The motion detection mode of operation. */
  public enum HubSercommMdMode: String {
   case off = "OFF"
   case pir = "PIR"
   case window = "WINDOW"
   case both = "BOTH"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubSercommSetCustomAttrs
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
    return HubSercommSetCustomAttrsResponse(message)
  }

  // MARK: setCustomAttrsRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** The IR LED mode */
    static let irLedMode: String = "irLedMode"
/** The IR LED luminance, on a scale of 1 to 5. */
    static let irLedLuminance: String = "irLedLuminance"
/** The motion detection mode of operation. */
    static let mdMode: String = "mdMode"
/** The motion detection threshold, on a scale of 0 to 255. */
    static let mdThreshold: String = "mdThreshold"
/** The motion detection threshold, on a scale of 0 to 10. */
    static let mdSensitivity: String = "mdSensitivity"
/** The motion detection window in X1,Y1,X2,Y2 format. */
    static let mdWindowCoordinates: String = "mdWindowCoordinates"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** The IR LED mode */
  public func setIrLedMode(_ irLedMode: String) {
    if let value: HubSercommIrLedMode = HubSercommIrLedMode(rawValue: irLedMode) {
      attributes[Attributes.irLedMode] = value.rawValue as AnyObject
    }
  }
  
  /** The IR LED luminance, on a scale of 1 to 5. */
  public func setIrLedLuminance(_ irLedLuminance: Int) {
    attributes[Attributes.irLedLuminance] = irLedLuminance as AnyObject
  }

  
  /** The motion detection mode of operation. */
  public func setMdMode(_ mdMode: String) {
    if let value: HubSercommMdMode = HubSercommMdMode(rawValue: mdMode) {
      attributes[Attributes.mdMode] = value.rawValue as AnyObject
    }
  }
  
  /** The motion detection threshold, on a scale of 0 to 255. */
  public func setMdThreshold(_ mdThreshold: Int) {
    attributes[Attributes.mdThreshold] = mdThreshold as AnyObject
  }

  
  /** The motion detection threshold, on a scale of 0 to 10. */
  public func setMdSensitivity(_ mdSensitivity: Int) {
    attributes[Attributes.mdSensitivity] = mdSensitivity as AnyObject
  }

  
  /** The motion detection window in X1,Y1,X2,Y2 format. */
  public func setMdWindowCoordinates(_ mdWindowCoordinates: String) {
    attributes[Attributes.mdWindowCoordinates] = mdWindowCoordinates as AnyObject
  }

  
}

public class HubSercommSetCustomAttrsResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Remove camera from database, remove if necessary */
public class HubSercommPurgeCameraRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommPurgeCameraRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommPurgeCamera
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
    return HubSercommPurgeCameraResponse(message)
  }

  // MARK: purgeCameraRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommPurgeCameraResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Get camera Pan/Tilt/Zoom attributes */
public class HubSercommPtzGetAttrsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommPtzGetAttrsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommPtzGetAttrs
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
    return HubSercommPtzGetAttrsResponse(message)
  }

  // MARK: ptzGetAttrsRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommPtzGetAttrsResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The camera PTZ attributes data */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Move camera to home position */
public class HubSercommPtzGotoHomeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommPtzGotoHomeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommPtzGotoHome
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
    return HubSercommPtzGotoHomeResponse(message)
  }

  // MARK: ptzGotoHomeRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
}

public class HubSercommPtzGotoHomeResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Move camera to absolute position */
public class HubSercommPtzGotoAbsoluteRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommPtzGotoAbsoluteRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommPtzGotoAbsolute
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
    return HubSercommPtzGotoAbsoluteResponse(message)
  }

  // MARK: ptzGotoAbsoluteRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** The pan position for the camera. */
    static let pan: String = "pan"
/** The tilt position for the camera. */
    static let tilt: String = "tilt"
/** The zoom position for the camera. */
    static let zoom: String = "zoom"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** The pan position for the camera. */
  public func setPan(_ pan: Int) {
    attributes[Attributes.pan] = pan as AnyObject
  }

  
  /** The tilt position for the camera. */
  public func setTilt(_ tilt: Int) {
    attributes[Attributes.tilt] = tilt as AnyObject
  }

  
  /** The zoom position for the camera. */
  public func setZoom(_ zoom: Int) {
    attributes[Attributes.zoom] = zoom as AnyObject
  }

  
}

public class HubSercommPtzGotoAbsoluteResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Move camera to relative position */
public class HubSercommPtzGotoRelativeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSercommPtzGotoRelativeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubSercommPtzGotoRelative
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
    return HubSercommPtzGotoRelativeResponse(message)
  }

  // MARK: ptzGotoRelativeRequest Attributes
  struct Attributes {
    /** The MAC address of the camera. */
    static let mac: String = "mac"
/** The pan delta for the camera. */
    static let deltaPan: String = "deltaPan"
/** The tilt delta for the camera. */
    static let deltaTilt: String = "deltaTilt"
/** The zoom delta for the camera. */
    static let deltaZoom: String = "deltaZoom"
 }
  
  /** The MAC address of the camera. */
  public func setMac(_ mac: String) {
    attributes[Attributes.mac] = mac as AnyObject
  }

  
  /** The pan delta for the camera. */
  public func setDeltaPan(_ deltaPan: Int) {
    attributes[Attributes.deltaPan] = deltaPan as AnyObject
  }

  
  /** The tilt delta for the camera. */
  public func setDeltaTilt(_ deltaTilt: Int) {
    attributes[Attributes.deltaTilt] = deltaTilt as AnyObject
  }

  
  /** The zoom delta for the camera. */
  public func setDeltaZoom(_ deltaZoom: Int) {
    attributes[Attributes.deltaZoom] = deltaZoom as AnyObject
  }

  
}

public class HubSercommPtzGotoRelativeResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubSercommStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubSercommStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubSercommStatus = HubSercommStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

