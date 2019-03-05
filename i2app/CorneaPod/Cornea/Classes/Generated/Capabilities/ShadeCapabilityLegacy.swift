
//
// ShadeCapabilityLegacy.swift
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

public class ShadeCapabilityLegacy: NSObject, ArcusShadeCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ShadeCapabilityLegacy  = ShadeCapabilityLegacy()
  
  static let ShadeShadestateOK: String = ShadeShadestate.ok.rawValue
  static let ShadeShadestateOBSTRUCTION: String = ShadeShadestate.obstruction.rawValue
  

  
  public static func getLevel(_ model: DeviceModel) -> NSNumber? {
    guard let level: Int = capability.getShadeLevel(model) else {
      return nil
    }
    return NSNumber(value: level)
  }
  
  public static func setLevel(_ level: Int, model: DeviceModel) {
    
    
    capability.setShadeLevel(level, model: model)
  }
  
  public static func getShadestate(_ model: DeviceModel) -> String? {
    return capability.getShadeShadestate(model)?.rawValue
  }
  
  public static func getLevelchanged(_ model: DeviceModel) -> Date? {
    guard let levelchanged: Date = capability.getShadeLevelchanged(model) else {
      return nil
    }
    return levelchanged
  }
  
  public static func goToOpen(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestShadeGoToOpen(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func goToClosed(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestShadeGoToClosed(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func goToFavorite(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestShadeGoToFavorite(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
