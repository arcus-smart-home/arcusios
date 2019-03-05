//
//  ArcusResendEmailPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/9/18.
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
import RxSwift
import Cornea

/**
  `ArcusResendEmailPresenter` defines the properties and methods required by a conforming class to implement
  resend verification email functionality.
*/
protocol ArcusResendEmailPresenter: ArcusPersonCapability {
  // The `PersonModel` to resend the email for.
  var personModel: PersonModel! { get set }

  // Read-only reference to the `personModel's` email.  Used for display purposes.
  var emailAddress: String { get }

  /**
   Attempt to resend the email verfication for the current `personModel`

   - Returns: An Observable indicating if resend was successful or not.
   */
  func resendEmail() -> Observable<Bool>
}

extension ArcusResendEmailPresenter {
  var emailAddress: String {
    guard let email = getPersonEmail(personModel) else {
      return ""
    }
    return email
  }

  func resendEmail() -> Observable<Bool> {
    do {
      return try requestPersonSendVerificationEmail(personModel, source: "IOS")
        .observeOn(MainScheduler.asyncInstance)
        .map {
          return $0 is PersonSendVerificationEmailResponse
        }
        .asObservable()
    } catch {
      return Observable.just(false).observeOn(MainScheduler.asyncInstance)
    }
  }
}
