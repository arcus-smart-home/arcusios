
//
// PairingSubsystemCapEvents.swift
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
  /** Gets all the PairingDevices from the pairingDevices attribute. */
  static let pairingSubsystemListPairingDevices: String = "subpairing:ListPairingDevices"
  /** Attempts to pair the requested type of device. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is not a hub connected device then the hub will not be put in pairing mode. */
  static let pairingSubsystemStartPairing: String = "subpairing:StartPairing"
  /**  Attempts to pair the requested device. This will also start / reset the IdlePairing timer. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is a cloud connected device then the system will enter pairing mode for the given device. If the requested product is an OAuth connected device, an error will be returned. If no productId is specified this will turn all hub radios into pairing mode and search for all types of devices.           */
  static let pairingSubsystemSearch: String = "subpairing:Search"
  /** Retrieves the help steps for the product currently being search for, or steps specific to the active pairing protocols. */
  static let pairingSubsystemListHelpSteps: String = "subpairing:ListHelpSteps"
  /**  Dismisses all devices from pairingDevices that are in the PAIRED state. This should be invoked when cancelling / exiting pairing. This will take the hub out of pairing mode. This will take the hub out of unpairing mode.  */
  static let pairingSubsystemDismissAll: String = "subpairing:DismissAll"
  /** This clears all timeouts, takes the place/hub out of pairing or unpairing mode, and takes the state back to IDLE. */
  static let pairingSubsystemStopSearching: String = "subpairing:StopSearching"
  /**  Retrieves the factory reset steps for the product currently being search for, or steps specific to the active pairing protocols. This will take the hub out of pairing mode.           */
  static let pairingSubsystemFactoryReset: String = "subpairing:FactoryReset"
  /** Gets the information about a kit.  This is a pair of product id, and the protocoladdress of that device.  Protocol address can be used to determine the state of the kitted device. */
  static let pairingSubsystemGetKitInformation: String = "subpairing:GetKitInformation"
  
}
// MARK: Events
public struct PairingSubsystemEvents {
  /** Indicates that it is taking longer to pair the device than it should be.  This is done in order to provide remediation steps to any listeners. */
  public static let pairingSubsystemPairingIdleTimeout: String = "subpairing:PairingIdleTimeout"
  /** Emitted when the system stops searching due to a timeout rather than an explicit user action, like Customize or DismissAll. */
  public static let pairingSubsystemPairingTimeout: String = "subpairing:PairingTimeout"
  /** Emitted when the pairing failed during search. */
  public static let pairingSubsystemPairingFailed: String = "subpairing:PairingFailed"
  }

// MARK: Errors
public struct PairingSubsystemStartPairingError: ArcusError {
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
    /** If the requested product requires a hub, or generic pairing is requested and there is no hub associated with the place, this error will be returned. */
    case hubMissing = "hub.missing"
    /** If the requested product requires a hub, or generic pairing is requested and the hub is currently offline, this error will be returned. */
    case hubOffline = "hub.offline"
    /** If the productAddress can&#x27;t be found or mock=true and no mock exists for the given product. */
    case requestParamInvalid = "request.param.invalid"
    
  }
}
// MARK: Errors
public struct PairingSubsystemSearchError: ArcusError {
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
    /** If search is requested for an OAuth flow device. */
    case requestInvalid = "request.invalid"
    /** If the form is missing any input fields or those fields fail validation. */
    case requestParamInvalid = "request.param.invalid"
    /** If the requested product requires a hub, or generic pairing is requested and there is no hub associated with the place, this error will be returned. */
    case hubMissing = "hub.missing"
    /** If the requested product requires a hub, or generic pairing is requested and the hub is currently offline, this error will be returned. */
    case hubOffline = "hub.offline"
    
  }
}
// MARK: Errors
public struct PairingSubsystemListHelpStepsError: ArcusError {
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
    /** If the pairing state is IDLE or HUB_UNPAIRING. */
    case requestStateInvalid = "request.state.invalid"
    
  }
}
// MARK: Errors
public struct PairingSubsystemFactoryResetError: ArcusError {
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
    /** If the system is attempting to pair a device that does not support orphan remove. */
    case requestStateInvalid = "request.state.invalid"
    /** If the requested product requires a hub, or generic pairing is requested and there is no hub associated with the place, this error will be returned. */
    case hubMissing = "hub.missing"
    /** If the requested product requires a hub, or generic pairing is requested and the hub is currently offline, this error will be returned. */
    case hubOffline = "hub.offline"
    
  }
}
// MARK: Errors
public struct PairingSubsystemGetKitInformationError: ArcusError {
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
    /** If the hub is not part of a kit this error will be returned. */
    case hubMissing = "hub.missing"
    
  }
}
// MARK: Enumerations

