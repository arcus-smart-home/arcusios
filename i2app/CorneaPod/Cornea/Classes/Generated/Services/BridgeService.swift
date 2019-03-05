
//
// BridgeService.swift
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
  public static let bridgeServiceNamespace: String = "bridgesvc"
  public static let bridgeServiceName: String = "BridgeService"
  public static let bridgeServiceAddress: String = "SERV:bridgesvc:"
}

/** Bridge Service for the mgt of bridge devices */
public protocol ArcusBridgeService: RxArcusService {
  /** Assigns a place to the device with the specified id provided the device is online. */
  func requestBridgeServiceRegisterDevice(_ attrs: [String: String]) throws -> Observable<ArcusSessionEvent>/** Removes the device with the specified id. */
  func requestBridgeServiceRemoveDevice(_ id: String, accountId: String, placeId: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusBridgeService {
  public func requestBridgeServiceRegisterDevice(_ attrs: [String: String]) throws -> Observable<ArcusSessionEvent> {
    let request: BridgeServiceRegisterDeviceRequest = BridgeServiceRegisterDeviceRequest()
    request.source = "BRDG::IPCD"
    
    
    
    request.setAttrs(attrs)

    return try sendRequest(request)
  }
  public func requestBridgeServiceRemoveDevice(_ id: String, accountId: String, placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: BridgeServiceRemoveDeviceRequest = BridgeServiceRemoveDeviceRequest()
    request.source = Constants.bridgeServiceAddress
    
    
    request.setId(id)
    request.setAccountId(accountId)
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  
}
