
//
// DoorsNLocksSubsystemCapabilityLegacy.swift
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

public class DoorsNLocksSubsystemCapabilityLegacy: NSObject, ArcusDoorsNLocksSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DoorsNLocksSubsystemCapabilityLegacy  = DoorsNLocksSubsystemCapabilityLegacy()
  

  
  public static func getLockDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemLockDevices(model)
  }
  
  public static func getMotorizedDoorDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemMotorizedDoorDevices(model)
  }
  
  public static func getContactSensorDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemContactSensorDevices(model)
  }
  
  public static func getPetDoorDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemPetDoorDevices(model)
  }
  
  public static func getWarnings(_ model: SubsystemModel) -> [String: String]? {
    return capability.getDoorsNLocksSubsystemWarnings(model)
  }
  
  public static func getUnlockedLocks(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemUnlockedLocks(model)
  }
  
  public static func getOfflineLocks(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemOfflineLocks(model)
  }
  
  public static func getJammedLocks(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemJammedLocks(model)
  }
  
  public static func getOpenMotorizedDoors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemOpenMotorizedDoors(model)
  }
  
  public static func getOfflineMotorizedDoors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemOfflineMotorizedDoors(model)
  }
  
  public static func getObstructedMotorizedDoors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemObstructedMotorizedDoors(model)
  }
  
  public static func getOpenContactSensors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemOpenContactSensors(model)
  }
  
  public static func getOfflineContactSensors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemOfflineContactSensors(model)
  }
  
  public static func getUnlockedPetDoors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemUnlockedPetDoors(model)
  }
  
  public static func getAutoPetDoors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemAutoPetDoors(model)
  }
  
  public static func getOfflinePetDoors(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemOfflinePetDoors(model)
  }
  
  public static func getAllPeople(_ model: SubsystemModel) -> [String]? {
    return capability.getDoorsNLocksSubsystemAllPeople(model)
  }
  
  public static func getAuthorizationByLock(_ model: SubsystemModel) -> [String: [Any]]? {
    return capability.getDoorsNLocksSubsystemAuthorizationByLock(model)
  }
  
  public static func getChimeConfig(_ model: SubsystemModel) -> [Any]? {
    return capability.getDoorsNLocksSubsystemChimeConfig(model)
  }
  
  public static func setChimeConfig(_ chimeConfig: [Any], model: SubsystemModel) {
    
    
    capability.setDoorsNLocksSubsystemChimeConfig(chimeConfig, model: model)
  }
  
  public static func authorizePeople(_  model: SubsystemModel, device: String, operations: [Any]) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDoorsNLocksSubsystemAuthorizePeople(model, device: device, operations: operations))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func synchAuthorization(_  model: SubsystemModel, device: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDoorsNLocksSubsystemSynchAuthorization(model, device: device))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
