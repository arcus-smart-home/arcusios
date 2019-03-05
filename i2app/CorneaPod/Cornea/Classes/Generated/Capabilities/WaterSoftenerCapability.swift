
//
// WaterSoftenerCap.swift
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
  public static var waterSoftenerNamespace: String = "watersoftener"
  public static var waterSoftenerName: String = "WaterSoftener"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let waterSoftenerRechargeStatus: String = "watersoftener:rechargeStatus"
  static let waterSoftenerCurrentSaltLevel: String = "watersoftener:currentSaltLevel"
  static let waterSoftenerMaxSaltLevel: String = "watersoftener:maxSaltLevel"
  static let waterSoftenerSaltLevelEnabled: String = "watersoftener:saltLevelEnabled"
  static let waterSoftenerRechargeStartTime: String = "watersoftener:rechargeStartTime"
  static let waterSoftenerRechargeTimeRemaining: String = "watersoftener:rechargeTimeRemaining"
  static let waterSoftenerDaysPoweredUp: String = "watersoftener:daysPoweredUp"
  static let waterSoftenerTotalRecharges: String = "watersoftener:totalRecharges"
  
}

public protocol ArcusWaterSoftenerCapability: class, RxArcusService {
  /** Recharge status of the water softener:  READY (providing soft water), RECHARGING (actively regenerating), RECHARGE_SCHEDULED (recharge required and will be done at rechargeStartTime) */
  func getWaterSoftenerRechargeStatus(_ model: DeviceModel) -> WaterSoftenerRechargeStatus?
  /** Current salt level from 0 (empty) to maxSaltLevel */
  func getWaterSoftenerCurrentSaltLevel(_ model: DeviceModel) -> Int?
  /** Max salt level for this softener */
  func getWaterSoftenerMaxSaltLevel(_ model: DeviceModel) -> Int?
  /** true indicates currentSaltLevel should be accurate - false indicates currentSaltLevel should be ignored */
  func getWaterSoftenerSaltLevelEnabled(_ model: DeviceModel) -> Bool?
  /** When regeneration is needed, hour of the day when it should be scheduled (e.g. 14 = 2:00 PM). Does not guarantee that regeneration will occur daily. */
  func getWaterSoftenerRechargeStartTime(_ model: DeviceModel) -> Int?
  /** When regeneration is needed, hour of the day when it should be scheduled (e.g. 14 = 2:00 PM). Does not guarantee that regeneration will occur daily. */
  func setWaterSoftenerRechargeStartTime(_ rechargeStartTime: Int, model: DeviceModel)
/** The number of minutes left before the softener completes its recharge cycle. */
  func getWaterSoftenerRechargeTimeRemaining(_ model: DeviceModel) -> Int?
  /** The number of consecutive days the softener has been powered on */
  func getWaterSoftenerDaysPoweredUp(_ model: DeviceModel) -> Int?
  /** The total number of recharge cycles the softener has performed since being added to the network */
  func getWaterSoftenerTotalRecharges(_ model: DeviceModel) -> Int?
  
  /** Forces a recharge on the water softener. */
  func requestWaterSoftenerRechargeNow(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusWaterSoftenerCapability {
  public func getWaterSoftenerRechargeStatus(_ model: DeviceModel) -> WaterSoftenerRechargeStatus? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.waterSoftenerRechargeStatus] as? String,
      let enumAttr: WaterSoftenerRechargeStatus = WaterSoftenerRechargeStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getWaterSoftenerCurrentSaltLevel(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSoftenerCurrentSaltLevel] as? Int
  }
  
  public func getWaterSoftenerMaxSaltLevel(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSoftenerMaxSaltLevel] as? Int
  }
  
  public func getWaterSoftenerSaltLevelEnabled(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSoftenerSaltLevelEnabled] as? Bool
  }
  
  public func getWaterSoftenerRechargeStartTime(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSoftenerRechargeStartTime] as? Int
  }
  
  public func setWaterSoftenerRechargeStartTime(_ rechargeStartTime: Int, model: DeviceModel) {
    model.set([Attributes.waterSoftenerRechargeStartTime: rechargeStartTime as AnyObject])
  }
  public func getWaterSoftenerRechargeTimeRemaining(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSoftenerRechargeTimeRemaining] as? Int
  }
  
  public func getWaterSoftenerDaysPoweredUp(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSoftenerDaysPoweredUp] as? Int
  }
  
  public func getWaterSoftenerTotalRecharges(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSoftenerTotalRecharges] as? Int
  }
  
  
  public func requestWaterSoftenerRechargeNow(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: WaterSoftenerRechargeNowRequest = WaterSoftenerRechargeNowRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
