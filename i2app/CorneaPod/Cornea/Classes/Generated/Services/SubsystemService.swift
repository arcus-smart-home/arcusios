
//
// SubsystemService.swift
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
  public static let subsystemServiceNamespace: String = "subs"
  public static let subsystemServiceName: String = "SubsystemService"
  public static let subsystemServiceAddress: String = "SERV:subs:"
}

/** Entry points for subsystems. */
public protocol ArcusSubsystemService: RxArcusService {
  /** Lists all subsystems available for a given place */
  func requestSubsystemServiceListSubsystems(_ placeId: String) throws -> Observable<ArcusSessionEvent>/** Flushes and reloads all the subsystems at the active given place, intended for testing */
  func requestSubsystemServiceReload() throws -> Observable<ArcusSessionEvent>
}

extension ArcusSubsystemService {
  public func requestSubsystemServiceListSubsystems(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: SubsystemServiceListSubsystemsRequest = SubsystemServiceListSubsystemsRequest()
    request.source = Constants.subsystemServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestSubsystemServiceReload() throws -> Observable<ArcusSessionEvent> {
    let request: SubsystemServiceReloadRequest = SubsystemServiceReloadRequest()
    request.source = Constants.subsystemServiceAddress
    
    

    return try sendRequest(request)
  }
  
}
