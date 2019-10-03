//
//  AccountSettingsPinCodeConfirmationViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/23/16.
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

class AccountSettingsPinCodeConfirmationViewController: ArcusPinCodeViewController {

  var placeIdToSetPinOn: String?
  var initiallyEnteredPin: String?
  //This tickToTopValueToUse is set by the previous pin code view to ensure the distance from the top
  //of the screen to the buttons is the same on both screens since the text above may not be the same height
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

  //-------------------------------------------------------------------------------
  // MARK: - ArcusPinCodeViewController overrides
  //-------------------------------------------------------------------------------
  @IBAction override func numericButtonPressed(_ sender: UIButton!) {
    super.numericButtonPressed(sender)

    if enteredPin.count == 4 {
      if let initiallyEnteredPin = initiallyEnteredPin,
        let placeIdToSetPinOn = placeIdToSetPinOn,
        initiallyEnteredPin == enteredPin {
        createGif()
        DispatchQueue.global(qos: .background).async {
          let currPerson = RxCornea.shared.settings?.currentPerson
          PersonController.setPin(initiallyEnteredPin,
                                  placeId: placeIdToSetPinOn,
                                  personModel: currPerson) { (success: Bool, error: Error?) in
                                    self.hideGif()
                                    if success && error == nil {
                                      if let navigationController = self.navigationController {
                                        let navStack = navigationController.viewControllers
                                        for vc in navStack where vc is AccountSettingsViewController {
                                          navigationController.popToViewController(vc, animated: true)
                                          break
                                        }
                                      }
                                    } else {
                                      DispatchQueue.main.async {
                                        self.handleSetPinError(error)
                                      }
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
