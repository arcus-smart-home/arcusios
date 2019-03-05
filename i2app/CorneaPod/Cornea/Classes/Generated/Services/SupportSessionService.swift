
//
// SupportSessionService.swift
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
  public static let supportSessionServiceNamespace: String = "suppcustsession"
  public static let supportSessionServiceName: String = "SupportSessionService"
  public static let supportSessionServiceAddress: String = "SERV:suppcustsession:"
}

/** Support Session Service */
public protocol ArcusSupportSessionService: RxArcusService {
  /** Find all active support customer sessions (if any) */
  func requestSupportSessionServiceListAllActiveSessions(_ limit: Int, token: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSupportSessionService {
  public func requestSupportSessionServiceListAllActiveSessions(_ limit: Int, token: String) throws -> Observable<ArcusSessionEvent> {
    let request: SupportSessionServiceListAllActiveSessionsRequest = SupportSessionServiceListAllActiveSessionsRequest()
    request.source = Constants.supportSessionServiceAddress
    
    
    request.setLimit(limit)
    request.setToken(token)

    return try sendRequest(request)
  }
  
}
