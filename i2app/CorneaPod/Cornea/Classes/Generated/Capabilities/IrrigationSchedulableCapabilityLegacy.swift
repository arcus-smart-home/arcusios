
//
// IrrigationSchedulableCapabilityLegacy.swift
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

public class IrrigationSchedulableCapabilityLegacy: NSObject, ArcusIrrigationSchedulableCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: IrrigationSchedulableCapabilityLegacy  = IrrigationSchedulableCapabilityLegacy()
  

  
  public static func getRefreshSchedule(_ model: DeviceModel) -> NSNumber? {
    guard let refreshSchedule: Bool = capability.getIrrigationSchedulableRefreshSchedule(model) else {
      return nil
    }
    return NSNumber(value: refreshSchedule)
  }
  
  public static func setRefreshSchedule(_ refreshSchedule: Bool, model: DeviceModel) {
    
    
    capability.setIrrigationSchedulableRefreshSchedule(refreshSchedule, model: model)
  }
  
  public static func enableSchedule(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestIrrigationSchedulableEnableSchedule(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disableSchedule(_  model: DeviceModel, duration: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableDisableSchedule(model, duration: duration))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func clearEvenOddSchedule(_  model: DeviceModel, zone: String, opId: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableClearEvenOddSchedule(model, zone: zone, opId: opId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setEvenOddSchedule(_  model: DeviceModel, zone: String, even: Bool, transitions: [Any], opId: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableSetEvenOddSchedule(model, zone: zone, even: even, transitions: transitions, opId: opId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func clearIntervalSchedule(_  model: DeviceModel, zone: String, opId: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableClearIntervalSchedule(model, zone: zone, opId: opId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setIntervalSchedule(_  model: DeviceModel, zone: String, days: Int, transitions: [Any], opId: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableSetIntervalSchedule(model, zone: zone, days: days, transitions: transitions, opId: opId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setIntervalStart(_  model: DeviceModel, zone: String, startDate: Double, opId: String) -> PMKPromise {
  
    
    let startDate: Date = Date(milliseconds: startDate)
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableSetIntervalStart(model, zone: zone, startDate: startDate, opId: opId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func clearWeeklySchedule(_  model: DeviceModel, zone: String, opId: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableClearWeeklySchedule(model, zone: zone, opId: opId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setWeeklySchedule(_  model: DeviceModel, zone: String, days: [String], transitions: [Any], opId: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationSchedulableSetWeeklySchedule(model, zone: zone, days: days, transitions: transitions, opId: opId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
