
//
// CareSubsystemCap.swift
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
  public static var careSubsystemNamespace: String = "subcare"
  public static var careSubsystemName: String = "CareSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let careSubsystemTriggeredDevices: String = "subcare:triggeredDevices"
  static let careSubsystemInactiveDevices: String = "subcare:inactiveDevices"
  static let careSubsystemCareDevices: String = "subcare:careDevices"
  static let careSubsystemCareCapableDevices: String = "subcare:careCapableDevices"
  static let careSubsystemPresenceDevices: String = "subcare:presenceDevices"
  static let careSubsystemBehaviors: String = "subcare:behaviors"
  static let careSubsystemActiveBehaviors: String = "subcare:activeBehaviors"
  static let careSubsystemAlarmMode: String = "subcare:alarmMode"
  static let careSubsystemAlarmState: String = "subcare:alarmState"
  static let careSubsystemLastAlertTime: String = "subcare:lastAlertTime"
  static let careSubsystemLastAlertCause: String = "subcare:lastAlertCause"
  static let careSubsystemLastAlertTriggers: String = "subcare:lastAlertTriggers"
  static let careSubsystemLastAcknowledgement: String = "subcare:lastAcknowledgement"
  static let careSubsystemLastAcknowledgementTime: String = "subcare:lastAcknowledgementTime"
  static let careSubsystemLastAcknowledgedBy: String = "subcare:lastAcknowledgedBy"
  static let careSubsystemLastClearTime: String = "subcare:lastClearTime"
  static let careSubsystemLastClearedBy: String = "subcare:lastClearedBy"
  static let careSubsystemCallTreeEnabled: String = "subcare:callTreeEnabled"
  static let careSubsystemCallTree: String = "subcare:callTree"
  static let careSubsystemSilent: String = "subcare:silent"
  static let careSubsystemCareDevicesPopulated: String = "subcare:careDevicesPopulated"
  
}

public protocol ArcusCareSubsystemCapability: class, RxArcusService {
  /** The addresses of all the currently triggered care-capable devices in this place. */
  func getCareSubsystemTriggeredDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of all the currently inactive care-capable devices in this place. */
  func getCareSubsystemInactiveDevices(_ model: SubsystemModel) -> [String]?
  /** This addresses of all the current care devices in this place. */
  func getCareSubsystemCareDevices(_ model: SubsystemModel) -> [String]?
  /** This addresses of all the current care devices in this place. */
  func setCareSubsystemCareDevices(_ careDevices: [String], model: SubsystemModel)
/** The addresses of all the current care-capable devices in this place. */
  func getCareSubsystemCareCapableDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of all the presence devices such as fobs in this place. */
  func getCareSubsystemPresenceDevices(_ model: SubsystemModel) -> [String]?
  /** The list of ids of behaviors that are currently defined on the subsystem.  Use ListBehaviors to get details. */
  func getCareSubsystemBehaviors(_ model: SubsystemModel) -> [String]?
  /** The list of ids of behaviors that are currently active */
  func getCareSubsystemActiveBehaviors(_ model: SubsystemModel) -> [String]?
  /** Whether the care alarm is currently turned on or in visit mode.  During visit mode behaviors will not trigger the care alarm, but the care pendant may still generate a panic. */
  func getCareSubsystemAlarmMode(_ model: SubsystemModel) -> CareSubsystemAlarmMode?
  /** Whether the care alarm is currently turned on or in visit mode.  During visit mode behaviors will not trigger the care alarm, but the care pendant may still generate a panic. */
  func setCareSubsystemAlarmMode(_ alarmMode: CareSubsystemAlarmMode, model: SubsystemModel)
/** Whether the alarm is currently going of or not. */
  func getCareSubsystemAlarmState(_ model: SubsystemModel) -> CareSubsystemAlarmState?
  /** The last time the alarm was fired. */
  func getCareSubsystemLastAlertTime(_ model: SubsystemModel) -> Date?
  /** The reason the alarm was fired. */
  func getCareSubsystemLastAlertCause(_ model: SubsystemModel) -> String?
  /** A map of behavior id to timestamp of when a behavior was triggered during an alert.  This map will not be populated until the alarm enters the alert state. Note this will only include the first time a behavior was triggered during an alert.  For more detailed information see the history log. */
  func getCareSubsystemLastAlertTriggers(_ model: SubsystemModel) -> [String: Double]?
  /** The current state of acknowledgement:     PENDING - Arcus is attempting to notify the user that an alarm has been triggered     ACKNOWLEDGED - One of the persons from the call tree has acknowledged the alarm     FAILED - No one acknowledged the alarm but no one was available to acknowledged it. */
  func getCareSubsystemLastAcknowledgement(_ model: SubsystemModel) -> CareSubsystemLastAcknowledgement?
  /** The last time at which acknowledgement changed to ACKNOWLEDGED or FAILED.  This will be empty when lastAcknowledgement is PENDING. */
  func getCareSubsystemLastAcknowledgementTime(_ model: SubsystemModel) -> Date?
  /** The actor that acknowledge the alarm when lastAcknowledgement is ACKNOWLEDGED.  Otherwise this field will be empty. */
  func getCareSubsystemLastAcknowledgedBy(_ model: SubsystemModel) -> String?
  /** The last time the alarm was disarmed.  This is the time that Disarm was requested, not the time at which CLEARING completed. */
  func getCareSubsystemLastClearTime(_ model: SubsystemModel) -> Date?
  /** The actor that disarmed the alarm, if available.  If it can&#x27;t be determined this will be empty. */
  func getCareSubsystemLastClearedBy(_ model: SubsystemModel) -> String?
  /** Whether the call tree should be used or just the account owner should be notified in an alarm scenario.  This will currently be false when the place is on BASIC and true when the place is on PREMIUM. */
  func getCareSubsystemCallTreeEnabled(_ model: SubsystemModel) -> Bool?
  /**  The call tree of users to notify when an alarm is triggered.  This list includes all the persons associated with the current place, whether or not they are alerted is determined by the boolean flag.  Order is determined by the order of the list. */
  func getCareSubsystemCallTree(_ model: SubsystemModel) -> [Any]?
  /**  The call tree of users to notify when an alarm is triggered.  This list includes all the persons associated with the current place, whether or not they are alerted is determined by the boolean flag.  Order is determined by the order of the list. */
  func setCareSubsystemCallTree(_ callTree: [Any], model: SubsystemModel)
/** When true only notifications will be sent, alert devices will not be triggered. */
  func getCareSubsystemSilent(_ model: SubsystemModel) -> Bool?
  /** When true only notifications will be sent, alert devices will not be triggered. */
  func setCareSubsystemSilent(_ silent: Bool, model: SubsystemModel)
/** Flag indicating that careDevices has been initialized from careCapableDevices.  This is to initialize the field a single time. Data FIX */
  func getCareSubsystemCareDevicesPopulated(_ model: SubsystemModel) -> Bool?
  
