
//
// DeviceAdvancedCapEvents.swift
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
  /** Upgrades the driver for this device to the driver specified.  If not specified it will look for the most current driver for this device. */
  static let deviceAdvancedUpgradeDriver: String = "devadv:UpgradeDriver"
  /** Gets the currently defined reflexes for the driver as a json object. */
  static let deviceAdvancedGetReflexes: String = "devadv:GetReflexes"
  /** Attempts to re-apply initial configuration for the device, this may leave it in an unusable state if it fails. */
  static let deviceAdvancedReconfigure: String = "devadv:Reconfigure"
  
}
// MARK: Events
public struct DeviceAdvancedEvents {
  /** Sent when a device has been removed for any reason. This may be very specific to the given protocol and require client interpretation. */
  public static let deviceAdvancedRemovedDevice: String = "devadv:RemovedDevice"
  }

// MARK: Enumerations

/** The state of the driver.            CREATED - Transient state meaning the device has been created but the driver is not running.  Clients should not see this state generally.            PROVISIONING - The driver is still in the process of configuring the device for initial use.            ACTIVE - The driver is fully loaded.  Note there may be additional error preventing it from running &#x27;normally&#x27;, see devadv:errors.            UNSUPPORTED - The device is using the fallback driver, it is not really supported by the platform.  This is often due to pairing errors, in which case devadv:errors will be populated.            RECOVERABLE - The device has been deleted from the hub, but may be recovered by re-pairing it with the hub.            UNRECOVERABLE - The device has been deleted from the hub and it is not possible to re-pair it.            TOMBSTONED - The user has force removed the device but it still exists in the hub database.             */
public enum DeviceAdvancedDriverstate: String {
  case created = "CREATED"
  case provisioning = "PROVISIONING"
  case active = "ACTIVE"
  case unsupported = "UNSUPPORTED"
  case recoverable = "RECOVERABLE"
  case unrecoverable = "UNRECOVERABLE"
  case tombstoned = "TOMBSTONED"
}

// MARK: Requests

/** Upgrades the driver for this device to the driver specified.  If not specified it will look for the most current driver for this device. */
public class DeviceAdvancedUpgradeDriverRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DeviceAdvancedUpgradeDriverRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.deviceAdvancedUpgradeDriver
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
    return DeviceAdvancedUpgradeDriverResponse(message)
  }

  // MARK: UpgradeDriverRequest Attributes
  struct Attributes {
    /** Optional driver name to upgrade this device to.  If specified driverVersion must also be provided. */
    static let driverName: String = "driverName"
/** Optional driver version to upgrade this device to.  If specified driverName must also be provided. */
    static let driverVersion: String = "driverVersion"
 }
  
  /** Optional driver name to upgrade this device to.  If specified driverVersion must also be provided. */
  public func setDriverName(_ driverName: String) {
    attributes[Attributes.driverName] = driverName as AnyObject
  }

  
  /** Optional driver version to upgrade this device to.  If specified driverName must also be provided. */
  public func setDriverVersion(_ driverVersion: String) {
    attributes[Attributes.driverVersion] = driverVersion as AnyObject
  }

  
}

public class DeviceAdvancedUpgradeDriverResponse: SessionEvent {
  
  
  /** The name of the driver after the platform has determined the new driver if any. */
  public func getDriverName() -> String? {
    return self.attributes["driverName"] as? String
  }
  /** The version of the driver after the platform has determined the new driver if any. */
  public func getDriverVersion() -> String? {
    return self.attributes["driverVersion"] as? String
  }
  /** True if the returned driver name and version are the result of an upgrade, false if they match the existing driver */
  public func getUpgraded() -> Bool? {
    return self.attributes["upgraded"] as? Bool
  }
}

/** Gets the currently defined reflexes for the driver as a json object. */
public class DeviceAdvancedGetReflexesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.deviceAdvancedGetReflexes
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
    return DeviceAdvancedGetReflexesResponse(message)
  }

  
}

public class DeviceAdvancedGetReflexesResponse: SessionEvent {
  
  
  /** The JSON representation of the device&#x27;s reflexes. */
  public func getReflexes() -> Any? {
    return self.attributes["reflexes"]
  }
}

/** Attempts to re-apply initial configuration for the device, this may leave it in an unusable state if it fails. */
public class DeviceAdvancedReconfigureRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.deviceAdvancedReconfigure
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
    return DeviceAdvancedReconfigureResponse(message)
  }

  
}

public class DeviceAdvancedReconfigureResponse: SessionEvent {
  
}

