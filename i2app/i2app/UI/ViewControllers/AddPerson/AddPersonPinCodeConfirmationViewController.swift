//
//  AddPersonPinCodeConfirmationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/29/16.
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

class AddPersonPinCodeConfirmationViewController: ArcusPinCodeViewController {
  internal var addPersonModel: AddPersonModel?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  // MARK: IBActions
  @IBAction override func numericButtonPressed(_ sender: UIButton!) {
    super.numericButtonPressed(sender)

    if self.enteredPin.count == 4 {
      if self.enteredPin == self.addPersonModel?.pinCode {
        createGif()

        DispatchQueue.global(qos: .background).async {
          if let placeId = RxCornea.shared.settings?.currentPlace?.modelId {
            PersonController
              .setPin(self.enteredPin,
                      placeId: placeId,
                      personModel: self.addPersonModel?.personModel()) { (success: Bool, error: Error?) in
                        self.hideGif()
                        if success && error == nil {
                          self.addPersonModel?.pinCode = self.enteredPin
                          self.performSegue(withIdentifier: "AddPersonPinToPhoneEntrySegue", sender: self)
                        } else {
                          self.handleSetPinError(error)
                        }
            }
          }
        }

      } else {
        self.displayErrorMessage("Please re-enter the PIN Code.",
                                 withTitle: "Pin Codes Do Not Match")
      }
    }
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonPinToPhoneEntrySegue" {
      let phoneNumberEntryViewController: AddPersonPhoneNumberViewController? =
        segue.destination as? AddPersonPhoneNumberViewController
      phoneNumberEntryViewController?.addPersonModel = self.addPersonModel
    }
  }
}
