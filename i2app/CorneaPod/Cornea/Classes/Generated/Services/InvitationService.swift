
//
// InvitationService.swift
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
  public static let invitationServiceNamespace: String = "invite"
  public static let invitationServiceName: String = "InvitationService"
  public static let invitationServiceAddress: String = "SERV:invite:"
}

/** Static services related to invitations */
public protocol ArcusInvitationService: RxArcusService {
  /** Finds an invitation by its code and invitee email */
  func requestInvitationServiceGetInvitation(_ code: String, inviteeEmail: String) throws -> Observable<ArcusSessionEvent>/** Creates a new person/login and associates them with the place from the invitation */
  func requestInvitationServiceAcceptInvitationCreateLogin(_ person: Any, password: String, code: String, inviteeEmail: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusInvitationService {
  public func requestInvitationServiceGetInvitation(_ code: String, inviteeEmail: String) throws -> Observable<ArcusSessionEvent> {
    let request: InvitationServiceGetInvitationRequest = InvitationServiceGetInvitationRequest()
    request.source = Constants.invitationServiceAddress
    request.isRequest = true
    
    request.setCode(code)
    request.setInviteeEmail(inviteeEmail)

    return try sendRequest(request)
  }
  public func requestInvitationServiceAcceptInvitationCreateLogin(_ person: Any, password: String, code: String, inviteeEmail: String) throws -> Observable<ArcusSessionEvent> {
    let request: InvitationServiceAcceptInvitationCreateLoginRequest = InvitationServiceAcceptInvitationCreateLoginRequest()
    request.source = Constants.invitationServiceAddress
    request.isRequest = true
    
    request.setPerson(person)
    request.setPassword(password)
    request.setCode(code)
    request.setInviteeEmail(inviteeEmail)

    return try sendRequest(request)
  }
  
}
