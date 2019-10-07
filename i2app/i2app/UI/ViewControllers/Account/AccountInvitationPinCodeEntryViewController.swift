//
//  AccountInvitationPinCodeEntryViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/19/16.
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
import Cornea

class AccountInvitationPinCodeEntryViewController: ArcusPinCodeViewController,
  RegistrationConfigHolder {
  internal var personModel: PersonModel?
  internal var pinCode: String?

  internal var config: RegistrationConfig?

  class func create(_ config: RegistrationConfig) -> AccountInvitationPinCodeEntryViewController? {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc = storyboard
      .instantiateViewController(withIdentifier: "AccountInvitationPinCodeEntryViewController")
      as? AccountInvitationPinCodeEntryViewController
    vc?.config = config

    return vc
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navBar(withCloseButtonAndTitle: NSLocalizedString("Pin Code", comment: ""))

    self.navigationController?.view.createBlurredBackground(self.presentingViewController)
    self.view.backgroundColor = self.navigationController?.view.backgroundColor
  }

  // MARK: IBActions
  @IBAction override func numericButtonPressed(_ sender: UIButton!) {
    super.numericButtonPressed(sender)

    if self.enteredPin.count == 4 {
      self.pinCode = self.enteredPin
      self.performSegue(withIdentifier: "AccountInvitationConfirmPinCodeSegue", sender: self)
    }
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AccountInvitationConfirmPinCodeSegue" {
      if let confirmPinViewController = segue.destination
        as? AccountInvitationPinCodeConfirmationViewController {
        confirmPinViewController.personModel = self.personModel
        confirmPinViewController.pinCode = self.pinCode
        confirmPinViewController.config = self.config
      }
    }
  }
}
