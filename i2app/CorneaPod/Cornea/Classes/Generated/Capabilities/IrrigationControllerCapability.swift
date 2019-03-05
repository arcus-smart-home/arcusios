
//
// IrrigationControllerCap.swift
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
  public static var irrigationControllerNamespace: String = "irrcont"
  public static var irrigationControllerName: String = "IrrigationController"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let irrigationControllerNumZones: String = "irrcont:numZones"
  static let irrigationControllerControllerState: String = "irrcont:controllerState"
  static let irrigationControllerRainDelayStart: String = "irrcont:rainDelayStart"
  static let irrigationControllerRainDelayDuration: String = "irrcont:rainDelayDuration"
  static let irrigationControllerMaxtransitions: String = "irrcont:maxtransitions"
  static let irrigationControllerMaxdailytransitions: String = "irrcont:maxdailytransitions"
  static let irrigationControllerMinirrigationtime: String = "irrcont:minirrigationtime"
  static let irrigationControllerMaxirrigationtime: String = "irrcont:maxirrigationtime"
  static let irrigationControllerBudget: String = "irrcont:budget"
  static let irrigationControllerZonesinfault: String = "irrcont:zonesinfault"
  static let irrigationControllerRainDelay: String = "irrcont:rainDelay"
  
}

public protocol ArcusIrrigationControllerCapability: class, RxArcusService {
  /** The number of irrigation zones this device controls. */
  func getIrrigationControllerNumZones(_ model: DeviceModel) -> Int?
  /** Indicates whether the zone is currently watering or not */
  func getIrrigationControllerControllerState(_ model: DeviceModel) -> IrrigationControllerControllerState?
  /** The start time of a rain delay. Used together with rainDelayDuration this can be used to define a time range during which the rain delay is active. */
  func getIrrigationControllerRainDelayStart(_ model: DeviceModel) -> Date?
  /** If zero, no rain delay is in affect. If non-zero, this value can be used together with rainDelayStart to define a time range during which the rain delay is active. */
  func getIrrigationControllerRainDelayDuration(_ model: DeviceModel) -> Int?
  /** Maximum number of schedule events this device can support. The schedule cannot allow the user to set more total events than this. */
  func getIrrigationControllerMaxtransitions(_ model: DeviceModel) -> Int?
  /** Maximum number of schedule events per day this device can support. */
  func getIrrigationControllerMaxdailytransitions(_ model: DeviceModel) -> Int?
  /** Minimum time one zone can be watering at a time. */
  func getIrrigationControllerMinirrigationtime(_ model: DeviceModel) -> Int?
  /** Maximum time one zone can be watering at a time. */
  func getIrrigationControllerMaxirrigationtime(_ model: DeviceModel) -> Int?
  /** Default: 100. Setting this number from 10-90 (most devices only support 10% increments) reduces the water usage to that percentage. Setting this number from 110-200) increases water usage for dryer moments. Note: current Orbit devices support &#x27;stacking&#x27; meaning if the increased schedule results in a subsequent start time to be delayed, this start time becomes &#x27;stacked&#x27; and handled as soon as possible. If the UI supports showing the user what zone is running, supporting budget&gt;100 means the UI will need to compute this stacking. Alternative is to not allow this number to be over 100 (as Arcus1 does). */
  func getIrrigationControllerBudget(_ model: DeviceModel) -> Int?
  /** Default: 100. Setting this number from 10-90 (most devices only support 10% increments) reduces the water usage to that percentage. Setting this number from 110-200) increases water usage for dryer moments. Note: current Orbit devices support &#x27;stacking&#x27; meaning if the increased schedule results in a subsequent start time to be delayed, this start time becomes &#x27;stacked&#x27; and handled as soon as possible. If the UI supports showing the user what zone is running, supporting budget&gt;100 means the UI will need to compute this stacking. Alternative is to not allow this number to be over 100 (as Arcus1 does). */
  func setIrrigationControllerBudget(_ budget: Int, model: DeviceModel)
/** Which zones are currently in fault (solenoid jammed, usually). 0 can represent a single pump, if each zone has a pump than pump and/or solenoid should be represented by zonenum. */
  func getIrrigationControllerZonesinfault(_ model: DeviceModel) -> [Int]?
  /** This attribute was deprecated in 1.8. */
  func getIrrigationControllerRainDelay(_ model: DeviceModel) -> Int?
  /** This attribute was deprecated in 1.8. */
  func setIrrigationControllerRainDelay(_ rainDelay: Int, model: DeviceModel)

