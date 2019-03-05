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
internal protocol HubPairingStepsPresenterProtocol: class, HubIdValidator {

  /// The delegate, a Parent View that manages the next button and contains the steps, delegates
  /// are expected to populate this presenter to it's children in weak references
  var delegate: HubPairingStepsPresenterDelegate? { get set }

  /// The steps to display as an array of View Models
  var steps: [HubPairingStepViewModel] { get }

  /// Invoked to indicate that pairing steps have been completed by user and that the device
  /// searching screen ("bugs bunny") should be displayed.
  /// -hubId:  the Hub ID input by the user
  func onSegueToSearching(hubId: String)

  /// Get the Hub ID, validate it, and confirm that the user can start searching for a hub
  /// Will call onSegueToSearching(hubId: String) on the delegate if all goes well.
  func onCheckSetProceedEnabled(hubId: String?)

}

/// A protcol for action handled by the Parent View that contains the steps
internal protocol HubPairingStepsPresenterDelegate: class {

  func onSegueToSearching(hubId: String)

  func onSetProceedEnabled(_ enable: Bool)

}

/// Concrete implemntation of HubPairingStepsPresenterProtocol
internal class HubPairingStepsPresenter: HubPairingStepsPresenterProtocol {

  weak var delegate: HubPairingStepsPresenterDelegate?

  func onSegueToSearching(hubId: String) {
    delegate?.onSegueToSearching(hubId: hubId)
  }

  func onCheckSetProceedEnabled(hubId: String?) {
    if let hubId = hubId,
      let response = try? validateHubId(hubId) {
      delegate?.onSetProceedEnabled(response)
    } else {
      delegate?.onSetProceedEnabled(false)
    }
  }

  var steps: [HubPairingStepViewModel]

  init(withSteps: [HubPairingStepViewModel]) {
    steps = withSteps
  }
}
