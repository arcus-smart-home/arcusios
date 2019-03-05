//
//  AccountInvitationPinCodeConfirmationViewController.swift
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
import CocoaLumberjack

class AccountInvitationPinCodeConfirmationViewController: ArcusPinCodeViewController,
  PersonInvitationTutorialCallback,
  RegistrationConfigHolder {
  internal var personModel: PersonModel?
  internal var pinCode: String?

  internal var config: RegistrationConfig?

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
      if self.enteredPin == self.pinCode {
        // Send the Pin Code
        // TODO: Clean up when Swift PersonController can be made
        var placeId: String
        if let invitationConfig = self.config as? InvitationRegistrationConfig,
          let invitation = invitationConfig.invitation,
          let placeID = invitation.placeId {
          placeId = placeID
        } else if let placeID = RxCornea.shared.settings?.currentPlace?.modelId {
          placeId = placeID
        } else {
          DDLogWarn("Entered an unexpected codepath in AccountInvitationPinCodeConfirmationViewController")
          placeId = ""
        }
        DDLogInfo("Current Place to set PIN code: \(placeId)")
        DispatchQueue.global(qos: .background).async {
          PersonController.setPin(self.pinCode,
                                  placeId: placeId,
                                  personModel: self.personModel) {
            (success, error) in
            DispatchQueue.main.async {
              if success {
                // Call Tutorial
                self.performSegue(withIdentifier: "AccountInvitationSuccessSegue", sender: self)
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
    if segue.identifier == "AccountInvitationSuccessSegue" {
      if let vc: SuccessAccountInviteViewController = segue.destination
        as? SuccessAccountInviteViewController {
        vc.config = self.config
      }
    }
  }

  // MARK: PersonInvitationTutorialCallback Methods
  func didDismissTutorial() {
    ApplicationRoutingService.defaultService.showDashboard()
  }
}
