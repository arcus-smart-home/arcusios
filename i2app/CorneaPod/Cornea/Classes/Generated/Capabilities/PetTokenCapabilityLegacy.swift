
//
// PetTokenCapabilityLegacy.swift
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

public class PetTokenCapabilityLegacy: NSObject, ArcusPetTokenCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PetTokenCapabilityLegacy  = PetTokenCapabilityLegacy()
  
  static let PetTokenLastAccessDirectionIN: String = PetTokenLastAccessDirection.petTokenIn.rawValue
  static let PetTokenLastAccessDirectionOUT: String = PetTokenLastAccessDirection.out.rawValue
  

  
  public static func getTokenNum(_ model: DeviceModel) -> NSNumber? {
    guard let tokenNum: Int = capability.getPetTokenTokenNum(model) else {
      return nil
    }
    return NSNumber(value: tokenNum)
  }
  
  public static func getTokenId(_ model: DeviceModel) -> NSNumber? {
    guard let tokenId: Int = capability.getPetTokenTokenId(model) else {
      return nil
    }
    return NSNumber(value: tokenId)
  }
  
  public static func getPaired(_ model: DeviceModel) -> NSNumber? {
    guard let paired: Bool = capability.getPetTokenPaired(model) else {
      return nil
    }
    return NSNumber(value: paired)
  }
  
  public static func getPetName(_ model: DeviceModel) -> String? {
    return capability.getPetTokenPetName(model)
  }
  
  public static func setPetName(_ petName: String, model: DeviceModel) {
    
    
    capability.setPetTokenPetName(petName, model: model)
  }
  
  public static func getLastAccessTime(_ model: DeviceModel) -> Date? {
    guard let lastAccessTime: Date = capability.getPetTokenLastAccessTime(model) else {
      return nil
    }
    return lastAccessTime
  }
  
  public static func getLastAccessDirection(_ model: DeviceModel) -> String? {
    return capability.getPetTokenLastAccessDirection(model)?.rawValue
  }
  
}
