
//
// NwsSameCodeService.swift
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
  public static let nwsSameCodeServiceNamespace: String = "nwssamecode"
  public static let nwsSameCodeServiceName: String = "NwsSameCodeService"
  public static let nwsSameCodeServiceAddress: String = "SERV:nwssamecode:"
}

/** Service methods for retrieving SAME Codes from the NWS SAME Code database. */
public protocol ArcusNwsSameCodeService: RxArcusService {
  /**  */
  func requestNwsSameCodeServiceListSameCounties(_ stateCode: String) throws -> Observable<ArcusSessionEvent>/**  */
  func requestNwsSameCodeServiceListSameStates() throws -> Observable<ArcusSessionEvent>/**  */
  func requestNwsSameCodeServiceGetSameCode(_ stateCode: String, county: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusNwsSameCodeService {
  public func requestNwsSameCodeServiceListSameCounties(_ stateCode: String) throws -> Observable<ArcusSessionEvent> {
    let request: NwsSameCodeServiceListSameCountiesRequest = NwsSameCodeServiceListSameCountiesRequest()
    request.source = Constants.nwsSameCodeServiceAddress
    request.isRequest = true
    
    request.setStateCode(stateCode)

    return try sendRequest(request)
  }
  public func requestNwsSameCodeServiceListSameStates() throws -> Observable<ArcusSessionEvent> {
    let request: NwsSameCodeServiceListSameStatesRequest = NwsSameCodeServiceListSameStatesRequest()
    request.source = Constants.nwsSameCodeServiceAddress
    request.isRequest = true
    

    return try sendRequest(request)
  }
  public func requestNwsSameCodeServiceGetSameCode(_ stateCode: String, county: String) throws -> Observable<ArcusSessionEvent> {
    let request: NwsSameCodeServiceGetSameCodeRequest = NwsSameCodeServiceGetSameCodeRequest()
    request.source = Constants.nwsSameCodeServiceAddress
    request.isRequest = true
    
    request.setStateCode(stateCode)
    request.setCounty(county)

    return try sendRequest(request)
  }
  
}
