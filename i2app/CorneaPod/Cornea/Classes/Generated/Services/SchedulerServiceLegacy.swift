
//
// SchedulerServiceLegacy.swift
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

public class SchedulerServiceLegacy: NSObject, ArcusSchedulerService, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let service: SchedulerServiceLegacy = SchedulerServiceLegacy()
  
  
  public static func listSchedulers(_ placeId: String, includeWeekdays: Bool) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestSchedulerServiceListSchedulers(placeId, includeWeekdays: includeWeekdays))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getScheduler(_ target: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestSchedulerServiceGetScheduler(target))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func fireCommand(_ target: String, commandId: String) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestSchedulerServiceFireCommand(target, commandId: commandId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func scheduleCommands(_ target: String, group: String, commands: [Any]) -> PMKPromise {
  
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestSchedulerServiceScheduleCommands(target, group: group, commands: commands))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func scheduleWeeklyCommand(_ target: String, schedule: String, days: [String], mode: String, time: String, offsetMinutes: Int, messageType: String, schedulerServiceAttributes: [String: Any]) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestSchedulerServiceScheduleWeeklyCommand(target, schedule: schedule, days: days, mode: mode, time: time, offsetMinutes: offsetMinutes, messageType: messageType, schedulerServiceAttributes: schedulerServiceAttributes))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateWeeklyCommand(_ target: String, schedule: String, commandId: String, days: [String], mode: String, time: String, offsetMinutes: Int, messageType: String, schedulerServiceAttributes: [String: Any]) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestSchedulerServiceUpdateWeeklyCommand(target, schedule: schedule, commandId: commandId, days: days, mode: mode, time: time, offsetMinutes: offsetMinutes, messageType: messageType, schedulerServiceAttributes: schedulerServiceAttributes))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func deleteCommand(_ target: String, schedule: String, commandId: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestSchedulerServiceDeleteCommand(target, schedule: schedule, commandId: commandId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
