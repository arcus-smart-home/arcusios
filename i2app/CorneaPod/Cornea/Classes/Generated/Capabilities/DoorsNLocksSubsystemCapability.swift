
//
// DoorsNLocksSubsystemCap.swift
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
  public static var doorsNLocksSubsystemNamespace: String = "subdoorsnlocks"
  public static var doorsNLocksSubsystemName: String = "DoorsNLocksSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let doorsNLocksSubsystemLockDevices: String = "subdoorsnlocks:lockDevices"
  static let doorsNLocksSubsystemMotorizedDoorDevices: String = "subdoorsnlocks:motorizedDoorDevices"
  static let doorsNLocksSubsystemContactSensorDevices: String = "subdoorsnlocks:contactSensorDevices"
  static let doorsNLocksSubsystemPetDoorDevices: String = "subdoorsnlocks:petDoorDevices"
  static let doorsNLocksSubsystemWarnings: String = "subdoorsnlocks:warnings"
  static let doorsNLocksSubsystemUnlockedLocks: String = "subdoorsnlocks:unlockedLocks"
  static let doorsNLocksSubsystemOfflineLocks: String = "subdoorsnlocks:offlineLocks"
  static let doorsNLocksSubsystemJammedLocks: String = "subdoorsnlocks:jammedLocks"
  static let doorsNLocksSubsystemOpenMotorizedDoors: String = "subdoorsnlocks:openMotorizedDoors"
  static let doorsNLocksSubsystemOfflineMotorizedDoors: String = "subdoorsnlocks:offlineMotorizedDoors"
  static let doorsNLocksSubsystemObstructedMotorizedDoors: String = "subdoorsnlocks:obstructedMotorizedDoors"
  static let doorsNLocksSubsystemOpenContactSensors: String = "subdoorsnlocks:openContactSensors"
  static let doorsNLocksSubsystemOfflineContactSensors: String = "subdoorsnlocks:offlineContactSensors"
  static let doorsNLocksSubsystemUnlockedPetDoors: String = "subdoorsnlocks:unlockedPetDoors"
  static let doorsNLocksSubsystemAutoPetDoors: String = "subdoorsnlocks:autoPetDoors"
  static let doorsNLocksSubsystemOfflinePetDoors: String = "subdoorsnlocks:offlinePetDoors"
  static let doorsNLocksSubsystemAllPeople: String = "subdoorsnlocks:allPeople"
  static let doorsNLocksSubsystemAuthorizationByLock: String = "subdoorsnlocks:authorizationByLock"
  static let doorsNLocksSubsystemChimeConfig: String = "subdoorsnlocks:chimeConfig"
  
}

public protocol ArcusDoorsNLocksSubsystemCapability: class, RxArcusService {
  /** The addresses of door locks defined at this place */
  func getDoorsNLocksSubsystemLockDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of motorized doors defined at this place */
  func getDoorsNLocksSubsystemMotorizedDoorDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of contact sensors defined at this place */
  func getDoorsNLocksSubsystemContactSensorDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of pet doors defined at this place */
  func getDoorsNLocksSubsystemPetDoorDevices(_ model: SubsystemModel) -> [String]?
  /** A set of warnings about devices which have potential issues that could cause an alarm to be missed.  The key is the address of the device with a warning and the value is an I18N code with the description of the problem. */
  func getDoorsNLocksSubsystemWarnings(_ model: SubsystemModel) -> [String: String]?
  /** The addresses of door locks that are currently unlocked */
  func getDoorsNLocksSubsystemUnlockedLocks(_ model: SubsystemModel) -> [String]?
  /** The addresses of door locks that are currently offline */
  func getDoorsNLocksSubsystemOfflineLocks(_ model: SubsystemModel) -> [String]?
  /** The addresses of door locks that are currently jammed */
  func getDoorsNLocksSubsystemJammedLocks(_ model: SubsystemModel) -> [String]?
  /** The addresses of motorized doors that are currently open */
  func getDoorsNLocksSubsystemOpenMotorizedDoors(_ model: SubsystemModel) -> [String]?
  /** The addresses of motorized doors that are currently offline */
  func getDoorsNLocksSubsystemOfflineMotorizedDoors(_ model: SubsystemModel) -> [String]?
  /** The addresses of motorized doors that are currently obstructed */
  func getDoorsNLocksSubsystemObstructedMotorizedDoors(_ model: SubsystemModel) -> [String]?
  /** The addressees of currently open contact sensors */
  func getDoorsNLocksSubsystemOpenContactSensors(_ model: SubsystemModel) -> [String]?
  /** The addresses of currently offline contact sensors */
  func getDoorsNLocksSubsystemOfflineContactSensors(_ model: SubsystemModel) -> [String]?
  /** The addresses of currently locked pet doors */
  func getDoorsNLocksSubsystemUnlockedPetDoors(_ model: SubsystemModel) -> [String]?
  /** The addresses of pet doors in auto mode */
  func getDoorsNLocksSubsystemAutoPetDoors(_ model: SubsystemModel) -> [String]?
  /** The addresses of offline pet doors */
  func getDoorsNLocksSubsystemOfflinePetDoors(_ model: SubsystemModel) -> [String]?
  /** The set of all people at the place that could be assigned to a lock (those with access and a pin) */
  func getDoorsNLocksSubsystemAllPeople(_ model: SubsystemModel) -> [String]?
  /** A between a door lock and the people that currently have access to that lock */
  func getDoorsNLocksSubsystemAuthorizationByLock(_ model: SubsystemModel) -> [String: [Any]]?
  /** The set of all that could have a chiming enabled/disabled. */
  func getDoorsNLocksSubsystemChimeConfig(_ model: SubsystemModel) -> [Any]?
  /** The set of all that could have a chiming enabled/disabled. */
  func setDoorsNLocksSubsystemChimeConfig(_ chimeConfig: [Any], model: SubsystemModel)

