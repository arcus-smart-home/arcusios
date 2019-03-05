
//
// EasCodeService.swift
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
  public static let easCodeServiceNamespace: String = "eascode"
  public static let easCodeServiceName: String = "EasCodeService"
  public static let easCodeServiceAddress: String = "SERV:eascode:"
}

/** Service methods for retrieving EAS Codes from the NOAA EAS Code database. */
public protocol ArcusEasCodeService: RxArcusService {
  /**  */
  func requestEasCodeServiceListEasCodes() throws -> Observable<ArcusSessionEvent>
}

extension ArcusEasCodeService {
  public func requestEasCodeServiceListEasCodes() throws -> Observable<ArcusSessionEvent> {
    let request: EasCodeServiceListEasCodesRequest = EasCodeServiceListEasCodesRequest()
    request.source = Constants.easCodeServiceAddress
    request.isRequest = true
    

    return try sendRequest(request)
  }
  
}
