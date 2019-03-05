//
//  HubPairingExitStrategyProtocol.swift
//  i2app
//
//  Created by Arcus Team on 6/21/17.
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
import Cornea

protocol HubPairingExitStrategyProtocol: class, HubPairingNode {

  /// depending on the strategy animate away from the Hub Pairing flow to the Dashboard
  func shouldDismissToDashboard()

  /// depending on the strategy animate the ChooseDeviceVC to the screen
  func shouldPresentAddDevices()

}

extension HubPairingExitStrategyProtocol where Self: UIViewController {

  func shouldDismissToDashboard() {
    ApplicationRoutingService.defaultService.showDashboard()
  }

  func shouldPresentAddDevices() {
    ApplicationRoutingService.defaultService.showPairingCatalog(false)
  }
}
