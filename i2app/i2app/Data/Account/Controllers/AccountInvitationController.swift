//
//  AccountInvitationController.swift
//  i2app
//
//  Created by Arcus Team on 5/13/16.
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
//

import Foundation
import Cornea

enum AccountInvitationError: Error {
  case invalid(message: String)
  case failed(message: String)
}

protocol AccountInvitationCallback {
  func invitationNotFound(_ error: AccountInvitationError)
  func invitationFound(_ invitation: Invitation)

  func invitationAcceptSuccess(_ person: PersonModel, email: String, password: String)
  func invitationAcceptError(_ error: AccountInvitationError)
}

@objc class AccountInvitationController: NSObject {
  let callback: AccountInvitationCallback?

  init(callback: AccountInvitationCallback) {
    self.callback = callback
  }

  func getInvitation(_ email: String, code: String) {
    DispatchQueue.global(qos: .background).async {
      _ = InvitationService.getInvitationWithCode(code, withInviteeEmail: email)
        .swiftThen { result in
          guard let result = result as? InvitationServiceGetInvitationResponse else { return nil }

          let invitation = Invitation(attributes: result.getInvitation() as? NSDictionary)
          self.callback?.invitationFound(invitation)

          return nil
        }
        .swiftCatch { _ in
          self.callback?.invitationNotFound(AccountInvitationError.invalid(message: "No Invitation Found"))

          return nil
      }
    }
  }

  func acceptInvitationCreateLogin(_ password: String, email: String, code: String, inviteeEmail: String) {

    let trimmedEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let trimmedPassword = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let person = PersonModel(attributes: [kAttrPersonEmail: trimmedEmail as AnyObject])

    DispatchQueue.global(qos: .background).async {
      _ = InvitationService.acceptInvitationCreateLogin(withPerson: person,
                                                        withPassword: trimmedPassword,
                                                        withCode: code,
                                                        withInviteeEmail: inviteeEmail)
        .swiftThen { event in
          self.callback?.invitationAcceptSuccess(person,
                                                 email: trimmedEmail,
                                                 password: trimmedPassword)
          return nil
        }
        .swiftCatch { error in
          guard let error = error as? NSError else { return nil }
          self.callback?
            .invitationAcceptError(AccountInvitationError.failed(message: error.localizedDescription))
          return nil
      }
    }
  }
}
