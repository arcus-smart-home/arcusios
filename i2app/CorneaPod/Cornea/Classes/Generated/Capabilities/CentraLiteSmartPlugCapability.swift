
//
// CentraLiteSmartPlugCap.swift
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
  public static var centraLiteSmartPlugNamespace: String = "centralitesmartplug"
  public static var centraLiteSmartPlugName: String = "CentraLiteSmartPlug"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let centraLiteSmartPlugHomeid: String = "centralitesmartplug:homeid"
  static let centraLiteSmartPlugNodeid: String = "centralitesmartplug:nodeid"
  
}

public protocol ArcusCentraLiteSmartPlugCapability: class, RxArcusService {
  /**  */
  func getCentraLiteSmartPlugHomeid(_ model: DeviceModel) -> String?
  /**  */
  func getCentraLiteSmartPlugNodeid(_ model: DeviceModel) -> String?
  
  /** Causes the Z-Wave side of the device to enter into learn mode for the specified duration. */
  func requestCentraLiteSmartPlugSetLearnMode(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Causes the Z-Wave side of the device to send a NIF frame. */
  func requestCentraLiteSmartPlugSendNif(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Causes the Z-Wave side of the device to reset. */
  func requestCentraLiteSmartPlugReset(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Attempt to pair the Z-Wave side of the device. */
  func requestCentraLiteSmartPlugPair(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Attempt to determine the Z-Wave side node and home id. */
  func requestCentraLiteSmartPlugQuery(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusCentraLiteSmartPlugCapability {
  public func getCentraLiteSmartPlugHomeid(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.centraLiteSmartPlugHomeid] as? String
  }
  
  public func getCentraLiteSmartPlugNodeid(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.centraLiteSmartPlugNodeid] as? String
  }
  
  
  public func requestCentraLiteSmartPlugSetLearnMode(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: CentraLiteSmartPlugSetLearnModeRequest = CentraLiteSmartPlugSetLearnModeRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCentraLiteSmartPlugSendNif(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: CentraLiteSmartPlugSendNifRequest = CentraLiteSmartPlugSendNifRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCentraLiteSmartPlugReset(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: CentraLiteSmartPlugResetRequest = CentraLiteSmartPlugResetRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCentraLiteSmartPlugPair(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: CentraLiteSmartPlugPairRequest = CentraLiteSmartPlugPairRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCentraLiteSmartPlugQuery(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: CentraLiteSmartPlugQueryRequest = CentraLiteSmartPlugQueryRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
