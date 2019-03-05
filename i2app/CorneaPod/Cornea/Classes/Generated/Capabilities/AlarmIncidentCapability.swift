
//
// AlarmIncidentCap.swift
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
  public static var alarmIncidentNamespace: String = "incident"
  public static var alarmIncidentName: String = "AlarmIncident"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let alarmIncidentPlaceId: String = "incident:placeId"
  static let alarmIncidentStartTime: String = "incident:startTime"
  static let alarmIncidentPrealertEndtime: String = "incident:prealertEndtime"
  static let alarmIncidentEndTime: String = "incident:endTime"
  static let alarmIncidentAlertState: String = "incident:alertState"
  static let alarmIncidentConfirmed: String = "incident:confirmed"
  static let alarmIncidentMonitoringState: String = "incident:monitoringState"
  static let alarmIncidentPlatformState: String = "incident:platformState"
  static let alarmIncidentHubState: String = "incident:hubState"
  static let alarmIncidentAlert: String = "incident:alert"
  static let alarmIncidentAdditionalAlerts: String = "incident:additionalAlerts"
  static let alarmIncidentTracker: String = "incident:tracker"
  static let alarmIncidentCancelled: String = "incident:cancelled"
  static let alarmIncidentCancelledBy: String = "incident:cancelledBy"
  static let alarmIncidentMonitored: String = "incident:monitored"
  
}

public protocol ArcusAlarmIncidentCapability: class, RxArcusService {
  /** The place this incident occurred at */
  func getAlarmIncidentPlaceId(_ model: AlarmIncidentModel) -> String?
  /** Platform-owned start time of the incident */
  func getAlarmIncidentStartTime(_ model: AlarmIncidentModel) -> Date?
  /** The time that the prealert will complete. */
  func getAlarmIncidentPrealertEndtime(_ model: AlarmIncidentModel) -> Date?
  /** The time the incident ended, won&#x27;t be set for the currently active incident */
  func getAlarmIncidentEndTime(_ model: AlarmIncidentModel) -> Date?
  /** The current alert state of the incident.  This may begin in PREALERT for a security alarm grace period, then go to ALERT, transition to CANCELLING when the user requests that it be cancelled, and finally to COMPLETE when it is no longer active. */
  func getAlarmIncidentAlertState(_ model: AlarmIncidentModel) -> AlarmIncidentAlertState?
  /** True if the incident has been confirmed */
  func getAlarmIncidentConfirmed(_ model: AlarmIncidentModel) -> Bool?
  /** An enum of the current monitoring state: NONE - If the alerts are not monitored PENDING - If the alert is monitored but we have not contacted the monitoring station yet DISPATCHING - If we have contacted the monitoring station but the authorities have not been contacted yet DISPATCHED - If the authorities have been contacted REFUSED - If the authorities have been contacted but refused the dispatch CANCELLED - If the alarm was cancelled before the authorities were contacted FAILED - If the signal to the monitoring station failed or the monitoring station did not clear the incident within a configured timeout. */
  func getAlarmIncidentMonitoringState(_ model: AlarmIncidentModel) -> AlarmIncidentMonitoringState?
  /** An enum of the current platform&#x27;s view of the incident state.  If hubState is not present, this will be the same as alertState. */
  func getAlarmIncidentPlatformState(_ model: AlarmIncidentModel) -> AlarmIncidentPlatformState?
  /** An enum of the current hub&#x27;s view of the incident state.  If there is only a platform alarm provider this will not be present. */
  func getAlarmIncidentHubState(_ model: AlarmIncidentModel) -> AlarmIncidentHubState?
  /** The primary alert type */
  func getAlarmIncidentAlert(_ model: AlarmIncidentModel) -> AlarmIncidentAlert?
  /** Additional alerts that were part of this incident */
  func getAlarmIncidentAdditionalAlerts(_ model: AlarmIncidentModel) -> [String]?
  /** A time series list of tracker events. */
  func getAlarmIncidentTracker(_ model: AlarmIncidentModel) -> [Any]?
  /** If this incident has been cancelled by the user.  It can&#x27;t be completely cleared until the sensors have stopped reporting smoke/CO and any professional monitoring dispatch has completed. */
  func getAlarmIncidentCancelled(_ model: AlarmIncidentModel) -> Bool?
  /** The address of the person who cancelled the alarm.  This will only be set if: 1 - the incident has cleared 2 - it was &quot;actively&quot; silenced by a user, rather than passively closed by timeout or other event */
  func getAlarmIncidentCancelledBy(_ model: AlarmIncidentModel) -> String?
  /** The monitored flag that should be true if any of the active alarms are monitored or false if none are monitored */
  func getAlarmIncidentMonitored(_ model: AlarmIncidentModel) -> Bool?
  