  /** Authorizes the given people on the lock.  Any people that previously existed on the lock not in this set will be deauthorized */
  func requestDoorsNLocksSubsystemAuthorizePeople(_  model: SubsystemModel, device: String, operations: [Any])
   throws -> Observable<ArcusSessionEvent>/** Synchronizes the access on the device and the service, by clearing all pins and reassociating people that should have access */
  func requestDoorsNLocksSubsystemSynchAuthorization(_  model: SubsystemModel, device: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusDoorsNLocksSubsystemCapability {
  public func getDoorsNLocksSubsystemLockDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemLockDevices] as? [String]
  }
  
  public func getDoorsNLocksSubsystemMotorizedDoorDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemMotorizedDoorDevices] as? [String]
  }
  
  public func getDoorsNLocksSubsystemContactSensorDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemContactSensorDevices] as? [String]
  }
  
  public func getDoorsNLocksSubsystemPetDoorDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemPetDoorDevices] as? [String]
  }
  
  public func getDoorsNLocksSubsystemWarnings(_ model: SubsystemModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemWarnings] as? [String: String]
  }
  
  public func getDoorsNLocksSubsystemUnlockedLocks(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemUnlockedLocks] as? [String]
  }
  
  public func getDoorsNLocksSubsystemOfflineLocks(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemOfflineLocks] as? [String]
  }
  
  public func getDoorsNLocksSubsystemJammedLocks(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemJammedLocks] as? [String]
  }
  
  public func getDoorsNLocksSubsystemOpenMotorizedDoors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemOpenMotorizedDoors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemOfflineMotorizedDoors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemOfflineMotorizedDoors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemObstructedMotorizedDoors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemObstructedMotorizedDoors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemOpenContactSensors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemOpenContactSensors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemOfflineContactSensors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemOfflineContactSensors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemUnlockedPetDoors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemUnlockedPetDoors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemAutoPetDoors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemAutoPetDoors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemOfflinePetDoors(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemOfflinePetDoors] as? [String]
  }
  
  public func getDoorsNLocksSubsystemAllPeople(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemAllPeople] as? [String]
  }
  
  public func getDoorsNLocksSubsystemAuthorizationByLock(_ model: SubsystemModel) -> [String: [Any]]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemAuthorizationByLock] as? [String: [Any]]
  }
  
  public func getDoorsNLocksSubsystemChimeConfig(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.doorsNLocksSubsystemChimeConfig] as? [Any]
  }
  
  public func setDoorsNLocksSubsystemChimeConfig(_ chimeConfig: [Any], model: SubsystemModel) {
    model.set([Attributes.doorsNLocksSubsystemChimeConfig: chimeConfig as AnyObject])
  }
  
  public func requestDoorsNLocksSubsystemAuthorizePeople(_  model: SubsystemModel, device: String, operations: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: DoorsNLocksSubsystemAuthorizePeopleRequest = DoorsNLocksSubsystemAuthorizePeopleRequest()
    request.source = model.address
    
    
    
    request.setDevice(device)
    
    request.setOperations(operations)
    
    return try sendRequest(request)
  }
  
  public func requestDoorsNLocksSubsystemSynchAuthorization(_  model: SubsystemModel, device: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: DoorsNLocksSubsystemSynchAuthorizationRequest = DoorsNLocksSubsystemSynchAuthorizationRequest()
    request.source = model.address
    
    
    
    request.setDevice(device)
    
    return try sendRequest(request)
  }
  
}
