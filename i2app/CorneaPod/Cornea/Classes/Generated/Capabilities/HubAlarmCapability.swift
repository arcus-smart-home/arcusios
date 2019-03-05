
//
// HubAlarmCap.swift
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
  public static var hubAlarmNamespace: String = "hubalarm"
  public static var hubAlarmName: String = "HubAlarm"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubAlarmState: String = "hubalarm:state"
  static let hubAlarmAlarmState: String = "hubalarm:alarmState"
  static let hubAlarmSecurityMode: String = "hubalarm:securityMode"
  static let hubAlarmSecurityArmTime: String = "hubalarm:securityArmTime"
  static let hubAlarmLastArmedTime: String = "hubalarm:lastArmedTime"
  static let hubAlarmLastArmedBy: String = "hubalarm:lastArmedBy"
  static let hubAlarmLastArmedFrom: String = "hubalarm:lastArmedFrom"
  static let hubAlarmLastDisarmedTime: String = "hubalarm:lastDisarmedTime"
  static let hubAlarmLastDisarmedBy: String = "hubalarm:lastDisarmedBy"
  static let hubAlarmLastDisarmedFrom: String = "hubalarm:lastDisarmedFrom"
  static let hubAlarmActiveAlerts: String = "hubalarm:activeAlerts"
  static let hubAlarmAvailableAlerts: String = "hubalarm:availableAlerts"
  static let hubAlarmCurrentIncident: String = "hubalarm:currentIncident"
  static let hubAlarmReconnectReport: String = "hubalarm:reconnectReport"
  static let hubAlarmSecurityAlertState: String = "hubalarm:securityAlertState"
  static let hubAlarmSecurityDevices: String = "hubalarm:securityDevices"
  static let hubAlarmSecurityExcludedDevices: String = "hubalarm:securityExcludedDevices"
  static let hubAlarmSecurityActiveDevices: String = "hubalarm:securityActiveDevices"
  static let hubAlarmSecurityCurrentActive: String = "hubalarm:securityCurrentActive"
  static let hubAlarmSecurityOfflineDevices: String = "hubalarm:securityOfflineDevices"
  static let hubAlarmSecurityTriggeredDevices: String = "hubalarm:securityTriggeredDevices"
  static let hubAlarmSecurityTriggers: String = "hubalarm:securityTriggers"
  static let hubAlarmSecurityPreAlertEndTime: String = "hubalarm:securityPreAlertEndTime"
  static let hubAlarmSecuritySilent: String = "hubalarm:securitySilent"
  static let hubAlarmSecurityEntranceDelay: String = "hubalarm:securityEntranceDelay"
  static let hubAlarmSecuritySensitivity: String = "hubalarm:securitySensitivity"
  static let hubAlarmPanicAlertState: String = "hubalarm:panicAlertState"
  static let hubAlarmPanicActiveDevices: String = "hubalarm:panicActiveDevices"
  static let hubAlarmPanicOfflineDevices: String = "hubalarm:panicOfflineDevices"
  static let hubAlarmPanicTriggeredDevices: String = "hubalarm:panicTriggeredDevices"
  static let hubAlarmPanicTriggers: String = "hubalarm:panicTriggers"
  static let hubAlarmPanicSilent: String = "hubalarm:panicSilent"
  static let hubAlarmSmokeAlertState: String = "hubalarm:smokeAlertState"
  static let hubAlarmSmokeActiveDevices: String = "hubalarm:smokeActiveDevices"
  static let hubAlarmSmokeOfflineDevices: String = "hubalarm:smokeOfflineDevices"
  static let hubAlarmSmokeTriggeredDevices: String = "hubalarm:smokeTriggeredDevices"
  static let hubAlarmSmokeTriggers: String = "hubalarm:smokeTriggers"
  static let hubAlarmSmokeSilent: String = "hubalarm:smokeSilent"
  static let hubAlarmCoAlertState: String = "hubalarm:coAlertState"
  static let hubAlarmCoActiveDevices: String = "hubalarm:coActiveDevices"
  static let hubAlarmCoOfflineDevices: String = "hubalarm:coOfflineDevices"
  static let hubAlarmCoTriggeredDevices: String = "hubalarm:coTriggeredDevices"
  static let hubAlarmCoTriggers: String = "hubalarm:coTriggers"
  static let hubAlarmCoSilent: String = "hubalarm:coSilent"
  static let hubAlarmWaterAlertState: String = "hubalarm:waterAlertState"
  static let hubAlarmWaterActiveDevices: String = "hubalarm:waterActiveDevices"
  static let hubAlarmWaterOfflineDevices: String = "hubalarm:waterOfflineDevices"
  static let hubAlarmWaterTriggeredDevices: String = "hubalarm:waterTriggeredDevices"
  static let hubAlarmWaterTriggers: String = "hubalarm:waterTriggers"
  static let hubAlarmWaterSilent: String = "hubalarm:waterSilent"
  
}

