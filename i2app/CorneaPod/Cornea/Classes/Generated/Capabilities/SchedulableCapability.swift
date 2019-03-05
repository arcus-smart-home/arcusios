
//
// SchedulableCap.swift
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
  public static var schedulableNamespace: String = "schedulable"
  public static var schedulableName: String = "Schedulable"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let schedulableType: String = "schedulable:type"
  static let schedulableScheduleEnabled: String = "schedulable:scheduleEnabled"
  
}

public protocol ArcusSchedulableCapability: class, RxArcusService {
  /** The type of scheduling that is possible on this device. NOT_SUPPORTED:  No scheduling is possible either via Arcus or the physical device DEVICE_ONLY:  Scheduling is not possible via Arcus, but can be configured on the physical device DRIVER_READ_ONLY:  Arcus may read scheduling information via a driver specific implementation but cannot write schedule information DRIVER_WRITE_ONLY:  Arcus may write scheduling information via a driver specific implementation but cnnot read schedule information SUPPORTED_DRIVER:  Arcus may completely control scheduling of the device via a driver specific implementation (i.e. schedule is likely read and pushed to the device) SUPPORTED_CLOUD:  Arcus may completely control scheduling of the device via an internal mechanism (i.e. cloud or hub based)  */
  func getSchedulableType(_ model: DeviceModel) -> SchedulableType?
  /** Whether or not a schedule is currently enabled for this device */
  func getSchedulableScheduleEnabled(_ model: DeviceModel) -> Bool?
  
  /** Enables scheduling for this device */
  func requestSchedulableEnableSchedule(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Disables scheduling for this device */
  func requestSchedulableDisableSchedule(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSchedulableCapability {
  public func getSchedulableType(_ model: DeviceModel) -> SchedulableType? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.schedulableType] as? String,
      let enumAttr: SchedulableType = SchedulableType(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSchedulableScheduleEnabled(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.schedulableScheduleEnabled] as? Bool
  }
  
  
  public func requestSchedulableEnableSchedule(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulableEnableScheduleRequest = SchedulableEnableScheduleRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSchedulableDisableSchedule(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: SchedulableDisableScheduleRequest = SchedulableDisableScheduleRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
