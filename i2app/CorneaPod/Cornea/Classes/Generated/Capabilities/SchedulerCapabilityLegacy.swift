
//
// SchedulerCapabilityLegacy.swift
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

public class SchedulerCapabilityLegacy: NSObject, ArcusSchedulerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SchedulerCapabilityLegacy  = SchedulerCapabilityLegacy()
  

  
  public static func getPlaceId(_ model: SchedulerModel) -> String? {
    return capability.getSchedulerPlaceId(model)
  }
  
  public static func getTarget(_ model: SchedulerModel) -> String? {
    return capability.getSchedulerTarget(model)
  }
  
  public static func getNextFireTime(_ model: SchedulerModel) -> Date? {
    guard let nextFireTime: Date = capability.getSchedulerNextFireTime(model) else {
      return nil
    }
    return nextFireTime
  }
  
  public static func getNextFireSchedule(_ model: SchedulerModel) -> String? {
    return capability.getSchedulerNextFireSchedule(model)
  }
  
  public static func getLastFireTime(_ model: SchedulerModel) -> Date? {
    guard let lastFireTime: Date = capability.getSchedulerLastFireTime(model) else {
      return nil
    }
    return lastFireTime
  }
  
  public static func getLastFireSchedule(_ model: SchedulerModel) -> String? {
    return capability.getSchedulerLastFireSchedule(model)
  }
  
  public static func getCommands(_ model: SchedulerModel) -> [String: Any]? {
    return capability.getSchedulerCommands(model)
  }
  
  public static func fireCommand(_  model: SchedulerModel, commandId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSchedulerFireCommand(model, commandId: commandId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func addWeeklySchedule(_  model: SchedulerModel, id: String, group: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSchedulerAddWeeklySchedule(model, id: id, group: group))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: SchedulerModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSchedulerDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
