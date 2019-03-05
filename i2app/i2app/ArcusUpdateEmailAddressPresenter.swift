//
//  ArcusUpdateEmailAddressPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/10/18.
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
 `ArcusUpdateEmailAddressPresenter` defines the properties and methods needed by a conforming class to update
 the personModel's email address.
 */
protocol ArcusUpdateEmailAddressPresenter: ArcusAccountCreationPresenter, ArcusPersonCapability {
  // The `PersonModel` to update the email address on.
  var personModel: PersonModel! { get set }

  // Read-only reference to the `personModel's` email.  Used for display purposes.
  var emailAddress: String { get }

  /**
   Attempt to update the email verfication for the current `personModel`

   - Returns: An Observable indicating if update was successful or not.
   */
  func attemptUpdateEmailAddress() -> Observable<Bool>
}

extension ArcusUpdateEmailAddressPresenter {
  var emailAddress: String {
    guard let email = getPersonEmail(personModel) else {
      return ""
    }
    return email
  }

  func attemptUpdateEmailAddress() -> Observable<Bool> {
    if let email = accountCreationModel.emailAddress {
      setPersonEmail(email, model: personModel)
    }

    return Observable.create { [personModel, disposeBag] observer in
      personModel?.commitChanges()
        .subscribe({ _ in
          observer.onNext(true)
          observer.onCompleted()
      })
      .disposed(by: disposeBag)

      return Disposables.create()
      }
      .observeOn(MainScheduler.asyncInstance)
  }
}
