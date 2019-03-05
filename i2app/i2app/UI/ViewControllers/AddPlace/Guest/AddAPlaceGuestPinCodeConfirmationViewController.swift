//
//  AddAPlaceGuestPinCodeConfirmationViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/18/16.
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

class AddAPlaceGuestPinCodeConfirmationViewController: ArcusPinCodeViewController {

  var initiallyEnteredPin: String?
  //This tickToTopValueToUse is set by the previous pin code view to ensure the distance from the top
  //of the screen to the buttons is the same on both screens, since the text above may not be the same height
  var tickToTopValueToUse: CGFloat?

  @IBOutlet weak var tickMarkToTopConstraint: NSLayoutConstraint!
  //-------------------------------------------------------------------------------
  // MARK: - UIViewController
  //-------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    navBar(withBackButtonAndTitle: NSLocalizedString("PIN CODE", comment: ""))
    if let tickToTopValueToUse = tickToTopValueToUse {
      tickMarkToTopConstraint.constant = tickToTopValueToUse
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  }

  //-------------------------------------------------------------------------------
  // MARK: - ArcusPinCodeViewController overrides
  //-------------------------------------------------------------------------------
  @IBAction override func numericButtonPressed(_ sender: UIButton!) {
    super.numericButtonPressed(sender)

    if enteredPin.characters.count == 4 {
      if let initiallyEnteredPin = initiallyEnteredPin, initiallyEnteredPin == enteredPin {
        createGif()
        DispatchQueue.global(qos: .background).async {
          guard let currPlace = RxCornea.shared.settings?.currentPlace,
            let currPerson = RxCornea.shared.settings?.currentPerson else {
              return
          }

          PersonController.setPin(initiallyEnteredPin,
                                  placeId: currPlace.modelId as String!,
                                  personModel: currPerson) { (success: Bool, error: Error?) in
            self.hideGif()
            if success && error == nil {
              DispatchQueue.global(qos: .background).async {
                let currPerson = RxCornea.shared.settings?.currentPerson
                let currAccount = RxCornea.shared.settings?.currentAccount
                AccountController.completedAccountStep(.signUpPinCode,
                                                           model: currPerson!,
                                                           withAccountModel: currAccount!)
              }
              self.navigationController?.pushViewController(SuccessAccountViewController.create(),
                                                            animated: true)
            } else {
              self.handleSetPinError(error)
            }
          }
        }
      } else {
        displayErrorMessage(NSLocalizedString("Please try again", comment: ""),
                            withTitle: NSLocalizedString("Pin codes do not match", comment: ""))
        self.clearPin()
      }
    }

  }

}
