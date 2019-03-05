
//
// AlarmSubsystemCap.swift
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
  public static var alarmSubsystemNamespace: String = "subalarm"
  public static var alarmSubsystemName: String = "AlarmSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let alarmSubsystemAlarmState: String = "subalarm:alarmState"
  static let alarmSubsystemSecurityMode: String = "subalarm:securityMode"
  static let alarmSubsystemSecurityArmTime: String = "subalarm:securityArmTime"
  static let alarmSubsystemLastArmedTime: String = "subalarm:lastArmedTime"
  static let alarmSubsystemLastArmedBy: String = "subalarm:lastArmedBy"
  static let alarmSubsystemLastArmedFrom: String = "subalarm:lastArmedFrom"
  static let alarmSubsystemLastDisarmedTime: String = "subalarm:lastDisarmedTime"
  static let alarmSubsystemLastDisarmedBy: String = "subalarm:lastDisarmedBy"
  static let alarmSubsystemLastDisarmedFrom: String = "subalarm:lastDisarmedFrom"
  static let alarmSubsystemActiveAlerts: String = "subalarm:activeAlerts"
  static let alarmSubsystemAvailableAlerts: String = "subalarm:availableAlerts"
  static let alarmSubsystemMonitoredAlerts: String = "subalarm:monitoredAlerts"
  static let alarmSubsystemCurrentIncident: String = "subalarm:currentIncident"
  static let alarmSubsystemCallTree: String = "subalarm:callTree"
  static let alarmSubsystemTestModeEnabled: String = "subalarm:testModeEnabled"
  static let alarmSubsystemFanShutoffSupported: String = "subalarm:fanShutoffSupported"
  static let alarmSubsystemFanShutoffOnSmoke: String = "subalarm:fanShutoffOnSmoke"
  static let alarmSubsystemFanShutoffOnCO: String = "subalarm:fanShutoffOnCO"
  static let alarmSubsystemRecordingSupported: String = "subalarm:recordingSupported"
  static let alarmSubsystemRecordOnSecurity: String = "subalarm:recordOnSecurity"
  static let alarmSubsystemRecordingDurationSec: String = "subalarm:recordingDurationSec"
  static let alarmSubsystemAlarmProvider: String = "subalarm:alarmProvider"
  static let alarmSubsystemRequestedAlarmProvider: String = "subalarm:requestedAlarmProvider"
  static let alarmSubsystemLastAlarmProviderAttempt: String = "subalarm:lastAlarmProviderAttempt"
  static let alarmSubsystemLastAlarmProviderError: String = "subalarm:lastAlarmProviderError"
  
}

