
//
// AccountService.swift
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
  public static let accountServiceNamespace: String = "account"
  public static let accountServiceName: String = "AccountService"
  public static let accountServiceAddress: String = "SERV:account:"
}

/** Entry points for the account service, which covers global operations on accounts not handled the account object capabilities. */
public protocol ArcusAccountService: RxArcusService {
  /** Creates an initial account, which includes the billing account, account owning person, default place, login credentials and default authorization grants */
  func requestAccountServiceCreateAccount(_ email: String, password: String, optin: String, isPublic: String, person: Any, place: Any) throws -> Observable<ArcusSessionEvent>
}

extension ArcusAccountService {
  public func requestAccountServiceCreateAccount(_ email: String, password: String, optin: String, isPublic: String, person: Any, place: Any) throws -> Observable<ArcusSessionEvent> {
    let request: AccountServiceCreateAccountRequest = AccountServiceCreateAccountRequest()
    request.source = Constants.accountServiceAddress
    request.isRequest = true
    
    request.setEmail(email)
    request.setPassword(password)
    request.setOptin(optin)
    request.setIsPublic(isPublic)
    request.setPerson(person)
    request.setPlace(place)

    return try sendRequest(request)
  }
  
}
