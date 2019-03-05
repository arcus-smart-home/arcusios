
//
// LawnNGardenSubsystemCap.swift
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
  public static var lawnNGardenSubsystemNamespace: String = "sublawnngarden"
  public static var lawnNGardenSubsystemName: String = "LawnNGardenSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let lawnNGardenSubsystemControllers: String = "sublawnngarden:controllers"
  static let lawnNGardenSubsystemScheduleStatus: String = "sublawnngarden:scheduleStatus"
  static let lawnNGardenSubsystemOddSchedules: String = "sublawnngarden:oddSchedules"
  static let lawnNGardenSubsystemEvenSchedules: String = "sublawnngarden:evenSchedules"
  static let lawnNGardenSubsystemWeeklySchedules: String = "sublawnngarden:weeklySchedules"
  static let lawnNGardenSubsystemIntervalSchedules: String = "sublawnngarden:intervalSchedules"
  static let lawnNGardenSubsystemNextEvent: String = "sublawnngarden:nextEvent"
  static let lawnNGardenSubsystemZonesWatering: String = "sublawnngarden:zonesWatering"
  
}

public protocol ArcusLawnNGardenSubsystemCapability: class, RxArcusService {
  /** The addresses of all irrigation controllers at this place */
  func getLawnNGardenSubsystemControllers(_ model: SubsystemModel) -> [String]?
  /** The current scheduling status of all controllers */
  func getLawnNGardenSubsystemScheduleStatus(_ model: SubsystemModel) -> [String: Any]?
  /** The odd day schedules for all controllers */
  func getLawnNGardenSubsystemOddSchedules(_ model: SubsystemModel) -> [String: Any]?
  /** The even day schedules for all controllers */
  func getLawnNGardenSubsystemEvenSchedules(_ model: SubsystemModel) -> [String: Any]?
  /** The weekly schedules for all controllers */
  func getLawnNGardenSubsystemWeeklySchedules(_ model: SubsystemModel) -> [String: Any]?
  /** The interval schedules for all controllers */
  func getLawnNGardenSubsystemIntervalSchedules(_ model: SubsystemModel) -> [String: Any]?
  /** The immediate next event across all active schedules */
  func getLawnNGardenSubsystemNextEvent(_ model: SubsystemModel) -> Any?
  /** Metadata about the current watering zone for each controller. */
  func getLawnNGardenSubsystemZonesWatering(_ model: SubsystemModel) -> [String: Any]?
  
