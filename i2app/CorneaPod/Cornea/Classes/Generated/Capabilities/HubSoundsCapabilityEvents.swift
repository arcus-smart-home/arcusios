
//
// HubSoundsCapEvents.swift
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
  /** Causes the hub to play the chime sound. */
  static let hubSoundsPlayTone: String = "hubsounds:PlayTone"
  /** Stop playing any sound. */
  static let hubSoundsQuiet: String = "hubsounds:Quiet"
  
}

// MARK: Enumerations

// MARK: Requests

/** Causes the hub to play the chime sound. */
public class HubSoundsPlayToneRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubSoundsPlayToneRequest Enumerations
  /** Prebuilt in sound to play from the hub. */
  public enum HubSoundsTone: String {
   case no_sound = "NO_SOUND"
   case armed = "ARMED"
   case arming = "ARMING"
   case intruder = "INTRUDER"
   case low_battery = "LOW_BATTERY"
   case paired = "PAIRED"
   case safety = "SAFETY"
   case unpaired = "UNPAIRED"
   case success_triple = "SUCCESS_TRIPLE"
   case success_single = "SUCCESS_SINGLE"
   case success_removal = "SUCCESS_REMOVAL"
   case startup = "STARTUP"
   case failed = "FAILED"
   case success_disarm = "SUCCESS_DISARM"
   case security_alarm = "SECURITY_ALARM"
   case panic_alarm = "PANIC_ALARM"
   case smoke_alarm = "SMOKE_ALARM"
   case co_alarm = "CO_ALARM"
   case water_leak_alarm = "WATER_LEAK_ALARM"
   case care_alarm = "CARE_ALARM"
   case button_press = "BUTTON_PRESS"
   case double_button_press = "DOUBLE_BUTTON_PRESS"
   case success_reboot = "SUCCESS_REBOOT"
   case door_chime_1 = "DOOR_CHIME_1"
   case door_chime_2 = "DOOR_CHIME_2"
   case door_chime_3 = "DOOR_CHIME_3"
   case door_chime_4 = "DOOR_CHIME_4"
   case door_chime_5 = "DOOR_CHIME_5"
   case door_chime_6 = "DOOR_CHIME_6"
   case door_chime_7 = "DOOR_CHIME_7"
   case door_chime_8 = "DOOR_CHIME_8"
   case door_chime_9 = "DOOR_CHIME_9"
   case door_chime_10 = "DOOR_CHIME_10"
   case ethernet_inserted = "ETHERNET_INSERTED"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubSoundsPlayTone
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
    return HubSoundsPlayToneResponse(message)
  }

  // MARK: PlayToneRequest Attributes
  struct Attributes {
    /** Prebuilt in sound to play from the hub. */
    static let tone: String = "tone"
/** How long to play the tone. */
    static let durationSec: String = "durationSec"
 }
  
  /** Prebuilt in sound to play from the hub. */
  public func setTone(_ tone: String) {
    if let value: HubSoundsTone = HubSoundsTone(rawValue: tone) {
      attributes[Attributes.tone] = value.rawValue as AnyObject
    }
  }
  
  /** How long to play the tone. */
  public func setDurationSec(_ durationSec: Int) {
    attributes[Attributes.durationSec] = durationSec as AnyObject
  }

  
}

public class HubSoundsPlayToneResponse: SessionEvent {
  
}

/** Stop playing any sound. */
public class HubSoundsQuietRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubSoundsQuiet
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
    return HubSoundsQuietResponse(message)
  }

  
}

public class HubSoundsQuietResponse: SessionEvent {
  
}

