//
//  ArcusAccountCreationViewModel.swift
//  i2app
//
//  Created by Arcus Team on 3/30/18.
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

import RxSwift

/**
 `AccountCreationState` struct is an option set used by `ArcusAccountCreationViewModel` to indicate the
 validation state of the the view model.
 */
struct AccountCreationState: OptionSet, RawRepresentable {
  let rawValue: UInt

  static let firstNameSet: AccountCreationState = AccountCreationState(rawValue: 1 << 0)
  static let lastNameSet: AccountCreationState = AccountCreationState(rawValue: 1 << 1)
  static let phoneSet: AccountCreationState = AccountCreationState(rawValue: 1 << 2)
  static let imageSet: AccountCreationState = AccountCreationState(rawValue: 1 << 3)
  static let emailSet: AccountCreationState = AccountCreationState(rawValue: 1 << 4)
  static let passwordSet: AccountCreationState = AccountCreationState(rawValue: 1 << 5)

  static let aquaintedViewSet: AccountCreationState = [.firstNameSet, .lastNameSet, .phoneSet]
  static let createAccountViewSet: AccountCreationState = [.emailSet, .passwordSet]
}

/**
 `ArcusAccountCreationViewModel` protocol defines the properties needed to capture user input as they complete
 account creation.
 */
protocol ArcusAccountCreationViewModel {
  var firstName: String? { get set }
  var lastName: String? { get set }
  var phoneNumber: String? { get set }
  var emailAddress: String? { get set }
  var password: String? { get set }
  var offersAndPromotions: Bool { get set }
  
  var temporaryUserImage: UIImage? { get set }

  // RxSwift variable that will emit changes to the model's `AccountCreationState`
  var state: Variable<AccountCreationState> { get set }
}

/**
 Concrete class that conforms to `ArcusAccountCreationViewModel` protocol, and is used by
 `ArcusAccountCreationPresenter` to capture user input from AccountCreation ViewControllers.
 */
class AccountCreationViewModel: ArcusAccountCreationViewModel {
  var firstName: String? {
    didSet {
      if let _: String = firstName {
        state.value = state.value.union(.firstNameSet)
      } else {
        state.value.subtract(.firstNameSet)
      }
    }
  }

  var lastName: String? {
    didSet {
      if let _: String = lastName {
        state.value = state.value.union(.lastNameSet)
      } else {
        state.value.subtract(.lastNameSet)
      }
    }
  }

  var phoneNumber: String? {
    didSet {
      if let _: String = phoneNumber {
        state.value = state.value.union(.phoneSet)
      } else {
        state.value.subtract(.phoneSet)
      }
    }
  }

  var emailAddress: String? {
    didSet {
      if let _: String = emailAddress {
        state.value = state.value.union(.emailSet)
      } else {
        state.value.subtract(.emailSet)
      }
    }
  }

  var password: String? {
    didSet {
      if let _: String = password {
        state.value = state.value.union(.passwordSet)
      } else {
        state.value.subtract(.passwordSet)
      }
    }
  }

  var offersAndPromotions: Bool = true

  var temporaryUserImage: UIImage?
  
  // Observable indicating the state of the model.
  var state: Variable<AccountCreationState> = Variable([])
}

/**
 `AccountCreationState` extension conforming to `CustomDebugStringConvertible`
 for creating human-readable logs.
 */
extension AccountCreationState: CustomDebugStringConvertible {
  public var debugDescription: String {
    // swiftlint:disable:next line_length
    return "\n firstNameSet: \(self.contains(.firstNameSet)), \n lastNameSet: \(self.contains(.lastNameSet)), \n phoneSet: \(self.contains(.phoneSet))"
  }
}
