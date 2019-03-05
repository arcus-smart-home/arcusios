//
//  AddAPlaceAccountOwnerServicePlanViewController.swift
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

class AddAPlaceAccountOwnerServicePlanViewController: UIViewController {

    fileprivate let congratsSegueIdentifier = "congratsSegue"

    var usersPrimaryPlace: PlaceModel?
    var newlyCreatedPlace: PlaceModel?

    @IBOutlet weak var servicePlanLabel: UILabel!
    @IBOutlet var labelsForLocalization: [UILabel]!
    //-------------------------------------------------------------------------------
    // MARK: - UIViewController
    //-------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundColorToDashboardColor()
        navBar(withBackButtonAndTitle: navigationItem.title)
        hideBackButton()

        for label in labelsForLocalization {
            if let labelContents = label.text {
                label.text = NSLocalizedString(labelContents, comment: "")
            }
        }

        if let place = usersPrimaryPlace {
            if isProMonitored(place) {
                servicePlanLabel.text = NSLocalizedString("By default, this place will be enrolled in the "
                  + "Premium Plan and the payment method on file will be charged.", comment: "")
            } else {
                servicePlanLabel.text = String.init(format: NSLocalizedString("By default, this place " +
                  "will have the same service plan as %@.", comment: ""), PlaceCapability.getNameFrom(place))
            }

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddAPlaceAccountOwnerCongratsViewController,
          segue.identifier == congratsSegueIdentifier {
            vc.newlyCreatedPlace = newlyCreatedPlace
        }
    }

    fileprivate func isProMonitored(_ place: PlaceModel) -> Bool {
      return AnyServiceLevelable.isProMonitoredPlace(place)
    }
}
