
//
// PetTokenCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var petTokenNamespace: String = "pettoken"
  public static var petTokenName: String = "PetToken"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let petTokenTokenNum: String = "pettoken:tokenNum"
  static let petTokenTokenId: String = "pettoken:tokenId"
  static let petTokenPaired: String = "pettoken:paired"
  static let petTokenPetName: String = "pettoken:petName"
  static let petTokenLastAccessTime: String = "pettoken:lastAccessTime"
  static let petTokenLastAccessDirection: String = "pettoken:lastAccessDirection"
  
}

public protocol ArcusPetTokenCapability: class, RxArcusService {
  /** Holds the index of the pet token up to 5. */
  func getPetTokenTokenNum(_ model: DeviceModel) -> Int?
  /** Holds the ID of the access token assoctiated with the smart pet door. */
  func getPetTokenTokenId(_ model: DeviceModel) -> Int?
  /** Is a token currently paired in this slot or not */
  func getPetTokenPaired(_ model: DeviceModel) -> Bool?
  /** The name of the pet identified by this token. */
  func getPetTokenPetName(_ model: DeviceModel) -> String?
  /** The name of the pet identified by this token. */
  func setPetTokenPetName(_ petName: String, model: DeviceModel)
/** Holds the timestamp of the last time this token was used to access the smart pet door. */
  func getPetTokenLastAccessTime(_ model: DeviceModel) -> Date?
  /** Identifies the direction of traffic, in or out, the last time the smart pet door was used by this pet. */
  func getPetTokenLastAccessDirection(_ model: DeviceModel) -> PetTokenLastAccessDirection?
  
  
}

extension ArcusPetTokenCapability {
  public func getPetTokenTokenNum(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.petTokenTokenNum] as? Int
  }
  
  public func getPetTokenTokenId(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.petTokenTokenId] as? Int
  }
  
  public func getPetTokenPaired(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.petTokenPaired] as? Bool
  }
  
  public func getPetTokenPetName(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.petTokenPetName] as? String
  }
  
  public func setPetTokenPetName(_ petName: String, model: DeviceModel) {
    model.set([Attributes.petTokenPetName: petName as AnyObject])
  }
  public func getPetTokenLastAccessTime(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.petTokenLastAccessTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPetTokenLastAccessDirection(_ model: DeviceModel) -> PetTokenLastAccessDirection? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.petTokenLastAccessDirection] as? String,
      let enumAttr: PetTokenLastAccessDirection = PetTokenLastAccessDirection(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
}
