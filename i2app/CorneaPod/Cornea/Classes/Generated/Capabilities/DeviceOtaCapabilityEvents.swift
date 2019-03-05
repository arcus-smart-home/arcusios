
//
// DeviceOtaCapEvents.swift
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
  /** Requests that the hub update its firmware */
  static let deviceOtaFirmwareUpdate: String = "devota:FirmwareUpdate"
  /** Requests that the hub cancel an existing firmware update */
  static let deviceOtaFirmwareUpdateCancel: String = "devota:FirmwareUpdateCancel"
  
}
// MARK: Events
public struct DeviceOtaEvents {
  /** Sent when a device has been removed for any reason. This may be very specific to the given protocol and require client interpretation. */
  public static let deviceOtaFirmwareUpdateProgress: String = "devota:FirmwareUpdateProgress"
  }

// MARK: Enumerations

/** Status of the current firmware update process. */
public enum DeviceOtaStatus: String {
  case idle = "IDLE"
  case inprogress = "INPROGRESS"
  case completed = "COMPLETED"
  case failed = "FAILED"
}

// MARK: Requests

/** Requests that the hub update its firmware */
public class DeviceOtaFirmwareUpdateRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DeviceOtaFirmwareUpdateRequest Enumerations
  /** The priority of the firmware update. Updates at NORMAL priority may be refused in some senarios. */
  public enum DeviceOtaPriority: String {
   case normal = "NORMAL"
   case urgent = "URGENT"
   
  }
  override init() {
    super.init()
    self.command = Commands.deviceOtaFirmwareUpdate
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
    return DeviceOtaFirmwareUpdateResponse(message)
  }

  // MARK: FirmwareUpdateRequest Attributes
  struct Attributes {
    /** The URL of the firmware. */
    static let url: String = "url"
/** The priority of the firmware update. Updates at NORMAL priority may be refused in some senarios. */
    static let priority: String = "priority"
/** An MD5 of the firmware if devices require it for validation of the download. */
    static let md5: String = "md5"
 }
  
  /** The URL of the firmware. */
  public func setUrl(_ url: String) {
    attributes[Attributes.url] = url as AnyObject
  }

  
  /** The priority of the firmware update. Updates at NORMAL priority may be refused in some senarios. */
  public func setPriority(_ priority: String) {
    if let value: DeviceOtaPriority = DeviceOtaPriority(rawValue: priority) {
      attributes[Attributes.priority] = value.rawValue as AnyObject
    }
  }
  
  /** An MD5 of the firmware if devices require it for validation of the download. */
  public func setMd5(_ md5: String) {
    attributes[Attributes.md5] = md5 as AnyObject
  }

  
}

public class DeviceOtaFirmwareUpdateResponse: SessionEvent {
  
  
  /** The status code result for the firmware update request. */
  public enum DeviceOtaStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    case failed = "FAILED"
    
  }
  /** The status code result for the firmware update request. */
  public func getStatus() -> DeviceOtaStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: DeviceOtaStatus = DeviceOtaStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the returned status code. */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Requests that the hub cancel an existing firmware update */
public class DeviceOtaFirmwareUpdateCancelRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.deviceOtaFirmwareUpdateCancel
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
    return DeviceOtaFirmwareUpdateCancelResponse(message)
  }

  
}

public class DeviceOtaFirmwareUpdateCancelResponse: SessionEvent {
  
  
  /** The status code result for the firmware update cancel request. */
  public enum DeviceOtaStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    case failed = "FAILED"
    
  }
  /** The status code result for the firmware update cancel request. */
  public func getStatus() -> DeviceOtaStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: DeviceOtaStatus = DeviceOtaStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the returned status code. */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

