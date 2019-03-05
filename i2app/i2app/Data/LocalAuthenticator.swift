//
//  LocalAuthenticator.swift
//  i2app
//
//  Created by Arcus Team on 10/24/16.
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

import Cornea
import RxSwift

/**
 * Protocol defines interface for a LocalAuthenticator:
 *    Provides methods to check LocalAuth availability, get & set enabled, and
 *    process LocalAuth with a param for a completion closure.
 **/
protocol LocalAuthenticator {
  // Check that LocalAuth is available.
  func isAvailable(_ error: NSErrorPointer?) -> Bool

  // Enable or disabled LocalAuth for given Account/Password combination.
  func setEnabled(_ enable: Bool, account: String, password: String) throws

  // Attempt LocalAuth with reason and completion handler.
  func requestLocalAuthentication(_ reason: String,
                                  completion: @escaping (_ success: Bool, _ error: NSError?) -> Void)

  // RxSwift based methods that will implement retry attempts on failed keychain reads
  func isAccountEnabled() -> Single<Void>
  // Check that LocalAuth has been enabled.
  func isEnabled() -> Single<Void>
}

/**
 *  Extension of LocalAuthenticator to provide abstract implementation of
 *  methods that tha LocalAuthenticator is not conforming to.
 **/
extension LocalAuthenticator {
  func isAvailable(_ error: NSErrorPointer?) -> Bool {
    if error != nil {
      error??.pointee = NSError(domain: "ArcusLocalAuthenticator",
                                code: -99,
                                userInfo:
        [NSLocalizedDescriptionKey: "Authenticator does not conform to isAvailable()"])
    }
    return false
  }

  func setEnabled(_ enable: Bool,
                  account: String,
                  password: String) throws {
    throw ClientError(errorType: .invalidConformance)
  }
}
