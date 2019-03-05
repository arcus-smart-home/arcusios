
//
// DoorLockCapabilityLegacy.swift
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

public class DoorLockCapabilityLegacy: NSObject, ArcusDoorLockCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DoorLockCapabilityLegacy  = DoorLockCapabilityLegacy()
  
  static let DoorLockLockstateLOCKED: String = DoorLockLockstate.locked.rawValue
  static let DoorLockLockstateUNLOCKED: String = DoorLockLockstate.unlocked.rawValue
  static let DoorLockLockstateLOCKING: String = DoorLockLockstate.locking.rawValue
  static let DoorLockLockstateUNLOCKING: String = DoorLockLockstate.unlocking.rawValue
  
  static let DoorLockTypeDEADBOLT: String = DoorLockType.deadbolt.rawValue
  static let DoorLockTypeLEVERLOCK: String = DoorLockType.leverlock.rawValue
  static let DoorLockTypeOTHER: String = DoorLockType.other.rawValue
  

  
  public static func getLockstate(_ model: DeviceModel) -> String? {
    return capability.getDoorLockLockstate(model)?.rawValue
  }
  
  public static func setLockstate(_ lockstate: String, model: DeviceModel) {
    guard let lockstate: DoorLockLockstate = DoorLockLockstate(rawValue: lockstate) else { return }
    
    capability.setDoorLockLockstate(lockstate, model: model)
  }
  
  public static func getType(_ model: DeviceModel) -> String? {
    return capability.getDoorLockType(model)?.rawValue
  }
  
  public static func getSlots(_ model: DeviceModel) -> [String: String]? {
    return capability.getDoorLockSlots(model)
  }
  
  public static func getNumPinsSupported(_ model: DeviceModel) -> NSNumber? {
    guard let numPinsSupported: Int = capability.getDoorLockNumPinsSupported(model) else {
      return nil
    }
    return NSNumber(value: numPinsSupported)
  }
  
  public static func getSupportsInvalidPin(_ model: DeviceModel) -> NSNumber? {
    guard let supportsInvalidPin: Bool = capability.getDoorLockSupportsInvalidPin(model) else {
      return nil
    }
    return NSNumber(value: supportsInvalidPin)
  }
  
  public static func getSupportsBuzzIn(_ model: DeviceModel) -> NSNumber? {
    guard let supportsBuzzIn: Bool = capability.getDoorLockSupportsBuzzIn(model) else {
      return nil
    }
    return NSNumber(value: supportsBuzzIn)
  }
  
  public static func getLockstatechanged(_ model: DeviceModel) -> Date? {
    guard let lockstatechanged: Date = capability.getDoorLockLockstatechanged(model) else {
      return nil
    }
    return lockstatechanged
  }
  
  public static func authorizePerson(_  model: DeviceModel, personId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDoorLockAuthorizePerson(model, personId: personId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func deauthorizePerson(_  model: DeviceModel, personId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDoorLockDeauthorizePerson(model, personId: personId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func buzzIn(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestDoorLockBuzzIn(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func clearAllPins(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestDoorLockClearAllPins(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
