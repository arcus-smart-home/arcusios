
//
// SchedulerService.swift
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
  public static let schedulerServiceNamespace: String = "scheduler"
  public static let schedulerServiceName: String = "SchedulerService"
  public static let schedulerServiceAddress: String = "SERV:scheduler:"
}

/** Handler for creating and modifying schedules. */
public protocol ArcusSchedulerService: RxArcusService {
  /** Lists all the schedulers for a given place. */
  func requestSchedulerServiceListSchedulers(_ placeId: String, includeWeekdays: Bool) throws -> Observable<ArcusSessionEvent>/** Creates a new Scheduler or returns the existing scheduler for target.  Generally this is used when there is no Scheduler in ListSchedulers for the given object. */
  func requestSchedulerServiceGetScheduler(_ target: String) throws -> Observable<ArcusSessionEvent>/** Fires the requested command right now, generally used for testing. */
  func requestSchedulerServiceFireCommand(_ target: String, commandId: String) throws -> Observable<ArcusSessionEvent>/**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
  func requestSchedulerServiceScheduleCommands(_ target: String, group: String, commands: [Any]) throws -> Observable<ArcusSessionEvent>/**  This is a convenience for Scheduler#GetScheduler(target)#AddSchedule(schedule, &#x27;WEEKLY&#x27;)#ScheduleWeeklyEvent(time, messageType, attributeMap). Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
  func requestSchedulerServiceScheduleWeeklyCommand(_ target: String, schedule: String, days: [String], mode: String, time: String, offsetMinutes: Int, messageType: String, schedulerServiceAttributes: [String: Any]) throws -> Observable<ArcusSessionEvent>/**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#UpdateWeeklyEvent(commandId, time, attributes). Updates schedule for an existing scheduled event.   */
  func requestSchedulerServiceUpdateWeeklyCommand(_ target: String, schedule: String, commandId: String, days: [String], mode: String, time: String, offsetMinutes: Int, messageType: String, schedulerServiceAttributes: [String: Any]) throws -> Observable<ArcusSessionEvent>/**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#DeleteCommand(comandId). Deletes any occurrence of the specified command from the week.   */
  func requestSchedulerServiceDeleteCommand(_ target: String, schedule: String, commandId: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSchedulerService {
  public func requestSchedulerServiceListSchedulers(_ placeId: String, includeWeekdays: Bool) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerServiceListSchedulersRequest = SchedulerServiceListSchedulersRequest()
    request.source = Constants.schedulerServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setIncludeWeekdays(includeWeekdays)

    return try sendRequest(request)
  }
  public func requestSchedulerServiceGetScheduler(_ target: String) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerServiceGetSchedulerRequest = SchedulerServiceGetSchedulerRequest()
    request.source = Constants.schedulerServiceAddress
    
    
    request.setTarget(target)

    return try sendRequest(request)
  }
  public func requestSchedulerServiceFireCommand(_ target: String, commandId: String) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerServiceFireCommandRequest = SchedulerServiceFireCommandRequest()
    request.source = Constants.schedulerServiceAddress
    
    
    request.setTarget(target)
    request.setCommandId(commandId)

    return try sendRequest(request)
  }
  public func requestSchedulerServiceScheduleCommands(_ target: String, group: String, commands: [Any]) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerServiceScheduleCommandsRequest = SchedulerServiceScheduleCommandsRequest()
    request.source = Constants.schedulerServiceAddress
    
    
    request.setTarget(target)
    request.setGroup(group)
    request.setCommands(commands)

    return try sendRequest(request)
  }
  public func requestSchedulerServiceScheduleWeeklyCommand(_ target: String, schedule: String, days: [String], mode: String, time: String, offsetMinutes: Int, messageType: String, schedulerServiceAttributes: [String: Any]) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerServiceScheduleWeeklyCommandRequest = SchedulerServiceScheduleWeeklyCommandRequest()
    request.source = Constants.schedulerServiceAddress
    
    
    request.setTarget(target)
    request.setSchedule(schedule)
    request.setDays(days)
    request.setMode(mode)
    request.setTime(time)
    request.setOffsetMinutes(offsetMinutes)
    request.setMessageType(messageType)
    request.setAttributes(schedulerServiceAttributes)

    return try sendRequest(request)
  }
  public func requestSchedulerServiceUpdateWeeklyCommand(_ target: String, schedule: String, commandId: String, days: [String], mode: String, time: String, offsetMinutes: Int, messageType: String, schedulerServiceAttributes: [String: Any]) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerServiceUpdateWeeklyCommandRequest = SchedulerServiceUpdateWeeklyCommandRequest()
    request.source = Constants.schedulerServiceAddress
    
    
    request.setTarget(target)
    request.setSchedule(schedule)
    request.setCommandId(commandId)
    request.setDays(days)
    request.setMode(mode)
    request.setTime(time)
    request.setOffsetMinutes(offsetMinutes)
    request.setMessageType(messageType)
    request.setAttributes(schedulerServiceAttributes)

    return try sendRequest(request)
  }
  public func requestSchedulerServiceDeleteCommand(_ target: String, schedule: String, commandId: String) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerServiceDeleteCommandRequest = SchedulerServiceDeleteCommandRequest()
    request.source = Constants.schedulerServiceAddress
    
    
    request.setTarget(target)
    request.setSchedule(schedule)
    request.setCommandId(commandId)

    return try sendRequest(request)
  }
  
}
