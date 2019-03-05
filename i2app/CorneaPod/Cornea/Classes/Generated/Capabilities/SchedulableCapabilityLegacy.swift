
//
// SchedulableCapabilityLegacy.swift
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

public class SchedulableCapabilityLegacy: NSObject, ArcusSchedulableCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SchedulableCapabilityLegacy  = SchedulableCapabilityLegacy()
  
  static let SchedulableTypeNOT_SUPPORTED: String = SchedulableType.not_supported.rawValue
  static let SchedulableTypeDEVICE_ONLY: String = SchedulableType.device_only.rawValue
  static let SchedulableTypeDRIVER_READ_ONLY: String = SchedulableType.driver_read_only.rawValue
  static let SchedulableTypeDRIVER_WRITE_ONLY: String = SchedulableType.driver_write_only.rawValue
  static let SchedulableTypeSUPPORTED_DRIVER: String = SchedulableType.supported_driver.rawValue
  static let SchedulableTypeSUPPORTED_CLOUD: String = SchedulableType.supported_cloud.rawValue
  

  
  public static func getType(_ model: DeviceModel) -> String? {
    return capability.getSchedulableType(model)?.rawValue
  }
  
  public static func getScheduleEnabled(_ model: DeviceModel) -> NSNumber? {
    guard let scheduleEnabled: Bool = capability.getSchedulableScheduleEnabled(model) else {
      return nil
    }
    return NSNumber(value: scheduleEnabled)
  }
  
  public static func enableSchedule(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSchedulableEnableSchedule(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disableSchedule(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSchedulableDisableSchedule(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
