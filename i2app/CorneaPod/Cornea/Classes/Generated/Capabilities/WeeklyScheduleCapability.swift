
//
// WeeklyScheduleCap.swift
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
  public static var weeklyScheduleNamespace: String = "schedweek"
  public static var weeklyScheduleName: String = "WeeklySchedule"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let weeklyScheduleMon: String = "schedweek:mon"
  static let weeklyScheduleTue: String = "schedweek:tue"
  static let weeklyScheduleWed: String = "schedweek:wed"
  static let weeklyScheduleThu: String = "schedweek:thu"
  static let weeklyScheduleFri: String = "schedweek:fri"
  static let weeklyScheduleSat: String = "schedweek:sat"
  static let weeklyScheduleSun: String = "schedweek:sun"
  
}

public protocol ArcusWeeklyScheduleCapability: class, RxArcusService {
  /** The commands that are scheduled to run on Mondays */
  func getWeeklyScheduleMon(_ model: ScheduleModel) -> [Any]?
  /** The commands that are scheduled to run on Tuesdays */
  func getWeeklyScheduleTue(_ model: ScheduleModel) -> [Any]?
  /** The commands that are scheduled to run on Wednesdays */
  func getWeeklyScheduleWed(_ model: ScheduleModel) -> [Any]?
  /** The commands that are scheduled to run on Thursdays */
  func getWeeklyScheduleThu(_ model: ScheduleModel) -> [Any]?
  /** The commands that are scheduled to run on Fridays */
  func getWeeklyScheduleFri(_ model: ScheduleModel) -> [Any]?
  /** The commands that are scheduled to run on Saturdays */
  func getWeeklyScheduleSat(_ model: ScheduleModel) -> [Any]?
  /** The commands that are scheduled to run on Sundays */
  func getWeeklyScheduleSun(_ model: ScheduleModel) -> [Any]?
  
  /**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event.      */
  func requestWeeklyScheduleScheduleWeeklyCommand(_  model: ScheduleModel, days: [String], time: String, mode: String, offsetMinutes: Int, messageType: String, weeklyScheduleAttributes: [String: Any])
   throws -> Observable<ArcusSessionEvent>/** Updates schedule for an existing scheduled command. */
  func requestWeeklyScheduleUpdateWeeklyCommand(_  model: ScheduleModel, commandId: String, days: [String], mode: String, offsetMinutes: Int, time: String, messageType: String, weeklyScheduleAttributes: [String: Any])
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusWeeklyScheduleCapability {
  public func getWeeklyScheduleMon(_ model: ScheduleModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weeklyScheduleMon] as? [Any]
  }
  
  public func getWeeklyScheduleTue(_ model: ScheduleModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weeklyScheduleTue] as? [Any]
  }
  
  public func getWeeklyScheduleWed(_ model: ScheduleModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weeklyScheduleWed] as? [Any]
  }
  
  public func getWeeklyScheduleThu(_ model: ScheduleModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weeklyScheduleThu] as? [Any]
  }
  
  public func getWeeklyScheduleFri(_ model: ScheduleModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weeklyScheduleFri] as? [Any]
  }
  
  public func getWeeklyScheduleSat(_ model: ScheduleModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weeklyScheduleSat] as? [Any]
  }
  
  public func getWeeklyScheduleSun(_ model: ScheduleModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weeklyScheduleSun] as? [Any]
  }
  
  
  public func requestWeeklyScheduleScheduleWeeklyCommand(_  model: ScheduleModel, days: [String], time: String, mode: String, offsetMinutes: Int, messageType: String, weeklyScheduleAttributes: [String: Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: WeeklyScheduleScheduleWeeklyCommandRequest = WeeklyScheduleScheduleWeeklyCommandRequest()
    request.source = model.address
    
    
    
    request.setDays(days)
    
    request.setTime(time)
    
    request.setMode(mode)
    
    request.setOffsetMinutes(offsetMinutes)
    
    request.setMessageType(messageType)
    
    request.setAttributes(weeklyScheduleAttributes)
    
    return try sendRequest(request)
  }
  
  public func requestWeeklyScheduleUpdateWeeklyCommand(_  model: ScheduleModel, commandId: String, days: [String], mode: String, offsetMinutes: Int, time: String, messageType: String, weeklyScheduleAttributes: [String: Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: WeeklyScheduleUpdateWeeklyCommandRequest = WeeklyScheduleUpdateWeeklyCommandRequest()
    request.source = model.address
    
    
    
    request.setCommandId(commandId)
    
    request.setDays(days)
    
    request.setMode(mode)
    
    request.setOffsetMinutes(offsetMinutes)
    
    request.setTime(time)
    
    request.setMessageType(messageType)
    
    request.setAttributes(weeklyScheduleAttributes)
    
    return try sendRequest(request)
  }
  
}
