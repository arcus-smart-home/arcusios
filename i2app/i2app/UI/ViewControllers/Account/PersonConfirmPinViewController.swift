//
//  PersonConfirmPinViewController.swift
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

class PersonConfirmPinViewController: ArcusPinCodeViewController, PersonChangePinControllerDelegate {
    internal var pinController: PersonChangePinController? {
        didSet {
            self.pinController?.delegate = self
        }
    }

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackgroundColorToParentColor()
        self.addDarkOverlay(BackgroupOverlayLightLevel)

        self.navBar(withBackButtonAndTitle: self.navigationItem.title)
    }

    // MARK: IBActions
    @IBAction override func numericButtonPressed(_ sender: UIButton!) {
        super.numericButtonPressed(sender)

        self.pinController?.confirmPin = self.enteredPin
    }

    // MARK: PersonChangePinControllerDelegate
    func confirmPinIsValid(_ isValid: Bool) {
      if isValid {
        self.pinController?.changePin()
      } else if pinController?.confirmPin?.characters.count == pinController?.pinLength &&
        pinController?.confirmPin != pinController?.newPin {
        let title = NSLocalizedString("Pin Codes Do Not Match", comment: "")
        let body = NSLocalizedString("Please re-enter the PIN Code.", comment: "")

        clearPin()
        displayErrorMessage(body,
                            withTitle:title)
      }
    }

    func pinChangeDidFinish(_ success: Bool, error: NSError?) {
        if success {
            self.pinController?.delegate = nil
            for viewController in (self.navigationController?.viewControllers)!
              where viewController is PeopleSettingsCarouselViewController {
                    self.navigationController?.popToViewController(viewController, animated: true)
              }
        } else {
          self.handleSetPinError(error)
        }
    }
}
