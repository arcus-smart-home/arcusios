
//
// ProblemDeviceCapabilityLegacy.swift
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

public class ProblemDeviceCapabilityLegacy: NSObject, ArcusProblemDeviceCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ProblemDeviceCapabilityLegacy  = ProblemDeviceCapabilityLegacy()
  

  
  public static func getCreated(_ model: ProblemDeviceModel) -> Date? {
    guard let created: Date = capability.getProblemDeviceCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getId(_ model: ProblemDeviceModel) -> String? {
    return capability.getProblemDeviceId(model)
  }
  
  public static func getDeviceModel(_ model: ProblemDeviceModel) -> String? {
    return capability.getProblemDeviceDeviceModel(model)
  }
  
  public static func getMfg(_ model: ProblemDeviceModel) -> String? {
    return capability.getProblemDeviceMfg(model)
  }
  
  public static func getDeviceType(_ model: ProblemDeviceModel) -> String? {
    return capability.getProblemDeviceDeviceType(model)
  }
  
  public static func addProblemDevices(_  model: ProblemDeviceModel, models: [Any]) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProblemDeviceAddProblemDevices(model, models: models))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listProblemDevicesForTimeframe(_  model: ProblemDeviceModel, deviceModel: String, mfg: String, deviceType: String, startDate: String, endDate: String, token: String, limit: Int) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProblemDeviceListProblemDevicesForTimeframe(model, deviceModel: deviceModel, mfg: mfg, deviceType: deviceType, startDate: startDate, endDate: endDate, token: token, limit: limit))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