/** The current pairing state of the associated place. Note that unlike subplacemonitor:pairingState this represents the state the system is attempting to enforce, not the current state of the hub. */
public enum PairingSubsystemPairingMode: String {
  case idle = "IDLE"
  case hub = "HUB"
  case cloud = "CLOUD"
  case oauth = "OAUTH"
  case hub_unpairing = "HUB_UNPAIRING"
}

// MARK: Requests

/** Gets all the PairingDevices from the pairingDevices attribute. */
public class PairingSubsystemListPairingDevicesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemListPairingDevices
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
    return PairingSubsystemListPairingDevicesResponse(message)
  }

  
}

public class PairingSubsystemListPairingDevicesResponse: SessionEvent {
  
  
  /** The full object model for the pairingDevices. */
  public func getDevices() -> [Any]? {
    return self.attributes["devices"] as? [Any]
  }
}

/** Attempts to pair the requested type of device. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is not a hub connected device then the hub will not be put in pairing mode. */
public class PairingSubsystemStartPairingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PairingSubsystemStartPairingRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemStartPairing
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

      let error = PairingSubsystemStartPairingError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingSubsystemStartPairingResponse(message)
  }

  // MARK: StartPairingRequest Attributes
  struct Attributes {
    /** (default: &#x27;&#x27;) If specified this indicates the type of device being paired.  This will be used to determine the pairing steps that should be returned as well as the radios to turn on for the hub. */
    static let productAddress: String = "productAddress"
/** (default: false) If set to true the system will attempt to create a mock device for pairing purposes, this is not supported by all product addresses and is intended for debugging.  When set to true the hub will never be put in pairing mode. */
    static let mock: String = "mock"
 }
  
  /** (default: &#x27;&#x27;) If specified this indicates the type of device being paired.  This will be used to determine the pairing steps that should be returned as well as the radios to turn on for the hub. */
  public func setProductAddress(_ productAddress: String) {
    attributes[Attributes.productAddress] = productAddress as AnyObject
  }

  
  /** (default: false) If set to true the system will attempt to create a mock device for pairing purposes, this is not supported by all product addresses and is intended for debugging.  When set to true the hub will never be put in pairing mode. */
  public func setMock(_ mock: Bool) {
    attributes[Attributes.mock] = mock as AnyObject
  }

  
}

public class PairingSubsystemStartPairingResponse: SessionEvent {
  
  
  /** The pairing mode. */
  public enum PairingSubsystemMode: String {
    case hub = "HUB"
    case cloud = "CLOUD"
    case oauth = "OAUTH"
    
  }
  /** The pairing steps for pairing the given type of device. */
  public func getSteps() -> [Any]? {
    return self.attributes["steps"] as? [Any]
  }
  /** The pairing mode. */
  public func getMode() -> PairingSubsystemMode? {
    guard let attribute = self.attributes["mode"] as? String,
      let enumAttr: PairingSubsystemMode = PairingSubsystemMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The URL of a pairing video if one exists. */
  public func getVideo() -> String? {
    return self.attributes["video"] as? String
  }
  /** Additional form data required for CLOUD pairing. */
  public func getForm() -> [Any]? {
    return self.attributes["form"] as? [Any]
  }
  /** The URL to launch an embedded browser to in order to continue pairing. */
  public func getOauthUrl() -> String? {
    return self.attributes["oauthUrl"] as? String
  }
  /** Additional information about the OAuth partner.  Current supported values are HONEYWELL &amp; NEST.  Any implementation MUST ensure that new values will not break rendering. */
  public func getOauthStyle() -> String? {
    return self.attributes["oauthStyle"] as? String
  }
}

/**  Attempts to pair the requested device. This will also start / reset the IdlePairing timer. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is a cloud connected device then the system will enter pairing mode for the given device. If the requested product is an OAuth connected device, an error will be returned. If no productId is specified this will turn all hub radios into pairing mode and search for all types of devices.           */
public class PairingSubsystemSearchRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PairingSubsystemSearchRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemSearch
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

