
//
// KeyPadCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var keyPadNamespace: String = "keypad"
  public static var keyPadName: String = "KeyPad"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let keyPadAlarmState: String = "keypad:alarmState"
  static let keyPadAlarmMode: String = "keypad:alarmMode"
  static let keyPadAlarmSounder: String = "keypad:alarmSounder"
  static let keyPadEnabledSounds: String = "keypad:enabledSounds"
  
}

public protocol ArcusKeyPadCapability: class, RxArcusService {
  /**           Current alarm state of the keypad.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.  In this case the          keypad should avoid making transition noises (such as the armed or disarmed beeps).  However if the state is          ARMING, SOAKING, or ALERTING and the associated sounds are enabled it should beep accordingly.           */
  func getKeyPadAlarmState(_ model: DeviceModel) -> KeyPadAlarmState?
  /**           Current alarm state of the keypad.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.  In this case the          keypad should avoid making transition noises (such as the armed or disarmed beeps).  However if the state is          ARMING, SOAKING, or ALERTING and the associated sounds are enabled it should beep accordingly.           */
  func setKeyPadAlarmState(_ alarmState: KeyPadAlarmState, model: DeviceModel)
/**           The current mode of the alarm.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.           */
  func getKeyPadAlarmMode(_ model: DeviceModel) -> KeyPadAlarmMode?
  /**           The current mode of the alarm.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.           */
  func setKeyPadAlarmMode(_ alarmMode: KeyPadAlarmMode, model: DeviceModel)
/**           DEPRECATED           When set to ON enabledSounds should be set to [BUTTONS,DISARMED,ARMED,ARMING,SOAKING,ALERTING].          When set to OFF enabledSounds should be set to [].          If enabledSounds is set to a value other than [] this should be changed to ON.          If both alarmSounder and enabledSounds are set in the same request an error should be thrown.           */
  func getKeyPadAlarmSounder(_ model: DeviceModel) -> KeyPadAlarmSounder?
  /**           DEPRECATED           When set to ON enabledSounds should be set to [BUTTONS,DISARMED,ARMED,ARMING,SOAKING,ALERTING].          When set to OFF enabledSounds should be set to [].          If enabledSounds is set to a value other than [] this should be changed to ON.          If both alarmSounder and enabledSounds are set in the same request an error should be thrown.           */
  func setKeyPadAlarmSounder(_ alarmSounder: KeyPadAlarmSounder, model: DeviceModel)
/**           This contains the set of times when the keypad should play tones, the common combinations are:          Keypad Sounds On  / Normal Alarm  - [BUTTONS,DISARMED,ARMED,ARMING,SOAKING,ALERTING]          Keypad Sounds Off / Normal Alarm  - [ALERTING]          Keypad Sounds On  / Silent Alarm  - [BUTTONS,DISARMED,ARMED,ARMING]          Keypad Sounds Off / Silent Alarm  - []                    Each sound should be enabled if it is present in the set or disabled if it is not present:          BUTTONS - Button presses should beep          DISARMED - Play a tone when the keypad disarms          ARMING - Play an exit delay tone          ARMED - Play a tone when the keypad is armed          SOAKING - Play an entrance delay tone          ALERTING - Play an alert tone           */
  func getKeyPadEnabledSounds(_ model: DeviceModel) -> [Any]?
  /**           This contains the set of times when the keypad should play tones, the common combinations are:          Keypad Sounds On  / Normal Alarm  - [BUTTONS,DISARMED,ARMED,ARMING,SOAKING,ALERTING]          Keypad Sounds Off / Normal Alarm  - [ALERTING]          Keypad Sounds On  / Silent Alarm  - [BUTTONS,DISARMED,ARMED,ARMING]          Keypad Sounds Off / Silent Alarm  - []                    Each sound should be enabled if it is present in the set or disabled if it is not present:          BUTTONS - Button presses should beep          DISARMED - Play a tone when the keypad disarms          ARMING - Play an exit delay tone          ARMED - Play a tone when the keypad is armed          SOAKING - Play an entrance delay tone          ALERTING - Play an alert tone           */
  func setKeyPadEnabledSounds(_ enabledSounds: [Any], model: DeviceModel)