  /** Escalates a PreAlert incident to Alerting immediately. */
  func requestAlarmIncidentVerify(_ model: AlarmIncidentModel) throws -> Observable<ArcusSessionEvent>/** Attempts to cancel the current alert, if one is active.  This will attempt to silence all alarms and stop the alert from going to the monitoring center if the alert is professionally monitored. */
  func requestAlarmIncidentCancel(_ model: AlarmIncidentModel) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the history log entries associated with this incident */
  func requestAlarmIncidentListHistoryEntries(_  model: AlarmIncidentModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusAlarmIncidentCapability {
  public func getAlarmIncidentPlaceId(_ model: AlarmIncidentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmIncidentPlaceId] as? String
  }
  
  public func getAlarmIncidentStartTime(_ model: AlarmIncidentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alarmIncidentStartTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAlarmIncidentPrealertEndtime(_ model: AlarmIncidentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alarmIncidentPrealertEndtime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAlarmIncidentEndTime(_ model: AlarmIncidentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alarmIncidentEndTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAlarmIncidentAlertState(_ model: AlarmIncidentModel) -> AlarmIncidentAlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmIncidentAlertState] as? String,
      let enumAttr: AlarmIncidentAlertState = AlarmIncidentAlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmIncidentConfirmed(_ model: AlarmIncidentModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmIncidentConfirmed] as? Bool
  }
  
  public func getAlarmIncidentMonitoringState(_ model: AlarmIncidentModel) -> AlarmIncidentMonitoringState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmIncidentMonitoringState] as? String,
      let enumAttr: AlarmIncidentMonitoringState = AlarmIncidentMonitoringState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmIncidentPlatformState(_ model: AlarmIncidentModel) -> AlarmIncidentPlatformState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmIncidentPlatformState] as? String,
      let enumAttr: AlarmIncidentPlatformState = AlarmIncidentPlatformState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmIncidentHubState(_ model: AlarmIncidentModel) -> AlarmIncidentHubState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmIncidentHubState] as? String,
      let enumAttr: AlarmIncidentHubState = AlarmIncidentHubState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmIncidentAlert(_ model: AlarmIncidentModel) -> AlarmIncidentAlert? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmIncidentAlert] as? String,
      let enumAttr: AlarmIncidentAlert = AlarmIncidentAlert(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmIncidentAdditionalAlerts(_ model: AlarmIncidentModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmIncidentAdditionalAlerts] as? [String]
  }
  
  public func getAlarmIncidentTracker(_ model: AlarmIncidentModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmIncidentTracker] as? [Any]
  }
  
  public func getAlarmIncidentCancelled(_ model: AlarmIncidentModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmIncidentCancelled] as? Bool
  }
  
  public func getAlarmIncidentCancelledBy(_ model: AlarmIncidentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmIncidentCancelledBy] as? String
  }
  
  public func getAlarmIncidentMonitored(_ model: AlarmIncidentModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmIncidentMonitored] as? Bool
  }
  
  
  public func requestAlarmIncidentVerify(_ model: AlarmIncidentModel) throws -> Observable<ArcusSessionEvent> {
    let request: AlarmIncidentVerifyRequest = AlarmIncidentVerifyRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAlarmIncidentCancel(_ model: AlarmIncidentModel) throws -> Observable<ArcusSessionEvent> {
    let request: AlarmIncidentCancelRequest = AlarmIncidentCancelRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAlarmIncidentListHistoryEntries(_  model: AlarmIncidentModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AlarmIncidentListHistoryEntriesRequest = AlarmIncidentListHistoryEntriesRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    return try sendRequest(request)
  }
  
}
