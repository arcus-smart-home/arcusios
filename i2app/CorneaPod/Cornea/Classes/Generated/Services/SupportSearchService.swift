
//
// SupportSearchService.swift
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
  public static let supportSearchServiceNamespace: String = "supportsearch"
  public static let supportSearchServiceName: String = "SupportSearchService"
  public static let supportSearchServiceAddress: String = "SERV:supportsearch:"
}

/** Support Search Service */
public protocol ArcusSupportSearchService: RxArcusService {
  /** Searches the Elastic Search full text search index */
  func requestSupportSearchServiceSupportMainSearch(_ critera: String, from: Any, size: Any) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSupportSearchService {
  public func requestSupportSearchServiceSupportMainSearch(_ critera: String, from: Any, size: Any) throws -> Observable<ArcusSessionEvent> {
    let request: SupportSearchServiceSupportMainSearchRequest = SupportSearchServiceSupportMainSearchRequest()
    request.source = Constants.supportSearchServiceAddress
    
    
    request.setCritera(critera)
    request.setFrom(from)
    request.setSize(size)

    return try sendRequest(request)
  }
  
}
