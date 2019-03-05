//
//  PersonInvitationPinCodeConfirmationViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/10/16.
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

class PersonInvitationPinCodeConfirmationViewController: ArcusPinCodeViewController,
PersonInvitationTutorialCallback {
  internal var invitation: Invitation?
  internal var personModel: PersonModel?
  internal var pinCode: String?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  // MARK: IBActions
  @IBAction override func numericButtonPressed(_ sender: UIButton!) {
    super.numericButtonPressed(sender)

    if self.enteredPin.characters.count == 4 {
      if self.enteredPin == self.pinCode {
        // Send the Pin Code
        // TODO: Clean up when Swift PersonController can be made
        DispatchQueue.global(qos: .background).async {
          PersonController.setPin(self.pinCode,
                                  placeId: self.invitation!.placeId,
                                  personModel: self.personModel) {
                                    (success, error) in
                                    DispatchQueue.main.async {
                                      if success {
                                        // Call Tutorial
                                        self.performSegue(withIdentifier: "PersonInvitationTutorialSegue",
                                                          sender: self)
                                      } else {
                                        self.handleSetPinError(error)
                                      }
                                    }
          }
        }

      } else {
        self.displayErrorMessage("Please re-enter the PIN Code.",
                                 withTitle: "Pin Codes Do Not Match")
        self.clearPin()
      }
    }
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PersonInvitationTutorialSegue" {
      if let vc: PersonInvitationTutorialViewController = segue.destination
        as? PersonInvitationTutorialViewController {
        vc.callback = self
      }
    }
  }

  // MARK: PersonInvitationTutorialCallback Methods
  func didDismissTutorial() {
    _ = self.navigationController?.popToRootViewController(animated: true)
  }
}
