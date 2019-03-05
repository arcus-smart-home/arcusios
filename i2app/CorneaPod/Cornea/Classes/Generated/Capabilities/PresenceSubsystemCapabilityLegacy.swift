
//
// PresenceSubsystemCapabilityLegacy.swift
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

public class PresenceSubsystemCapabilityLegacy: NSObject, ArcusPresenceSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PresenceSubsystemCapabilityLegacy  = PresenceSubsystemCapabilityLegacy()
  

  
  public static func getOccupied(_ model: SubsystemModel) -> NSNumber? {
    guard let occupied: Bool = capability.getPresenceSubsystemOccupied(model) else {
      return nil
    }
    return NSNumber(value: occupied)
  }
  
  public static func getOccupiedConf(_ model: SubsystemModel) -> Any? {
    return capability.getPresenceSubsystemOccupiedConf(model)
  }
  
  public static func getPeopleAtHome(_ model: SubsystemModel) -> [String]? {
    return capability.getPresenceSubsystemPeopleAtHome(model)
  }
  
  public static func getPeopleAway(_ model: SubsystemModel) -> [String]? {
    return capability.getPresenceSubsystemPeopleAway(model)
  }
  
  public static func getDevicesAtHome(_ model: SubsystemModel) -> [String]? {
    return capability.getPresenceSubsystemDevicesAtHome(model)
  }
  
  public static func getDevicesAway(_ model: SubsystemModel) -> [String]? {
    return capability.getPresenceSubsystemDevicesAway(model)
  }
  
  public static func getAllDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getPresenceSubsystemAllDevices(model)
  }
  
  public static func getPresenceAnalysis(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPresenceSubsystemGetPresenceAnalysis(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
