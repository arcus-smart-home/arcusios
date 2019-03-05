//
//  ArcusAccountCreationSubmissionPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/6/18.
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
 Typealias for tuple used with Account Creation submission.
 */
fileprivate typealias AccountCreationSubmission =
  (email: String, password: String, optin: String, isPublic: String, person: PersonModel, place: PlaceModel)

/**
 `ArcusAccountCreationSubmissionPresenter` protocol defines the properties needed for a presenter in order to
 create a new account.
 */
protocol ArcusAccountCreationSubmissionPresenter: ArcusAccountCreationPresenter,
LoginPresenterProtocol,
ArcusAccountService,
ArcusPersonCapability {
  /**
   Attempt to send `account:CreateAccount` cmd to the platform with `accountCreationModel` used to configure
   the request.
   */
  func attemptAccountCreation()

  func processAccountCreationFailure(_ code: String?)

  func processAccountCreationCompletion()
}

extension ArcusAccountCreationSubmissionPresenter {
  func attemptAccountCreation() {
    guard let submission = prepareAccountCreationSubmission(accountCreationModel) else {
      return
    }

    try? _ = requestAccountServiceCreateAccount(submission.email,
                                                password: submission.password,
                                                optin: submission.optin,
                                                isPublic: submission.isPublic,
                                                person: submission.person,
                                                place: submission.place)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self, submission] event in
          guard let _ = event as? AccountServiceCreateAccountResponse else {
            if let error = event as? SessionErrorEvent {
              self?.processAccountCreationFailure(error.getErrorCode())
            }
            return
          }

          self?.loginUser(withUsername: submission.email, andPassword: submission.password)
      })
      .addDisposableTo(disposeBag)
  }

  func attemptToSendVerificationEmail() {
    if let currentPerson = RxCornea.shared.settings?.currentPerson {
      try? _ = requestPersonSendVerificationEmail(currentPerson, source: "IOS")
    }
  }

  func userLoginDidSucceed() {
    guard let cacheLoader = RxCornea.shared.cacheLoader as? RxSwiftModelCacheLoader else { return }
    var loaderDisposable: Disposable?
    loaderDisposable = cacheLoader.getStatus()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] status in
        if status.contains(.modelsLoadedExcludeProductCatalogAlarms) {
          self?.processImageIfNeeded()
          self?.attemptToSendVerificationEmail()
          self?.processAccountCreationCompletion()
          loaderDisposable?.dispose()
        }
      })
    loaderDisposable?.disposed(by: disposeBag)
  }

  func userLoginFailed(withErrorType errorType: UserLoginError) {}

  func processAccountCreationFailure(_ code: String?) {}

  private func processImageIfNeeded() {
    // If user added an image, then update cache to associate with currentPerson.
    guard let image =  accountCreationModel.temporaryUserImage,
      let modelId = RxCornea.shared.settings?.currentPerson?.modelId else {
      return
    }
    
    AKFileManager.default().cacheImage(image, forHash: modelId)
  }
}

fileprivate extension ArcusAccountCreationSubmissionPresenter {
  /**
   Prepare user entered data for submission to the platform.  Takes `ArcusAccountCreationViewModel` and creates
   `AccountCreationSubmission` if configured properly.

   - Parameters:
   - model: `ArcusAccountCreationViewModel` used to create the `AccountCreationSubmission` tuple.

   - Returns: Optional `AccountCreationSubmission` tuple.
   */
  func prepareAccountCreationSubmission(_ model: ArcusAccountCreationViewModel) -> AccountCreationSubmission? {
    guard let firstName: String = model.firstName,
      let lastName: String = model.lastName,
      let phone: String = model.phoneNumber,
      let email: String = model.emailAddress,
      let password: String = model.password else {
        return nil
    }
    let optin: String = optinStringValue(accountCreationModel.offersAndPromotions)
    let isPublic: String = ""
    let person: PersonModel = preparePersonModelForSubmission(firstName,
                                                              lastName: lastName,
                                                              phone: phone,
                                                              email: email)
    let place: PlaceModel = PlaceModel()

    return (email: email, password: password, optin: optin, isPublic: isPublic, person: person, place: place)
  }

  /**
   Get optin string for bool value.

   - Parameters:
   - optin: Bool indicating if user wishes to optin or not.

   - Returns: String value of the optin bool.
   */
  func optinStringValue(_ optin: Bool) -> String {
    if !optin {
      return "false"
    }
    return "true"
  }

  /**
   Create a PersonModel with FirstName, LastName, & Phone to be used in AccountCreation submission.

   - Parameters:
   - firstName: String of the user's first name.
   - lastName: String of the user's last name.
   - phone: String of the user's phone number.
   - email: String of the user's email address.

   - Returns: PersonModel containing provided first, last, and phone.
   */
  func preparePersonModelForSubmission(_ firstName: String,
                                       lastName: String,
                                       phone: String,
                                       email: String) -> PersonModel {
    let person = PersonModel()

    setPersonFirstName(firstName, model: person)
    setPersonLastName(lastName, model: person)
    setPersonMobileNumber(phone, model: person)
    setPersonEmail(email, model: person)

    return PersonModel(attributes: person.changes)
  }
}
