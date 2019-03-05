
//
// IrrigationControllerCapabilityLegacy.swift
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

public class IrrigationControllerCapabilityLegacy: NSObject, ArcusIrrigationControllerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: IrrigationControllerCapabilityLegacy  = IrrigationControllerCapabilityLegacy()
  
  static let IrrigationControllerControllerStateOFF: String = IrrigationControllerControllerState.off.rawValue
  static let IrrigationControllerControllerStateWATERING: String = IrrigationControllerControllerState.watering.rawValue
  static let IrrigationControllerControllerStateNOT_WATERING: String = IrrigationControllerControllerState.not_watering.rawValue
  static let IrrigationControllerControllerStateRAIN_DELAY: String = IrrigationControllerControllerState.rain_delay.rawValue
  

  
  public static func getNumZones(_ model: DeviceModel) -> NSNumber? {
    guard let numZones: Int = capability.getIrrigationControllerNumZones(model) else {
      return nil
    }
    return NSNumber(value: numZones)
  }
  
  public static func getControllerState(_ model: DeviceModel) -> String? {
    return capability.getIrrigationControllerControllerState(model)?.rawValue
  }
  
  public static func getRainDelayStart(_ model: DeviceModel) -> Date? {
    guard let rainDelayStart: Date = capability.getIrrigationControllerRainDelayStart(model) else {
      return nil
    }
    return rainDelayStart
  }
  
  public static func getRainDelayDuration(_ model: DeviceModel) -> NSNumber? {
    guard let rainDelayDuration: Int = capability.getIrrigationControllerRainDelayDuration(model) else {
      return nil
    }
    return NSNumber(value: rainDelayDuration)
  }
  
  public static func getMaxtransitions(_ model: DeviceModel) -> NSNumber? {
    guard let maxtransitions: Int = capability.getIrrigationControllerMaxtransitions(model) else {
      return nil
    }
    return NSNumber(value: maxtransitions)
  }
  
  public static func getMaxdailytransitions(_ model: DeviceModel) -> NSNumber? {
    guard let maxdailytransitions: Int = capability.getIrrigationControllerMaxdailytransitions(model) else {
      return nil
    }
    return NSNumber(value: maxdailytransitions)
  }
  
  public static func getMinirrigationtime(_ model: DeviceModel) -> NSNumber? {
    guard let minirrigationtime: Int = capability.getIrrigationControllerMinirrigationtime(model) else {
      return nil
    }
    return NSNumber(value: minirrigationtime)
  }
  
  public static func getMaxirrigationtime(_ model: DeviceModel) -> NSNumber? {
    guard let maxirrigationtime: Int = capability.getIrrigationControllerMaxirrigationtime(model) else {
      return nil
    }
    return NSNumber(value: maxirrigationtime)
  }
  
  public static func getBudget(_ model: DeviceModel) -> NSNumber? {
    guard let budget: Int = capability.getIrrigationControllerBudget(model) else {
      return nil
    }
    return NSNumber(value: budget)
  }
  
  public static func setBudget(_ budget: Int, model: DeviceModel) {
    
    
    capability.setIrrigationControllerBudget(budget, model: model)
  }
  
  public static func getZonesinfault(_ model: DeviceModel) -> [Int]? {
    return capability.getIrrigationControllerZonesinfault(model)
  }
  
  public static func getRainDelay(_ model: DeviceModel) -> NSNumber? {
    guard let rainDelay: Int = capability.getIrrigationControllerRainDelay(model) else {
      return nil
    }
    return NSNumber(value: rainDelay)
  }
  
  public static func setRainDelay(_ rainDelay: Int, model: DeviceModel) {
    
    
    capability.setIrrigationControllerRainDelay(rainDelay, model: model)
  }
  
  public static func waterNowV2(_  model: DeviceModel, zone: String, duration: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationControllerWaterNowV2(model, zone: zone, duration: duration))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func cancelV2(_  model: DeviceModel, zone: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationControllerCancelV2(model, zone: zone))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func waterNow(_  model: DeviceModel, zonenum: Int, duration: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationControllerWaterNow(model, zonenum: zonenum, duration: duration))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func cancel(_  model: DeviceModel, zonenum: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIrrigationControllerCancel(model, zonenum: zonenum))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
