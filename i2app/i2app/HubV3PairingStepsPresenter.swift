//
//  HubPairingStepsPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/3/18.
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

import Foundation

/// Presenter protocol to manage multiple Hub Pairing steps being contained by one view
internal protocol HubV3PairingStepsPresenterProtocol: class, HubIdValidator {

  /// The steps to display as an array of View Models
  static var steps: [HubV3PairingStepViewModel] { get }

}

/// Concrete implementation of HubPairingStepsPresenterProtocol
internal class HubV3PairingStepsPresenter: HubV3PairingStepsPresenterProtocol {
  
  internal static let steps: [HubV3PairingStepViewModel] = {
    var computedSteps = [HubV3PairingStepViewModel]()
    var step1 = HubV3PairingStepViewModel()
    step1.order = 1
    step1.info = "It's best to install the Hub in a central location. Insert the supplied power cable into the Hub."
    step1.imageName = "HubV3ConnectStep1"
    computedSteps.append(step1)

    var step2 = HubV3PairingStepViewModel()
    step2.order = 2
    step2.info = "Plus the power cable into an outlet."
    step2.imageName = "HubStep5"
    computedSteps.append(step2)

    var step3 = HubV3PairingStepViewModel()
    step3.order = 3
    step3.info = "The Hub’s light ring will rotate purple during boot up. After you hear the welcome message, the Hub will start rotating blue."
    let attributedString = NSMutableAttributedString(string: "Light ring not rotating blue?\n")
    let attributes0: [String : Any] = [
      NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 14)!,
      NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
    ]

    attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: attributedString.length))

    step3.linkText = attributedString
    step3.linkDestination = NSURL.SupportHubPurpleRing
    step3.imageName = "HubV3ConnectStep3"
    computedSteps.append(step3)

    var step4 = HubV3PairingStepViewModel()
    step4.order = 4
    step4.subtitle = "How do you want to connect your Hub to the internet?"
    step4.info = "Connecting to Wi-Fi is best for setting up in a central location. To place the Hub near your router, use the included Ethernet cable."
    step4.imageName = "HubWifiIcon90x90"
    step4.isConnectionSelection = true
    computedSteps.append(step4)

    return computedSteps
  }()

}
