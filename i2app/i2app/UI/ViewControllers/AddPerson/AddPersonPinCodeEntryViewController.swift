//
//  AddPersonPinCodeEntryViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/28/16.
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

class AddPersonPinCodeEntryViewController: ArcusPinCodeViewController {
    internal var addPersonModel: AddPersonModel?

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackgroundColorToDashboardColor()
        self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

        self.navBar(withTitle: self.navigationItem.title,
                    andRightButtonText: NSLocalizedString("SKIP", comment: ""),
                    with: #selector(self.onSkipTapped),
                    selectorTarget: self)
    }

    // MARK: IBActions
    @IBAction override func numericButtonPressed(_ sender: UIButton!) {
        super.numericButtonPressed(sender)

        if self.enteredPin.count == 4 {
            self.addPersonModel?.pinCode = self.enteredPin
            self.performSegue(withIdentifier: "AddPersonConfirmPinCodeSegue", sender: self)
        }
    }

    // MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPersonConfirmPinCodeSegue" {
            let confirmPinViewController: AddPersonPinCodeConfirmationViewController? =
                segue.destination as? AddPersonPinCodeConfirmationViewController
            confirmPinViewController?.addPersonModel = self.addPersonModel
        } else if segue.identifier == "skipItSegue" {
            let addPhoneViewController: AddPersonPhoneNumberViewController? =
              segue.destination as? AddPersonPhoneNumberViewController
            addPhoneViewController?.addPersonModel = self.addPersonModel
        }
    }

    // MARK: SkipIt
    func onSkipTapped() {
        let subtitle = NSLocalizedString("Without a PIN Code, this person will not be able to disarm your "
          + "alarm, participate in your Alarm Notification List or unlock any locks. Are you sure you want "
          + "to skip?", comment: "")
        displayMessage(
            NSLocalizedString("NO PIN CODE", comment: ""),
            subtitle: subtitle,
            backgroundColor: UIColor.white,
            buttonOne: NSLocalizedString("NO", comment: ""),
            buttonTwo: NSLocalizedString("YES", comment: ""),
            buttoneOneStyle: FontDataTypeButtonDark,
            buttonTwoStyle: FontDataTypeButtonPink,
            withTarget: self,
            withButtonOneSelector: #selector(self.slideOutTwoButtonAlert),
            andButtonTwoSelector: #selector(self.onSkipConfirmed))
    }

    func onSkipConfirmed() {
        slideOutTwoButtonAlert()

        self.addPersonModel?.pinCode = ""   // Clear any previously-entered PIN code
        self.performSegue(withIdentifier: "skipItSegue", sender: self)
    }
}