public protocol ArcusHubAlarmCapability: class, RxArcusService {
  /** The current state of the hub local alarm subsystem. */
  func getHubAlarmState(_ model: HubAlarmModel) -> HubAlarmState?
  /** The combined state of the alarm across all alerts. */
  func getHubAlarmAlarmState(_ model: HubAlarmModel) -> HubAlarmAlarmState?
  /** The state of the security alarm. */
  func getHubAlarmSecurityMode(_ model: HubAlarmModel) -> HubAlarmSecurityMode?
  /** The time at which the security system was or will be armed.  This will be cleared when the security system is disarmed. */
  func getHubAlarmSecurityArmTime(_ model: HubAlarmModel) -> Date?
  /** The last time the security alarm was armed. */
  func getHubAlarmLastArmedTime(_ model: HubAlarmModel) -> Date?
  /** The address of the last person to arm the security alarm, this may be empty if it was armed from a scene or a rule. */
  func getHubAlarmLastArmedBy(_ model: HubAlarmModel) -> String?
  /** The address of the keypad, rule, scene, or app the security alarm was armed from. */
  func getHubAlarmLastArmedFrom(_ model: HubAlarmModel) -> String?
  /** The last time at which the security system was disarmed. */
  func getHubAlarmLastDisarmedTime(_ model: HubAlarmModel) -> Date?
  /** The address of the last person to disarm the security alarm, this may be empty if it was disarmed from a scene or a rule. */
  func getHubAlarmLastDisarmedBy(_ model: HubAlarmModel) -> String?
  /** The address of the keypad, rule, scene, or app the security alarm was disarmed from. */
  func getHubAlarmLastDisarmedFrom(_ model: HubAlarmModel) -> String?
  /** A priority ordered list of alerts that are currently active.  Note that the banner should always use the first element from this list, it is ordered. */
  func getHubAlarmActiveAlerts(_ model: HubAlarmModel) -> [Any]?
  /** The set of alarms which are supported by the devices paired at the current place. */
  func getHubAlarmAvailableAlerts(_ model: HubAlarmModel) -> [Any]?
  /** The currently incident, will be the empty string when there is no current incident. */
  func getHubAlarmCurrentIncident(_ model: HubAlarmModel) -> String?
  /** True if the report issued by the hub is due to a reconnect. */
  func getHubAlarmReconnectReport(_ model: HubAlarmModel) -> Bool?
  /** The current state of this alert. */
  func getHubAlarmSecurityAlertState(_ model: HubAlarmModel) -> HubAlarmSecurityAlertState?
  /** The addresss of all devices that could participate in the security alarm. */
  func getHubAlarmSecurityDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices that are excluded from participating in this alarm. */
  func getHubAlarmSecurityExcludedDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices that are participating in this alarm. */
  func getHubAlarmSecurityActiveDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices that were initially active at arm time. */
  func getHubAlarmSecurityCurrentActive(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices would be active except they have fallen offline. */
  func getHubAlarmSecurityOfflineDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices which are currently triggered. */
  func getHubAlarmSecurityTriggeredDevices(_ model: HubAlarmModel) -> [String]?
  /** The triggers associated with the current alert. */
  func getHubAlarmSecurityTriggers(_ model: HubAlarmModel) -> [Any]?
  /** The time at which the prealert time for the current incident expires. */
  func getHubAlarmSecurityPreAlertEndTime(_ model: HubAlarmModel) -> Date?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func getHubAlarmSecuritySilent(_ model: HubAlarmModel) -> Bool?
  /** The amount of time an alarm device must be triggering for before the alarm is fired for the current arming cycle..&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
  func getHubAlarmSecurityEntranceDelay(_ model: HubAlarmModel) -> Int?
  /** The number of alarm devices which must trigger before the alarm is fired for the current arming cycle.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
  func getHubAlarmSecuritySensitivity(_ model: HubAlarmModel) -> Int?
  /** The current state of this alert. */
  func getHubAlarmPanicAlertState(_ model: HubAlarmModel) -> HubAlarmPanicAlertState?
  /** The addresses of the devices that are participating in this alarm. */
  func getHubAlarmPanicActiveDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices would be active except they have fallen offline. */
  func getHubAlarmPanicOfflineDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices which are currently triggered. */
  func getHubAlarmPanicTriggeredDevices(_ model: HubAlarmModel) -> [String]?
  /** The triggers associated with the current alert. */
  func getHubAlarmPanicTriggers(_ model: HubAlarmModel) -> [Any]?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func getHubAlarmPanicSilent(_ model: HubAlarmModel) -> Bool?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func setHubAlarmPanicSilent(_ panicSilent: Bool, model: HubAlarmModel)
/** The current state of this alert. */
  func getHubAlarmSmokeAlertState(_ model: HubAlarmModel) -> HubAlarmSmokeAlertState?
  /** The addresses of the devices that are participating in this alarm. */
  func getHubAlarmSmokeActiveDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices would be active except they have fallen offline. */
  func getHubAlarmSmokeOfflineDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices which are currently triggered. */
  func getHubAlarmSmokeTriggeredDevices(_ model: HubAlarmModel) -> [String]?
  /** The triggers associated with the current alert. */
  func getHubAlarmSmokeTriggers(_ model: HubAlarmModel) -> [Any]?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func getHubAlarmSmokeSilent(_ model: HubAlarmModel) -> Bool?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func setHubAlarmSmokeSilent(_ smokeSilent: Bool, model: HubAlarmModel)
/** The current state of this alert. */
  func getHubAlarmCoAlertState(_ model: HubAlarmModel) -> HubAlarmCoAlertState?
  /** The addresses of the devices that are participating in this alarm. */
  func getHubAlarmCoActiveDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices would be active except they have fallen offline. */
  func getHubAlarmCoOfflineDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices which are currently triggered. */
  func getHubAlarmCoTriggeredDevices(_ model: HubAlarmModel) -> [String]?
  /** The triggers associated with the current alert. */
  func getHubAlarmCoTriggers(_ model: HubAlarmModel) -> [Any]?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func getHubAlarmCoSilent(_ model: HubAlarmModel) -> Bool?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func setHubAlarmCoSilent(_ coSilent: Bool, model: HubAlarmModel)
/** The current state of this alert. */
  func getHubAlarmWaterAlertState(_ model: HubAlarmModel) -> HubAlarmWaterAlertState?
  /** The addresses of the devices that are participating in this alarm. */
  func getHubAlarmWaterActiveDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices would be active except they have fallen offline. */
  func getHubAlarmWaterOfflineDevices(_ model: HubAlarmModel) -> [String]?
  /** The addresses of the devices which are currently triggered. */
  func getHubAlarmWaterTriggeredDevices(_ model: HubAlarmModel) -> [String]?
  /** The triggers associated with the current alert. */
  func getHubAlarmWaterTriggers(_ model: HubAlarmModel) -> [Any]?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func getHubAlarmWaterSilent(_ model: HubAlarmModel) -> Bool?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func setHubAlarmWaterSilent(_ waterSilent: Bool, model: HubAlarmModel)

  /** Puts the hub local alarm into an &#x27;active&#x27; state. */
  func requestHubAlarmActivate(_ model: HubAlarmModel) throws -> Observable<ArcusSessionEvent>/** Puts the subsystem into a &#x27;suspended&#x27; state. */
  func requestHubAlarmSuspend(_ model: HubAlarmModel) throws -> Observable<ArcusSessionEvent>/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
  func requestHubAlarmArm(_  model: HubAlarmModel, mode: String, bypassed: Bool, entranceDelaySecs: Int, exitDelaySecs: Int, alarmSensitivityDeviceCount: Int, silent: Bool, soundsEnabled: Bool, activeDevices: [String], armedBy: String, armedFrom: String)
   throws -> Observable<ArcusSessionEvent>/** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
  func requestHubAlarmDisarm(_  model: HubAlarmModel, disarmedBy: String, disarmedFrom: String)
   throws -> Observable<ArcusSessionEvent>/** Triggers the PANIC alarm. */
  func requestHubAlarmPanic(_  model: HubAlarmModel, source: String, event: String)
   throws -> Observable<ArcusSessionEvent>/** Issued by the platform when an incident has been fully canceled so the hub will clear out the current incident and related triggers. */
  func requestHubAlarmClearIncident(_ model: HubAlarmModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubAlarmCapability {
  public func getHubAlarmState(_ model: HubAlarmModel) -> HubAlarmState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmState] as? String,
      let enumAttr: HubAlarmState = HubAlarmState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmAlarmState(_ model: HubAlarmModel) -> HubAlarmAlarmState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmAlarmState] as? String,
      let enumAttr: HubAlarmAlarmState = HubAlarmAlarmState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmSecurityMode(_ model: HubAlarmModel) -> HubAlarmSecurityMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmSecurityMode] as? String,
      let enumAttr: HubAlarmSecurityMode = HubAlarmSecurityMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmSecurityArmTime(_ model: HubAlarmModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAlarmSecurityArmTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAlarmLastArmedTime(_ model: HubAlarmModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAlarmLastArmedTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAlarmLastArmedBy(_ model: HubAlarmModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmLastArmedBy] as? String
  }
  
  public func getHubAlarmLastArmedFrom(_ model: HubAlarmModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmLastArmedFrom] as? String
  }
  
