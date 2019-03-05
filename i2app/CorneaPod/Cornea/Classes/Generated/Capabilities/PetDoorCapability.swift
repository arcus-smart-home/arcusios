
//
// PetDoorCap.swift
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
  public static var petDoorNamespace: String = "petdoor"
  public static var petDoorName: String = "PetDoor"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let petDoorLockstate: String = "petdoor:lockstate"
  static let petDoorLastlockstatechangedtime: String = "petdoor:lastlockstatechangedtime"
  static let petDoorLastaccesstime: String = "petdoor:lastaccesstime"
  static let petDoorDirection: String = "petdoor:direction"
  static let petDoorNumPetTokensSupported: String = "petdoor:numPetTokensSupported"
  
}

public protocol ArcusPetDoorCapability: class, RxArcusService {
  /** Lock state of the door, to override the doorlock lockstate. */
  func getPetDoorLockstate(_ model: DeviceModel) -> PetDoorLockstate?
  /** Lock state of the door, to override the doorlock lockstate. */
  func setPetDoorLockstate(_ lockstate: PetDoorLockstate, model: DeviceModel)
/** UTC date time of last lockstate change */
  func getPetDoorLastlockstatechangedtime(_ model: DeviceModel) -> Date?
  /** Holds the timestamp of the last time access through the smart pet door. */
  func getPetDoorLastaccesstime(_ model: DeviceModel) -> Date?
  /** Direction a pet last passed through the smart pet door. */
  func getPetDoorDirection(_ model: DeviceModel) -> PetDoorDirection?
  /** The number (5) of RFID tags this device supports. */
  func getPetDoorNumPetTokensSupported(_ model: DeviceModel) -> Int?
  
  /** Remove a pet token from the pet door to prevent further access. */
  func requestPetDoorRemoveToken(_  model: DeviceModel, tokenId: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusPetDoorCapability {
  public func getPetDoorLockstate(_ model: DeviceModel) -> PetDoorLockstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.petDoorLockstate] as? String,
      let enumAttr: PetDoorLockstate = PetDoorLockstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setPetDoorLockstate(_ lockstate: PetDoorLockstate, model: DeviceModel) {
    model.set([Attributes.petDoorLockstate: lockstate.rawValue as AnyObject])
  }
  public func getPetDoorLastlockstatechangedtime(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.petDoorLastlockstatechangedtime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPetDoorLastaccesstime(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.petDoorLastaccesstime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPetDoorDirection(_ model: DeviceModel) -> PetDoorDirection? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.petDoorDirection] as? String,
      let enumAttr: PetDoorDirection = PetDoorDirection(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPetDoorNumPetTokensSupported(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.petDoorNumPetTokensSupported] as? Int
  }
  
  
  public func requestPetDoorRemoveToken(_  model: DeviceModel, tokenId: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: PetDoorRemoveTokenRequest = PetDoorRemoveTokenRequest()
    request.source = model.address
    
    
    
    request.setTokenId(tokenId)
    
    return try sendRequest(request)
  }
  
}
