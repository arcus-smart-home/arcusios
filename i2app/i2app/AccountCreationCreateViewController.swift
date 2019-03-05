//
//  AccountCreationCreateViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/5/17.
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
 View controller that handles the create account forwarding to the web
 */
class AccountCreationCreateViewController: UIViewController {

  /**
 
   */
  var presenter: AccountCreationCreatePresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let titleFont = UIFont(name: "AvenirNext-Regular", size: 18) {
      UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: titleFont]
    }
  }
  
  /**
   Action to close the view.
   - parameter sender: The element that triggered the action.
  */
  @IBAction func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  /**
   Action to forward to the web account creation flow
   - parameter sender: The element that triggered the action.
   */
  @IBAction func nextButtonPressed(_ sender: Any) {
    if let presenter = presenter, let url = presenter.urlForWebCreation() {
      dismiss(animated: false, completion: nil)
      UIApplication.shared.openURL(url)
    }
  }
}
