
//
// PairingDeviceCapEvents.swift
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
  /**  Retrieves the customization steps for the given device, the deviceId should match the value from discoveredDeviceIds or PairingDevice#deviceId. If this call is successful the hub will no longer be in any pairing mode.           */
  static let pairingDeviceCustomize: String = "pairdev:Customize"
  /** Used by the client to indicate which customizations they have applied to the device.  The set may be read from the customizations attribute. */
  static let pairingDeviceAddCustomization: String = "pairdev:AddCustomization"
  /**  Dismisses a device from the pairing subsystem.  This should be called when customization is completed or skipped. This call is idempotent, so if the device has previously been dismissed this will not return an error, unlike Customize.           */
  static let pairingDeviceDismiss: String = "pairdev:Dismiss"
  /**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the PairingDevice. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This will take the hub out of pairing mode and may put it in unpairing mode depending on the device being removed.           */
  static let pairingDeviceRemove: String = "pairdev:Remove"
  /**  Causes the hub to blacklist this device and treat it as if it was deleted even though it still has connectivity to the hub. This will take the hub out of pairing mode.           */
  static let pairingDeviceForceRemove: String = "pairdev:ForceRemove"
  
}
// MARK: Events
public struct PairingDeviceEvents {
  /** Emitted when a new device is discovered, intended for analytics &amp; debugging. */
  public static let pairingDeviceDiscovered: String = "pairdev:Discovered"
  /** Emitted when a device successfully completes configuration, intended for analytics &amp; debugging. */
  public static let pairingDeviceConfigured: String = "pairdev:Configured"
  /** Emitted when a device fails pairing, intended for analytics &amp; debugging. */
  public static let pairingDevicePairingFailed: String = "pairdev:PairingFailed"
  }

// MARK: Errors
public struct PairingDeviceCustomizeError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If the device is not fully paired. */
    case requestStateInvalid = "request.state.invalid"
    
  }
}
// MARK: Errors
public struct PairingDeviceAddCustomizationError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If it is an unrecognized customization. */
    case requestParamInvalid = "request.param.invalid"
    
  }
}
// MARK: Errors
public struct PairingDeviceDismissError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If the device is not fully paired. */
    case requestStateInvalid = "request.state.invalid"
    
  }
}
// MARK: Enumerations

/**  The current state of pairing for the device:      PAIRING - The system has discovered a device and is in the process of configuring it. (deviceAddress will be null)     MISPAIRED - The device failed to pair properly and must be removed / factory reset and re-paired (deviceAddress will be null)     MISCONFIGURED - The system was unable to fully configure the device, but it can retry without going through a full re-pair process. (deviceAddress may be null)     PAIRED - The device successfully paired. (deviceAddress will be populated)              */
public enum PairingDevicePairingState: String {
  case pairing = "PAIRING"
  case mispaired = "MISPAIRED"
  case misconfigured = "MISCONFIGURED"
  case paired = "PAIRED"
}

/** The current pairing phase. */
public enum PairingDevicePairingPhase: String {
  case join = "JOIN"
  case connect = "CONNECT"
  case identify = "IDENTIFY"
  case prepare = "PREPARE"
  case configure = "CONFIGURE"
  case failed = "FAILED"
  case paired = "PAIRED"
}

/** The mode of removal */
public enum PairingDeviceRemoveMode: String {
  case cloud = "CLOUD"
  case hub_automatic = "HUB_AUTOMATIC"
  case hub_manual = "HUB_MANUAL"
}

// MARK: Requests

/**  Retrieves the customization steps for the given device, the deviceId should match the value from discoveredDeviceIds or PairingDevice#deviceId. If this call is successful the hub will no longer be in any pairing mode.           */
public class PairingDeviceCustomizeRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingDeviceCustomize
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

      let error = PairingDeviceCustomizeError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingDeviceCustomizeResponse(message)
  }

  
}

public class PairingDeviceCustomizeResponse: SessionEvent {
  
  
  /** The customization actions for the given device. */
  public func getSteps() -> [Any]? {
    return self.attributes["steps"] as? [Any]
  }
}

/** Used by the client to indicate which customizations they have applied to the device.  The set may be read from the customizations attribute. */
public class PairingDeviceAddCustomizationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PairingDeviceAddCustomizationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.pairingDeviceAddCustomization
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

      let error = PairingDeviceAddCustomizationError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingDeviceAddCustomizationResponse(message)
  }

  // MARK: AddCustomizationRequest Attributes
  struct Attributes {
    /** The customization applied by the user. */
    static let customization: String = "customization"
 }
  
  /** The customization applied by the user. */
  public func setCustomization(_ customization: String) {
    attributes[Attributes.customization] = customization as AnyObject
  }

  
}

public class PairingDeviceAddCustomizationResponse: SessionEvent {
  
}

/**  Dismisses a device from the pairing subsystem.  This should be called when customization is completed or skipped. This call is idempotent, so if the device has previously been dismissed this will not return an error, unlike Customize.           */
public class PairingDeviceDismissRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingDeviceDismiss
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

      let error = PairingDeviceDismissError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingDeviceDismissResponse(message)
  }

  
}

public class PairingDeviceDismissResponse: SessionEvent {
  
}

/**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the PairingDevice. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This will take the hub out of pairing mode and may put it in unpairing mode depending on the device being removed.           */
public class PairingDeviceRemoveRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingDeviceRemove
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
    return PairingDeviceRemoveResponse(message)
  }

  
}

public class PairingDeviceRemoveResponse: SessionEvent {
  
  
  /** The mode of removal. */
  public enum PairingDeviceMode: String {
    case cloud = "CLOUD"
    case hub_automatic = "HUB_AUTOMATIC"
    case hub_manual = "HUB_MANUAL"
    
  }
  /** The removal steps for the given device.  Will be empty for devices that support autonomous removal. */
  public func getSteps() -> [Any]? {
    return self.attributes["steps"] as? [Any]
  }
  /** The mode of removal. */
  public func getMode() -> PairingDeviceMode? {
    guard let attribute = self.attributes["mode"] as? String,
      let enumAttr: PairingDeviceMode = PairingDeviceMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The URL for a removal video. */
  public func getVideo() -> String? {
    return self.attributes["video"] as? String
  }
}

/**  Causes the hub to blacklist this device and treat it as if it was deleted even though it still has connectivity to the hub. This will take the hub out of pairing mode.           */
public class PairingDeviceForceRemoveRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingDeviceForceRemove
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
    return PairingDeviceForceRemoveResponse(message)
  }

  
}

public class PairingDeviceForceRemoveResponse: SessionEvent {
  
}