  /** Starts watering the indicated zone for the duration specified. */
  func requestIrrigationControllerWaterNowV2(_  model: DeviceModel, zone: String, duration: Int)
   throws -> Observable<ArcusSessionEvent>/** Cancels any watering currently in progress. */
  func requestIrrigationControllerCancelV2(_  model: DeviceModel, zone: String)
   throws -> Observable<ArcusSessionEvent>/** This method was deprecated in 1.8. */
  func requestIrrigationControllerWaterNow(_  model: DeviceModel, zonenum: Int, duration: Int)
   throws -> Observable<ArcusSessionEvent>/** This method was deprecated in 1.8. */
  func requestIrrigationControllerCancel(_  model: DeviceModel, zonenum: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusIrrigationControllerCapability {
  public func getIrrigationControllerNumZones(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerNumZones] as? Int
  }
  
  public func getIrrigationControllerControllerState(_ model: DeviceModel) -> IrrigationControllerControllerState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.irrigationControllerControllerState] as? String,
      let enumAttr: IrrigationControllerControllerState = IrrigationControllerControllerState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getIrrigationControllerRainDelayStart(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.irrigationControllerRainDelayStart] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getIrrigationControllerRainDelayDuration(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerRainDelayDuration] as? Int
  }
  
  public func getIrrigationControllerMaxtransitions(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerMaxtransitions] as? Int
  }
  
  public func getIrrigationControllerMaxdailytransitions(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerMaxdailytransitions] as? Int
  }
  
  public func getIrrigationControllerMinirrigationtime(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerMinirrigationtime] as? Int
  }
  
  public func getIrrigationControllerMaxirrigationtime(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerMaxirrigationtime] as? Int
  }
  
  public func getIrrigationControllerBudget(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerBudget] as? Int
  }
  
  public func setIrrigationControllerBudget(_ budget: Int, model: DeviceModel) {
    model.set([Attributes.irrigationControllerBudget: budget as AnyObject])
  }
  public func getIrrigationControllerZonesinfault(_ model: DeviceModel) -> [Int]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerZonesinfault] as? [Int]
  }
  
  public func getIrrigationControllerRainDelay(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationControllerRainDelay] as? Int
  }
  
  public func setIrrigationControllerRainDelay(_ rainDelay: Int, model: DeviceModel) {
    model.set([Attributes.irrigationControllerRainDelay: rainDelay as AnyObject])
  }
  
  public func requestIrrigationControllerWaterNowV2(_  model: DeviceModel, zone: String, duration: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationControllerWaterNowV2Request = IrrigationControllerWaterNowV2Request()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setDuration(duration)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationControllerCancelV2(_  model: DeviceModel, zone: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationControllerCancelV2Request = IrrigationControllerCancelV2Request()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationControllerWaterNow(_  model: DeviceModel, zonenum: Int, duration: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationControllerWaterNowRequest = IrrigationControllerWaterNowRequest()
    request.source = model.address
    
    
    
    request.setZonenum(zonenum)
    
    request.setDuration(duration)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationControllerCancel(_  model: DeviceModel, zonenum: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationControllerCancelRequest = IrrigationControllerCancelRequest()
    request.source = model.address
    
    
    
    request.setZonenum(zonenum)
    
    return try sendRequest(request)
  }
  
}
