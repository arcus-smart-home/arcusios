
//
// ScheduleCap.swift
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
  public static var scheduleNamespace: String = "sched"
  public static var scheduleName: String = "Schedule"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let scheduleGroup: String = "sched:group"
  static let scheduleEnabled: String = "sched:enabled"
  static let scheduleNextFireTime: String = "sched:nextFireTime"
  static let scheduleNextFireCommand: String = "sched:nextFireCommand"
  static let scheduleLastFireTime: String = "sched:lastFireTime"
  static let scheduleLastFireCommand: String = "sched:lastFireCommand"
  static let scheduleLastFireMessageType: String = "sched:lastFireMessageType"
  static let scheduleLastFireAttributes: String = "sched:lastFireAttributes"
  
}

public protocol ArcusScheduleCapability: class, RxArcusService {
  /** The scheduling group.  Only one Schedule in a scheduling group may be enabled at a time. */
  func getScheduleGroup(_ model: ScheduleModel) -> String?
  /** Whether or not this scheduled is currently enabled to run.  When disabled no scheduled commands will be sent. */
  func getScheduleEnabled(_ model: ScheduleModel) -> Bool?
  /** Whether or not this scheduled is currently enabled to run.  When disabled no scheduled commands will be sent. */
  func setScheduleEnabled(_ enabled: Bool, model: ScheduleModel)
/** The next time the schedule will fire, this may be null if the schedule is disabled or there are no scheduled times. */
  func getScheduleNextFireTime(_ model: ScheduleModel) -> Date?
  /** The command that will be sent when it fires next.  This is a key into the commands attribute. */
  func getScheduleNextFireCommand(_ model: ScheduleModel) -> String?
  /** The last time the schedule executed a command. */
  func getScheduleLastFireTime(_ model: ScheduleModel) -> Date?
  /** The id of the last command that was executed.  This may not exist in the commands attribute if the schedule has been modified since it last fired. */
  func getScheduleLastFireCommand(_ model: ScheduleModel) -> String?
  /** The type of message that was sent on last execution. */
  func getScheduleLastFireMessageType(_ model: ScheduleModel) -> String?
  /** The attributes that were sent on last execution. */
  func getScheduleLastFireAttributes(_ model: ScheduleModel) -> [String: Any]?
  
  /** Deletes this Schedule and removes any scheduled commands. */
  func requestScheduleDelete(_ model: ScheduleModel) throws -> Observable<ArcusSessionEvent>/** Deletes any occurrences of the scheduled command from this Schedule. */
  func requestScheduleDeleteCommand(_  model: ScheduleModel, commandId: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusScheduleCapability {
  public func getScheduleGroup(_ model: ScheduleModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.scheduleGroup] as? String
  }
  
  public func getScheduleEnabled(_ model: ScheduleModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.scheduleEnabled] as? Bool
  }
  
  public func setScheduleEnabled(_ enabled: Bool, model: ScheduleModel) {
    model.set([Attributes.scheduleEnabled: enabled as AnyObject])
  }
  public func getScheduleNextFireTime(_ model: ScheduleModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.scheduleNextFireTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getScheduleNextFireCommand(_ model: ScheduleModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.scheduleNextFireCommand] as? String
  }
  
  public func getScheduleLastFireTime(_ model: ScheduleModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.scheduleLastFireTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getScheduleLastFireCommand(_ model: ScheduleModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.scheduleLastFireCommand] as? String
  }
  
  public func getScheduleLastFireMessageType(_ model: ScheduleModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.scheduleLastFireMessageType] as? String
  }
  
  public func getScheduleLastFireAttributes(_ model: ScheduleModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.scheduleLastFireAttributes] as? [String: Any]
  }
  
  
  public func requestScheduleDelete(_ model: ScheduleModel) throws -> Observable<ArcusSessionEvent> {
    let request: ScheduleDeleteRequest = ScheduleDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestScheduleDeleteCommand(_  model: ScheduleModel, commandId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ScheduleDeleteCommandRequest = ScheduleDeleteCommandRequest()
    request.source = model.address
    
    
    
    request.setCommandId(commandId)
    
    return try sendRequest(request)
  }
  
}
