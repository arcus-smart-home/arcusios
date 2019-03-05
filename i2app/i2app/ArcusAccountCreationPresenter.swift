//
//  ArcusAccountCreationPresenter.swift
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

import Foundation
import Cornea

/**
 `ArcusAccountCreationPresenter` protocol defines the properties needed for a presenter in order to collect the
 info needed to create a new account.
 */
protocol ArcusAccountCreationPresenter: EmailValidator {
  var accountCreationModel: ArcusAccountCreationViewModel! { get set }

  /**
   Attempt to set `accountCreationModel.firstName` with string supplied by the user.  Method will validate
   string, and if valid will set `accountCreationModel.firstName` with the new value.  Otherwise
   `accountCreationModel.firstName` is set to nil in order to properly maintain `accountCreationModel.state`.

   - Parameters:
   - firstName: String for user's first name.
   */
  func userUpdatedFirstName(_ firstName: String?)

  /**
   Attempt to set `accountCreationModel.lastName` with string supplied by the user.  Method will validate
   string, and if valid will set `accountCreationModel.lastName` with the new value.  Otherwise
   `accountCreationModel.laststName` is set to nil in order to properly maintain `accountCreationModel.state`.

   - Parameters:
   - lastName: String for user's last name.
   */
  func userUpdatedLastName(_ lastName: String?)

  /**
   Attempt to set `accountCreationModel.phoneNumber` with string supplied by the user.  Method will validate
   string, and if valid will set `accountCreationModel.phoneNumber` with the new value.  Otherwise
   `accountCreationModel.phoneNumber` is set to nil in order to properly maintain `accountCreationModel.state`.

   - Parameters:
   - phone: String for user's phone number.
   */
  func userUpdatedPhoneNumber(_ phone: String?)

  /**
   Attempt to set `accountCreationModel.emailAddress` with string supplied by the user.  Method will validate
   string, and if valid will set `accountCreationModel.emailAddress` with the new value.  Otherwise
   `accountCreationModel.emailAddress` is set to nil in order to properly maintain
   `accountCreationModel.state`.

   - Parameters:
   - email: String for user's email address.
   */
  func userUpdatedEmail(_ email: String?)

  /**
   Attempt to set `accountCreationModel.password` with string supplied by the user.  Method will validate
   password and confirmPassword, and if valid will set `accountCreationModel.password` with the new value.
   Otherwise `accountCreationModel.password` is set to nil in order to properly maintain
   `accountCreationModel.state`.

   - Parameters:
   - password: String for user's password.
   - confirmPassword: String for confirming the user's password.
   */
  func userUpdatedPassword(_ password: String?, confirmPassword: String?)

  /**
   Attempt to set `accountCreationModel.offersAndPromotions` with bool supplied by the user.

   - Parameters:
   - offers: Bool indicating if the user has opted to receive offers and promotions.
   */
  func userUpdatedOffersAndPromotions(_ offers: Bool)

  /**
   Validator for `accountCreationModel.firstName`.  Checks if length is greater than zero.

   - Parameters:
   - name: The string to validate.

   - Returns: Bool indicating if name is valid.
   */
  func validateFirstName(_ name: String?) -> Bool

  /**
   Validator for `accountCreationModel.lastName`.  Checks if length is greater than zero.

   - Parameters:
   - name: The string to validate.

   - Returns: Bool indicating if name is valid.
   */
  func validateLastName(_ name: String?) -> Bool

  /**
   Validator for `accountCreationModel.phoneNumber`.  Checks if string is numeric, and 10 character in length
   or if 10 characters in length and starts with a `1`.

   - Parameters:
   - name: The string to validate.

   - Returns: Bool indicating if phoneNumber is valid.
   */
  func validatePhoneNumber(_ phoneNumber: String?) -> Bool

  /**
   Validator for `accountCreationModel.email`.  Checks if string is in proper email format: ###@###.###

   - Parameters:
   - email: The string to validate.

   - Returns: Bool indicating if email is valid.
   */
  func validateEmailAddress(_ email: String?) -> Bool

