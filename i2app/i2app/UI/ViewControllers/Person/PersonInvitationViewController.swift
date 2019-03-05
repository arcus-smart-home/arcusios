//
//  PersonInvitationViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/1/16.
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

class PersonInvitationViewController: BaseTextViewController,
  AccountInvitationCallback,
PersonInvitationsCallback {

  @IBOutlet internal var nextButton: ArcusButton!
  @IBOutlet internal var emailTextField: AccountTextField!
  @IBOutlet internal var codeTextField: AccountTextField!
  @IBOutlet internal var mainText: ArcusLabel!

  var popupWindow: PopupSelectionWindow!

  var personController: PersonInvitationsController?
  var accountController: AccountInvitationController?
  var invitation: Invitation?

  var userInteraction: Bool = false

  @objc class func create() -> PersonInvitationViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Invitation", bundle:nil)
    let viewController: PersonInvitationViewController? = storyboard
      .instantiateViewController(withIdentifier: "PersonInvitationViewController")
      as? PersonInvitationViewController

    return viewController!
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navBar(withBackButtonAndTitle: NSLocalizedString("Invitation Code", comment: ""))

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    self.accountController = AccountInvitationController(callback: self)

    if let currentPerson = RxCornea.shared.settings?.currentPerson {
      self.personController = PersonInvitationsController(model: currentPerson,
                                                          callback: self)
    }

    self.configureTextFields()
  }

  // MARK: - UI Configuration
  func configureTextFields() {
    self.emailTextField.textColor = UIColor.white
    self.emailTextField.floatingLabelTextColor = UIColor.white.withAlphaComponent(0.6)
    self.emailTextField.floatingLabelActiveTextColor = UIColor.white
    self.emailTextField.activeSeparatorColor = UIColor.white.withAlphaComponent(0.4)
    self.emailTextField.separatorColor = UIColor.white.withAlphaComponent(0.4)

    self.codeTextField.textColor = UIColor.white
    self.codeTextField.floatingLabelTextColor = UIColor.white.withAlphaComponent(0.6)
    self.codeTextField.floatingLabelActiveTextColor = UIColor.white
    self.codeTextField.activeSeparatorColor = UIColor.white.withAlphaComponent(0.4)
    self.codeTextField.separatorColor = UIColor.white.withAlphaComponent(0.4)
  }

  // MARK: Button Presses

  func close(_ sender: ArcusButton) {
    self.dismiss(animated: true) { }
  }

  @IBAction func nextButtonPressed(_ sender: AnyObject) {
    if userInteraction == true {
      return
    }

    userInteraction = true

    // Validate?
    if  let email = emailTextField.text,
      let code = codeTextField.text, !(emailTextField.text?.isEmpty)!
      && !(codeTextField.text?.isEmpty)! {
      // Navigate Next

      accountController?.getInvitation(email, code: code)
    } else {
      self.displayInvitationError()
    }
  }

  override func saveRegistrationContext() {

  }

  func displayInvitationError() {
    self.popupErrorWindow("Email and/or invitation\ncode not recognized",
                          subtitle: "Please check the email address and invitation code and try again."
                            + "\n\nInvitation codes expire after 7 days."
                            + "\n\nIf you are trying to accept an invitation on someone's behalf, "
                            + "log out and tap USE INVITATION CODE.")

    userInteraction = false
  }

  // MARK: AccountInvitationCallback Methods

  func invitationNotFound(_ error: AccountInvitationError) {
    if case .invalid(_) = error {
      self.displayInvitationError()
    }
  }

  func invitationFound(_ invitation: Invitation) {
    // Display Popup
    var lastName = ""
    if invitation.invitorLastName != nil && invitation.invitorLastName?.isEmpty != false {
      lastName = " \(invitation.invitorLastName ?? "")"
    }

    // Accept Invite Popup
    var buttons: [PopupSelectionButtonModel] = [PopupSelectionButtonModel]()

    let acceptButton = PopupSelectionButtonModel.create("ACCEPT",
                                                        event: #selector(doAccept(_:)),
                                                        obj: invitation)
    let declineButton = PopupSelectionButtonModel.create("DECLINE",
                                                         event: #selector(doDecline(_:)),
                                                         obj: invitation)
    declineButton?.backgroundColor = ObjCMacroAdapter.arcusPinkAlertColor()

    buttons.append(acceptButton!)
    buttons.append(declineButton!)

    let subtitle = "You've been invited to '\(invitation.placeName ?? "")' "
      + "by \(invitation.invitorFirstName ?? "")\(lastName).\nWould you like to accept the invitation?"
    if let buttonView = PopupSelectionButtonsView
      .create(withTitle: "ACCEPT INVITATION",
              subtitle: subtitle,
              buttons: buttons) {
      buttonView.owner = self

      popupWindow = PopupSelectionWindow.popup(self.view,
                                               subview: buttonView,
                                               owner: self,
                                               close: #selector(doClose),
                                               style: PopupWindowStyleMessageWindow)
    }

  }

  func invitationAcceptSuccess(_ person: PersonModel, email: String, password: String) { }

  func invitationAcceptError(_ error: AccountInvitationError) { }

  // MARK: PersonInvitationCallback Functions

  func showInvitationsPending(_ invitations: [Invitation]) { }

  func showNoInvitations() { }

  func showInvitationAccepted(_ invitation: Invitation) {
    // Do this
    self.invitation = invitation
    self.performSegue(withIdentifier: "PersonInvitationAcceptedSegue", sender: self)
  }

  func showInvitationAcceptInvalidError() {
    self.popupErrorWindow("INVITATION NOT VALID",
                          subtitle: "Contact the account owner for details.\n"
                            + "You may need to be re-invited")

    userInteraction = false
  }

  func showInvitationDeclined(_ invitation: Invitation) {
    self.navigationController?.popViewController(animated: true)
  }

  // MARK: Popup Actions

  func doAccept(_ invitation: Invitation) {
    self.personController?.acceptInvitation(invitation)
  }

  func doDecline(_ invitation: Invitation) {
    self.personController?.declineInvitation(invitation)
  }

  func doClose() {
    userInteraction = false
  }

  // MARK: PrepareForSegue

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PersonInvitationAcceptedSegue" {
      if let vc: PersonInvitationPinCodeEntryViewController = segue.destination
        as? PersonInvitationPinCodeEntryViewController {
        vc.personModel = RxCornea.shared.settings?.currentPerson
        vc.invitation = self.invitation
      }
    }
  }
}