  /**  */
  func requestCareSubsystemPanic(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/**  */
  func requestCareSubsystemAcknowledge(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/**  */
  func requestCareSubsystemClear(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Creates a list of time buckets and indicates which care devices, optionally filtered, are triggered during that bucket. */
  func requestCareSubsystemListActivity(_  model: SubsystemModel, start: Date, end: Date, bucket: Int, devices: [String])
   throws -> Observable<ArcusSessionEvent>/** Returns a list of all the history log entries associated with this subsystem. */
  func requestCareSubsystemListDetailedActivity(_  model: SubsystemModel, limit: Int, token: String, devices: [String])
   throws -> Observable<ArcusSessionEvent>/**  */
  func requestCareSubsystemListBehaviors(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/**  */
  func requestCareSubsystemListBehaviorTemplates(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/**  */
  func requestCareSubsystemAddBehavior(_  model: SubsystemModel, behavior: Any)
   throws -> Observable<ArcusSessionEvent>/** Updates the requested attributes on the specified behavior. */
  func requestCareSubsystemUpdateBehavior(_  model: SubsystemModel, behavior: Any)
   throws -> Observable<ArcusSessionEvent>/** Updates the requested attributes on the specified behavior. */
  func requestCareSubsystemRemoveBehavior(_  model: SubsystemModel, id: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusCareSubsystemCapability {
  public func getCareSubsystemTriggeredDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemTriggeredDevices] as? [String]
  }
  
  public func getCareSubsystemInactiveDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemInactiveDevices] as? [String]
  }
  
  public func getCareSubsystemCareDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemCareDevices] as? [String]
  }
  
  public func setCareSubsystemCareDevices(_ careDevices: [String], model: SubsystemModel) {
    model.set([Attributes.careSubsystemCareDevices: careDevices as AnyObject])
  }
  public func getCareSubsystemCareCapableDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemCareCapableDevices] as? [String]
  }
  
  public func getCareSubsystemPresenceDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemPresenceDevices] as? [String]
  }
  
  public func getCareSubsystemBehaviors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemBehaviors] as? [String]
  }
  
  public func getCareSubsystemActiveBehaviors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemActiveBehaviors] as? [String]
  }
  
  public func getCareSubsystemAlarmMode(_ model: SubsystemModel) -> CareSubsystemAlarmMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.careSubsystemAlarmMode] as? String,
      let enumAttr: CareSubsystemAlarmMode = CareSubsystemAlarmMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setCareSubsystemAlarmMode(_ alarmMode: CareSubsystemAlarmMode, model: SubsystemModel) {
    model.set([Attributes.careSubsystemAlarmMode: alarmMode.rawValue as AnyObject])
  }
  public func getCareSubsystemAlarmState(_ model: SubsystemModel) -> CareSubsystemAlarmState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.careSubsystemAlarmState] as? String,
      let enumAttr: CareSubsystemAlarmState = CareSubsystemAlarmState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getCareSubsystemLastAlertTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.careSubsystemLastAlertTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getCareSubsystemLastAlertCause(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemLastAlertCause] as? String
  }
  
  public func getCareSubsystemLastAlertTriggers(_ model: SubsystemModel) -> [String: Double]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemLastAlertTriggers] as? [String: Double]
  }
  
  public func getCareSubsystemLastAcknowledgement(_ model: SubsystemModel) -> CareSubsystemLastAcknowledgement? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.careSubsystemLastAcknowledgement] as? String,
      let enumAttr: CareSubsystemLastAcknowledgement = CareSubsystemLastAcknowledgement(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getCareSubsystemLastAcknowledgementTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.careSubsystemLastAcknowledgementTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getCareSubsystemLastAcknowledgedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemLastAcknowledgedBy] as? String
  }
  
  public func getCareSubsystemLastClearTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.careSubsystemLastClearTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getCareSubsystemLastClearedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemLastClearedBy] as? String
  }
  
  public func getCareSubsystemCallTreeEnabled(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemCallTreeEnabled] as? Bool
  }
  
  public func getCareSubsystemCallTree(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemCallTree] as? [Any]
  }
  
  public func setCareSubsystemCallTree(_ callTree: [Any], model: SubsystemModel) {
    model.set([Attributes.careSubsystemCallTree: callTree as AnyObject])
  }
  public func getCareSubsystemSilent(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemSilent] as? Bool
  }
  
  public func setCareSubsystemSilent(_ silent: Bool, model: SubsystemModel) {
    model.set([Attributes.careSubsystemSilent: silent as AnyObject])
  }
  public func getCareSubsystemCareDevicesPopulated(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.careSubsystemCareDevicesPopulated] as? Bool
  }
  
  
  public func requestCareSubsystemPanic(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemPanicRequest = CareSubsystemPanicRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemAcknowledge(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemAcknowledgeRequest = CareSubsystemAcknowledgeRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemClear(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemClearRequest = CareSubsystemClearRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemListActivity(_  model: SubsystemModel, start: Date, end: Date, bucket: Int, devices: [String])
   throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemListActivityRequest = CareSubsystemListActivityRequest()
    request.source = model.address
    
    
    
    request.setStart(start)
    
    request.setEnd(end)
    
    request.setBucket(bucket)
    
    request.setDevices(devices)
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemListDetailedActivity(_  model: SubsystemModel, limit: Int, token: String, devices: [String])
   throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemListDetailedActivityRequest = CareSubsystemListDetailedActivityRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    request.setDevices(devices)
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemListBehaviors(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemListBehaviorsRequest = CareSubsystemListBehaviorsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemListBehaviorTemplates(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemListBehaviorTemplatesRequest = CareSubsystemListBehaviorTemplatesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemAddBehavior(_  model: SubsystemModel, behavior: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemAddBehaviorRequest = CareSubsystemAddBehaviorRequest()
    request.source = model.address
    
    
    
    request.setBehavior(behavior)
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemUpdateBehavior(_  model: SubsystemModel, behavior: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemUpdateBehaviorRequest = CareSubsystemUpdateBehaviorRequest()
    request.source = model.address
    
    
    
    request.setBehavior(behavior)
    
    return try sendRequest(request)
  }
  
  public func requestCareSubsystemRemoveBehavior(_  model: SubsystemModel, id: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: CareSubsystemRemoveBehaviorRequest = CareSubsystemRemoveBehaviorRequest()
    request.source = model.address
    
    
    
    request.setId(id)
    
    return try sendRequest(request)
  }
  
}
