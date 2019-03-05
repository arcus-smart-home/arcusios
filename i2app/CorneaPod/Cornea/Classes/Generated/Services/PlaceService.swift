
//
// PlaceService.swift
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
  public static let placeServiceNamespace: String = "place"
  public static let placeServiceName: String = "PlaceService"
  public static let placeServiceAddress: String = "SERV:place:"
}

/** Static services related to places. */
public protocol ArcusPlaceService: RxArcusService {
  /** Creates an initial account, which includes the billing account, account owning person, default place, login credentials and default authorization grants */
  func requestPlaceServiceListTimezones() throws -> Observable<ArcusSessionEvent>/** Validates the place&#x27;s address. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
  func requestPlaceServiceValidateAddress(_ placeId: String, streetAddress: Any) throws -> Observable<ArcusSessionEvent>
}

extension ArcusPlaceService {
  public func requestPlaceServiceListTimezones() throws -> Observable<ArcusSessionEvent> {
    let request: PlaceServiceListTimezonesRequest = PlaceServiceListTimezonesRequest()
    request.source = Constants.placeServiceAddress
    request.isRequest = true
    

    return try sendRequest(request)
  }
  public func requestPlaceServiceValidateAddress(_ placeId: String, streetAddress: Any) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceServiceValidateAddressRequest = PlaceServiceValidateAddressRequest()
    request.source = Constants.placeServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setStreetAddress(streetAddress)

    return try sendRequest(request)
  }
  
}
