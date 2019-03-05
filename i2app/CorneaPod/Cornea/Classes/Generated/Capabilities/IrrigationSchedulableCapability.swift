
//
// IrrigationSchedulableCap.swift
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
  public static var irrigationSchedulableNamespace: String = "irrsched"
  public static var irrigationSchedulableName: String = "IrrigationSchedulable"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let irrigationSchedulableRefreshSchedule: String = "irrsched:refreshSchedule"
  
}

public protocol ArcusIrrigationSchedulableCapability: class, RxArcusService {
  /** If true then the device needs to schedule synchronized with the platform. */
  func getIrrigationSchedulableRefreshSchedule(_ model: DeviceModel) -> Bool?
  /** If true then the device needs to schedule synchronized with the platform. */
  func setIrrigationSchedulableRefreshSchedule(_ refreshSchedule: Bool, model: DeviceModel)

  /** Enables scheduling on the device */
  func requestIrrigationSchedulableEnableSchedule(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Disables schedulig on the device for an optional amount of time */
  func requestIrrigationSchedulableDisableSchedule(_  model: DeviceModel, duration: Int)
   throws -> Observable<ArcusSessionEvent>/** Clears the even/odd day schedule for the given zone */
  func requestIrrigationSchedulableClearEvenOddSchedule(_  model: DeviceModel, zone: String, opId: String)
   throws -> Observable<ArcusSessionEvent>/** Sets an even/odd day schedule for the given zone */
  func requestIrrigationSchedulableSetEvenOddSchedule(_  model: DeviceModel, zone: String, even: Bool, transitions: [Any], opId: String)
   throws -> Observable<ArcusSessionEvent>/** Clears the interval schedule for the given zone */
  func requestIrrigationSchedulableClearIntervalSchedule(_  model: DeviceModel, zone: String, opId: String)
   throws -> Observable<ArcusSessionEvent>/** Sets an interval schedule for the given zone */
  func requestIrrigationSchedulableSetIntervalSchedule(_  model: DeviceModel, zone: String, days: Int, transitions: [Any], opId: String)
   throws -> Observable<ArcusSessionEvent>/** Sets the interval start date */
  func requestIrrigationSchedulableSetIntervalStart(_  model: DeviceModel, zone: String, startDate: Date, opId: String)
   throws -> Observable<ArcusSessionEvent>/** Clears the weekly schedule for the given zone */
  func requestIrrigationSchedulableClearWeeklySchedule(_  model: DeviceModel, zone: String, opId: String)
   throws -> Observable<ArcusSessionEvent>/** Sets a weekly schedule for the given zone */
  func requestIrrigationSchedulableSetWeeklySchedule(_  model: DeviceModel, zone: String, days: [String], transitions: [Any], opId: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusIrrigationSchedulableCapability {
  public func getIrrigationSchedulableRefreshSchedule(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.irrigationSchedulableRefreshSchedule] as? Bool
  }
  
  public func setIrrigationSchedulableRefreshSchedule(_ refreshSchedule: Bool, model: DeviceModel) {
    model.set([Attributes.irrigationSchedulableRefreshSchedule: refreshSchedule as AnyObject])
  }
  
  public func requestIrrigationSchedulableEnableSchedule(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableEnableScheduleRequest = IrrigationSchedulableEnableScheduleRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableDisableSchedule(_  model: DeviceModel, duration: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableDisableScheduleRequest = IrrigationSchedulableDisableScheduleRequest()
    request.source = model.address
    
    
    
    request.setDuration(duration)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableClearEvenOddSchedule(_  model: DeviceModel, zone: String, opId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableClearEvenOddScheduleRequest = IrrigationSchedulableClearEvenOddScheduleRequest()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setOpId(opId)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableSetEvenOddSchedule(_  model: DeviceModel, zone: String, even: Bool, transitions: [Any], opId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableSetEvenOddScheduleRequest = IrrigationSchedulableSetEvenOddScheduleRequest()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setEven(even)
    
    request.setTransitions(transitions)
    
    request.setOpId(opId)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableClearIntervalSchedule(_  model: DeviceModel, zone: String, opId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableClearIntervalScheduleRequest = IrrigationSchedulableClearIntervalScheduleRequest()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setOpId(opId)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableSetIntervalSchedule(_  model: DeviceModel, zone: String, days: Int, transitions: [Any], opId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableSetIntervalScheduleRequest = IrrigationSchedulableSetIntervalScheduleRequest()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setDays(days)
    
    request.setTransitions(transitions)
    
    request.setOpId(opId)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableSetIntervalStart(_  model: DeviceModel, zone: String, startDate: Date, opId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableSetIntervalStartRequest = IrrigationSchedulableSetIntervalStartRequest()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setStartDate(startDate)
    
    request.setOpId(opId)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableClearWeeklySchedule(_  model: DeviceModel, zone: String, opId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableClearWeeklyScheduleRequest = IrrigationSchedulableClearWeeklyScheduleRequest()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setOpId(opId)
    
    return try sendRequest(request)
  }
  
  public func requestIrrigationSchedulableSetWeeklySchedule(_  model: DeviceModel, zone: String, days: [String], transitions: [Any], opId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IrrigationSchedulableSetWeeklyScheduleRequest = IrrigationSchedulableSetWeeklyScheduleRequest()
    request.source = model.address
    
    
    
    request.setZone(zone)
    
    request.setDays(days)
    
    request.setTransitions(transitions)
    
    request.setOpId(opId)
    
    return try sendRequest(request)
  }
  
}
