
//
// I18NService.swift
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
  public static let i18NServiceNamespace: String = "i18n"
  public static let i18NServiceName: String = "I18NService"
  public static let i18NServiceAddress: String = "SERV:i18n:"
}

/** Entry points for the i18n service, which is used to fetch localized keys. */
public protocol ArcusI18NService: RxArcusService {
  /** Loads localized keys from the server */
  func requestI18NServiceLoadLocalizedStrings(_ bundleNames: [String], locale: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusI18NService {
  public func requestI18NServiceLoadLocalizedStrings(_ bundleNames: [String], locale: String) throws -> Observable<ArcusSessionEvent> {
    let request: I18NServiceLoadLocalizedStringsRequest = I18NServiceLoadLocalizedStringsRequest()
    request.source = Constants.i18NServiceAddress
    request.isRequest = true
    
    request.setBundleNames(bundleNames)
    request.setLocale(locale)

    return try sendRequest(request)
  }
  
}
