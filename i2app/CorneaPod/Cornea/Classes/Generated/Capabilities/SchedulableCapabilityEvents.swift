
//
// SchedulableCapEvents.swift
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
  /** Enables scheduling for this device */
  static let schedulableEnableSchedule: String = "schedulable:EnableSchedule"
  /** Disables scheduling for this device */
  static let schedulableDisableSchedule: String = "schedulable:DisableSchedule"
  
}

// MARK: Enumerations

/** The type of scheduling that is possible on this device. NOT_SUPPORTED:  No scheduling is possible either via Arcus or the physical device DEVICE_ONLY:  Scheduling is not possible via Arcus, but can be configured on the physical device DRIVER_READ_ONLY:  Arcus may read scheduling information via a driver specific implementation but cannot write schedule information DRIVER_WRITE_ONLY:  Arcus may write scheduling information via a driver specific implementation but cnnot read schedule information SUPPORTED_DRIVER:  Arcus may completely control scheduling of the device via a driver specific implementation (i.e. schedule is likely read and pushed to the device) SUPPORTED_CLOUD:  Arcus may completely control scheduling of the device via an internal mechanism (i.e. cloud or hub based)  */
public enum SchedulableType: String {
  case not_supported = "NOT_SUPPORTED"
  case device_only = "DEVICE_ONLY"
  case driver_read_only = "DRIVER_READ_ONLY"
  case driver_write_only = "DRIVER_WRITE_ONLY"
  case supported_driver = "SUPPORTED_DRIVER"
  case supported_cloud = "SUPPORTED_CLOUD"
}

// MARK: Requests

/** Enables scheduling for this device */
public class SchedulableEnableScheduleRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.schedulableEnableSchedule
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
    return SchedulableEnableScheduleResponse(message)
  }

  
}

public class SchedulableEnableScheduleResponse: SessionEvent {
  
}

/** Disables scheduling for this device */
public class SchedulableDisableScheduleRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.schedulableDisableSchedule
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
    return SchedulableDisableScheduleResponse(message)
  }

  
}

public class SchedulableDisableScheduleResponse: SessionEvent {
  
}

