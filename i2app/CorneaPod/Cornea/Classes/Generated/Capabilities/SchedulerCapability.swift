
//
// SchedulerCap.swift
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
  public static var schedulerNamespace: String = "scheduler"
  public static var schedulerName: String = "Scheduler"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let schedulerPlaceId: String = "scheduler:placeId"
  static let schedulerTarget: String = "scheduler:target"
  static let schedulerNextFireTime: String = "scheduler:nextFireTime"
  static let schedulerNextFireSchedule: String = "scheduler:nextFireSchedule"
  static let schedulerLastFireTime: String = "scheduler:lastFireTime"
  static let schedulerLastFireSchedule: String = "scheduler:lastFireSchedule"
  static let schedulerCommands: String = "scheduler:commands"
  
}

public protocol ArcusSchedulerCapability: class, RxArcusService {
  /** The ID of the place that this object is associated with. */
  func getSchedulerPlaceId(_ model: SchedulerModel) -> String?
  /** The target that scheduled messages will be sent to. */
  func getSchedulerTarget(_ model: SchedulerModel) -> String?
  /** The next time a scheduled command will fire.  This may be null if all schedules are disabled. */
  func getSchedulerNextFireTime(_ model: SchedulerModel) -> Date?
  /** ID of the schedule that will fire next. */
  func getSchedulerNextFireSchedule(_ model: SchedulerModel) -> String?
  /** The last time the schedule executed a command. */
  func getSchedulerLastFireTime(_ model: SchedulerModel) -> Date?
  /** ID of the schedule that fired previously. */
  func getSchedulerLastFireSchedule(_ model: SchedulerModel) -> String?
  /**  The commands that this schedule may send.  This is a derived, read-only view.  The specific format of the ScheduledCommand depends on the type of schedule this is.  Currently only WeeklySchedule and TimeOfDayCommand are supported.           */
  func getSchedulerCommands(_ model: SchedulerModel) -> [String: Any]?
  
  /** Fires the requested command right now, generally used for testing. */
  func requestSchedulerFireCommand(_  model: SchedulerModel, commandId: String)
   throws -> Observable<ArcusSessionEvent>/**  Creates a new schedule which will appear as a new multi-instance object on the Scheduler with the given id. If a schedule with the given id already exists with the same type this will be a no-op.  If a schedule with the same id and a different type exists, this will return an error.           */
  func requestSchedulerAddWeeklySchedule(_  model: SchedulerModel, id: String, group: String)
   throws -> Observable<ArcusSessionEvent>/** Deletes this scheduler object and all associated schedules, this is generally not recommended.  If the target object is deleted, this Scheduler will automatically be deleted. */
  func requestSchedulerDelete(_ model: SchedulerModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSchedulerCapability {
  public func getSchedulerPlaceId(_ model: SchedulerModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.schedulerPlaceId] as? String
  }
  
  public func getSchedulerTarget(_ model: SchedulerModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.schedulerTarget] as? String
  }
  
  public func getSchedulerNextFireTime(_ model: SchedulerModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.schedulerNextFireTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSchedulerNextFireSchedule(_ model: SchedulerModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.schedulerNextFireSchedule] as? String
  }
  
  public func getSchedulerLastFireTime(_ model: SchedulerModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.schedulerLastFireTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSchedulerLastFireSchedule(_ model: SchedulerModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.schedulerLastFireSchedule] as? String
  }
  
  public func getSchedulerCommands(_ model: SchedulerModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.schedulerCommands] as? [String: Any]
  }
  
  
  public func requestSchedulerFireCommand(_  model: SchedulerModel, commandId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerFireCommandRequest = SchedulerFireCommandRequest()
    request.source = model.address
    
    
    
    request.setCommandId(commandId)
    
    return try sendRequest(request)
  }
  
  public func requestSchedulerAddWeeklySchedule(_  model: SchedulerModel, id: String, group: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerAddWeeklyScheduleRequest = SchedulerAddWeeklyScheduleRequest()
    request.source = model.address
    
    
    
    request.setId(id)
    
    request.setGroup(group)
    
    return try sendRequest(request)
  }
  
  public func requestSchedulerDelete(_ model: SchedulerModel) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulerDeleteRequest = SchedulerDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
