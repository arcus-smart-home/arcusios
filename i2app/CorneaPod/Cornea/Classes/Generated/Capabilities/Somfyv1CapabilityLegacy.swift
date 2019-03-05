
//
// Somfyv1CapabilityLegacy.swift
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

public class Somfyv1CapabilityLegacy: NSObject, ArcusSomfyv1Capability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: Somfyv1CapabilityLegacy  = Somfyv1CapabilityLegacy()
  
  static let Somfyv1TypeSHADE: String = Somfyv1Type.shade.rawValue
  static let Somfyv1TypeBLIND: String = Somfyv1Type.blind.rawValue
  
  static let Somfyv1ReversedNORMAL: String = Somfyv1Reversed.normal.rawValue
  static let Somfyv1ReversedREVERSED: String = Somfyv1Reversed.reversed.rawValue
  
  static let Somfyv1CurrentstateOPEN: String = Somfyv1Currentstate.open.rawValue
  static let Somfyv1CurrentstateCLOSED: String = Somfyv1Currentstate.closed.rawValue
  

  
  public static func getType(_ model: DeviceModel) -> String? {
    return capability.getSomfyv1Type(model)?.rawValue
  }
  
  public static func setType(_ type: String, model: DeviceModel) {
    guard let type: Somfyv1Type = Somfyv1Type(rawValue: type) else { return }
    
    capability.setSomfyv1Type(type, model: model)
  }
  
  public static func getReversed(_ model: DeviceModel) -> String? {
    return capability.getSomfyv1Reversed(model)?.rawValue
  }
  
  public static func setReversed(_ reversed: String, model: DeviceModel) {
    guard let reversed: Somfyv1Reversed = Somfyv1Reversed(rawValue: reversed) else { return }
    
    capability.setSomfyv1Reversed(reversed, model: model)
  }
  
  public static func getChannel(_ model: DeviceModel) -> NSNumber? {
    guard let channel: Int = capability.getSomfyv1Channel(model) else {
      return nil
    }
    return NSNumber(value: channel)
  }
  
  public static func getCurrentstate(_ model: DeviceModel) -> String? {
    return capability.getSomfyv1Currentstate(model)?.rawValue
  }
  
  public static func getStatechanged(_ model: DeviceModel) -> Date? {
    guard let statechanged: Date = capability.getSomfyv1Statechanged(model) else {
      return nil
    }
    return statechanged
  }
  
  public static func goToOpen(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSomfyv1GoToOpen(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func goToClosed(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSomfyv1GoToClosed(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func goToFavorite(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSomfyv1GoToFavorite(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
