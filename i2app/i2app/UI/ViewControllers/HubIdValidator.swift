//
//  HubIdValidator.swift
//  i2app
//
//  Created by Arcus Team on 6/22/17.
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

/// Protocol to share Logic that will validate a Hub ID String
protocol HubIdValidator {

  /// Extended:

  /** Returns True for a Valid HubID else throws a HubIdValidationError explaing why

   Example Implementation:
   ```
      do {
        _ = try validateHubId(self.textField.text)
        // Do some work, you are valid
      } catch {
        //Handle the error
        if let error = error as? HubIdValidationError {
          self.displayErrorMessage(error.errorMessage, withTitle: "Invalid Hub ID")
        }
      }
   ```
   */
  func validateHubId(_ incHubId: String?) throws -> Bool

}

extension HubIdValidator {
  func validateHubId(_ incHubId: String?) throws -> Bool {
    guard let incHubId = incHubId else {
      throw HubIdValidationError.invalidFormat
    }
    if incHubId.count == 0 {
      throw HubIdValidationError.empty
    }
    if incHubId.count < 8 {
      throw HubIdValidationError.tooShort
    }
    if incHubId.count > 8 {
      throw HubIdValidationError.tooLong
    }
    let predicate = NSPredicate(format: "SELF MATCHES %@", "(^[a-zA-Z]{3}-[0-9]{4}?$)")
    if !predicate.evaluate(with: incHubId) {
      throw HubIdValidationError.invalidFormat
    }
    return true
  }
}

/// Error for Hub Validation, 3 cases, Too Short. Too Long, Invalid
enum HubIdValidationError: Error {
  case invalidFormat
  case tooShort
  case tooLong
  case empty

  var errorMessage: String {
    switch self {
    case .empty:
      return "Missing Hub ID"
    case .tooShort:
      return "Invalid Hub ID"
    case .tooLong:
      return "Invalid Hub ID"
    case .invalidFormat:
      return "Invalid Hub ID"
    }
  }
}
