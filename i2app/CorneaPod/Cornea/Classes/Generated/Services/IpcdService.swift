
//
// IpcdService.swift
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
  public static let ipcdServiceNamespace: String = "ipcd"
  public static let ipcdServiceName: String = "IpcdService"
  public static let ipcdServiceAddress: String = "SERV:ipcd:"
}

/** IPCD Service */
public protocol ArcusIpcdService: RxArcusService {
  /** Lists the available vendor/model combinations for supported IPCD devices */
  func requestIpcdServiceListDeviceTypes() throws -> Observable<ArcusSessionEvent>/** Finds the IPCD device for the given vendor/model/sn combination that uniquely identies an IPCD device */
  func requestIpcdServiceFindDevice(_ deviceType: Any, sn: String) throws -> Observable<ArcusSessionEvent>/** Forces unregistration of an IPCD device */
  func requestIpcdServiceForceUnregister(_ protocolAddress: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusIpcdService {
  public func requestIpcdServiceListDeviceTypes() throws -> Observable<ArcusSessionEvent> {
    let request: IpcdServiceListDeviceTypesRequest = IpcdServiceListDeviceTypesRequest()
    request.source = Constants.ipcdServiceAddress
    
    

    return try sendRequest(request)
  }
  public func requestIpcdServiceFindDevice(_ deviceType: Any, sn: String) throws -> Observable<ArcusSessionEvent> {
    let request: IpcdServiceFindDeviceRequest = IpcdServiceFindDeviceRequest()
    request.source = Constants.ipcdServiceAddress
    
    
    request.setDeviceType(deviceType)
    request.setSn(sn)

    return try sendRequest(request)
  }
  public func requestIpcdServiceForceUnregister(_ protocolAddress: String) throws -> Observable<ArcusSessionEvent> {
    let request: IpcdServiceForceUnregisterRequest = IpcdServiceForceUnregisterRequest()
    request.source = Constants.ipcdServiceAddress
    
    
    request.setProtocolAddress(protocolAddress)

    return try sendRequest(request)
  }
  
}
