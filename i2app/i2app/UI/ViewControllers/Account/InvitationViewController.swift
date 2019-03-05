//
//  InvitationViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/11/16.
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

class InvitationViewController: BaseTextViewController, AccountInvitationCallback {

    @IBOutlet internal var nextButton: ArcusButton!
    @IBOutlet internal var emailTextField: AccountTextField!
    @IBOutlet internal var codeTextField: AccountTextField!
    @IBOutlet internal var mainText: ArcusLabel!

    var controller: AccountInvitationController?
    var invitation: Invitation?

    @objc class func create() -> InvitationViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "CreateAccount", bundle:nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InvitationViewController")
            as? InvitationViewController

        return viewController!
    }

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar(withBackButtonAndTitle: NSLocalizedString("Invitation Code", comment: ""))

        self.navigationController?.view.createBlurredBackground(self.presentingViewController)
        self.view.backgroundColor = self.navigationController?.view.backgroundColor

        controller = AccountInvitationController(callback: self)

    }

    func close(_ sender: ArcusButton) {
        self.dismiss(animated: true) { }
    }

    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        // Validate?
        if  let email = emailTextField.text,
            let code = codeTextField.text, !(emailTextField.text?.isEmpty)!
                && !(codeTextField.text?.isEmpty)! {
            // Navigate Next

            controller?.getInvitation(email, code: code)
        } else {
            displayInvitationNotFoundError()
        }
    }

    override func saveRegistrationContext() {

    }

    func displayInvitationNotFoundError() {
        self.popupErrorWindow("Email and/or Invitation Code Not" +
            " Recognized",
                              subtitle: "Please check the email address and" +
                                " invitation code and try again.\n\nInvitation" +
            " codes expire after 7 days.")
    }

    // MARK: AccountInvitationCallback Methods

    func invitationNotFound(_ error: AccountInvitationError) {
        if case .invalid(_) = error {
            displayInvitationNotFoundError()
        }
    }

    func invitationFound(_ invitation: Invitation) {
        self.invitation = invitation
        self.performSegue(withIdentifier: "InvitationAcceptedSegue", sender: self)
    }

    func invitationAcceptSuccess(_ person: PersonModel, email: String, password: String) {
    }

    func invitationAcceptError(_ error: AccountInvitationError) {
    }

    // MARK: PrepareForSegue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InvitationAcceptedSegue" {
            if let viewController: InvitationAcceptedViewController = segue.destination
                as? InvitationAcceptedViewController {
                viewController.invitation = self.invitation
            }
        }
    }

}
