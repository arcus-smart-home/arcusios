//
//  AccountCreationHaveHubViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/12/17.
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

/**
 This screen asks users if they have a hub or not. If the user has a hub then the screen forwards to 
 hub pairing, if the user has no hub then the screen forwards to the hubless device catalog. Additionally, 
 the user can skip the selection and go straight to the dashboard.
 */
class AccountCreationHaveHubViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.hidesBackButton = true
  }

  /**
   Dismisses the current screen and navigates to the dashboard.
   */
  @IBAction func dashboardButtonPressed(_ sender: Any) {
    ApplicationRoutingService.defaultService.showDashboard()
  }

  /**
   Indicates that the user has a hub.
   */
  @IBAction func yesButtonPressed(_ sender: Any) {

    // TODO: Use HubBuilder
    ApplicationRoutingService.defaultService.showHubPairing()
  }

  /**
   Indicates that the user does not have a hub.
   */
  @IBAction func noButtonPressed(_ sender: Any) {
    ApplicationRoutingService.defaultService.showPairingCatalog(true)
  }
}
