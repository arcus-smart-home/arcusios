//
//  PersonInvitationPinCodeEntryViewController.swift
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

class PersonInvitationPinCodeEntryViewController: ArcusPinCodeViewController {
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
            self.pinCode = self.enteredPin
            self.performSegue(withIdentifier: "PersonInvitationConfirmPinCodeSegue", sender: self)
        }
    }

    // MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonInvitationConfirmPinCodeSegue" {
            if let confirmPinViewController = segue.destination
                as? PersonInvitationPinCodeConfirmationViewController {
                confirmPinViewController.personModel = self.personModel
                confirmPinViewController.pinCode = self.pinCode
                confirmPinViewController.invitation = self.invitation
            }
        }
    }
}
