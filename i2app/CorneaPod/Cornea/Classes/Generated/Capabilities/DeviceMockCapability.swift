
//
// DeviceMockCap.swift
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
  public static var deviceMockNamespace: String = "devmock"
  public static var deviceMockName: String = "DeviceMock"
}



public protocol ArcusDeviceMockCapability: class, RxArcusService {
  
  /** Sets the attributes on the mock device */
  func requestDeviceMockSetAttributes(_  model: DeviceModel, attrs: [String: Any])
   throws -> Observable<ArcusSessionEvent>/** Causes the device to connect */
  func requestDeviceMockConnect(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Causes the device to disconnect */
  func requestDeviceMockDisconnect(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusDeviceMockCapability {
  
  public func requestDeviceMockSetAttributes(_  model: DeviceModel, attrs: [String: Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: DeviceMockSetAttributesRequest = DeviceMockSetAttributesRequest()
    request.source = model.address
    
    
    
    request.setAttrs(attrs)
    
    return try sendRequest(request)
  }
  
  public func requestDeviceMockConnect(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceMockConnectRequest = DeviceMockConnectRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestDeviceMockDisconnect(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceMockDisconnectRequest = DeviceMockDisconnectRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
