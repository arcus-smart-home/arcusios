//
//  AccountCreationRoutingDriver.swift
//  i2app
//
//  Created by Arcus Team on 4/13/18.
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

class AccountCreationRoutingDriver: ArcusRoutingDriver, ArcusAccountCapability {
  // Required by `ArcusRoutingDriver`
  var isRouting: Bool = true

  // Required by `RxArcusService` & `ArcusAccountCapability`
  var disposeBag: DisposeBag = DisposeBag()

  required init() {
    // Observe Settings Events to determine when the app changes places.
    if let settings = RxCornea.shared.settings as? RxSwiftSettings {
      observeSettingsEvents(settings)
    }
  }

  func observeSettingsEvents(_ settings: RxSwiftSettings) {
    settings.getEvents()
      .filter {
        return $0 is CurrentAccountChangeEvent || $0 is CurrentPersonChangeEvent
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let currentAccount = RxCornea.shared.settings?.currentAccount,
          let currentPerson = RxCornea.shared.settings?.currentPerson else {
            return
        }
        self?.validateAccountState(currentAccount, currentPerson: currentPerson)
      })
      .disposed(by: disposeBag)
  }

  fileprivate func validateAccountState(_ currentAccount: AccountModel, currentPerson: PersonModel) {
    // Verify Person is AccountOwner
    // If owner, then route to new AccountCreation, else route to legacy AccountCreation.
    if getAccountOwner(currentAccount) == currentPerson.modelId {
      validateAccountCreationState(currentAccount)
    } else {
      legacyValidateAccountCreationState()
    }
  }

  fileprivate func validateAccountCreationState(_ currentAccount: AccountModel) {
    let state: String? = AccountCapability.getStateFrom(RxCornea.shared.settings?.currentAccount)
    if let accountStateString: String = state, accountStateString.count > 0 {
      let accountState = SwiftAccountState.fromString(accountStateString)
      if accountState == .accountStateSignUp1 {
        // Show Check Your Email
        ApplicationRoutingService.defaultService.showCheckYourEmail()
      } else if accountState != .accountStateSignUpComplete {
        // Show Account Almost Complete
        ApplicationRoutingService.defaultService.showAccountAlmostReady()
      }
    }
  }

  fileprivate func legacyValidateAccountCreationState() {
    let config = CreateAccountViewController.needsAccountNavController()
    if config.needsConfig {
      ApplicationRoutingService.defaultService.showAccountCreation()
    }
  }
}
