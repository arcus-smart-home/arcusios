
//
// ProMonitoringSettingsCapEvents.swift
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
  /** Checks if the current place supports professional monitoring or not. */
  static let proMonitoringSettingsCheckAvailability: String = "promon:CheckAvailability"
  /** Allows the user to join the trial group by submitting a trial code. */
  static let proMonitoringSettingsJoinTrial: String = "promon:JoinTrial"
  /** Validates that the place&#x27;s address is recognized by the professional monitoring system. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
  static let proMonitoringSettingsValidateAddress: String = "promon:ValidateAddress"
  /** Validate the address with UCC, and updates the  current place&#x27;s address if it is changed.  The address is optional and if not specified will use the address of the current place. */
  static let proMonitoringSettingsUpdateAddress: String = "promon:UpdateAddress"
  /** Lists the departments which service a place, generally used to figure out where to get a permit from. */
  static let proMonitoringSettingsListDepartments: String = "promon:ListDepartments"
  /** Gets the set of professionally monitored devices which are currently offline. */
  static let proMonitoringSettingsCheckSensors: String = "promon:CheckSensors"
  /**           This enrolls and activates professional monitoring at the given place.  Billing will be updated and the place will be professionally monitored.          Note that if testCall is set to true this may return successfully, and then fail later if the test call fails.           */
  static let proMonitoringSettingsActivate: String = "promon:Activate"
  /**              This instructs the monitoring service to place a call to the number associated with the place.  This call will return immediately, but the lastCallStatus should be watched to determine when the test call is completed.             Note that if a test call is already in progress this will return the existing testCallTime, and as such may be retried safely.           */
  static let proMonitoringSettingsTestCall: String = "promon:TestCall"
  /** Downgrades the account to premium, deactivates the place and clears all promonitoring settings */
  static let proMonitoringSettingsReset: String = "promon:Reset"
  
}

// MARK: Errors
public struct ProMonitoringSettingsCheckAvailabilityError: ArcusError {
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
    /** The place has no address or is missing the zip code.  This should prompt the user to update their address. */
    case addressInvalid = "address.invalid"
    
  }
}
// MARK: Errors
public struct ProMonitoringSettingsJoinTrialError: ArcusError {
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
    /** If an incorrect trial code is received. */
    case codeInvalid = "code.invalid"
    
  }
}
// MARK: Errors
public struct ProMonitoringSettingsValidateAddressError: ArcusError {
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
    /** The place has no address or has an address that is missing information.  This should prompt the user to edit their place address or call support. */
    case addressInvalid = "address.invalid"
    
  }
}
// MARK: Errors
public struct ProMonitoringSettingsUpdateAddressError: ArcusError {
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
    /** The address does not pass validation as one recognized by UCC. */
    case addressInvalid = "address.invalid"
    /** The address is not in an area where professionally monitoring is currently available. */
    case addressUnavailable = "address.unavailable"
    /** If residential is not set to true. */
    case addressUnsupported = "address.unsupported"
    
  }
}
// MARK: Errors
public struct ProMonitoringSettingsListDepartmentsError: ArcusError {
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
    /** If the address hasn&#x27;t been validated. */
    case addressInvalid = "address.invalid"
    
  }
}
// MARK: Errors
public struct ProMonitoringSettingsActivateError: ArcusError {
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
    /** If the address hasn&#x27;t been validated. */
    case addressInvalid = "address.invalid"
    /** If promonitoring has already been activated at this place. This is an error to inform the caller that a test call has not​ been initiated. */
    case promonitoringActive = "promonitoring.active"
    /** If the account level is basic and there is no billing information. */
    case billinginfoMissing = "billinginfo.missing"
    
  }
}
// MARK: Enumerations

/** Will be UNVERIFIED until UpdateAddress is invoked, which upon success will be changed to RESIDENTIAL. */
public enum ProMonitoringSettingsAddressVerification: String {
  case unverified = "UNVERIFIED"
  case residential = "RESIDENTIAL"
}

/** The current state of a test call. */
public enum ProMonitoringSettingsTestCallStatus: String {
  case idle = "IDLE"
  case waiting = "WAITING"
  case succeeded = "SUCCEEDED"
  case failed = "FAILED"
}

// MARK: Requests

/** Checks if the current place supports professional monitoring or not. */
public class ProMonitoringSettingsCheckAvailabilityRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsCheckAvailability
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

      let error = ProMonitoringSettingsCheckAvailabilityError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return ProMonitoringSettingsCheckAvailabilityResponse(message)
  }

  
}

public class ProMonitoringSettingsCheckAvailabilityResponse: SessionEvent {
  
  
  /** The type of availability in the active place&#x27;s area */
  public enum ProMonitoringSettingsAvailable: String {
    case none = "NONE"
    case trial = "TRIAL"
    case full = "FULL"
    
  }
  /** The type of availability in the active place&#x27;s area */
  public func getAvailable() -> ProMonitoringSettingsAvailable? {
    guard let attribute = self.attributes["available"] as? String,
      let enumAttr: ProMonitoringSettingsAvailable = ProMonitoringSettingsAvailable(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Allows the user to join the trial group by submitting a trial code. */
public class ProMonitoringSettingsJoinTrialRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProMonitoringSettingsJoinTrialRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsJoinTrial
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

      let error = ProMonitoringSettingsJoinTrialError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return ProMonitoringSettingsJoinTrialResponse(message)
  }

  // MARK: JoinTrialRequest Attributes
  struct Attributes {
    /**  */
    static let code: String = "code"
 }
  
  /**  */
  public func setCode(_ code: String) {
    attributes[Attributes.code] = code as AnyObject
  }

  
}

public class ProMonitoringSettingsJoinTrialResponse: SessionEvent {
  
}

/** Validates that the place&#x27;s address is recognized by the professional monitoring system. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
public class ProMonitoringSettingsValidateAddressRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProMonitoringSettingsValidateAddressRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsValidateAddress
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

      let error = ProMonitoringSettingsValidateAddressError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return ProMonitoringSettingsValidateAddressResponse(message)
  }

  // MARK: ValidateAddressRequest Attributes
  struct Attributes {
    /** If specified this address will be validated instead of the default place address. */
    static let streetAddress: String = "streetAddress"
 }
  
  /** If specified this address will be validated instead of the default place address. */
  public func setStreetAddress(_ streetAddress: Any) {
    attributes[Attributes.streetAddress] = streetAddress as AnyObject
  }

  
}

