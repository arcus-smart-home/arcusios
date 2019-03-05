
//
// SecuritySubsystemCap.swift
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
  public static var securitySubsystemNamespace: String = "subsecurity"
  public static var securitySubsystemName: String = "SecuritySubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let securitySubsystemSecurityDevices: String = "subsecurity:securityDevices"
  static let securitySubsystemTriggeredDevices: String = "subsecurity:triggeredDevices"
  static let securitySubsystemReadyDevices: String = "subsecurity:readyDevices"
  static let securitySubsystemArmedDevices: String = "subsecurity:armedDevices"
  static let securitySubsystemBypassedDevices: String = "subsecurity:bypassedDevices"
  static let securitySubsystemOfflineDevices: String = "subsecurity:offlineDevices"
  static let securitySubsystemKeypads: String = "subsecurity:keypads"
  static let securitySubsystemAlarmState: String = "subsecurity:alarmState"
  static let securitySubsystemAlarmMode: String = "subsecurity:alarmMode"
  static let securitySubsystemLastAlertTime: String = "subsecurity:lastAlertTime"
  static let securitySubsystemLastAlertCause: String = "subsecurity:lastAlertCause"
  static let securitySubsystemCurrentAlertTriggers: String = "subsecurity:currentAlertTriggers"
  static let securitySubsystemCurrentAlertCause: String = "subsecurity:currentAlertCause"
  static let securitySubsystemLastAlertTriggers: String = "subsecurity:lastAlertTriggers"
  static let securitySubsystemLastAcknowledgement: String = "subsecurity:lastAcknowledgement"
  static let securitySubsystemLastAcknowledgementTime: String = "subsecurity:lastAcknowledgementTime"
  static let securitySubsystemLastAcknowledgedBy: String = "subsecurity:lastAcknowledgedBy"
  static let securitySubsystemLastArmedTime: String = "subsecurity:lastArmedTime"
  static let securitySubsystemLastArmedBy: String = "subsecurity:lastArmedBy"
  static let securitySubsystemLastDisarmedTime: String = "subsecurity:lastDisarmedTime"
  static let securitySubsystemLastDisarmedBy: String = "subsecurity:lastDisarmedBy"
  static let securitySubsystemCallTreeEnabled: String = "subsecurity:callTreeEnabled"
  static let securitySubsystemCallTree: String = "subsecurity:callTree"
  static let securitySubsystemKeypadArmBypassedTimeOutSec: String = "subsecurity:keypadArmBypassedTimeOutSec"
  static let securitySubsystemBlacklistedSecurityDevices: String = "subsecurity:blacklistedSecurityDevices"
  
}

