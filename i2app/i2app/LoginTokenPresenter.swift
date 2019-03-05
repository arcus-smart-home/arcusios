//
//  LoginTokenPresenter.swift
//  i2app
//
//  Created by Arcus Team on 10/25/17.
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

/**
 Delegate for callbacks from the Login Token Presenter.
 */
protocol LoginTokenPresenterDelegate: class {

  /**
   Called when the login fails.
   */
  func loginFailed()

  /**
   Called when login succeeds.
   */
  func loginSucceeded()

}

/**
 Protocol defining the interface of a LoginTokenPresenter.
 */
protocol LoginTokenPresenterProtocol: class {

  /**
   The delegate used to execute callbacks.
   */
  var delegate: LoginTokenPresenterDelegate? { get }

  /**
   The token used to login the user.
   */
  var token: String { get }

  /**
   The view controller to be presented after login succeeds.
   */
  var successViewController: UIViewController { get }

  // MARK: Extended 

  /**
   Sets up the notifications needed.
   */
  func setup()

  /**
   Stops listening to notifications.
   */
  func tearDown()

  /**
   Logs the user in with the current token.
   */
  func loginWithCurrentToken()
}

/**
 This class is used to log a user in using an authentication token. If the login transaction succeeds, 
 the delegate recieves a call with loginSucceeded(). If the transaction fails the delegate recieves a 
 call with loginFailed(). If the user is already logged in when loginWithCurrentToken is called, the 
 user will first be logged out before proceeding with the login with token.
 */
class LoginTokenPresenter {

  /**
   Required by LoginTokenPresenterProtocol
   */
  weak private(set) var delegate: LoginTokenPresenterDelegate?

  /**
   Required by LoginTokenPresenterProtocol
   */
  private(set) var successViewController: UIViewController

  /**
   Required by LoginTokenPresenterProtocol
   */
  private(set) var token: String
    
  /**
  Ensures that a log in attempt only occurs once
  */
  fileprivate var hasLoggedIn = false

  /**
   Initializes the presenter with the given values.
   
   - Parameters:
    - delegate: The delegate to be used for callbacks.
    - token: Token to be used for authentication.
    - successViewController: View controller to be displayed once the user is logged in.
   */
  required init(delegate: LoginTokenPresenterDelegate,
                token: String,
                successViewController: UIViewController) {
    self.delegate = delegate
    self.token = token
    self.successViewController = successViewController
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  fileprivate func loginUser() {
    // TODO: FIX ME!
//    _ = ArcusClient.sharedInstance().loginUser(withToken: token)
//      .swiftThenInBackground { _ in
//
//        // Make sure there is a session before calling suceed
//        if UserSettings.sharedInstance().currentPerson.emailAddress != nil {
//          // Once the session is ready save the token
//          ArcusClient.sharedInstance().saveLoginToken()
//
//          self.delegate?.loginSucceeded()
//        }
//
//        return nil
//      }
//      .swiftCatch { _ in
//        self.delegate?.loginFailed()
//
//        return nil
//    }
  }

  @objc fileprivate func handleSessionReady() {
    // Once the session is ready save the token
    // TODO: FIX ME!
//    ArcusClient.sharedInstance().saveLoginToken()
    delegate?.loginSucceeded()
  }

}

// MARK: LoginTokenPresenterProtocol

extension LoginTokenPresenter: LoginTokenPresenterProtocol,
UserAuthenticationController {

  func setup() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleSessionReady),
                                           name: Notification.Name.subsystemCacheInitialized,
                                           object: nil)
  }

  func tearDown() {
    NotificationCenter.default.removeObserver(self,
                                              name: Notification.Name.subsystemCacheInitialized,
                                              object: nil)
  }

  func loginWithCurrentToken() {
    if !hasLoggedIn {
      hasLoggedIn = true
      logout({
        self.loginUser()
      })
    }
  }

}
