
//
// PetDoorCapabilityLegacy.swift
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

public class PetDoorCapabilityLegacy: NSObject, ArcusPetDoorCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PetDoorCapabilityLegacy  = PetDoorCapabilityLegacy()
  
  static let PetDoorLockstateLOCKED: String = PetDoorLockstate.locked.rawValue
  static let PetDoorLockstateUNLOCKED: String = PetDoorLockstate.unlocked.rawValue
  static let PetDoorLockstateAUTO: String = PetDoorLockstate.auto.rawValue
  
  static let PetDoorDirectionIN: String = PetDoorDirection.petDoorIn.rawValue
  static let PetDoorDirectionOUT: String = PetDoorDirection.out.rawValue
  

  
  public static func getLockstate(_ model: DeviceModel) -> String? {
    return capability.getPetDoorLockstate(model)?.rawValue
  }
  
  public static func setLockstate(_ lockstate: String, model: DeviceModel) {
    guard let lockstate: PetDoorLockstate = PetDoorLockstate(rawValue: lockstate) else { return }
    
    capability.setPetDoorLockstate(lockstate, model: model)
  }
  
  public static func getLastlockstatechangedtime(_ model: DeviceModel) -> Date? {
    guard let lastlockstatechangedtime: Date = capability.getPetDoorLastlockstatechangedtime(model) else {
      return nil
    }
    return lastlockstatechangedtime
  }
  
  public static func getLastaccesstime(_ model: DeviceModel) -> Date? {
    guard let lastaccesstime: Date = capability.getPetDoorLastaccesstime(model) else {
      return nil
    }
    return lastaccesstime
  }
  
  public static func getDirection(_ model: DeviceModel) -> String? {
    return capability.getPetDoorDirection(model)?.rawValue
  }
  
  public static func getNumPetTokensSupported(_ model: DeviceModel) -> NSNumber? {
    guard let numPetTokensSupported: Int = capability.getPetDoorNumPetTokensSupported(model) else {
      return nil
    }
    return NSNumber(value: numPetTokensSupported)
  }
  
  public static func removeToken(_  model: DeviceModel, tokenId: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPetDoorRemoveToken(model, tokenId: tokenId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
