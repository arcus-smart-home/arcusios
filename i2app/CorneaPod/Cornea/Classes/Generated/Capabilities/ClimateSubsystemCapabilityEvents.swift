
//
// ClimateSubsystemCapEvents.swift
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
  /** Enables the scheduler associated with the given thermostat.  NOTE this will return a &#x27;timezone.notset&#x27; error if the place does not have a valid timezone. */
  static let climateSubsystemEnableScheduler: String = "subclimate:EnableScheduler"
  /** Enables the scheduler associated with the given thermostat. */
  static let climateSubsystemDisableScheduler: String = "subclimate:DisableScheduler"
  
}

// MARK: Enumerations

// MARK: Requests

/** Enables the scheduler associated with the given thermostat.  NOTE this will return a &#x27;timezone.notset&#x27; error if the place does not have a valid timezone. */
public class ClimateSubsystemEnableSchedulerRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ClimateSubsystemEnableSchedulerRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.climateSubsystemEnableScheduler
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
    return ClimateSubsystemEnableSchedulerResponse(message)
  }

  // MARK: EnableSchedulerRequest Attributes
  struct Attributes {
    /** The address of the thermostat to enable the schedule for */
    static let thermostat: String = "thermostat"
 }
  
  /** The address of the thermostat to enable the schedule for */
  public func setThermostat(_ thermostat: String) {
    attributes[Attributes.thermostat] = thermostat as AnyObject
  }

  
}

public class ClimateSubsystemEnableSchedulerResponse: SessionEvent {
  
}

/** Enables the scheduler associated with the given thermostat. */
public class ClimateSubsystemDisableSchedulerRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ClimateSubsystemDisableSchedulerRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.climateSubsystemDisableScheduler
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
    return ClimateSubsystemDisableSchedulerResponse(message)
  }

  // MARK: DisableSchedulerRequest Attributes
  struct Attributes {
    /** The address of the thermostat to disable the schedule for */
    static let thermostat: String = "thermostat"
 }
  
  /** The address of the thermostat to disable the schedule for */
  public func setThermostat(_ thermostat: String) {
    attributes[Attributes.thermostat] = thermostat as AnyObject
  }

  
}

public class ClimateSubsystemDisableSchedulerResponse: SessionEvent {
  
}

