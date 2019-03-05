
//
// KeyPadCapEvents.swift
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
  /**           Tell the Keypad that the arming process has started (exit delay), if sounds are enabled this should beep for the specified period.          The delay should be used to allow the beep to speed up as the end of the time window is reached.          The driver should update alarmState to ARMING and alarmMode to match the requested alarmMode.           */
  static let keyPadBeginArming: String = "keypad:BeginArming"
  /**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
  static let keyPadArmed: String = "keypad:Armed"
  /**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
  static let keyPadDisarmed: String = "keypad:Disarmed"
  /**           Tell the Keypad that the alarm is preparing to go off (entrance delay), if sounds are enabled it should beep the tone matching the given mode.          The duration should be used to allow the beep to speed up as the end of the time window is reached.          This should update alarmState to SOAKING and alarmMode to match the requested alarmMode.           */
  static let keyPadSoaking: String = "keypad:Soaking"
  /**           Tell the Keypad that the alarm is currently alerting.          This should update alarmState to ALERTING and alarmMode to match the requested alarmMode.           */
  static let keyPadAlerting: String = "keypad:Alerting"
  /** Tell the Keypad to make a chime noise. */
  static let keyPadChime: String = "keypad:Chime"
  /** Tell the Keypad that the arming process cannot be started due to triggered devices */
  static let keyPadArmingUnavailable: String = "keypad:ArmingUnavailable"
  
}
// MARK: Events
public struct KeyPadEvents {
  /** The arm button has been pressed on the keypad. */
  public static let keyPadArmPressed: String = "keypad:ArmPressed"
  /** The disarm button has been pressed on the keypad. */
  public static let keyPadDisarmPressed: String = "keypad:DisarmPressed"
  /** The panic button has been pressed on the keypad. */
  public static let keyPadPanicPressed: String = "keypad:PanicPressed"
  /** User has typed in an invalid pin on the keypad, as verified by the Pin Management API. */
  public static let keyPadInvalidPinEntered: String = "keypad:InvalidPinEntered"
  }

// MARK: Enumerations

/**           Current alarm state of the keypad.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.  In this case the          keypad should avoid making transition noises (such as the armed or disarmed beeps).  However if the state is          ARMING, SOAKING, or ALERTING and the associated sounds are enabled it should beep accordingly.           */
public enum KeyPadAlarmState: String {
  case disarmed = "DISARMED"
  case armed = "ARMED"
  case arming = "ARMING"
  case alerting = "ALERTING"
  case soaking = "SOAKING"
}

/**           The current mode of the alarm.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.           */
public enum KeyPadAlarmMode: String {
  case on = "ON"
  case partial = "PARTIAL"
  case off = "OFF"
}

/**           DEPRECATED           When set to ON enabledSounds should be set to [BUTTONS,DISARMED,ARMED,ARMING,SOAKING,ALERTING].          When set to OFF enabledSounds should be set to [].          If enabledSounds is set to a value other than [] this should be changed to ON.          If both alarmSounder and enabledSounds are set in the same request an error should be thrown.           */
public enum KeyPadAlarmSounder: String {
  case on = "ON"
  case off = "OFF"
}

// MARK: Requests

/**           Tell the Keypad that the arming process has started (exit delay), if sounds are enabled this should beep for the specified period.          The delay should be used to allow the beep to speed up as the end of the time window is reached.          The driver should update alarmState to ARMING and alarmMode to match the requested alarmMode.           */
public class KeyPadBeginArmingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: KeyPadBeginArmingRequest Enumerations
  /** The mode the alarm should be armed into. */
  public enum KeyPadAlarmMode: String {
   case on = "ON"
   case partial = "PARTIAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.keyPadBeginArming
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
    return KeyPadBeginArmingResponse(message)
  }

  // MARK: BeginArmingRequest Attributes
  struct Attributes {
    /** The exit delay in seconds */
    static let delayInS: String = "delayInS"
/** The mode the alarm should be armed into. */
    static let alarmMode: String = "alarmMode"
 }
  
  /** The exit delay in seconds */
  public func setDelayInS(_ delayInS: Int) {
    attributes[Attributes.delayInS] = delayInS as AnyObject
  }

  
  /** The mode the alarm should be armed into. */
  public func setAlarmMode(_ alarmMode: String) {
    if let value: KeyPadAlarmMode = KeyPadAlarmMode(rawValue: alarmMode) {
      attributes[Attributes.alarmMode] = value.rawValue as AnyObject
    }
  }
  
}

