
//
// ProblemDeviceCap.swift
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
  public static var problemDeviceNamespace: String = "suppprobdev"
  public static var problemDeviceName: String = "ProblemDevice"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let problemDeviceCreated: String = "suppprobdev:created"
  static let problemDeviceId: String = "suppprobdev:id"
  static let problemDeviceDeviceModel: String = "suppprobdev:deviceModel"
  static let problemDeviceMfg: String = "suppprobdev:mfg"
  static let problemDeviceDeviceType: String = "suppprobdev:deviceType"
  
}

public protocol ArcusProblemDeviceCapability: class, RxArcusService {
  /** The date the problem device was added to the db */
  func getProblemDeviceCreated(_ model: ProblemDeviceModel) -> Date?
  /** device id */
  func getProblemDeviceId(_ model: ProblemDeviceModel) -> String?
  /** specific model of the device */
  func getProblemDeviceDeviceModel(_ model: ProblemDeviceModel) -> String?
  /** manufacturer name of the device */
  func getProblemDeviceMfg(_ model: ProblemDeviceModel) -> String?
  /** generic type of the device */
  func getProblemDeviceDeviceType(_ model: ProblemDeviceModel) -> String?
  
  /** Add device(s) having a problem to the db. Normally taken care of by the end session call. */
  func requestProblemDeviceAddProblemDevices(_  model: ProblemDeviceModel, models: [Any])
   throws -> Observable<ArcusSessionEvent>/** Lists problem devices within a time range across accounts and places */
  func requestProblemDeviceListProblemDevicesForTimeframe(_  model: ProblemDeviceModel, deviceModel: String, mfg: String, deviceType: String, startDate: String, endDate: String, token: String, limit: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusProblemDeviceCapability {
  public func getProblemDeviceCreated(_ model: ProblemDeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.problemDeviceCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getProblemDeviceId(_ model: ProblemDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.problemDeviceId] as? String
  }
  
  public func getProblemDeviceDeviceModel(_ model: ProblemDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.problemDeviceDeviceModel] as? String
  }
  
  public func getProblemDeviceMfg(_ model: ProblemDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.problemDeviceMfg] as? String
  }
  
  public func getProblemDeviceDeviceType(_ model: ProblemDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.problemDeviceDeviceType] as? String
  }
  
  
  public func requestProblemDeviceAddProblemDevices(_  model: ProblemDeviceModel, models: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: ProblemDeviceAddProblemDevicesRequest = ProblemDeviceAddProblemDevicesRequest()
    request.source = model.address
    
    
    
    request.setModels(models)
    
    return try sendRequest(request)
  }
  
  public func requestProblemDeviceListProblemDevicesForTimeframe(_  model: ProblemDeviceModel, deviceModel: String, mfg: String, deviceType: String, startDate: String, endDate: String, token: String, limit: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProblemDeviceListProblemDevicesForTimeframeRequest = ProblemDeviceListProblemDevicesForTimeframeRequest()
    request.source = model.address
    
    
    
    request.setDeviceModel(deviceModel)
    
    request.setMfg(mfg)
    
    request.setDeviceType(deviceType)
    
    request.setStartDate(startDate)
    
    request.setEndDate(endDate)
    
    request.setToken(token)
    
    request.setLimit(limit)
    
    return try sendRequest(request)
  }
  
}
