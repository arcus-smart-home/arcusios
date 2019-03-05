//
//  LoginTokenViewController.swift
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
 This view controller presents a loading screen while the presenter attempts to log in using an
 authentication token. If login succeeds then the user is taken to the next screen as indicated by
 the presenter. If the login fails, the screen will present the Login View Controller.
 */
class LoginTokenViewController: UIViewController {

  /**
   Presenter used to execute the login with token.
   */
  var presenter: LoginTokenPresenterProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    presenter?.setup()
    presenter?.loginWithCurrentToken()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    presenter?.tearDown()
  }
}

// MARK: LoginTokenPresenterDelegate

extension LoginTokenViewController: LoginTokenPresenterDelegate {

  func loginSucceeded() {
    DispatchQueue.main.async {
      guard let presenter = self.presenter else {
        return
      }

      self.transitionScreen(toViewController: presenter.successViewController)
    }
  }

  func loginFailed() {
    DispatchQueue.main.async {
      let storyboard = UIStoryboard(name: "Login", bundle: nil)
      let login = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")

      self.transitionScreen(toViewController: login)
    }
  }

  private func transitionScreen(toViewController viewController: UIViewController) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

//    appDelegate.transitionRoot(to: viewController)
  }
  
}
