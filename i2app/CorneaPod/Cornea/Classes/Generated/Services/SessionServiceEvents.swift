
//
// SessionServiceEvents.swift
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
  /** Sets the place that this session is associated with, the session will begin receiving broadcasts for the requested place */
  public static let sessionServiceSetActivePlace: String = "sess:SetActivePlace"
  /** Logs an event to the server */
  public static let sessionServiceLog: String = "sess:Log"
  /** Persists a UI analytics tag on the server */
  public static let sessionServiceTag: String = "sess:Tag"
  /** Lists the available places for the currently logged in user */
  public static let sessionServiceListAvailablePlaces: String = "sess:ListAvailablePlaces"
  /** Returns the preferences for the currently logged in user at their active place or empty if no preferences have been set or active place has not been set */
  public static let sessionServiceGetPreferences: String = "sess:GetPreferences"
  /** Sets the one or more preferences for the currently logged in user at their active place.  If a key is defined in their preferences but not specified here, it will not be cleared by this set. */
  public static let sessionServiceSetPreferences: String = "sess:SetPreferences"
  /** Resets the preference with the given key for the currently logged in user at their active place.  This will remove the preference and return this preference to default. */
  public static let sessionServiceResetPreference: String = "sess:ResetPreference"
  /** Lock the device by removing the mobile device record and logout the current session. */
  public static let sessionServiceLockDevice: String = "sess:LockDevice"
  
}
// MARK: Errors
public struct SessionServiceSetPreferencesError: ArcusError {
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
    /** If no active place is currently set. */
    case placeActiveNotSet = "place.active.notSet"
    
  }
}
// MARK: Errors
public struct SessionServiceResetPreferenceError: ArcusError {
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
    /** If no active place is currently set. */
    case placeActiveNotSet = "place.active.notSet"
    
  }
}

// MARK: Requests

/** Sets the place that this session is associated with, the session will begin receiving broadcasts for the requested place */
public class SessionServiceSetActivePlaceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SessionServiceSetActivePlaceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sessionServiceSetActivePlace
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
    return SessionServiceSetActivePlaceResponse(message)
  }
  // MARK: SetActivePlaceRequest Attributes
  struct Attributes {
    /** The id of the place to activate */
    static let placeId: String = "placeId"
 }
  
  /** The id of the place to activate */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class SessionServiceSetActivePlaceResponse: SessionEvent {
  
  
  /** The active place */
  public func getPlaceId() -> String? {
    return self.attributes["placeId"] as? String
  }
  /** Preferences for the currently logged in user at this place */
  public func getPreferences() -> Any? {
    return self.attributes["preferences"]
  }
}

/** Logs an event to the server */
public class SessionServiceLogRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SessionServiceLogRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sessionServiceLog
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
    return SessionServiceLogResponse(message)
  }
  // MARK: LogRequest Attributes
  struct Attributes {
    /** The category for the log message */
    static let category: String = "category"
/** A unique code for the event that happened */
    static let code: String = "code"
/** An optional message to include */
    static let message: String = "message"
 }
  
  /** The category for the log message */
  public func setCategory(_ category: String) {
    attributes[Attributes.category] = category as AnyObject
  }

  
  /** A unique code for the event that happened */
  public func setCode(_ code: String) {
    attributes[Attributes.code] = code as AnyObject
  }

  
  /** An optional message to include */
  public func setMessage(_ message: String) {
    attributes[Attributes.message] = message as AnyObject
  }

  
}

public class SessionServiceLogResponse: SessionEvent {
  
}

/** Persists a UI analytics tag on the server */
public class SessionServiceTagRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SessionServiceTagRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sessionServiceTag
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
    return SessionServiceTagResponse(message)
  }
  // MARK: TagRequest Attributes
  struct Attributes {
    /** The name of the analytic event */
    static let name: String = "name"
/** Additional data associated with the event */
    static let context: String = "context"
 }
  
  /** The name of the analytic event */
  public func setName(_ name: String) {
    attributes[Attributes.name] = name as AnyObject
  }

  
  /** Additional data associated with the event */
  public func setContext(_ context: [String: String]) {
    attributes[Attributes.context] = context as AnyObject
  }

  
}

