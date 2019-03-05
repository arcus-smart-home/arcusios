
//
// SubsystemCapabilityLegacy.swift
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

public class SubsystemCapabilityLegacy: NSObject, ArcusSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SubsystemCapabilityLegacy  = SubsystemCapabilityLegacy()
  
  static let SubsystemStateACTIVE: String = SubsystemState.active.rawValue
  static let SubsystemStateSUSPENDED: String = SubsystemState.suspended.rawValue
  

  
  public static func getName(_ model: SubsystemModel) -> String? {
    return capability.getSubsystemName(model)
  }
  
  public static func getVersion(_ model: SubsystemModel) -> String? {
    return capability.getSubsystemVersion(model)
  }
  
  public static func getHash(_ model: SubsystemModel) -> String? {
    return capability.getSubsystemHash(model)
  }
  
  public static func getAccount(_ model: SubsystemModel) -> String? {
    return capability.getSubsystemAccount(model)
  }
  
  public static func getPlace(_ model: SubsystemModel) -> String? {
    return capability.getSubsystemPlace(model)
  }
  
  public static func getAvailable(_ model: SubsystemModel) -> NSNumber? {
    guard let available: Bool = capability.getSubsystemAvailable(model) else {
      return nil
    }
    return NSNumber(value: available)
  }
  
  public static func getState(_ model: SubsystemModel) -> String? {
    return capability.getSubsystemState(model)?.rawValue
  }
  
  public static func activate(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSubsystemActivate(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func suspend(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSubsystemSuspend(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSubsystemDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHistoryEntries(_  model: SubsystemModel, limit: Int, token: String, includeIncidents: Bool) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSubsystemListHistoryEntries(model, limit: limit, token: token, includeIncidents: includeIncidents))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