      let error = PairingSubsystemSearchError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingSubsystemSearchResponse(message)
  }

  // MARK: SearchRequest Attributes
  struct Attributes {
    /** (default: &#x27;&#x27;) The address of the product catalog entry for the device being paired. */
    static let productAddress: String = "productAddress"
/** (default: {}) Any input parameters gathered from the user. */
    static let form: String = "form"
 }
  
  /** (default: &#x27;&#x27;) The address of the product catalog entry for the device being paired. */
  public func setProductAddress(_ productAddress: String) {
    attributes[Attributes.productAddress] = productAddress as AnyObject
  }

  
  /** (default: {}) Any input parameters gathered from the user. */
  public func setForm(_ form: [String: String]) {
    attributes[Attributes.form] = form as AnyObject
  }

  
}

public class PairingSubsystemSearchResponse: SessionEvent {
  
  
  /** The pairing mode. */
  public enum PairingSubsystemMode: String {
    case hub = "HUB"
    case cloud = "CLOUD"
    case oauth = "OAUTH"
    
  }
  /** The pairing mode. */
  public func getMode() -> PairingSubsystemMode? {
    guard let attribute = self.attributes["mode"] as? String,
      let enumAttr: PairingSubsystemMode = PairingSubsystemMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Retrieves the help steps for the product currently being search for, or steps specific to the active pairing protocols. */
public class PairingSubsystemListHelpStepsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemListHelpSteps
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

      let error = PairingSubsystemListHelpStepsError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingSubsystemListHelpStepsResponse(message)
  }

  
}

public class PairingSubsystemListHelpStepsResponse: SessionEvent {
  
  
  /** The pairing steps for pairing the given type of device. */
  public func getSteps() -> [Any]? {
    return self.attributes["steps"] as? [Any]
  }
}

/**  Dismisses all devices from pairingDevices that are in the PAIRED state. This should be invoked when cancelling / exiting pairing. This will take the hub out of pairing mode. This will take the hub out of unpairing mode.  */
public class PairingSubsystemDismissAllRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemDismissAll
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
    return PairingSubsystemDismissAllResponse(message)
  }

  
}

public class PairingSubsystemDismissAllResponse: SessionEvent {
  
  
  /** Any screens / actions the user must be displayed after pairing is complete. */
  public func getActions() -> [Any]? {
    return self.attributes["actions"] as? [Any]
  }
}

/** This clears all timeouts, takes the place/hub out of pairing or unpairing mode, and takes the state back to IDLE. */
public class PairingSubsystemStopSearchingRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemStopSearching
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
    return PairingSubsystemStopSearchingResponse(message)
  }

  
}

public class PairingSubsystemStopSearchingResponse: SessionEvent {
  
}

/**  Retrieves the factory reset steps for the product currently being search for, or steps specific to the active pairing protocols. This will take the hub out of pairing mode.           */
public class PairingSubsystemFactoryResetRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemFactoryReset
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

      let error = PairingSubsystemFactoryResetError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingSubsystemFactoryResetResponse(message)
  }

  
}

public class PairingSubsystemFactoryResetResponse: SessionEvent {
  
  
  /** The factory reset steps for the given type of device. */
  public func getSteps() -> [Any]? {
    return self.attributes["steps"] as? [Any]
  }
  /** The URL for a removal video. */
  public func getVideo() -> String? {
    return self.attributes["video"] as? String
  }
}

/** Gets the information about a kit.  This is a pair of product id, and the protocoladdress of that device.  Protocol address can be used to determine the state of the kitted device. */
public class PairingSubsystemGetKitInformationRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.pairingSubsystemGetKitInformation
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

      let error = PairingSubsystemGetKitInformationError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PairingSubsystemGetKitInformationResponse(message)
  }

  
}

public class PairingSubsystemGetKitInformationResponse: SessionEvent {
  
  
  /** A list of the product.id and protocolAddress pairs. */
  public func getKitInfo() -> [Any]? {
    return self.attributes["kitInfo"] as? [Any]
  }
}

