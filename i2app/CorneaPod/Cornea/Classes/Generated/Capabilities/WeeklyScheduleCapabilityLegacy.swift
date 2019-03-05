
//
// WeeklyScheduleCapabilityLegacy.swift
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
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class WeeklyScheduleCapabilityLegacy: NSObject, ArcusWeeklyScheduleCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: WeeklyScheduleCapabilityLegacy  = WeeklyScheduleCapabilityLegacy()
  

  
  public static func getMon(_ model: ScheduleModel) -> [Any]? {
    return capability.getWeeklyScheduleMon(model)
  }
  
  public static func getTue(_ model: ScheduleModel) -> [Any]? {
    return capability.getWeeklyScheduleTue(model)
  }
  
  public static func getWed(_ model: ScheduleModel) -> [Any]? {
    return capability.getWeeklyScheduleWed(model)
  }
  
  public static func getThu(_ model: ScheduleModel) -> [Any]? {
    return capability.getWeeklyScheduleThu(model)
  }
  
  public static func getFri(_ model: ScheduleModel) -> [Any]? {
    return capability.getWeeklyScheduleFri(model)
  }
  
  public static func getSat(_ model: ScheduleModel) -> [Any]? {
    return capability.getWeeklyScheduleSat(model)
  }
  
  public static func getSun(_ model: ScheduleModel) -> [Any]? {
    return capability.getWeeklyScheduleSun(model)
  }
  
  public static func scheduleWeeklyCommand(_  model: ScheduleModel, days: [String], time: String, mode: String, offsetMinutes: Int, messageType: String, weeklyScheduleAttributes: [String: Any]) -> PMKPromise {
  
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestWeeklyScheduleScheduleWeeklyCommand(model, days: days, time: time, mode: mode, offsetMinutes: offsetMinutes, messageType: messageType, weeklyScheduleAttributes: weeklyScheduleAttributes))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateWeeklyCommand(_  model: ScheduleModel, commandId: String, days: [String], mode: String, offsetMinutes: Int, time: String, messageType: String, weeklyScheduleAttributes: [String: Any]) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestWeeklyScheduleUpdateWeeklyCommand(model, commandId: commandId, days: days, mode: mode, offsetMinutes: offsetMinutes, time: time, messageType: messageType, weeklyScheduleAttributes: weeklyScheduleAttributes))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
