
//
// ProMonitoringServiceEvents.swift
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
  /** Gets the promonitoring settings for the specified place. */
  public static let proMonitoringServiceGetSettings: String = "promon:GetSettings"
  /** Gets the promonitoring metadata that represents UCC caller id data for each area as a list of phone numbers */
  public static let proMonitoringServiceGetMetaData: String = "promon:GetMetaData"
  /** Check promonitoring availability for the given zipcode and state */
  public static let proMonitoringServiceCheckAvailability: String = "promon:CheckAvailability"
  
}
// MARK: Errors
public struct ProMonitoringServiceCheckAvailabilityError: ArcusError {
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
    /** The zipcode is not recognized by the platform. */
    case zipUnrecognized = "zip.unrecognized"
    
  }
}

// MARK: Requests

/** Gets the promonitoring settings for the specified place. */
public class ProMonitoringServiceGetSettingsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProMonitoringServiceGetSettingsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringServiceGetSettings
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
    return ProMonitoringServiceGetSettingsResponse(message)
  }
  // MARK: GetSettingsRequest Attributes
  struct Attributes {
    /** The place address to load the settings for */
    static let place: String = "place"
 }
  
  /** The place address to load the settings for */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
}

public class ProMonitoringServiceGetSettingsResponse: SessionEvent {
  
  
  /** The promonitoring settings for the given place. */
  public func getSettings() -> Any? {
    return self.attributes["settings"]
  }
}

/** Gets the promonitoring metadata that represents UCC caller id data for each area as a list of phone numbers */
public class ProMonitoringServiceGetMetaDataRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringServiceGetMetaData
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
    return ProMonitoringServiceGetMetaDataResponse(message)
  }
  
}

public class ProMonitoringServiceGetMetaDataResponse: SessionEvent {
  
  
  /** A list of known UCC caller id phone numbers */
  public func getMetadata() -> [String]? {
    return self.attributes["metadata"] as? [String]
  }
}

/** Check promonitoring availability for the given zipcode and state */
public class ProMonitoringServiceCheckAvailabilityRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProMonitoringServiceCheckAvailabilityRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.proMonitoringServiceCheckAvailability
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

      let error = ProMonitoringServiceCheckAvailabilityError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return ProMonitoringServiceCheckAvailabilityResponse(message)
  }
  // MARK: CheckAvailabilityRequest Attributes
  struct Attributes {
    /** 5 digits US postal codes */
    static let zipcode: String = "zipcode"
/** The US postal service 2 character state code (such as KS, CA, NY). */
    static let state: String = "state"
 }
  
  /** 5 digits US postal codes */
  public func setZipcode(_ zipcode: String) {
    attributes[Attributes.zipcode] = zipcode as AnyObject
  }

  
  /** The US postal service 2 character state code (such as KS, CA, NY). */
  public func setState(_ state: String) {
    attributes[Attributes.state] = state as AnyObject
  }

  
}

public class ProMonitoringServiceCheckAvailabilityResponse: SessionEvent {
  
  
  /** The availability result */
  public enum ProMonitoringServiceAvailability: String {
    case none = "NONE"
    case trial = "TRIAL"
    case full = "FULL"
    
  }
  /** The availability result */
  public func getAvailability() -> ProMonitoringServiceAvailability? {
    guard let attribute = self.attributes["availability"] as? String,
      let enumAttr: ProMonitoringServiceAvailability = ProMonitoringServiceAvailability(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

