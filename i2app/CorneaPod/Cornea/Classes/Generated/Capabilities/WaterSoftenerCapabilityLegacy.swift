
//
// WaterSoftenerCapabilityLegacy.swift
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

public class WaterSoftenerCapabilityLegacy: NSObject, ArcusWaterSoftenerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: WaterSoftenerCapabilityLegacy  = WaterSoftenerCapabilityLegacy()
  
  static let WaterSoftenerRechargeStatusREADY: String = WaterSoftenerRechargeStatus.ready.rawValue
  static let WaterSoftenerRechargeStatusRECHARGING: String = WaterSoftenerRechargeStatus.recharging.rawValue
  static let WaterSoftenerRechargeStatusRECHARGE_SCHEDULED: String = WaterSoftenerRechargeStatus.recharge_scheduled.rawValue
  

  
  public static func getRechargeStatus(_ model: DeviceModel) -> String? {
    return capability.getWaterSoftenerRechargeStatus(model)?.rawValue
  }
  
  public static func getCurrentSaltLevel(_ model: DeviceModel) -> NSNumber? {
    guard let currentSaltLevel: Int = capability.getWaterSoftenerCurrentSaltLevel(model) else {
      return nil
    }
    return NSNumber(value: currentSaltLevel)
  }
  
  public static func getMaxSaltLevel(_ model: DeviceModel) -> NSNumber? {
    guard let maxSaltLevel: Int = capability.getWaterSoftenerMaxSaltLevel(model) else {
      return nil
    }
    return NSNumber(value: maxSaltLevel)
  }
  
  public static func getSaltLevelEnabled(_ model: DeviceModel) -> NSNumber? {
    guard let saltLevelEnabled: Bool = capability.getWaterSoftenerSaltLevelEnabled(model) else {
      return nil
    }
    return NSNumber(value: saltLevelEnabled)
  }
  
  public static func getRechargeStartTime(_ model: DeviceModel) -> NSNumber? {
    guard let rechargeStartTime: Int = capability.getWaterSoftenerRechargeStartTime(model) else {
      return nil
    }
    return NSNumber(value: rechargeStartTime)
  }
  
  public static func setRechargeStartTime(_ rechargeStartTime: Int, model: DeviceModel) {
    
    
    capability.setWaterSoftenerRechargeStartTime(rechargeStartTime, model: model)
  }
  
  public static func getRechargeTimeRemaining(_ model: DeviceModel) -> NSNumber? {
    guard let rechargeTimeRemaining: Int = capability.getWaterSoftenerRechargeTimeRemaining(model) else {
      return nil
    }
    return NSNumber(value: rechargeTimeRemaining)
  }
  
  public static func getDaysPoweredUp(_ model: DeviceModel) -> NSNumber? {
    guard let daysPoweredUp: Int = capability.getWaterSoftenerDaysPoweredUp(model) else {
      return nil
    }
    return NSNumber(value: daysPoweredUp)
  }
  
  public static func getTotalRecharges(_ model: DeviceModel) -> NSNumber? {
    guard let totalRecharges: Int = capability.getWaterSoftenerTotalRecharges(model) else {
      return nil
    }
    return NSNumber(value: totalRecharges)
  }
  
  public static func rechargeNow(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestWaterSoftenerRechargeNow(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