public class KeyPadBeginArmingResponse: SessionEvent {
  
}

/**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
public class KeyPadArmedRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: KeyPadArmedRequest Enumerations
  /** The mode the alarm is armed into. */
  public enum KeyPadAlarmMode: String {
   case on = "ON"
   case partial = "PARTIAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.keyPadArmed
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
    return KeyPadArmedResponse(message)
  }

  // MARK: ArmedRequest Attributes
  struct Attributes {
    /** The mode the alarm is armed into. */
    static let alarmMode: String = "alarmMode"
 }
  
  /** The mode the alarm is armed into. */
  public func setAlarmMode(_ alarmMode: String) {
    if let value: KeyPadAlarmMode = KeyPadAlarmMode(rawValue: alarmMode) {
      attributes[Attributes.alarmMode] = value.rawValue as AnyObject
    }
  }
  
}

public class KeyPadArmedResponse: SessionEvent {
  
}

/**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
public class KeyPadDisarmedRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.keyPadDisarmed
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
    return KeyPadDisarmedResponse(message)
  }

  
}

public class KeyPadDisarmedResponse: SessionEvent {
  
}

/**           Tell the Keypad that the alarm is preparing to go off (entrance delay), if sounds are enabled it should beep the tone matching the given mode.          The duration should be used to allow the beep to speed up as the end of the time window is reached.          This should update alarmState to SOAKING and alarmMode to match the requested alarmMode.           */
public class KeyPadSoakingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: KeyPadSoakingRequest Enumerations
  /** The mode the alarm is armed into. */
  public enum KeyPadAlarmMode: String {
   case on = "ON"
   case partial = "PARTIAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.keyPadSoaking
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
    return KeyPadSoakingResponse(message)
  }

  // MARK: SoakingRequest Attributes
  struct Attributes {
    /** The mode the alarm is armed into. */
    static let durationInS: String = "durationInS"
/** The mode the alarm is armed into. */
    static let alarmMode: String = "alarmMode"
 }
  
  /** The mode the alarm is armed into. */
  public func setDurationInS(_ durationInS: Int) {
    attributes[Attributes.durationInS] = durationInS as AnyObject
  }

  
  /** The mode the alarm is armed into. */
  public func setAlarmMode(_ alarmMode: String) {
    if let value: KeyPadAlarmMode = KeyPadAlarmMode(rawValue: alarmMode) {
      attributes[Attributes.alarmMode] = value.rawValue as AnyObject
    }
  }
  
}

public class KeyPadSoakingResponse: SessionEvent {
  
}

/**           Tell the Keypad that the alarm is currently alerting.          This should update alarmState to ALERTING and alarmMode to match the requested alarmMode.           */
public class KeyPadAlertingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: KeyPadAlertingRequest Enumerations
  /** The mode the alarm is armed into. */
  public enum KeyPadAlarmMode: String {
   case on = "ON"
   case partial = "PARTIAL"
   case panic = "PANIC"
   
  }
  override init() {
    super.init()
    self.command = Commands.keyPadAlerting
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
    return KeyPadAlertingResponse(message)
  }

  // MARK: AlertingRequest Attributes
  struct Attributes {
    /** The mode the alarm is armed into. */
    static let alarmMode: String = "alarmMode"
 }
  
  /** The mode the alarm is armed into. */
  public func setAlarmMode(_ alarmMode: String) {
    if let value: KeyPadAlarmMode = KeyPadAlarmMode(rawValue: alarmMode) {
      attributes[Attributes.alarmMode] = value.rawValue as AnyObject
    }
  }
  
}

public class KeyPadAlertingResponse: SessionEvent {
  
}

/** Tell the Keypad to make a chime noise. */
public class KeyPadChimeRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.keyPadChime
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
    return KeyPadChimeResponse(message)
  }

  
}

public class KeyPadChimeResponse: SessionEvent {
  
}

/** Tell the Keypad that the arming process cannot be started due to triggered devices */
public class KeyPadArmingUnavailableRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.keyPadArmingUnavailable
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
    return KeyPadArmingUnavailableResponse(message)
  }

  
}

public class KeyPadArmingUnavailableResponse: SessionEvent {
  
}

