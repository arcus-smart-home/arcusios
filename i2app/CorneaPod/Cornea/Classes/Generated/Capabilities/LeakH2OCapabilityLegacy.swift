
//
// LeakH2OCapabilityLegacy.swift
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

public class LeakH2OCapabilityLegacy: NSObject, ArcusLeakH2OCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: LeakH2OCapabilityLegacy  = LeakH2OCapabilityLegacy()
  
  static let LeakH2OStateSAFE: String = LeakH2OState.safe.rawValue
  static let LeakH2OStateLEAK: String = LeakH2OState.leak.rawValue
  

  
  public static func getState(_ model: DeviceModel) -> String? {
    return capability.getLeakH2OState(model)?.rawValue
  }
  
  public static func setState(_ state: String, model: DeviceModel) {
    guard let state: LeakH2OState = LeakH2OState(rawValue: state) else { return }
    
    capability.setLeakH2OState(state, model: model)
  }
  
  public static func getStatechanged(_ model: DeviceModel) -> Date? {
    guard let statechanged: Date = capability.getLeakH2OStatechanged(model) else {
      return nil
    }
    return statechanged
  }
  
  public static func leakh2o(_  model: DeviceModel, state: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestLeakH2OLeakh2o(model, state: state))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
