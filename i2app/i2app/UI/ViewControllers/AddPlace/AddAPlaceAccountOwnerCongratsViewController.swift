//
//  AddAPlaceAccountOwnerCongratsViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/12/16.
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

class AddAPlaceAccountOwnerCongratsViewController: UIViewController {

  var newlyCreatedPlace: PlaceModel?

  @IBOutlet weak var successLabel: UILabel!
  @IBOutlet var labelsToBeLocalized: [UILabel]!

  //-------------------------------------------------------------------------------
  // MARK: - UIViewController
  //-------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    navBar(withBackButtonAndTitle: self.navigationItem.title)
    hideBackButton()

    for label in labelsToBeLocalized {
      if let labelText = label.text {
        label.text = NSLocalizedString(labelText, comment: "")
      }
    }

    if let newlyCreatedPlace = newlyCreatedPlace {
      let string = NSLocalizedString("You've successfully added %@ to your account.", comment: "")
      successLabel.text = String.init(format: string,
                                      PlaceCapability.getNameFrom(newlyCreatedPlace))
    }
  }

  //-------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------
  @IBAction func userTappedNext(_ sender: AnyObject) {
    var shouldShowChoosePlaceTutorial = false
    if let shouldShow = RxCornea.shared.settings?.displayChoosePlaceTutorial() {
      shouldShowChoosePlaceTutorial = shouldShow
    }

    let popToRoot = {
      if let navController = self.navigationController {
        if let dashboardVC = navController.viewControllers[0] as? DashboardTwoViewController {
          dashboardVC.setDashboardBackgroundImageForCurrentPlace()
        }
        _ = navController.popToRootViewController(animated: true)
      }
    }

    if shouldShowChoosePlaceTutorial  {
      let tutorialVC = TutorialViewController.create(with: .choosePlaces, shouldHideShowAgain: true) {
        popToRoot()
      }

      present(tutorialVC!, animated: true, completion: nil)
    } else {
      popToRoot()
    }
  }
}
