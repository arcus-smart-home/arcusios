
//
// DeviceCapEvents.swift
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
  /** Returns a list of all the history log entries associated with this device */
  static let deviceListHistoryEntries: String = "dev:ListHistoryEntries"
  /**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the Device. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This may put the hub in unpairing mode depending on the device being removed.           */
  static let deviceRemove: String = "dev:Remove"
  /** Sent to request that a device be removed. */
  static let deviceForceRemove: String = "dev:ForceRemove"
  
}
// MARK: Events
public struct DeviceEvents {
  /** Sent when a device comes online. This may be very specific to the given protocol and require client interpretation. */
  public static let deviceDeviceConnected: String = "dev:DeviceConnected"
  /** Sent when a device goes offline. This may be very specific to the given protocol and require client interpretation.  Not all drivers will be able to detect this event. */
  public static let deviceDeviceDisconnected: String = "dev:DeviceDisconnected"
  /** Sent when a device is removed. */
  public static let deviceDeviceRemoved: String = "dev:DeviceRemoved"
  }

// MARK: Enumerations

// MARK: Requests

/** Returns a list of all the history log entries associated with this device */
public class DeviceListHistoryEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DeviceListHistoryEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.deviceListHistoryEntries
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
    return DeviceListHistoryEntriesResponse(message)
  }

  // MARK: ListHistoryEntriesRequest Attributes
  struct Attributes {
    /** The maximum number of events to return (defaults to 10) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results */
    static let token: String = "token"
 }
  
  /** The maximum number of events to return (defaults to 10) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
}

public class DeviceListHistoryEntriesResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this device */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

/**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the Device. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This may put the hub in unpairing mode depending on the device being removed.           */
public class DeviceRemoveRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DeviceRemoveRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.deviceRemove
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
    return DeviceRemoveResponse(message)
  }

  // MARK: RemoveRequest Attributes
  struct Attributes {
    /** The number of milliseconds that device removal is expected for.  Defaults to 5 minutes if not specified. */
    static let timeout: String = "timeout"
 }
  
  /** The number of milliseconds that device removal is expected for.  Defaults to 5 minutes if not specified. */
  public func setTimeout(_ timeout: Int) {
    attributes[Attributes.timeout] = timeout as AnyObject
  }

  
}

public class DeviceRemoveResponse: SessionEvent {
  
  
  /** The mode of removal. */
  public enum DeviceMode: String {
    case cloud = "CLOUD"
    case hub_automatic = "HUB_AUTOMATIC"
    case hub_manual = "HUB_MANUAL"
    
  }
  /** The removal steps for the given device.  Will be empty for devices that support autonomous removal. */
  public func getSteps() -> [Any]? {
    return self.attributes["steps"] as? [Any]
  }
  /** The mode of removal. */
  public func getMode() -> DeviceMode? {
    guard let attribute = self.attributes["mode"] as? String,
      let enumAttr: DeviceMode = DeviceMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The URL for a removal video. */
  public func getVideo() -> String? {
    return self.attributes["video"] as? String
  }
}

/** Sent to request that a device be removed. */
public class DeviceForceRemoveRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.deviceForceRemove
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
    return DeviceForceRemoveResponse(message)
  }

  
}

public class DeviceForceRemoveResponse: SessionEvent {
  
}

