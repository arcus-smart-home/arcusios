
//
// ScheduleCapabilityLegacy.swift
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

public class ScheduleCapabilityLegacy: NSObject, ArcusScheduleCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ScheduleCapabilityLegacy  = ScheduleCapabilityLegacy()
  

  
  public static func getGroup(_ model: ScheduleModel) -> String? {
    return capability.getScheduleGroup(model)
  }
  
  public static func getEnabled(_ model: ScheduleModel) -> NSNumber? {
    guard let enabled: Bool = capability.getScheduleEnabled(model) else {
      return nil
    }
    return NSNumber(value: enabled)
  }
  
  public static func setEnabled(_ enabled: Bool, model: ScheduleModel) {
    
    
    capability.setScheduleEnabled(enabled, model: model)
  }
  
  public static func getNextFireTime(_ model: ScheduleModel) -> Date? {
    guard let nextFireTime: Date = capability.getScheduleNextFireTime(model) else {
      return nil
    }
    return nextFireTime
  }
  
  public static func getNextFireCommand(_ model: ScheduleModel) -> String? {
    return capability.getScheduleNextFireCommand(model)
  }
  
  public static func getLastFireTime(_ model: ScheduleModel) -> Date? {
    guard let lastFireTime: Date = capability.getScheduleLastFireTime(model) else {
      return nil
    }
    return lastFireTime
  }
  
  public static func getLastFireCommand(_ model: ScheduleModel) -> String? {
    return capability.getScheduleLastFireCommand(model)
  }
  
  public static func getLastFireMessageType(_ model: ScheduleModel) -> String? {
    return capability.getScheduleLastFireMessageType(model)
  }
  
  public static func getLastFireAttributes(_ model: ScheduleModel) -> [String: Any]? {
    return capability.getScheduleLastFireAttributes(model)
  }
  
  public static func delete(_ model: ScheduleModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestScheduleDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func deleteCommand(_  model: ScheduleModel, commandId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestScheduleDeleteCommand(model, commandId: commandId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