  /**           Tell the Keypad that the arming process has started (exit delay), if sounds are enabled this should beep for the specified period.          The delay should be used to allow the beep to speed up as the end of the time window is reached.          The driver should update alarmState to ARMING and alarmMode to match the requested alarmMode.           */
  func requestKeyPadBeginArming(_  model: DeviceModel, delayInS: Int, alarmMode: String)
   throws -> Observable<ArcusSessionEvent>/**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
  func requestKeyPadArmed(_  model: DeviceModel, alarmMode: String)
   throws -> Observable<ArcusSessionEvent>/**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
  func requestKeyPadDisarmed(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/**           Tell the Keypad that the alarm is preparing to go off (entrance delay), if sounds are enabled it should beep the tone matching the given mode.          The duration should be used to allow the beep to speed up as the end of the time window is reached.          This should update alarmState to SOAKING and alarmMode to match the requested alarmMode.           */
  func requestKeyPadSoaking(_  model: DeviceModel, durationInS: Int, alarmMode: String)
   throws -> Observable<ArcusSessionEvent>/**           Tell the Keypad that the alarm is currently alerting.          This should update alarmState to ALERTING and alarmMode to match the requested alarmMode.           */
  func requestKeyPadAlerting(_  model: DeviceModel, alarmMode: String)
   throws -> Observable<ArcusSessionEvent>/** Tell the Keypad to make a chime noise. */
  func requestKeyPadChime(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Tell the Keypad that the arming process cannot be started due to triggered devices */
  func requestKeyPadArmingUnavailable(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusKeyPadCapability {
  public func getKeyPadAlarmState(_ model: DeviceModel) -> KeyPadAlarmState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.keyPadAlarmState] as? String,
      let enumAttr: KeyPadAlarmState = KeyPadAlarmState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setKeyPadAlarmState(_ alarmState: KeyPadAlarmState, model: DeviceModel) {
    model.set([Attributes.keyPadAlarmState: alarmState.rawValue as AnyObject])
  }
  public func getKeyPadAlarmMode(_ model: DeviceModel) -> KeyPadAlarmMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.keyPadAlarmMode] as? String,
      let enumAttr: KeyPadAlarmMode = KeyPadAlarmMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setKeyPadAlarmMode(_ alarmMode: KeyPadAlarmMode, model: DeviceModel) {
    model.set([Attributes.keyPadAlarmMode: alarmMode.rawValue as AnyObject])
  }
  public func getKeyPadAlarmSounder(_ model: DeviceModel) -> KeyPadAlarmSounder? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.keyPadAlarmSounder] as? String,
      let enumAttr: KeyPadAlarmSounder = KeyPadAlarmSounder(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setKeyPadAlarmSounder(_ alarmSounder: KeyPadAlarmSounder, model: DeviceModel) {
    model.set([Attributes.keyPadAlarmSounder: alarmSounder.rawValue as AnyObject])
  }
  public func getKeyPadEnabledSounds(_ model: DeviceModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.keyPadEnabledSounds] as? [Any]
  }
  
  public func setKeyPadEnabledSounds(_ enabledSounds: [Any], model: DeviceModel) {
    model.set([Attributes.keyPadEnabledSounds: enabledSounds as AnyObject])
  }
  
  public func requestKeyPadBeginArming(_  model: DeviceModel, delayInS: Int, alarmMode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: KeyPadBeginArmingRequest = KeyPadBeginArmingRequest()
    request.source = model.address
    
    
    
    request.setDelayInS(delayInS)
    
    request.setAlarmMode(alarmMode)
    
    return try sendRequest(request)
  }
  
  public func requestKeyPadArmed(_  model: DeviceModel, alarmMode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: KeyPadArmedRequest = KeyPadArmedRequest()
    request.source = model.address
    
    
    
    request.setAlarmMode(alarmMode)
    
    return try sendRequest(request)
  }
  
  public func requestKeyPadDisarmed(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: KeyPadDisarmedRequest = KeyPadDisarmedRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestKeyPadSoaking(_  model: DeviceModel, durationInS: Int, alarmMode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: KeyPadSoakingRequest = KeyPadSoakingRequest()
    request.source = model.address
    
    
    
    request.setDurationInS(durationInS)
    
    request.setAlarmMode(alarmMode)
    
    return try sendRequest(request)
  }
  
  public func requestKeyPadAlerting(_  model: DeviceModel, alarmMode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: KeyPadAlertingRequest = KeyPadAlertingRequest()
    request.source = model.address
    
    
    
    request.setAlarmMode(alarmMode)
    
    return try sendRequest(request)
  }
  
  public func requestKeyPadChime(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: KeyPadChimeRequest = KeyPadChimeRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestKeyPadArmingUnavailable(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: KeyPadArmingUnavailableRequest = KeyPadArmingUnavailableRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
