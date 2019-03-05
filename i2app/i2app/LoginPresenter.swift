//
//  LoginPresenter.swift
//  i2app
//
//  Created by Arcus Team on 10/3/17.
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
 Helper for defining the types of error encountered during login.
 */
enum UserLoginError {
  case credentialsInvalid
  case unknown
}

/**
 Required behavior of a login presenter.
 */
protocol LoginPresenterProtocol: UserAuthenticationController, BiometricAuthenticationMixin {

  /**
   Called when login has been successful.
   */
  func userLoginDidSucceed()

  /**
   Called when login fails.
   - parameter errorType: The type of error encountered during login.
   */
  func userLoginFailed(withErrorType errorType: UserLoginError)

  /**
   Logs in the user with the provided credentials.
   - parameter username: The username of the user to be logged in.
   - parameter password: The password of the user to be logged in.
   */
  func loginUser(withUsername username: String, andPassword password: String)
}

extension LoginPresenterProtocol {

  // MARK: Functions
  /**
   Initializes the presenter with the provided delegate.
   - parameter delegate: The object to be used for delegate callbacks.
   */
  func loginUser(withUsername username: String, andPassword password: String) {
    var username: String = username

    // Check username for '!', and attempt to configure sessionURL based on substring following '!'
    let usernameComponents = username.components(separatedBy: "!")
    if usernameComponents.count > 1,
      let email = usernameComponents.first, let urlString = usernameComponents.last {

      // Update username to remove '!' and urlString.
      username = email

      // Attempt to update sessionURL
      setTestPlatform(urlString)
    }

    loginUser(username, password: password, completion: { success, error in
      if let error = error as NSError? {
        var errorType = UserLoginError.unknown

        let code = error.code
        if code == 401 {
          errorType = .credentialsInvalid
        }

        if errorType != .unknown {
          self.userLoginFailed(withErrorType: errorType)
        }
      } else if success == true {
        // Check if TouchID is enabled, and if user has changed, disable.
        self.validateTouchIDStateForEmail(username)

        // Cache User Creds for use with Biometric Auth
        self.saveUserCredentials(username, password: password)

        // notify that login was successful
        self.userLoginDidSucceed()
      }
    })
  }

  private func setTestPlatform(_ urlString: String) {
    guard let session: ArcusSession = RxCornea.shared.session else { return }
    guard let url: URL = URL(string: urlString) else { return }

    session.configureSessionUrl(.other, host: url.host, port: url.port)
  }
}