public protocol ArcusSecuritySubsystemCapability: class, RxArcusService {
  /** The addresses of all the security devices in the safety alarm subsystem.  This includes sensor devices (contact and motion), input devices (keypads), and output devices (sirens). Whether or not these devices actually participate in any alarm states depend on the alarm mode. */
  func getSecuritySubsystemSecurityDevices(_ model: SubsystemModel) -> [String]?
  /** Devices which are ready to be armed, this set is empty the the alarmState is not DISARMED.  This will only include sensors. */
  func getSecuritySubsystemTriggeredDevices(_ model: SubsystemModel) -> [String]?
  /** Devices which are ready to be armed, this set is empty the the alarmState is not DISARMED.  This will only include sensors. */
  func getSecuritySubsystemReadyDevices(_ model: SubsystemModel) -> [String]?
  /** Devices which may result in triggering an alarm.  This set is empty when the alarmState is DISARMED. Note that armedDevices / bypassedDevices / offlineDevices are disjoint, a value will only appear in one of these sets at a time.  Additionally when the alarm is not​ DISARMED the union of these sets should equals devices:{alarmMode}. */
  func getSecuritySubsystemArmedDevices(_ model: SubsystemModel) -> [String]?
  /** Devices which are online and would normally be armed in the current mode but have been explicitly bypassed via ArmBypassed.  This set is empty when alarmState is DISARMED. Note that armedDevices / bypassedDevices / offlineDevices are disjoint, a value will only appear in one of these sets at a time.  Additionally when the alarm is not DISARMED the union of these sets should equals devices:{alarmMode}. */
  func getSecuritySubsystemBypassedDevices(_ model: SubsystemModel) -> [String]?
  /** Devices which would normally be armed in the current mode but have fallen offline.  This state takes precedent over bypassedDevices. Note that armedDevices / bypassedDevices / offlineDevices are disjoint, a value will only appear in one of these sets at a time.  Additionally when the alarm is not DISARMED the union of these sets should equals devices:{alarmMode}. */
  func getSecuritySubsystemOfflineDevices(_ model: SubsystemModel) -> [String]?
  /** Keypad devices */
  func getSecuritySubsystemKeypads(_ model: SubsystemModel) -> [String]?
  /** Indicates the current state of the alarm:     DISARMED - The alarm is currently DISARMED.  Note that any devices in the triggered or warning state may prevent the alarm from going to fully armed.     ARMING - The alarm is in the process of arming, delaying giving users a chance to leave the house.     ARMED - Indicate the alarm is armed and any security device may trigger an alarm.  See armedDevices to determine which devices might trigger the alarm.     ALERT - The alarm is &#x27;going off&#x27;.  Any sirens are triggered, the call tree is activated, etc.     CLEARING - The alarm has been acknowledged and the system is waiting for all devices to no longer be triggered at which point it will return to DISARMED     SOAKING - An armed secuirty device has triggered the alarm and the system is waiting for the alarm to be disarmed. */
  func getSecuritySubsystemAlarmState(_ model: SubsystemModel) -> SecuritySubsystemAlarmState?
  /** If the alarmState is &#x27;DISARMED&#x27; this will be OFF.  Otherwise it will be id of the alarmMode which is currently active. */
  func getSecuritySubsystemAlarmMode(_ model: SubsystemModel) -> SecuritySubsystemAlarmMode?
  /** The last time the alarm was fired. */
  func getSecuritySubsystemLastAlertTime(_ model: SubsystemModel) -> Date?
  /** The reason the alarm was fired. */
  func getSecuritySubsystemLastAlertCause(_ model: SubsystemModel) -> String?
  /** A map of address to timestamp of when a device was triggered during an alert.  This map will not be populated until the alarm enters the alert state. Note this will only include the first time a device was triggered during an alert.  For more detailed information see the history log. */
  func getSecuritySubsystemCurrentAlertTriggers(_ model: SubsystemModel) -> [String: Double]?
  /** The reason the current alert was raised */
  func getSecuritySubsystemCurrentAlertCause(_ model: SubsystemModel) -> SecuritySubsystemCurrentAlertCause?
  /** A map of address to timestamp of when a device was triggered during an alert.  This map will not be populated until the alarm enters the soak state. Note this will only include the first time a device was triggered during an alert.  For more detailed information see the history log. */
  func getSecuritySubsystemLastAlertTriggers(_ model: SubsystemModel) -> [String: Double]?
  /** The current state of acknowledgement:     PENDING - Arcus is attempting to notify the user that an alarm has been triggered     ACKNOWLEDGED - One of the persons from the call tree has acknowledged the alarm     FAILED - No one acknowledged the alarm but no one was available to acknowledged it. */
  func getSecuritySubsystemLastAcknowledgement(_ model: SubsystemModel) -> SecuritySubsystemLastAcknowledgement?
  /** The last time the alarm was acknowledged. */
  func getSecuritySubsystemLastAcknowledgementTime(_ model: SubsystemModel) -> Date?
  /** The actor that acknowledge the alarm when lastAcknowledgement is ACKNOWLEDGED.  Otherwise this field will be empty. */
  func getSecuritySubsystemLastAcknowledgedBy(_ model: SubsystemModel) -> String?
  /** The last time the alarm was armed. */
  func getSecuritySubsystemLastArmedTime(_ model: SubsystemModel) -> Date?
  /** The actor that armed the alarm, if available.  If it can&#x27;t be determined this will be empty. */
  func getSecuritySubsystemLastArmedBy(_ model: SubsystemModel) -> String?
  /** The last time the alarm was disarmed. */
  func getSecuritySubsystemLastDisarmedTime(_ model: SubsystemModel) -> Date?
  /** The actor that disarmed the alarm, if available.  If it can&#x27;t be determined this will be empty. */
  func getSecuritySubsystemLastDisarmedBy(_ model: SubsystemModel) -> String?
  /** Set to true if the account is PREMIUM, indicating the callTree will be used for alerts. Set to false if the account is BASIC, indicating that only the account owner will be notified. */
  func getSecuritySubsystemCallTreeEnabled(_ model: SubsystemModel) -> Bool?
  /** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
  func getSecuritySubsystemCallTree(_ model: SubsystemModel) -> [Any]?
  /** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
  func setSecuritySubsystemCallTree(_ callTree: [Any], model: SubsystemModel)
/** The number of seconds the subsystem will allow for a second keypad ON push to armbypassed the system. */
  func getSecuritySubsystemKeypadArmBypassedTimeOutSec(_ model: SubsystemModel) -> Int?
  /** The number of seconds the subsystem will allow for a second keypad ON push to armbypassed the system. */
  func setSecuritySubsystemKeypadArmBypassedTimeOutSec(_ keypadArmBypassedTimeOutSec: Int, model: SubsystemModel)
/** The addresses of all the devices that are blacklisted, and therefore not considered as security devices. */
  func getSecuritySubsystemBlacklistedSecurityDevices(_ model: SubsystemModel) -> [String]?
  
