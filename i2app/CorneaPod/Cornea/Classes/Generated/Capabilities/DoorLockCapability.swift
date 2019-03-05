
//
// DoorLockCap.swift
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
  public static var doorLockNamespace: String = "doorlock"
  public static var doorLockName: String = "DoorLock"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let doorLockLockstate: String = "doorlock:lockstate"
  static let doorLockType: String = "doorlock:type"
  static let doorLockSlots: String = "doorlock:slots"
  static let doorLockNumPinsSupported: String = "doorlock:numPinsSupported"
  static let doorLockSupportsInvalidPin: String = "doorlock:supportsInvalidPin"
  static let doorLockSupportsBuzzIn: String = "doorlock:supportsBuzzIn"
  static let doorLockLockstatechanged: String = "doorlock:lockstatechanged"
  
}

public protocol ArcusDoorLockCapability: class, RxArcusService {
  /** Reflects the state of the lock mechanism. */
  func getDoorLockLockstate(_ model: DeviceModel) -> DoorLockLockstate?
  /** Reflects the state of the lock mechanism. */
  func setDoorLockLockstate(_ lockstate: DoorLockLockstate, model: DeviceModel)
/** Reflects the type of door lock. */
  func getDoorLockType(_ model: DeviceModel) -> DoorLockType?
  /** Reflects the mapping between slots and people */
  func getDoorLockSlots(_ model: DeviceModel) -> [String: String]?
  /** The number of pins that this device supports */
  func getDoorLockNumPinsSupported(_ model: DeviceModel) -> Int?
  /** True if this driver will fire an event when an invalid pin is used */
  func getDoorLockSupportsInvalidPin(_ model: DeviceModel) -> Bool?
  /** Indicates whether or not the driver supports the BuzzIn method. */
  func getDoorLockSupportsBuzzIn(_ model: DeviceModel) -> Bool?
  /** UTC date time of last lockstate change */
  func getDoorLockLockstatechanged(_ model: DeviceModel) -> Date?
  
  /** Authorizes a person on this lock by adding the person&#x27;s pin on the lock and returns the slot ID used */
  func requestDoorLockAuthorizePerson(_  model: DeviceModel, personId: String)
   throws -> Observable<ArcusSessionEvent>/** Remove the pin for the given user from the lock and sets the slot state to UNUSED */
  func requestDoorLockDeauthorizePerson(_  model: DeviceModel, personId: String)
   throws -> Observable<ArcusSessionEvent>/** Temporarily unlock the lock if locked.  Automatically relock in 30 seconds. */
  func requestDoorLockBuzzIn(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Clear all the pins currently set in the lock. */
  func requestDoorLockClearAllPins(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusDoorLockCapability {
  public func getDoorLockLockstate(_ model: DeviceModel) -> DoorLockLockstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.doorLockLockstate] as? String,
      let enumAttr: DoorLockLockstate = DoorLockLockstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setDoorLockLockstate(_ lockstate: DoorLockLockstate, model: DeviceModel) {
    model.set([Attributes.doorLockLockstate: lockstate.rawValue as AnyObject])
  }
  public func getDoorLockType(_ model: DeviceModel) -> DoorLockType? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.doorLockType] as? String,
      let enumAttr: DoorLockType = DoorLockType(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getDoorLockSlots(_ model: DeviceModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorLockSlots] as? [String: String]
  }
  
  public func getDoorLockNumPinsSupported(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorLockNumPinsSupported] as? Int
  }
  
  public func getDoorLockSupportsInvalidPin(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorLockSupportsInvalidPin] as? Bool
  }
  
  public func getDoorLockSupportsBuzzIn(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorLockSupportsBuzzIn] as? Bool
  }
  
  public func getDoorLockLockstatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.doorLockLockstatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestDoorLockAuthorizePerson(_  model: DeviceModel, personId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: DoorLockAuthorizePersonRequest = DoorLockAuthorizePersonRequest()
    request.source = model.address
    
    
    
    request.setPersonId(personId)
    
    return try sendRequest(request)
  }
  
  public func requestDoorLockDeauthorizePerson(_  model: DeviceModel, personId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: DoorLockDeauthorizePersonRequest = DoorLockDeauthorizePersonRequest()
    request.source = model.address
    
    
    
    request.setPersonId(personId)
    
    return try sendRequest(request)
  }
  
  public func requestDoorLockBuzzIn(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DoorLockBuzzInRequest = DoorLockBuzzInRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestDoorLockClearAllPins(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DoorLockClearAllPinsRequest = DoorLockClearAllPinsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
