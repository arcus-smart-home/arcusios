
//
// HaloCapEvents.swift
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
  /** Start a new hush process (assumes device is in pre-alert state). */
  static let haloStartHush: String = "halo:StartHush"
  /** Send when user says Halo is flashing a particular color. */
  static let haloSendHush: String = "halo:SendHush"
  /** Cancel out of current hush process. */
  static let haloCancelHush: String = "halo:CancelHush"
  /** Run test cycle on the Halo. Should be moved to some generic capability. */
  static let haloStartTest: String = "halo:StartTest"
  
}

// MARK: Enumerations

/** Current state of Halo device. */
public enum HaloDevicestate: String {
  case safe = "SAFE"
  case weather = "WEATHER"
  case smoke = "SMOKE"
  case co = "CO"
  case pre_smoke = "PRE_SMOKE"
  case eol = "EOL"
  case low_battery = "LOW_BATTERY"
  case very_low_battery = "VERY_LOW_BATTERY"
  case failed_battery = "FAILED_BATTERY"
}

/** Current status of Hush process. */
public enum HaloHushstatus: String {
  case success = "SUCCESS"
  case timeout = "TIMEOUT"
  case ready = "READY"
  case disabled = "DISABLED"
}

/** This is the room type description for the location of the Halo device, which can be read out in an alert. */
public enum HaloRoom: String {
  case none = "NONE"
  case basement = "BASEMENT"
  case bedroom = "BEDROOM"
  case den = "DEN"
  case dining_room = "DINING_ROOM"
  case downstairs = "DOWNSTAIRS"
  case entryway = "ENTRYWAY"
  case family_room = "FAMILY_ROOM"
  case game_room = "GAME_ROOM"
  case guest_bedroom = "GUEST_BEDROOM"
  case hallway = "HALLWAY"
  case kids_bedroom = "KIDS_BEDROOM"
  case living_room = "LIVING_ROOM"
  case master_bedroom = "MASTER_BEDROOM"
  case office = "OFFICE"
  case study = "STUDY"
  case upstairs = "UPSTAIRS"
  case workout_room = "WORKOUT_ROOM"
}

/** Response code from remote test of the halo test feature. */
public enum HaloRemotetestresult: String {
  case success = "SUCCESS"
  case fail_ion_sensor = "FAIL_ION_SENSOR"
  case fail_photo_sensor = "FAIL_PHOTO_SENSOR"
  case fail_co_sensor = "FAIL_CO_SENSOR"
  case fail_temp_sensor = "FAIL_TEMP_SENSOR"
  case fail_weather_radio = "FAIL_WEATHER_RADIO"
  case fail_other = "FAIL_OTHER"
}

/** State of the Arcus system, as transmited to Halo to be indicated to the user through lights and sound. */
public enum HaloHaloalertstate: String {
  case quiet = "QUIET"
  case intruder = "INTRUDER"
  case panic = "PANIC"
  case water = "WATER"
  case smoke = "SMOKE"
  case co = "CO"
  case care = "CARE"
  case alerting_generic = "ALERTING_GENERIC"
}

// MARK: Requests

/** Start a new hush process (assumes device is in pre-alert state). */
public class HaloStartHushRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.haloStartHush
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
    return HaloStartHushResponse(message)
  }

  
}

public class HaloStartHushResponse: SessionEvent {
  
  
  /** Was the halo in a proper state to start hush: smoke per-alert or smoke alert (but not denied due to &gt;4% UL requirement). */
  public func getHushstarted() -> Bool? {
    return self.attributes["hushstarted"] as? Bool
  }
}

/** Send when user says Halo is flashing a particular color. */
public class HaloSendHushRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HaloSendHushRequest Enumerations
  /** Color the user says is being currently displayed by Halo in the Hush process. */
  public enum HaloColor: String {
   case red = "RED"
   case blue = "BLUE"
   case green = "GREEN"
   
  }
  override init() {
    super.init()
    self.command = Commands.haloSendHush
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
    return HaloSendHushResponse(message)
  }

  // MARK: SendHushRequest Attributes
  struct Attributes {
    /** Color the user says is being currently displayed by Halo in the Hush process. */
    static let color: String = "color"
 }
  
  /** Color the user says is being currently displayed by Halo in the Hush process. */
  public func setColor(_ color: String) {
    if let value: HaloColor = HaloColor(rawValue: color) {
      attributes[Attributes.color] = value.rawValue as AnyObject
    }
  }
  
}

public class HaloSendHushResponse: SessionEvent {
  
}

/** Cancel out of current hush process. */
public class HaloCancelHushRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.haloCancelHush
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
    return HaloCancelHushResponse(message)
  }

  
}

public class HaloCancelHushResponse: SessionEvent {
  
}

/** Run test cycle on the Halo. Should be moved to some generic capability. */
public class HaloStartTestRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.haloStartTest
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
    return HaloStartTestResponse(message)
  }

  
}

public class HaloStartTestResponse: SessionEvent {
  
}