public protocol ArcusAlarmSubsystemCapability: class, RxArcusService {
  /** The combined state of the alarm across all alerts. */
  func getAlarmSubsystemAlarmState(_ model: SubsystemModel) -> AlarmSubsystemAlarmState?
  /** The state of the security alarm. */
  func getAlarmSubsystemSecurityMode(_ model: SubsystemModel) -> AlarmSubsystemSecurityMode?
  /** The time at which the security system was or will be armed.  This will be cleared when the security system is disarmed. */
  func getAlarmSubsystemSecurityArmTime(_ model: SubsystemModel) -> Date?
  /** The last time the security alarm was armed. */
  func getAlarmSubsystemLastArmedTime(_ model: SubsystemModel) -> Date?
  /** The address of the last person to arm the security alarm, this may be empty if it was armed from a scene or a rule. */
  func getAlarmSubsystemLastArmedBy(_ model: SubsystemModel) -> String?
  /** The address of the keypad, rule, scene, or app the security alarm was armed from. */
  func getAlarmSubsystemLastArmedFrom(_ model: SubsystemModel) -> String?
  /** The last time at which the security system was disarmed. */
  func getAlarmSubsystemLastDisarmedTime(_ model: SubsystemModel) -> Date?
  /** The address of the last person to disarm the security alarm, this may be empty if it was disarmed from a scene or a rule. */
  func getAlarmSubsystemLastDisarmedBy(_ model: SubsystemModel) -> String?
  /** The address of the keypad, rule, scene, or app the security alarm was disarmed from. */
  func getAlarmSubsystemLastDisarmedFrom(_ model: SubsystemModel) -> String?
  /** A priority ordered list of alerts that are currently active.  Note that the banner should always use the first element from this list, it is ordered. */
  func getAlarmSubsystemActiveAlerts(_ model: SubsystemModel) -> [Any]?
  /** The set of alarms which are supported by the devices paired at the current place. */
  func getAlarmSubsystemAvailableAlerts(_ model: SubsystemModel) -> [Any]?
  /** The set of alarms which are professionally monitored. */
  func getAlarmSubsystemMonitoredAlerts(_ model: SubsystemModel) -> [Any]?
  /** The set of alarms which are professionally monitored. */
  func setAlarmSubsystemMonitoredAlerts(_ monitoredAlerts: [Any], model: SubsystemModel)
/** The currently incident, will be the empty string when there is no current incident.  This may stay populated for a period of time after this incident is over to notify the user that an incident happened next time they login.   Cancelling the incident or disarming from the keypad will clear out the current incident, although it will remain active until dispatch has completed.  When this field is populated the incident screen should be shown. */
  func getAlarmSubsystemCurrentIncident(_ model: SubsystemModel) -> String?
  /** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
  func getAlarmSubsystemCallTree(_ model: SubsystemModel) -> [Any]?
  /** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
  func setAlarmSubsystemCallTree(_ callTree: [Any], model: SubsystemModel)
/** Flag used by AlarmIncidentService. When true the service implementation should create a mock incident instead. Defaults to false */
  func getAlarmSubsystemTestModeEnabled(_ model: SubsystemModel) -> Bool?
  /** Flag used by AlarmIncidentService. When true the service implementation should create a mock incident instead. Defaults to false */
  func setAlarmSubsystemTestModeEnabled(_ testModeEnabled: Bool, model: SubsystemModel)
/** Indicates whether fanShutoffOnSmoke and fanShutoffOnCO are supported for the current place.  True if there are any fans, thermostats or space heaters at the current place. */
  func getAlarmSubsystemFanShutoffSupported(_ model: SubsystemModel) -> Bool?
  /** When set to true, all fans, thermostats and space heaters will be turned off when a Smoke alarm is triggered.  Defaults to false. */
  func getAlarmSubsystemFanShutoffOnSmoke(_ model: SubsystemModel) -> Bool?
  /** When set to true, all fans, thermostats and space heaters will be turned off when a Smoke alarm is triggered.  Defaults to false. */
  func setAlarmSubsystemFanShutoffOnSmoke(_ fanShutoffOnSmoke: Bool, model: SubsystemModel)
/** When set to true, all fans, thermostats and space heaters will be turned off when a CO alarm is triggered.  Defaults to true */
  func getAlarmSubsystemFanShutoffOnCO(_ model: SubsystemModel) -> Bool?
  /** When set to true, all fans, thermostats and space heaters will be turned off when a CO alarm is triggered.  Defaults to true */
  func setAlarmSubsystemFanShutoffOnCO(_ fanShutoffOnCO: Bool, model: SubsystemModel)
/** Whether or not the alarm subsystem supports recording on alarm.  This requires the user to have cameras and a premium / promonitoring service level to support recording. */
  func getAlarmSubsystemRecordingSupported(_ model: SubsystemModel) -> Bool?
  /** When set to true all cameras will record.  This flag may be true even if recordingSupported is false.  Default to be true. */
  func getAlarmSubsystemRecordOnSecurity(_ model: SubsystemModel) -> Bool?
  /** When set to true all cameras will record.  This flag may be true even if recordingSupported is false.  Default to be true. */
  func setAlarmSubsystemRecordOnSecurity(_ recordOnSecurity: Bool, model: SubsystemModel)
/** The number of seconds to record for when a security alarm is triggered.  Default to be 60 seconds. */
  func getAlarmSubsystemRecordingDurationSec(_ model: SubsystemModel) -> Int?
  /** The number of seconds to record for when a security alarm is triggered.  Default to be 60 seconds. */
  func setAlarmSubsystemRecordingDurationSec(_ recordingDurationSec: Int, model: SubsystemModel)
/** The provider of the alarming implementation. Defaults to PLATFORM. */
  func getAlarmSubsystemAlarmProvider(_ model: SubsystemModel) -> AlarmSubsystemAlarmProvider?
  /** The provider of the alarming implementation that was requested. Defaults to HUB */
  func getAlarmSubsystemRequestedAlarmProvider(_ model: SubsystemModel) -> AlarmSubsystemRequestedAlarmProvider?
  /** The last time at which the change of provider of the alarming implementation requested. */
  func getAlarmSubsystemLastAlarmProviderAttempt(_ model: SubsystemModel) -> Date?
  /** The error message upon the last change of provider of the alarming implementation. */
  func getAlarmSubsystemLastAlarmProviderError(_ model: SubsystemModel) -> String?
  
