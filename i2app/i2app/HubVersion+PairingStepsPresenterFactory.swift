//
//  HubVersion+PairingStepsPresenterFactory.swift
//  i2app
//
//  Created by Arcus Team on 7/11/18.
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

extension HubVersion {

  func createStepPresenter() -> HubPairingStepsPresenterProtocol {
    switch self {
    case .version2:
      return HubPairingStepsPresenter(withSteps: HubVersion.v2Steps)
    case .version3:
      return HubPairingStepsPresenter(withSteps: HubVersion.v3Steps)
    }
  }

  static let v2Steps: [HubPairingStepViewModel] = {
    var computedSteps = [HubPairingStepViewModel]()
    var step1 = HubPairingStepViewModel()
    step1.order = 1
    step1.info = "Remove the battery cover,\ninsert the included backup\nbatteries, then reattach the cover."
    step1.imageName = "HubStep1"
    computedSteps.append(step1)

    var step2 = HubPairingStepViewModel()
    step2.order = 2
    step2.info = "Plug one end of the supplied\nethernet cable into your router."
    step2.imageName = "HubStep2"
    computedSteps.append(step2)

    var step3 = HubPairingStepViewModel()
    step3.order = 3
    step3.info = "Plug the other end\ninto the Hub."
    step3.imageName = "HubStep3"
    computedSteps.append(step3)

    var step4 = HubPairingStepViewModel()
    step4.order = 4
    step4.info = "Insert the supplied power\ncable into the Hub."
    step4.imageName = "HubStep4"
    computedSteps.append(step4)

    var step5 = HubPairingStepViewModel()
    step5.order = 5
    step5.info = "Plug the power cable\ninto a power outlet."
    step5.imageName = "HubStep5"
    computedSteps.append(step5)

    var step6 = HubPairingStepViewModel()
    step6.order = 6
    step6.info = "Enter the Hub ID found\non the bottom of the Hub."
    step6.imageName = "HubStep6"
    step6.isHubIdForm = true
    computedSteps.append(step6)

    return computedSteps
  }()

  static let v3Steps: [HubPairingStepViewModel] = {
    var computedSteps = [HubPairingStepViewModel]()
    var step1 = HubPairingStepViewModel()
    step1.order = 1
    step1.info = "Plug one end of the supplied\nethernet cable into your router."
    step1.imageName = "HubStep2"
    computedSteps.append(step1)

    var step2 = HubPairingStepViewModel()
    step2.order = 2
    step2.info = "Plug the other end\ninto the Hub."
    step2.imageName = "HubV3EthernetStep2"
    computedSteps.append(step2)

    var step3 = HubPairingStepViewModel()
    step3.order = 3
    step3.info = "Enter the Hub ID found\non the bottom of the Hub."
    step3.imageName = "HubV3Bottom"
    step3.isHubIdForm = true
    computedSteps.append(step3)

    return computedSteps
  }()
}
