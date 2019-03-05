
//
// DimmerCapabilityLegacy.swift
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

public class DimmerCapabilityLegacy: NSObject, ArcusDimmerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DimmerCapabilityLegacy  = DimmerCapabilityLegacy()
  

  
  public static func getBrightness(_ model: DeviceModel) -> NSNumber? {
    guard let brightness: Int = capability.getDimmerBrightness(model) else {
      return nil
    }
    return NSNumber(value: brightness)
  }
  
  public static func setBrightness(_ brightness: Int, model: DeviceModel) {
    
    
    capability.setDimmerBrightness(brightness, model: model)
  }
  
  public static func getRampingtarget(_ model: DeviceModel) -> NSNumber? {
    guard let rampingtarget: Int = capability.getDimmerRampingtarget(model) else {
      return nil
    }
    return NSNumber(value: rampingtarget)
  }
  
  public static func getRampingtime(_ model: DeviceModel) -> NSNumber? {
    guard let rampingtime: Int = capability.getDimmerRampingtime(model) else {
      return nil
    }
    return NSNumber(value: rampingtime)
  }
  
  public static func rampBrightness(_  model: DeviceModel, brightness: Int, seconds: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDimmerRampBrightness(model, brightness: brightness, seconds: seconds))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func incrementBrightness(_  model: DeviceModel, amount: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDimmerIncrementBrightness(model, amount: amount))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func decrementBrightness(_  model: DeviceModel, amount: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDimmerDecrementBrightness(model, amount: amount))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
