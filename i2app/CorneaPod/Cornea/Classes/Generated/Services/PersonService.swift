
//
// PersonService.swift
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
  public static let personServiceNamespace: String = "person"
  public static let personServiceName: String = "PersonService"
  public static let personServiceAddress: String = "SERV:person:"
}

/** Entry points for global operations on the people. */
public protocol ArcusPersonService: RxArcusService {
  /** Requests the platform to generate a password reset token and notify the user */
  func requestPersonServiceSendPasswordReset(_ email: String, method: String) throws -> Observable<ArcusSessionEvent>/** Resets the users password */
  func requestPersonServiceResetPassword(_ email: String, token: String, password: String) throws -> Observable<ArcusSessionEvent>/** Changes the password for the given person */
  func requestPersonServiceChangePassword(_ currentPassword: String, newPassword: String, emailAddress: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusPersonService {
  public func requestPersonServiceSendPasswordReset(_ email: String, method: String) throws -> Observable<ArcusSessionEvent> {
    let request: PersonServiceSendPasswordResetRequest = PersonServiceSendPasswordResetRequest()
    request.source = Constants.personServiceAddress
    request.isRequest = true
    
    request.setEmail(email)
    request.setMethod(method)

    return try sendRequest(request)
  }
  public func requestPersonServiceResetPassword(_ email: String, token: String, password: String) throws -> Observable<ArcusSessionEvent> {
    let request: PersonServiceResetPasswordRequest = PersonServiceResetPasswordRequest()
    request.source = Constants.personServiceAddress
    request.isRequest = true
    
    request.setEmail(email)
    request.setToken(token)
    request.setPassword(password)

    return try sendRequest(request)
  }
  public func requestPersonServiceChangePassword(_ currentPassword: String, newPassword: String, emailAddress: String) throws -> Observable<ArcusSessionEvent> {
    let request: PersonServiceChangePasswordRequest = PersonServiceChangePasswordRequest()
    request.source = Constants.personServiceAddress
    request.isRequest = true
    
    request.setCurrentPassword(currentPassword)
    request.setNewPassword(newPassword)
    request.setEmailAddress(emailAddress)

    return try sendRequest(request)
  }
  
}