  /** Stops a controller from watering whether it was started manually or not. */
  func requestLawnNGardenSubsystemStopWatering(_  model: SubsystemModel, controller: String, currentOnly: Bool)
   throws -> Observable<ArcusSessionEvent>/** Changes the scheduling mode on a controller between the various types */
  func requestLawnNGardenSubsystemSwitchScheduleMode(_  model: SubsystemModel, controller: String, mode: String)
   throws -> Observable<ArcusSessionEvent>/** Enables the current schedule */
  func requestLawnNGardenSubsystemEnableScheduling(_  model: SubsystemModel, controller: String)
   throws -> Observable<ArcusSessionEvent>/** Disables the current schedule */
  func requestLawnNGardenSubsystemDisableScheduling(_  model: SubsystemModel, controller: String)
   throws -> Observable<ArcusSessionEvent>/** Skips scheduled watering events for a specific length of time */
  func requestLawnNGardenSubsystemSkip(_  model: SubsystemModel, controller: String, hours: Int)
   throws -> Observable<ArcusSessionEvent>/** Cancels skipping (rain delay) */
  func requestLawnNGardenSubsystemCancelSkip(_  model: SubsystemModel, controller: String)
   throws -> Observable<ArcusSessionEvent>/** Configures the start time and interval for the interval schedule */
  func requestLawnNGardenSubsystemConfigureIntervalSchedule(_  model: SubsystemModel, controller: String, startTime: Date, days: Int)
   throws -> Observable<ArcusSessionEvent>/** Creates a weekly schedule event */
  func requestLawnNGardenSubsystemCreateWeeklyEvent(_  model: SubsystemModel, controller: String, days: [String], timeOfDay: String, zoneDurations: [Any])
   throws -> Observable<ArcusSessionEvent>/** Updates a weekly schedule event */
  func requestLawnNGardenSubsystemUpdateWeeklyEvent(_  model: SubsystemModel, controller: String, eventId: String, days: [String], timeOfDay: String, zoneDurations: [Any], day: String)
   throws -> Observable<ArcusSessionEvent>/** Removes a weekly schedule event */
  func requestLawnNGardenSubsystemRemoveWeeklyEvent(_  model: SubsystemModel, controller: String, eventId: String, day: String)
   throws -> Observable<ArcusSessionEvent>/** Creates a non-weekly scheduling event */
  func requestLawnNGardenSubsystemCreateScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, timeOfDay: String, zoneDurations: [Any])
   throws -> Observable<ArcusSessionEvent>/** Updates an existing non-weekly schedule event */
  func requestLawnNGardenSubsystemUpdateScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String, timeOfDay: String, zoneDurations: [Any])
   throws -> Observable<ArcusSessionEvent>/** Removes an existing non-weekly schedule event */
  func requestLawnNGardenSubsystemRemoveScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String)
   throws -> Observable<ArcusSessionEvent>/** Attempts to repush an entire scheduled identified by the mode down to the device, typically useful when applying some event has failed */
  func requestLawnNGardenSubsystemSyncSchedule(_  model: SubsystemModel, controller: String, mode: String)
   throws -> Observable<ArcusSessionEvent>/** Attempts to repush an entire scheduled event down to the device, typically useful when applying some event has failed */
  func requestLawnNGardenSubsystemSyncScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusLawnNGardenSubsystemCapability {
  public func getLawnNGardenSubsystemControllers(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemControllers] as? [String]
  }
  
  public func getLawnNGardenSubsystemScheduleStatus(_ model: SubsystemModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemScheduleStatus] as? [String: Any]
  }
  
  public func getLawnNGardenSubsystemOddSchedules(_ model: SubsystemModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemOddSchedules] as? [String: Any]
  }
  
  public func getLawnNGardenSubsystemEvenSchedules(_ model: SubsystemModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemEvenSchedules] as? [String: Any]
  }
  
  public func getLawnNGardenSubsystemWeeklySchedules(_ model: SubsystemModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemWeeklySchedules] as? [String: Any]
  }
  
  public func getLawnNGardenSubsystemIntervalSchedules(_ model: SubsystemModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemIntervalSchedules] as? [String: Any]
  }
  
  public func getLawnNGardenSubsystemNextEvent(_ model: SubsystemModel) -> Any? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemNextEvent] as? Any
  }
  
  public func getLawnNGardenSubsystemZonesWatering(_ model: SubsystemModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lawnNGardenSubsystemZonesWatering] as? [String: Any]
  }
  
  
  public func requestLawnNGardenSubsystemStopWatering(_  model: SubsystemModel, controller: String, currentOnly: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemStopWateringRequest = LawnNGardenSubsystemStopWateringRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setCurrentOnly(currentOnly)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemSwitchScheduleMode(_  model: SubsystemModel, controller: String, mode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemSwitchScheduleModeRequest = LawnNGardenSubsystemSwitchScheduleModeRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setMode(mode)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemEnableScheduling(_  model: SubsystemModel, controller: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemEnableSchedulingRequest = LawnNGardenSubsystemEnableSchedulingRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemDisableScheduling(_  model: SubsystemModel, controller: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemDisableSchedulingRequest = LawnNGardenSubsystemDisableSchedulingRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemSkip(_  model: SubsystemModel, controller: String, hours: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemSkipRequest = LawnNGardenSubsystemSkipRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setHours(hours)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemCancelSkip(_  model: SubsystemModel, controller: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemCancelSkipRequest = LawnNGardenSubsystemCancelSkipRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemConfigureIntervalSchedule(_  model: SubsystemModel, controller: String, startTime: Date, days: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemConfigureIntervalScheduleRequest = LawnNGardenSubsystemConfigureIntervalScheduleRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setStartTime(startTime)
    
    request.setDays(days)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemCreateWeeklyEvent(_  model: SubsystemModel, controller: String, days: [String], timeOfDay: String, zoneDurations: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemCreateWeeklyEventRequest = LawnNGardenSubsystemCreateWeeklyEventRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setDays(days)
    
    request.setTimeOfDay(timeOfDay)
    
    request.setZoneDurations(zoneDurations)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemUpdateWeeklyEvent(_  model: SubsystemModel, controller: String, eventId: String, days: [String], timeOfDay: String, zoneDurations: [Any], day: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemUpdateWeeklyEventRequest = LawnNGardenSubsystemUpdateWeeklyEventRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setEventId(eventId)
    
    request.setDays(days)
    
    request.setTimeOfDay(timeOfDay)
    
    request.setZoneDurations(zoneDurations)
    
    request.setDay(day)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemRemoveWeeklyEvent(_  model: SubsystemModel, controller: String, eventId: String, day: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemRemoveWeeklyEventRequest = LawnNGardenSubsystemRemoveWeeklyEventRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setEventId(eventId)
    
    request.setDay(day)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemCreateScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, timeOfDay: String, zoneDurations: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemCreateScheduleEventRequest = LawnNGardenSubsystemCreateScheduleEventRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setMode(mode)
    
    request.setTimeOfDay(timeOfDay)
    
    request.setZoneDurations(zoneDurations)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemUpdateScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String, timeOfDay: String, zoneDurations: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemUpdateScheduleEventRequest = LawnNGardenSubsystemUpdateScheduleEventRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setMode(mode)
    
    request.setEventId(eventId)
    
    request.setTimeOfDay(timeOfDay)
    
    request.setZoneDurations(zoneDurations)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemRemoveScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemRemoveScheduleEventRequest = LawnNGardenSubsystemRemoveScheduleEventRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setMode(mode)
    
    request.setEventId(eventId)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemSyncSchedule(_  model: SubsystemModel, controller: String, mode: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemSyncScheduleRequest = LawnNGardenSubsystemSyncScheduleRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setMode(mode)
    
    return try sendRequest(request)
  }
  
  public func requestLawnNGardenSubsystemSyncScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LawnNGardenSubsystemSyncScheduleEventRequest = LawnNGardenSubsystemSyncScheduleEventRequest()
    request.source = model.address
    
    
    
    request.setController(controller)
    
    request.setMode(mode)
    
    request.setEventId(eventId)
    
    return try sendRequest(request)
  }
  
}