public class ProMonitoringSettingsValidateAddressResponse: SessionEvent {
  
  
  /** True if the given address is recognized, false otherwise. */
  public func getValid() -> Bool? {
    return self.attributes["valid"] as? Bool
  }
  /** A list of validated addresses that are similar to the place&#x27;s address. */
  public func getSuggestions() -> [Any]? {
    return self.attributes["suggestions"] as? [Any]
  }
}

/** Validate the address with UCC, and updates the  current place&#x27;s address if it is changed.  The address is optional and if not specified will use the address of the current place. */
public class ProMonitoringSettingsUpdateAddressRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProMonitoringSettingsUpdateAddressRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsUpdateAddress
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

      let error = ProMonitoringSettingsUpdateAddressError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return ProMonitoringSettingsUpdateAddressResponse(message)
  }

  // MARK: UpdateAddressRequest Attributes
  struct Attributes {
    /** If specified the place address will be updated to use this given address. */
    static let streetAddress: String = "streetAddress"
/** Whether or not this is a residential address.  Currently will always return an error if set to false. */
    static let residential: String = "residential"
 }
  
  /** If specified the place address will be updated to use this given address. */
  public func setStreetAddress(_ streetAddress: Any) {
    attributes[Attributes.streetAddress] = streetAddress as AnyObject
  }

  
  /** Whether or not this is a residential address.  Currently will always return an error if set to false. */
  public func setResidential(_ residential: Bool) {
    attributes[Attributes.residential] = residential as AnyObject
  }

  
}

public class ProMonitoringSettingsUpdateAddressResponse: SessionEvent {
  
}

/** Lists the departments which service a place, generally used to figure out where to get a permit from. */
public class ProMonitoringSettingsListDepartmentsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsListDepartments
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

      let error = ProMonitoringSettingsListDepartmentsError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return ProMonitoringSettingsListDepartmentsResponse(message)
  }

  
}

public class ProMonitoringSettingsListDepartmentsResponse: SessionEvent {
  
  
  /** The departments which service the current address. */
  public func getDepartments() -> [Any]? {
    return self.attributes["departments"] as? [Any]
  }
}

/** Gets the set of professionally monitored devices which are currently offline. */
public class ProMonitoringSettingsCheckSensorsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsCheckSensors
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
    return ProMonitoringSettingsCheckSensorsResponse(message)
  }

  
}

public class ProMonitoringSettingsCheckSensorsResponse: SessionEvent {
  
  
  /** The addresses of the professionally monitored devices which are offline. */
  public func getOffline() -> [String]? {
    return self.attributes["offline"] as? [String]
  }
}

/**           This enrolls and activates professional monitoring at the given place.  Billing will be updated and the place will be professionally monitored.          Note that if testCall is set to true this may return successfully, and then fail later if the test call fails.           */
public class ProMonitoringSettingsActivateRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProMonitoringSettingsActivateRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsActivate
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

      let error = ProMonitoringSettingsActivateError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return ProMonitoringSettingsActivateResponse(message)
  }

  // MARK: ActivateRequest Attributes
  struct Attributes {
    /** (Default: false) Set to true to invoke a test call and activate upon success.  Set to false / unspecified to activate without sending a test call. */
    static let testCall: String = "testCall"
 }
  
  /** (Default: false) Set to true to invoke a test call and activate upon success.  Set to false / unspecified to activate without sending a test call. */
  public func setTestCall(_ testCall: Bool) {
    attributes[Attributes.testCall] = testCall as AnyObject
  }

  
}

public class ProMonitoringSettingsActivateResponse: SessionEvent {
  
}

/**              This instructs the monitoring service to place a call to the number associated with the place.  This call will return immediately, but the lastCallStatus should be watched to determine when the test call is completed.             Note that if a test call is already in progress this will return the existing testCallTime, and as such may be retried safely.           */
public class ProMonitoringSettingsTestCallRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsTestCall
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
    return ProMonitoringSettingsTestCallResponse(message)
  }

  
}

public class ProMonitoringSettingsTestCallResponse: SessionEvent {
  
  
  /** This is the start time for testCallTime.  This may be used to ensure that the state on promonitoringconfig is valid before checking for completion (in case a previous test call has been executed.) */
  public func getTestCallTime() -> Date? {
    return self.attributes["testCallTime"] as? Date
  }
}

/** Downgrades the account to premium, deactivates the place and clears all promonitoring settings */
public class ProMonitoringSettingsResetRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringSettingsReset
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
    return ProMonitoringSettingsResetResponse(message)
  }

  
}

public class ProMonitoringSettingsResetResponse: SessionEvent {
  
}

