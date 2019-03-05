//
//  BiometricAuthenticationMessage.swift
//  i2app
//
//  Created by Arcus Team on 12/6/17.
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
// swiftlint:disable line_length

import Foundation
import Cornea

enum BiometricAuthenticationMessage {
  case lockout
  case notEnrolled
  case accessRevoked
  case biometryNotEnrolled
  case biometryNotAvailable

  var title: String {

    switch self {
    case .lockout:
      return NSLocalizedString("Touch ID or Face ID Temporarily Disabled",
                               comment: "")
    case .notEnrolled:
      return NSLocalizedString("Touch ID or Face ID Disabled",
                               comment: "")
    case .accessRevoked:
      return NSLocalizedString("CANNOT ACCESS FEATURE",
                               comment: "")
    case .biometryNotEnrolled:
      return NSLocalizedString("TOUCH ID OR FACE ID INFO MISSING",
                               comment: "")
    case .biometryNotAvailable:
      return NSLocalizedString("DEVICE SUPPORT NOT AVAILABLE",
                        comment: "")
    }
  }

  var message: String {
    switch self {
    case .lockout:
      return NSLocalizedString("For security reasons, please login using your Email and Password.",
                               comment: "")
    case .notEnrolled:
      return NSLocalizedString("For security reasons, please login using your Email and Password; then re-enable this feature in your Arcus Settings.",
                               comment: "")
    case .accessRevoked:
      return NSLocalizedString("Go to your iOS Settings and allow \"Arcus\" to access this feature.",
                               comment: "")
    case .biometryNotEnrolled:
      return NSLocalizedString("To use this feature, please set up Touch ID or Face ID in your iOS settings. ",
                               comment: "")
    case .biometryNotAvailable:
      return NSLocalizedString("This iOS device does not support enabling this feature. ",
                        comment: "")
    }
  }
}
