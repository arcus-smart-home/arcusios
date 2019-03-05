
//
// DeviceCapabilityLegacy.swift
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

public class DeviceCapabilityLegacy: NSObject, ArcusDeviceCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DeviceCapabilityLegacy  = DeviceCapabilityLegacy()
  

  
  public static func getAccount(_ model: DeviceModel) -> String? {
    return capability.getDeviceAccount(model)
  }
  
  public static func getPlace(_ model: DeviceModel) -> String? {
    return capability.getDevicePlace(model)
  }
  
  public static func getDevtypehint(_ model: DeviceModel) -> String? {
    return capability.getDeviceDevtypehint(model)
  }
  
  public static func getName(_ model: DeviceModel) -> String? {
    return capability.getDeviceName(model)
  }
  
  public static func setName(_ name: String, model: DeviceModel) {
    
    
    capability.setDeviceName(name, model: model)
  }
  
  public static func getVendor(_ model: DeviceModel) -> String? {
    return capability.getDeviceVendor(model)
  }
  
  public static func getModel(_ model: DeviceModel) -> String? {
    return capability.getDeviceModel(model)
  }
  
  public static func getProductId(_ model: DeviceModel) -> String? {
    return capability.getDeviceProductId(model)
  }
  
  public static func listHistoryEntries(_  model: DeviceModel, limit: Int, token: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDeviceListHistoryEntries(model, limit: limit, token: token))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func remove(_  model: DeviceModel, timeout: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDeviceRemove(model, timeout: timeout))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func forceRemove(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestDeviceForceRemove(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
