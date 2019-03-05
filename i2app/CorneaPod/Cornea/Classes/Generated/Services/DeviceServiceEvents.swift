
//
// DeviceServiceEvents.swift
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
  /** A request to synchronize the hub local reflexes with device services */
  public static let deviceServiceSyncDevices: String = "dev:SyncDevices"
  
}

// MARK: Requests

/** A request to synchronize the hub local reflexes with device services */
public class DeviceServiceSyncDevicesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DeviceServiceSyncDevicesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.deviceServiceSyncDevices
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
    return DeviceServiceSyncDevicesResponse(message)
  }
  // MARK: SyncDevicesRequest Attributes
  struct Attributes {
    /** The account identifier of the hub requesting synchronization */
    static let accountId: String = "accountId"
/** The place identifier of the hub requesting synchronization */
    static let placeId: String = "placeId"
/** The version of hub local reflexes currently supported by the hub */
    static let reflexVersion: String = "reflexVersion"
/** A base64 encoded and gzipped json list of SyncDeviceInfo objects */
    static let devices: String = "devices"
 }
  
  /** The account identifier of the hub requesting synchronization */
  public func setAccountId(_ accountId: String) {
    attributes[Attributes.accountId] = accountId as AnyObject
  }

  
  /** The place identifier of the hub requesting synchronization */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** The version of hub local reflexes currently supported by the hub */
  public func setReflexVersion(_ reflexVersion: Int) {
    attributes[Attributes.reflexVersion] = reflexVersion as AnyObject
  }

  
  /** A base64 encoded and gzipped json list of SyncDeviceInfo objects */
  public func setDevices(_ devices: String) {
    attributes[Attributes.devices] = devices as AnyObject
  }

  
}

public class DeviceServiceSyncDevicesResponse: SessionEvent {
  
  
  /** A map from person id to SHA-1 hashed pin for that person */
  public func getPins() -> [String: String]? {
    return self.attributes["pins"] as? [String: String]
  }
  /** A base64 encoded and gzipped json list of SyncDeviceState objects */
  public func getDevices() -> String? {
    return self.attributes["devices"] as? String
  }
  /** A base64 encoded and gzipped json list of ReflexDriverDefinition objects */
  public func getDrivers() -> String? {
    return self.attributes["drivers"] as? String
  }
}

