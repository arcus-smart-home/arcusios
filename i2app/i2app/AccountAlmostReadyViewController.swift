//
//  AccountAlmostReadyViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/10/18.
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

import UIKit
import RxSwift
import Cornea

class AccountAlmostReadyViewController: UIViewController,
  ArcusPersonNameEmailPresenter,
ArcusLogoutPresenter {
  @IBOutlet weak var loggedInAsLabel: UILabel!

  // MARK: - ArcusResendEmailPresenter Properties

  var personModel: PersonModel!
  var disposeBag: DisposeBag = DisposeBag()

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Add Sclera font to Navigation Title.
    addScleraStyleToNavigationTitle()

    // Remove back button from Navigation Bar.
    navigationItem.backBarButtonItem = nil
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Set first name/email address text.
    configureLoggedInAsLabel(firstName, email: emailAddress)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  // MARK: - UI Configuration

  func configureLoggedInAsLabel(_ firstName: String, email: String) {
    let formattedString = NSMutableAttributedString()
    let size = loggedInAsLabel.font.pointSize
    formattedString
      .normal("Logged in as ", size: size)
      .bold("\(firstName),\n\(email)", size: size)

    loggedInAsLabel.attributedText = formattedString
  }

  // MARK: - IBActions

  @IBAction func logoutButtonPressed(_ sender: AnyObject) {
    logout()
  }
}

fileprivate extension NSMutableAttributedString {
  @discardableResult func addText(_ text: String, font: UIFont) -> NSMutableAttributedString {
    let attrs: [String :AnyObject] = [NSFontAttributeName: font]
    self.append(NSMutableAttributedString(string: text, attributes:attrs))
    return self
  }

  @discardableResult func bold(_ text: String,  size: CGFloat) -> NSMutableAttributedString {
    guard let font = UIFont(name: "AvenirNext-DemiBold", size: size) else {
      return NSMutableAttributedString()
    }
    return addText(text, font: font)
  }

  @discardableResult func normal(_ text: String, size: CGFloat) -> NSMutableAttributedString {
    guard let font = UIFont(name: "AvenirNext-Medium", size: size) else {
      return NSMutableAttributedString()
    }
    return addText(text, font: font)
  }
}