  /** Immediately puts the alarm into ALERT mode and record the lastAlertCause as PANIC.  If it is in ALERT this will have no affect.  If it is in any other state this will return an error.The cause will be recorded as the lastAlertCause. */
  func requestSecuritySubsystemPanic(_  model: SubsystemModel, silent: Bool)
   throws -> Observable<ArcusSessionEvent>/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If any devices associated with the alarm mode are triggered, this will return an error with code &#x27;TriggeredDevices&#x27;. */
  func requestSecuritySubsystemArm(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent>/** Attempts to arm the alarm into the request mode, bypassing any triggered devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If all devices in the requested mode are faulted, this will return an error. */
  func requestSecuritySubsystemArmBypassed(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent>/** This call acknowledges the alarm and indicates the given user is taking responsibility for dealing with it.  This will stop call tree processing but not stop the alerts. */
  func requestSecuritySubsystemAcknowledge(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Requests that the alarm be returned to the disarmed state.  If the alarm is currently in Alert then this will acknowledge the alarm (if it was not previously acknowledged) and transition to CLEARING. */
  func requestSecuritySubsystemDisarm(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSecuritySubsystemCapability {
  public func getSecuritySubsystemSecurityDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemSecurityDevices] as? [String]
  }
  
  public func getSecuritySubsystemTriggeredDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemTriggeredDevices] as? [String]
  }
  
  public func getSecuritySubsystemReadyDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemReadyDevices] as? [String]
  }
  
  public func getSecuritySubsystemArmedDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemArmedDevices] as? [String]
  }
  
  public func getSecuritySubsystemBypassedDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemBypassedDevices] as? [String]
  }
  
  public func getSecuritySubsystemOfflineDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemOfflineDevices] as? [String]
  }
  
  public func getSecuritySubsystemKeypads(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemKeypads] as? [String]
  }
  
  public func getSecuritySubsystemAlarmState(_ model: SubsystemModel) -> SecuritySubsystemAlarmState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.securitySubsystemAlarmState] as? String,
      let enumAttr: SecuritySubsystemAlarmState = SecuritySubsystemAlarmState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSecuritySubsystemAlarmMode(_ model: SubsystemModel) -> SecuritySubsystemAlarmMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.securitySubsystemAlarmMode] as? String,
      let enumAttr: SecuritySubsystemAlarmMode = SecuritySubsystemAlarmMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSecuritySubsystemLastAlertTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.securitySubsystemLastAlertTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSecuritySubsystemLastAlertCause(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemLastAlertCause] as? String
  }
  
  public func getSecuritySubsystemCurrentAlertTriggers(_ model: SubsystemModel) -> [String: Double]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemCurrentAlertTriggers] as? [String: Double]
  }
  
  public func getSecuritySubsystemCurrentAlertCause(_ model: SubsystemModel) -> SecuritySubsystemCurrentAlertCause? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.securitySubsystemCurrentAlertCause] as? String,
      let enumAttr: SecuritySubsystemCurrentAlertCause = SecuritySubsystemCurrentAlertCause(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSecuritySubsystemLastAlertTriggers(_ model: SubsystemModel) -> [String: Double]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemLastAlertTriggers] as? [String: Double]
  }
  
  public func getSecuritySubsystemLastAcknowledgement(_ model: SubsystemModel) -> SecuritySubsystemLastAcknowledgement? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.securitySubsystemLastAcknowledgement] as? String,
      let enumAttr: SecuritySubsystemLastAcknowledgement = SecuritySubsystemLastAcknowledgement(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSecuritySubsystemLastAcknowledgementTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.securitySubsystemLastAcknowledgementTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSecuritySubsystemLastAcknowledgedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemLastAcknowledgedBy] as? String
  }
  
  public func getSecuritySubsystemLastArmedTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.securitySubsystemLastArmedTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSecuritySubsystemLastArmedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemLastArmedBy] as? String
  }
  
  public func getSecuritySubsystemLastDisarmedTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.securitySubsystemLastDisarmedTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSecuritySubsystemLastDisarmedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemLastDisarmedBy] as? String
  }
  
  public func getSecuritySubsystemCallTreeEnabled(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemCallTreeEnabled] as? Bool
  }
  
  public func getSecuritySubsystemCallTree(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemCallTree] as? [Any]
  }
  
  public func setSecuritySubsystemCallTree(_ callTree: [Any], model: SubsystemModel) {
    model.set([Attributes.securitySubsystemCallTree: callTree as AnyObject])
  }
  public func getSecuritySubsystemKeypadArmBypassedTimeOutSec(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemKeypadArmBypassedTimeOutSec] as? Int
  }
  
  public func setSecuritySubsystemKeypadArmBypassedTimeOutSec(_ keypadArmBypassedTimeOutSec: Int, model: SubsystemModel) {
    model.set([Attributes.securitySubsystemKeypadArmBypassedTimeOutSec: keypadArmBypassedTimeOutSec as AnyObject])
  }
  public func getSecuritySubsystemBlacklistedSecurityDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securitySubsystemBlacklistedSecurityDevices] as? [String]
  }
  
  
  public func requestSecuritySubsystemPanic(_  model: SubsystemModel, silent: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: SecuritySubsystemPanicRequest = SecuritySubsystemPanicRequest()
    request.source = model.address
    
    
    
    request.setSilent(silent)
    
    return try sendRequest(request)
  }
  
  public func requestSecuritySubsystemArm(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SecuritySubsystemArmRequest = SecuritySubsystemArmRequest()
    request.source = model.address
    
    
    
    request.setMode(mode)
    
    return try sendRequest(request)
  }
  
  public func requestSecuritySubsystemArmBypassed(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SecuritySubsystemArmBypassedRequest = SecuritySubsystemArmBypassedRequest()
    request.source = model.address
    
    
    
    request.setMode(mode)
    
    return try sendRequest(request)
  }
  
  public func requestSecuritySubsystemAcknowledge(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: SecuritySubsystemAcknowledgeRequest = SecuritySubsystemAcknowledgeRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSecuritySubsystemDisarm(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: SecuritySubsystemDisarmRequest = SecuritySubsystemDisarmRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
