//
//  AccountCreationCompleteAccountViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/12/17.
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

/*
 Screen used to indicate users that their account needs to be completed. This view presents the user the 
 option to complete the account or sign out.
 */
class AccountCreationCompleteAccountViewController: UIViewController {

  // MARK: Properties

  /**
   Shows the email of the logged in user.
   */
  @IBOutlet weak var emailLabel: UILabel!

  /**
   Shows a message with the name of the logged in user.
   */
  @IBOutlet weak var loggedInLabel: UILabel!

  /**
   Presenter user to fetch the view model.
   */
  var presenter: AccountCreationCompleteAccountPresenterProtocol?

  // MARK: Functions

  override func viewDidLoad() {
    super.viewDidLoad()

    if let titleFont = UIFont(name: "AvenirNext-Regular", size: 18) {
      navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: titleFont]
    }

    presenter = AccountCreationCompleteAccountPresenter(delegate: self)
    presenter?.fetchData()

    navigationItem.hidesBackButton = true
  }

  /**
   Fowards the user to the web for account creation.
   */
  @IBAction func completeButtonPressed(_ sender: Any) {
    if let presenter = presenter, let url = presenter.viewModel.completeAccountURL {
      UIApplication.shared.openURL(url)
    }
  }

  /**
   Signs out the user, sending him back to the previous screen.
   */
  @IBAction func signOutButtonPressed(_ sender: Any) {
    presenter?.logout()
  }

  fileprivate func updateViews() {
    if let presenter = presenter {
      emailLabel.text = ""
      if let userEmail = presenter.viewModel.userEmail {
        emailLabel.text = presenter.viewModel.userEmail
      }

      if let name = presenter.viewModel.userName {
        var boldFont = UIFont(name: "AvenirNext-DemiBold", size: 14.0)
        if boldFont != nil {
          boldFont = UIFont()
        }
        var normalFont = UIFont(name: "AvenirNext-Regular", size: 14.0)
        if normalFont != nil {
          normalFont = UIFont()
        }
        let attributesBold: [String : Any] = [
          NSFontAttributeName: boldFont
        ]
        let attributesNormal: [String : Any] = [
          NSFontAttributeName: normalFont
        ]
        let personNameFormatted = name + ","
        let personNameAttributed = NSAttributedString(string: personNameFormatted, attributes: attributesBold)
        let loggedInText = NSAttributedString(string: "Logged in as ", attributes: attributesNormal)
        let combinedText = NSMutableAttributedString()

        combinedText.append(loggedInText)
        combinedText.append(personNameAttributed)

        loggedInLabel.attributedText = combinedText
      }
    }
  }
}

// MARK: AccountCreationCompleteAccountPresenterDelegate
extension AccountCreationCompleteAccountViewController: AccountCreationCompleteAccountPresenterDelegate {
  func shouldUpdateViews() {
    DispatchQueue.main.async {
      self.updateViews()
    }
  }
}
