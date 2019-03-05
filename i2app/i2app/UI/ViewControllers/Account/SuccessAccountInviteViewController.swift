//
//  SuccessAccountInviteViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/17/16.
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

class SuccessAccountInviteViewController: BaseTextViewController,
  RegistrationConfigHolder {
  @IBOutlet internal var subText: ArcusLabel!

  internal var config: RegistrationConfig?

  class func create(_ config: RegistrationConfig) -> SuccessAccountInviteViewController? {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc: SuccessAccountInviteViewController? = storyboard
      .instantiateViewController(withIdentifier: "SuccessAccountInviteViewController")
      as? SuccessAccountInviteViewController

    vc?.config = config

    return vc
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Tag when a user completes signup successfully
    ArcusAnalytics.tag("Sign Up Complete", attributes: [String: AnyObject]())

    UserDefaults.standard.set(true, forKey: "accountJustCreated")
    UserDefaults.standard.synchronize()

    self.navBar(withCloseButtonAndTitle: NSLocalizedString("Congrats", comment: ""))

    self.setBackgroundColorToParentColor()

    if let invitationConfig: InvitationRegistrationConfig = self.config as? InvitationRegistrationConfig {
      var firstName = ""
      var lastName = ""
      if let text = invitationConfig.invitation?.invitorFirstName {
        firstName = text
      }
      if let text = invitationConfig.invitation?.invitorLastName {
        lastName = text
      }
      let subtitleText = "You now have access to \(firstName)"
        + " \(lastName)\'s "
        + "Place and can manage things like:"

      self.subText.text = subtitleText
    }
  }

  @IBAction func close(_ sender: AnyObject) {
    _ = RxCornea.shared.settings?.currentPerson?.refresh()
    ApplicationRoutingService.defaultService.showDashboard()
  }
}