  /** Immediately puts the alarm into ALERT mode and record the lastAlertCause as PANIC.  If it is in ALERT this will have no affect.  If it is in any other state this will return an error.The cause will be recorded as the lastAlertCause. */
  func requestAlarmSubsystemListIncidents(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
  func requestAlarmSubsystemArm(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent>/** Attempts to arm the alarm into the requested mode, excluding any offline or currently tripped devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
  func requestAlarmSubsystemArmBypassed(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent>/** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
  func requestAlarmSubsystemDisarm(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Triggers the PANIC alarm. */
  func requestAlarmSubsystemPanic(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** . */
  func requestAlarmSubsystemSetProvider(_  model: SubsystemModel, provider: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusAlarmSubsystemCapability {
  public func getAlarmSubsystemAlarmState(_ model: SubsystemModel) -> AlarmSubsystemAlarmState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmSubsystemAlarmState] as? String,
      let enumAttr: AlarmSubsystemAlarmState = AlarmSubsystemAlarmState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmSubsystemSecurityMode(_ model: SubsystemModel) -> AlarmSubsystemSecurityMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmSubsystemSecurityMode] as? String,
      let enumAttr: AlarmSubsystemSecurityMode = AlarmSubsystemSecurityMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmSubsystemSecurityArmTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alarmSubsystemSecurityArmTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAlarmSubsystemLastArmedTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alarmSubsystemLastArmedTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAlarmSubsystemLastArmedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemLastArmedBy] as? String
  }
  
  public func getAlarmSubsystemLastArmedFrom(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemLastArmedFrom] as? String
  }
  
  public func getAlarmSubsystemLastDisarmedTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alarmSubsystemLastDisarmedTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAlarmSubsystemLastDisarmedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemLastDisarmedBy] as? String
  }
  
  public func getAlarmSubsystemLastDisarmedFrom(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemLastDisarmedFrom] as? String
  }
  
  public func getAlarmSubsystemActiveAlerts(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemActiveAlerts] as? [Any]
  }
  
  public func getAlarmSubsystemAvailableAlerts(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemAvailableAlerts] as? [Any]
  }
  
  public func getAlarmSubsystemMonitoredAlerts(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemMonitoredAlerts] as? [Any]
  }
  
  public func setAlarmSubsystemMonitoredAlerts(_ monitoredAlerts: [Any], model: SubsystemModel) {
    model.set([Attributes.alarmSubsystemMonitoredAlerts: monitoredAlerts as AnyObject])
  }
  public func getAlarmSubsystemCurrentIncident(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemCurrentIncident] as? String
  }
  
  public func getAlarmSubsystemCallTree(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemCallTree] as? [Any]
  }
  
  public func setAlarmSubsystemCallTree(_ callTree: [Any], model: SubsystemModel) {
    model.set([Attributes.alarmSubsystemCallTree: callTree as AnyObject])
  }
  public func getAlarmSubsystemTestModeEnabled(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemTestModeEnabled] as? Bool
  }
  
  public func setAlarmSubsystemTestModeEnabled(_ testModeEnabled: Bool, model: SubsystemModel) {
    model.set([Attributes.alarmSubsystemTestModeEnabled: testModeEnabled as AnyObject])
  }
  public func getAlarmSubsystemFanShutoffSupported(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemFanShutoffSupported] as? Bool
  }
  
  public func getAlarmSubsystemFanShutoffOnSmoke(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemFanShutoffOnSmoke] as? Bool
  }
  
  public func setAlarmSubsystemFanShutoffOnSmoke(_ fanShutoffOnSmoke: Bool, model: SubsystemModel) {
    model.set([Attributes.alarmSubsystemFanShutoffOnSmoke: fanShutoffOnSmoke as AnyObject])
  }
  public func getAlarmSubsystemFanShutoffOnCO(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemFanShutoffOnCO] as? Bool
  }
  
  public func setAlarmSubsystemFanShutoffOnCO(_ fanShutoffOnCO: Bool, model: SubsystemModel) {
    model.set([Attributes.alarmSubsystemFanShutoffOnCO: fanShutoffOnCO as AnyObject])
  }
  public func getAlarmSubsystemRecordingSupported(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemRecordingSupported] as? Bool
  }
  
  public func getAlarmSubsystemRecordOnSecurity(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemRecordOnSecurity] as? Bool
  }
  
  public func setAlarmSubsystemRecordOnSecurity(_ recordOnSecurity: Bool, model: SubsystemModel) {
    model.set([Attributes.alarmSubsystemRecordOnSecurity: recordOnSecurity as AnyObject])
  }
  public func getAlarmSubsystemRecordingDurationSec(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemRecordingDurationSec] as? Int
  }
  
  public func setAlarmSubsystemRecordingDurationSec(_ recordingDurationSec: Int, model: SubsystemModel) {
    model.set([Attributes.alarmSubsystemRecordingDurationSec: recordingDurationSec as AnyObject])
  }
  public func getAlarmSubsystemAlarmProvider(_ model: SubsystemModel) -> AlarmSubsystemAlarmProvider? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmSubsystemAlarmProvider] as? String,
      let enumAttr: AlarmSubsystemAlarmProvider = AlarmSubsystemAlarmProvider(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmSubsystemRequestedAlarmProvider(_ model: SubsystemModel) -> AlarmSubsystemRequestedAlarmProvider? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmSubsystemRequestedAlarmProvider] as? String,
      let enumAttr: AlarmSubsystemRequestedAlarmProvider = AlarmSubsystemRequestedAlarmProvider(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmSubsystemLastAlarmProviderAttempt(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alarmSubsystemLastAlarmProviderAttempt] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAlarmSubsystemLastAlarmProviderError(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSubsystemLastAlarmProviderError] as? String
  }
  
  
  public func requestAlarmSubsystemListIncidents(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: AlarmSubsystemListIncidentsRequest = AlarmSubsystemListIncidentsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAlarmSubsystemArm(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AlarmSubsystemArmRequest = AlarmSubsystemArmRequest()
    request.source = model.address
    
    
    
    request.setMode(mode)
    
    return try sendRequest(request)
  }
  
  public func requestAlarmSubsystemArmBypassed(_  model: SubsystemModel, mode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AlarmSubsystemArmBypassedRequest = AlarmSubsystemArmBypassedRequest()
    request.source = model.address
    
    
    
    request.setMode(mode)
    
    return try sendRequest(request)
  }
  
  public func requestAlarmSubsystemDisarm(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: AlarmSubsystemDisarmRequest = AlarmSubsystemDisarmRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAlarmSubsystemPanic(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: AlarmSubsystemPanicRequest = AlarmSubsystemPanicRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAlarmSubsystemSetProvider(_  model: SubsystemModel, provider: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AlarmSubsystemSetProviderRequest = AlarmSubsystemSetProviderRequest()
    request.source = model.address
    
    
    
    request.setProvider(provider)
    
    return try sendRequest(request)
  }
  
}
