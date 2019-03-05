
//
// LawnNGardenSubsystemCapabilityLegacy.swift
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

public class LawnNGardenSubsystemCapabilityLegacy: NSObject, ArcusLawnNGardenSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: LawnNGardenSubsystemCapabilityLegacy  = LawnNGardenSubsystemCapabilityLegacy()
  

  
  public static func getControllers(_ model: SubsystemModel) -> [String]? {
    return capability.getLawnNGardenSubsystemControllers(model)
  }
  
  public static func getScheduleStatus(_ model: SubsystemModel) -> [String: Any]? {
    return capability.getLawnNGardenSubsystemScheduleStatus(model)
  }
  
  public static func getOddSchedules(_ model: SubsystemModel) -> [String: Any]? {
    return capability.getLawnNGardenSubsystemOddSchedules(model)
  }
  
  public static func getEvenSchedules(_ model: SubsystemModel) -> [String: Any]? {
    return capability.getLawnNGardenSubsystemEvenSchedules(model)
  }
  
  public static func getWeeklySchedules(_ model: SubsystemModel) -> [String: Any]? {
    return capability.getLawnNGardenSubsystemWeeklySchedules(model)
  }
  
  public static func getIntervalSchedules(_ model: SubsystemModel) -> [String: Any]? {
    return capability.getLawnNGardenSubsystemIntervalSchedules(model)
  }
  
  public static func getNextEvent(_ model: SubsystemModel) -> Any? {
    return capability.getLawnNGardenSubsystemNextEvent(model)
  }
  
  public static func getZonesWatering(_ model: SubsystemModel) -> [String: Any]? {
    return capability.getLawnNGardenSubsystemZonesWatering(model)
  }
  
  public static func stopWatering(_  model: SubsystemModel, controller: String, currentOnly: Bool) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemStopWatering(model, controller: controller, currentOnly: currentOnly))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func switchScheduleMode(_  model: SubsystemModel, controller: String, mode: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemSwitchScheduleMode(model, controller: controller, mode: mode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func enableScheduling(_  model: SubsystemModel, controller: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemEnableScheduling(model, controller: controller))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disableScheduling(_  model: SubsystemModel, controller: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemDisableScheduling(model, controller: controller))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func skip(_  model: SubsystemModel, controller: String, hours: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemSkip(model, controller: controller, hours: hours))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func cancelSkip(_  model: SubsystemModel, controller: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemCancelSkip(model, controller: controller))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func configureIntervalSchedule(_  model: SubsystemModel, controller: String, startTime: Double, days: Int) -> PMKPromise {
  
    
    let startTime: Date = Date(milliseconds: startTime)
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemConfigureIntervalSchedule(model, controller: controller, startTime: startTime, days: days))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func createWeeklyEvent(_  model: SubsystemModel, controller: String, days: [String], timeOfDay: String, zoneDurations: [Any]) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemCreateWeeklyEvent(model, controller: controller, days: days, timeOfDay: timeOfDay, zoneDurations: zoneDurations))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateWeeklyEvent(_  model: SubsystemModel, controller: String, eventId: String, days: [String], timeOfDay: String, zoneDurations: [Any], day: String) -> PMKPromise {
  
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemUpdateWeeklyEvent(model, controller: controller, eventId: eventId, days: days, timeOfDay: timeOfDay, zoneDurations: zoneDurations, day: day))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func removeWeeklyEvent(_  model: SubsystemModel, controller: String, eventId: String, day: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemRemoveWeeklyEvent(model, controller: controller, eventId: eventId, day: day))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func createScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, timeOfDay: String, zoneDurations: [Any]) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemCreateScheduleEvent(model, controller: controller, mode: mode, timeOfDay: timeOfDay, zoneDurations: zoneDurations))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String, timeOfDay: String, zoneDurations: [Any]) -> PMKPromise {
  
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemUpdateScheduleEvent(model, controller: controller, mode: mode, eventId: eventId, timeOfDay: timeOfDay, zoneDurations: zoneDurations))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func removeScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemRemoveScheduleEvent(model, controller: controller, mode: mode, eventId: eventId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func syncSchedule(_  model: SubsystemModel, controller: String, mode: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemSyncSchedule(model, controller: controller, mode: mode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func syncScheduleEvent(_  model: SubsystemModel, controller: String, mode: String, eventId: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLawnNGardenSubsystemSyncScheduleEvent(model, controller: controller, mode: mode, eventId: eventId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