  /**
   Validator for `accountCreationModel.password`.  Checks if string is at least 8 chars, & contains at least
   one letter and one number.

   - Parameters:
   - password: The string to validate.

   - Returns: Bool indicating if password is valid.
   */
  func validatePassword(_ password: String?) -> Bool

  /**
   Validator for `accountCreationModel.password`.  Validated that pasword matches confirm password

   - Parameters:
   - password: The string to validate.
   - confirmPassword:  The string to validate password against.

   - Returns: Bool indicating if password/confirmPassword combo is valid.
   */
  func validateConfirmPassword(_ password: String?, confirmPassword: String?) -> Bool
}

extension ArcusAccountCreationPresenter {
  func userUpdatedFirstName(_ firstName: String?) {
    guard var model: ArcusAccountCreationViewModel = accountCreationModel else { return }

    let trimmedName = firstName?.trimmingCharacters(in: .whitespacesAndNewlines)

    if validateFirstName(trimmedName) {
      model.firstName = trimmedName
    } else {
      model.firstName = nil
    }
  }

  func userUpdatedLastName(_ lastName: String?) {
    guard var model: ArcusAccountCreationViewModel = accountCreationModel else { return }

    let trimmedName = lastName?.trimmingCharacters(in: .whitespacesAndNewlines)

    if validateLastName(trimmedName) {
      model.lastName = trimmedName
    } else {
      model.lastName = nil
    }
  }

  func userUpdatedPhoneNumber(_ phone: String?) {
    guard var model: ArcusAccountCreationViewModel = accountCreationModel else { return }

    if validatePhoneNumber(phone) {
      model.phoneNumber = phone
    } else {
      model.phoneNumber = nil
    }
  }

  func userUpdatedEmail(_ email: String?) {
    guard var model: ArcusAccountCreationViewModel = accountCreationModel else { return }

    if validateEmailAddress(email) {
      model.emailAddress = email
    } else {
      model.emailAddress = nil
    }
  }

  func userUpdatedPassword(_ password: String?, confirmPassword: String?) {
    guard var model: ArcusAccountCreationViewModel = accountCreationModel else { return }

    if validatePassword(password) && validateConfirmPassword(password, confirmPassword: confirmPassword) {
      model.password = password
    } else {
      model.password = nil
    }
  }

  func userUpdatedOffersAndPromotions(_ offers: Bool) {
    guard var model: ArcusAccountCreationViewModel = accountCreationModel else { return }
    model.offersAndPromotions = offers
  }

  func validateFirstName(_ name: String?) -> Bool {
    if let firstName = name, firstName.count > 0 {
      return true
    }
    return false
  }

  func validateLastName(_ name: String?) -> Bool {
    if let lastName = name, lastName.count > 0 {
      return true
    }
    return false
  }

  func validatePhoneNumber(_ phoneNumber: String?) -> Bool {
    guard let phoneNumber: String = phoneNumber else {
      return false
    }
    var isValid: Bool = false

    var leadingOne: Bool = false
    if phoneNumber.count > 0 {
      leadingOne = (phoneNumber[phoneNumber.startIndex] == "1")
    }

    if leadingOne && phoneNumber.count == 11 {
      isValid = true
    } else if !leadingOne && phoneNumber.count == 10 {
      isValid = true
    }

    if isValid {
      isValid = phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    return isValid
  }

  func validateEmailAddress(_ email: String?) -> Bool {
    guard let email = email else { return false }
    return isValid(email: email)
  }

  func validatePassword(_ password: String?) -> Bool {
    guard let password = password else { return false }
    return isValid(password: password)
  }

  func validateConfirmPassword(_ password: String?, confirmPassword: String?) -> Bool {
    guard let confirmPassword = confirmPassword, validatePassword(password) else { return false }
    return password == confirmPassword
  }

  func isValid(password: String) -> Bool {
    let passwordRegex = "(?=^.{8,}$)(?=.*[a-zA-Z])(?=.*[0-9])(?!.*[:space:]).*$"

    let passwordValidation = NSPredicate(format:"SELF MATCHES[c] %@", passwordRegex)
    return passwordValidation.evaluate(with: password)
  }
}