public class SessionServiceTagResponse: SessionEvent {
  
}

/** Lists the available places for the currently logged in user */
public class SessionServiceListAvailablePlacesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.sessionServiceListAvailablePlaces
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
    return SessionServiceListAvailablePlacesResponse(message)
  }
  
}

public class SessionServiceListAvailablePlacesResponse: SessionEvent {
  
  
  /** The places the currently logged in user has access */
  public func getPlaces() -> [Any]? {
    return self.attributes["places"] as? [Any]
  }
}

/** Returns the preferences for the currently logged in user at their active place or empty if no preferences have been set or active place has not been set */
public class SessionServiceGetPreferencesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.sessionServiceGetPreferences
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
    return SessionServiceGetPreferencesResponse(message)
  }
  
}

public class SessionServiceGetPreferencesResponse: SessionEvent {
  
  
  /** Preferences for the the currently logged in user at their active place */
  public func getPrefs() -> Any? {
    return self.attributes["prefs"]
  }
}

/** Sets the one or more preferences for the currently logged in user at their active place.  If a key is defined in their preferences but not specified here, it will not be cleared by this set. */
public class SessionServiceSetPreferencesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SessionServiceSetPreferencesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sessionServiceSetPreferences
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

      let error = SessionServiceSetPreferencesError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return SessionServiceSetPreferencesResponse(message)
  }
  // MARK: SetPreferencesRequest Attributes
  struct Attributes {
    /** Preferences to set for the the currently logged in user at their active place */
    static let prefs: String = "prefs"
 }
  
  /** Preferences to set for the the currently logged in user at their active place */
  public func setPrefs(_ prefs: Any) {
    attributes[Attributes.prefs] = prefs as AnyObject
  }

  
}

public class SessionServiceSetPreferencesResponse: SessionEvent {
  
}

/** Resets the preference with the given key for the currently logged in user at their active place.  This will remove the preference and return this preference to default. */
public class SessionServiceResetPreferenceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SessionServiceResetPreferenceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sessionServiceResetPreference
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

      let error = SessionServiceResetPreferenceError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return SessionServiceResetPreferenceResponse(message)
  }
  // MARK: ResetPreferenceRequest Attributes
  struct Attributes {
    /** Key of the preference to reset */
    static let prefKey: String = "prefKey"
 }
  
  /** Key of the preference to reset */
  public func setPrefKey(_ prefKey: String) {
    attributes[Attributes.prefKey] = prefKey as AnyObject
  }

  
}

public class SessionServiceResetPreferenceResponse: SessionEvent {
  
}

/** Lock the device by removing the mobile device record and logout the current session. */
public class SessionServiceLockDeviceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SessionServiceLockDeviceRequest Enumerations
  /** reason for the lock device call */
  public enum SessionServiceReason: String {
   case user_requested = "USER_REQUESTED"
   case touch_failed = "TOUCH_FAILED"
   
  }
  override init() {
    super.init()
    self.command = Commands.sessionServiceLockDevice
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
    return SessionServiceLockDeviceResponse(message)
  }
  // MARK: LockDeviceRequest Attributes
  struct Attributes {
    /** mobile device identifier */
    static let deviceIdentifier: String = "deviceIdentifier"
/** reason for the lock device call */
    static let reason: String = "reason"
 }
  
  /** mobile device identifier */
  public func setDeviceIdentifier(_ deviceIdentifier: String) {
    attributes[Attributes.deviceIdentifier] = deviceIdentifier as AnyObject
  }

  
  /** reason for the lock device call */
  public func setReason(_ reason: String) {
    if let value = SessionServiceReason(rawValue: reason) {
      attributes[Attributes.reason] = value.rawValue as AnyObject
    }
  }
  
}

public class SessionServiceLockDeviceResponse: SessionEvent {
  
}

