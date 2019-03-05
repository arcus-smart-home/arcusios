//
//  InvitationAcceptedViewController.swift
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

class InvitationAcceptedViewController: BaseTextViewController {

  @IBOutlet internal var nextButton: ArcusButton!
  @IBOutlet internal var titleText: ArcusLabel!
  @IBOutlet internal var subtitleText: ArcusLabel!

  var invitation: Invitation?

  @objc class func createWithInvitation(_ invitation: Invitation) -> InvitationAcceptedViewController? {
    let storyboard: UIStoryboard = UIStoryboard(name: "CreateAccount", bundle:nil)
    let viewController: InvitationAcceptedViewController? =
      storyboard.instantiateViewController(withIdentifier: "InvitationAcceptedViewController")
        as? InvitationAcceptedViewController

    viewController!.invitation = invitation

    return viewController
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    guard let invitation = self.invitation else {
      return
    }
    self.navBar(withBackButtonAndTitle: NSLocalizedString("Invitation Code", comment: ""))

    self.navigationController?.view.createBlurredBackground(self.presentingViewController)
    self.view.backgroundColor = self.navigationController?.view.backgroundColor

    let titleText = "Hi \(invitation.inviteeFirstName ?? "")"
    let subtitleText = "Thanks for accepting your invitation\nto \(invitation.invitorFirstName ?? "")\'s"
      + " place called \(invitation.placeName ?? "")."
      + "\n\n"
      + "Get Started by answering a few questions, then we'll show you how it works."

    self.titleText.text = titleText
    self.subtitleText.text = subtitleText

  }

  @IBAction func nextButtonPressed(_ sender: AnyObject) {
    let config: InvitationRegistrationConfig = InvitationRegistrationConfig()
    config.invitation = self.invitation

    if let vc: CreateAccountViewController = CreateAccountViewController.create(config) {
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}