  public func getHubAlarmLastDisarmedTime(_ model: HubAlarmModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAlarmLastDisarmedTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAlarmLastDisarmedBy(_ model: HubAlarmModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmLastDisarmedBy] as? String
  }
  
  public func getHubAlarmLastDisarmedFrom(_ model: HubAlarmModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmLastDisarmedFrom] as? String
  }
  
  public func getHubAlarmActiveAlerts(_ model: HubAlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmActiveAlerts] as? [Any]
  }
  
  public func getHubAlarmAvailableAlerts(_ model: HubAlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmAvailableAlerts] as? [Any]
  }
  
  public func getHubAlarmCurrentIncident(_ model: HubAlarmModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmCurrentIncident] as? String
  }
  
  public func getHubAlarmReconnectReport(_ model: HubAlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmReconnectReport] as? Bool
  }
  
  public func getHubAlarmSecurityAlertState(_ model: HubAlarmModel) -> HubAlarmSecurityAlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmSecurityAlertState] as? String,
      let enumAttr: HubAlarmSecurityAlertState = HubAlarmSecurityAlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmSecurityDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityDevices] as? [String]
  }
  
  public func getHubAlarmSecurityExcludedDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityExcludedDevices] as? [String]
  }
  
  public func getHubAlarmSecurityActiveDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityActiveDevices] as? [String]
  }
  
  public func getHubAlarmSecurityCurrentActive(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityCurrentActive] as? [String]
  }
  
  public func getHubAlarmSecurityOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityOfflineDevices] as? [String]
  }
  
  public func getHubAlarmSecurityTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityTriggeredDevices] as? [String]
  }
  
  public func getHubAlarmSecurityTriggers(_ model: HubAlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityTriggers] as? [Any]
  }
  
  public func getHubAlarmSecurityPreAlertEndTime(_ model: HubAlarmModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAlarmSecurityPreAlertEndTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAlarmSecuritySilent(_ model: HubAlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecuritySilent] as? Bool
  }
  
  public func getHubAlarmSecurityEntranceDelay(_ model: HubAlarmModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecurityEntranceDelay] as? Int
  }
  
  public func getHubAlarmSecuritySensitivity(_ model: HubAlarmModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSecuritySensitivity] as? Int
  }
  
  public func getHubAlarmPanicAlertState(_ model: HubAlarmModel) -> HubAlarmPanicAlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmPanicAlertState] as? String,
      let enumAttr: HubAlarmPanicAlertState = HubAlarmPanicAlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmPanicActiveDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmPanicActiveDevices] as? [String]
  }
  
  public func getHubAlarmPanicOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmPanicOfflineDevices] as? [String]
  }
  
  public func getHubAlarmPanicTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmPanicTriggeredDevices] as? [String]
  }
  
  public func getHubAlarmPanicTriggers(_ model: HubAlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmPanicTriggers] as? [Any]
  }
  
  public func getHubAlarmPanicSilent(_ model: HubAlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmPanicSilent] as? Bool
  }
  
  public func setHubAlarmPanicSilent(_ panicSilent: Bool, model: HubAlarmModel) {
    model.set([Attributes.hubAlarmPanicSilent: panicSilent as AnyObject])
  }
  public func getHubAlarmSmokeAlertState(_ model: HubAlarmModel) -> HubAlarmSmokeAlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmSmokeAlertState] as? String,
      let enumAttr: HubAlarmSmokeAlertState = HubAlarmSmokeAlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmSmokeActiveDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSmokeActiveDevices] as? [String]
  }
  
  public func getHubAlarmSmokeOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSmokeOfflineDevices] as? [String]
  }
  
  public func getHubAlarmSmokeTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSmokeTriggeredDevices] as? [String]
  }
  
  public func getHubAlarmSmokeTriggers(_ model: HubAlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSmokeTriggers] as? [Any]
  }
  
  public func getHubAlarmSmokeSilent(_ model: HubAlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmSmokeSilent] as? Bool
  }
  
  public func setHubAlarmSmokeSilent(_ smokeSilent: Bool, model: HubAlarmModel) {
    model.set([Attributes.hubAlarmSmokeSilent: smokeSilent as AnyObject])
  }
  public func getHubAlarmCoAlertState(_ model: HubAlarmModel) -> HubAlarmCoAlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmCoAlertState] as? String,
      let enumAttr: HubAlarmCoAlertState = HubAlarmCoAlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmCoActiveDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmCoActiveDevices] as? [String]
  }
  
  public func getHubAlarmCoOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmCoOfflineDevices] as? [String]
  }
  
  public func getHubAlarmCoTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmCoTriggeredDevices] as? [String]
  }
  
  public func getHubAlarmCoTriggers(_ model: HubAlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmCoTriggers] as? [Any]
  }
  
  public func getHubAlarmCoSilent(_ model: HubAlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmCoSilent] as? Bool
  }
  
  public func setHubAlarmCoSilent(_ coSilent: Bool, model: HubAlarmModel) {
    model.set([Attributes.hubAlarmCoSilent: coSilent as AnyObject])
  }
  public func getHubAlarmWaterAlertState(_ model: HubAlarmModel) -> HubAlarmWaterAlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAlarmWaterAlertState] as? String,
      let enumAttr: HubAlarmWaterAlertState = HubAlarmWaterAlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAlarmWaterActiveDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmWaterActiveDevices] as? [String]
  }
  
  public func getHubAlarmWaterOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmWaterOfflineDevices] as? [String]
  }
  
  public func getHubAlarmWaterTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmWaterTriggeredDevices] as? [String]
  }
  
  public func getHubAlarmWaterTriggers(_ model: HubAlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmWaterTriggers] as? [Any]
  }
  
  public func getHubAlarmWaterSilent(_ model: HubAlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAlarmWaterSilent] as? Bool
  }
  
  public func setHubAlarmWaterSilent(_ waterSilent: Bool, model: HubAlarmModel) {
    model.set([Attributes.hubAlarmWaterSilent: waterSilent as AnyObject])
  }
  
  public func requestHubAlarmActivate(_ model: HubAlarmModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubAlarmActivateRequest = HubAlarmActivateRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubAlarmSuspend(_ model: HubAlarmModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubAlarmSuspendRequest = HubAlarmSuspendRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubAlarmArm(_  model: HubAlarmModel, mode: String, bypassed: Bool, entranceDelaySecs: Int, exitDelaySecs: Int, alarmSensitivityDeviceCount: Int, silent: Bool, soundsEnabled: Bool, activeDevices: [String], armedBy: String, armedFrom: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAlarmArmRequest = HubAlarmArmRequest()
    request.source = model.address
    
    
    
    request.setMode(mode)
    
    request.setBypassed(bypassed)
    
    request.setEntranceDelaySecs(entranceDelaySecs)
    
    request.setExitDelaySecs(exitDelaySecs)
    
    request.setAlarmSensitivityDeviceCount(alarmSensitivityDeviceCount)
    
    request.setSilent(silent)
    
    request.setSoundsEnabled(soundsEnabled)
    
    request.setActiveDevices(activeDevices)
    
    request.setArmedBy(armedBy)
    
    request.setArmedFrom(armedFrom)
    
    return try sendRequest(request)
  }
  
  public func requestHubAlarmDisarm(_  model: HubAlarmModel, disarmedBy: String, disarmedFrom: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAlarmDisarmRequest = HubAlarmDisarmRequest()
    request.source = model.address
    
    
    
    request.setDisarmedBy(disarmedBy)
    
    request.setDisarmedFrom(disarmedFrom)
    
    return try sendRequest(request)
  }
  
  public func requestHubAlarmPanic(_  model: HubAlarmModel, source: String, event: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAlarmPanicRequest = HubAlarmPanicRequest()
    request.source = model.address
    
    
    
    request.setSource(source)
    
    request.setEvent(event)
    
    return try sendRequest(request)
  }
  
  public func requestHubAlarmClearIncident(_ model: HubAlarmModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubAlarmClearIncidentRequest = HubAlarmClearIncidentRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
