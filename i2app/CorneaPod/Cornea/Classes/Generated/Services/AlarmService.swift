
//
// AlarmService.swift
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
  public static let alarmServiceNamespace: String = "alarmservice"
  public static let alarmServiceName: String = "AlarmService"
  public static let alarmServiceAddress: String = "SERV:alarmservice:"
}

/** Alarm Service */
public protocol ArcusAlarmService: RxArcusService {
  /** Issued by the alarm subsystem when a new alert is added to an incident. */
  func requestAlarmServiceAddAlarm(_ alarm: String, alarms: [String], triggers: [Any]) throws -> Observable<ArcusSessionEvent>/** Issued by the alarm subsystem when the alarm has been cleared */
  func requestAlarmServiceCancelAlert(_ method: String, alarms: [String]) throws -> Observable<ArcusSessionEvent>
}

extension ArcusAlarmService {
  public func requestAlarmServiceAddAlarm(_ alarm: String, alarms: [String], triggers: [Any]) throws -> Observable<ArcusSessionEvent> {
    let request: AlarmServiceAddAlarmRequest = AlarmServiceAddAlarmRequest()
    request.source = Constants.alarmServiceAddress
    
    
    request.setAlarm(alarm)
    request.setAlarms(alarms)
    request.setTriggers(triggers)

    return try sendRequest(request)
  }
  public func requestAlarmServiceCancelAlert(_ method: String, alarms: [String]) throws -> Observable<ArcusSessionEvent> {
    let request: AlarmServiceCancelAlertRequest = AlarmServiceCancelAlertRequest()
    request.source = Constants.alarmServiceAddress
    
    
    request.setMethod(method)
    request.setAlarms(alarms)

    return try sendRequest(request)
  }
  
}
