
//
// DeviceAdvancedCapabilityLegacy.swift
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

public class DeviceAdvancedCapabilityLegacy: NSObject, ArcusDeviceAdvancedCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DeviceAdvancedCapabilityLegacy  = DeviceAdvancedCapabilityLegacy()
  
  static let DeviceAdvancedDriverstateCREATED: String = DeviceAdvancedDriverstate.created.rawValue
  static let DeviceAdvancedDriverstatePROVISIONING: String = DeviceAdvancedDriverstate.provisioning.rawValue
  static let DeviceAdvancedDriverstateACTIVE: String = DeviceAdvancedDriverstate.active.rawValue
  static let DeviceAdvancedDriverstateUNSUPPORTED: String = DeviceAdvancedDriverstate.unsupported.rawValue
  static let DeviceAdvancedDriverstateRECOVERABLE: String = DeviceAdvancedDriverstate.recoverable.rawValue
  static let DeviceAdvancedDriverstateUNRECOVERABLE: String = DeviceAdvancedDriverstate.unrecoverable.rawValue
  static let DeviceAdvancedDriverstateTOMBSTONED: String = DeviceAdvancedDriverstate.tombstoned.rawValue
  

  
  public static func getDrivername(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedDrivername(model)
  }
  
  public static func getDriverversion(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedDriverversion(model)
  }
  
  public static func getDrivercommit(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedDrivercommit(model)
  }
  
  public static func getDriverhash(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedDriverhash(model)
  }
  
  public static func getDriverstate(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedDriverstate(model)?.rawValue
  }
  
  public static func getProtocol(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedProtocol(model)
  }
  
  public static func getSubprotocol(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedSubprotocol(model)
  }
  
  public static func getProtocolid(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedProtocolid(model)
  }
  
  public static func getErrors(_ model: DeviceModel) -> [String: String]? {
    return capability.getDeviceAdvancedErrors(model)
  }
  
  public static func getAdded(_ model: DeviceModel) -> Date? {
    guard let added: Date = capability.getDeviceAdvancedAdded(model) else {
      return nil
    }
    return added
  }
  
  public static func getFirmwareVersion(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedFirmwareVersion(model)
  }
  
  public static func getHubLocal(_ model: DeviceModel) -> NSNumber? {
    guard let hubLocal: Bool = capability.getDeviceAdvancedHubLocal(model) else {
      return nil
    }
    return NSNumber(value: hubLocal)
  }
  
  public static func getDegraded(_ model: DeviceModel) -> NSNumber? {
    guard let degraded: Bool = capability.getDeviceAdvancedDegraded(model) else {
      return nil
    }
    return NSNumber(value: degraded)
  }
  
  public static func getDegradedCode(_ model: DeviceModel) -> String? {
    return capability.getDeviceAdvancedDegradedCode(model)
  }
  
  public static func setDegradedCode(_ degradedCode: String, model: DeviceModel) {
    
    
    capability.setDeviceAdvancedDegradedCode(degradedCode, model: model)
  }
  
  public static func upgradeDriver(_  model: DeviceModel, driverName: String, driverVersion: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDeviceAdvancedUpgradeDriver(model, driverName: driverName, driverVersion: driverVersion))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getReflexes(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestDeviceAdvancedGetReflexes(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func reconfigure(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestDeviceAdvancedReconfigure(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
