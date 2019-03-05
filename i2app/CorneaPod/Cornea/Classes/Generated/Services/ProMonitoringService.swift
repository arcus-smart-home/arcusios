
//
// ProMonitoringService.swift
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
  public static let proMonitoringServiceNamespace: String = "promon"
  public static let proMonitoringServiceName: String = "ProMonitoringService"
  public static let proMonitoringServiceAddress: String = "SERV:promon:"
}

/** Access to the professional monitoring settings for a place. */
public protocol ArcusProMonitoringService: RxArcusService {
  /** Gets the promonitoring settings for the specified place. */
  func requestProMonitoringServiceGetSettings(_ place: String) throws -> Observable<ArcusSessionEvent>/** Gets the promonitoring metadata that represents UCC caller id data for each area as a list of phone numbers */
  func requestProMonitoringServiceGetMetaData() throws -> Observable<ArcusSessionEvent>/** Check promonitoring availability for the given zipcode and state */
  func requestProMonitoringServiceCheckAvailability(_ zipcode: String, state: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusProMonitoringService {
  public func requestProMonitoringServiceGetSettings(_ place: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringServiceGetSettingsRequest = ProMonitoringServiceGetSettingsRequest()
    request.source = Constants.proMonitoringServiceAddress
    
    
    request.setPlace(place)

    return try sendRequest(request)
  }
  public func requestProMonitoringServiceGetMetaData() throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringServiceGetMetaDataRequest = ProMonitoringServiceGetMetaDataRequest()
    request.source = Constants.proMonitoringServiceAddress
    
    

    return try sendRequest(request)
  }
  public func requestProMonitoringServiceCheckAvailability(_ zipcode: String, state: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringServiceCheckAvailabilityRequest = ProMonitoringServiceCheckAvailabilityRequest()
    request.source = Constants.proMonitoringServiceAddress
    request.isRequest = true
    
    request.setZipcode(zipcode)
    request.setState(state)

    return try sendRequest(request)
  }
  
}
