//
// Created by Arcus Team on 5/5/16.
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

class PersonInvitationsListViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, PersonInvitationsCallback {
  var invitationsController: PersonInvitationsController!

  var invitationsList: [Invitation] = [Invitation]()

  var popupWindow: PopupSelectionWindow!

  var selectedInvitation: Invitation?

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.backgroundColor = UIColor.clear
      tableView.estimatedRowHeight = 120
    }
  }

  class func create() -> PersonInvitationsListViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Invitation", bundle:nil)
    let viewController: PersonInvitationsListViewController? =
      storyboard.instantiateViewController(withIdentifier: "PersonInvitationsViewController")
      as? PersonInvitationsListViewController

    return viewController!
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    if let currentPerson = RxCornea.shared.settings?.currentPerson {
      invitationsController = PersonInvitationsController(model: currentPerson,
                                                          callback: self)
    }

    setBackgroundColorToDashboardColor()

    navBar(withBackButtonAndTitle: self.navigationItem.title)

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    tableView.reloadData()
  }

  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.invitationsList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let CellIdentifier = "PersonInvitationListTableViewCell"

    let reuseCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)!

    if let cell: PersonInvitationListTableViewCell =
      tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        as? PersonInvitationListTableViewCell {

      cell.backgroundColor = UIColor.clear
      cell.selectionStyle = UITableViewCellSelectionStyle.none

      let invitation: Invitation = invitationsList[indexPath.row]

      var address1: String = invitation.streetAddress1 ?? ""
      var address2: String = invitation.streetAddress2 ?? ""
      let city: String = invitation.city ?? ""

      if !address1.isEmpty && (!address2.isEmpty || !city.isEmpty) {
        address1 += ", "
      }

      if !address2.isEmpty && !city.isEmpty {
        address2 += ", "
      }

      cell.titleLabel.text = invitation.placeName
      cell.subtitleLabel.text = "\(address1)\(address2)\(city)"
      cell.invitationLabel.text =
      "Invited by \(invitation.invitorFirstName ?? "") \(invitation.invitorLastName ?? "")"

      return cell
    }

    return reuseCell
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let invitation: Invitation = invitationsList[indexPath.row]
    var lastName = ""

    if invitation.invitorLastName != nil && invitation.invitorLastName?.isEmpty != false {
      lastName = " \(invitation.invitorLastName ?? "")"
    }

    // Accept Invite Popup
    var buttons: [PopupSelectionButtonModel] = [PopupSelectionButtonModel]()

    buttons.append(PopupSelectionButtonModel.create("ACCEPT",
                                                    event: #selector(doAccept(_:)),
                                                    obj: invitation))
    buttons.append(PopupSelectionButtonModel.create("DECLINE",
                                                    event: #selector(doDecline(_:)),
                                                    obj: invitation))

    if let buttonView = PopupSelectionButtonsView
      .create(withTitle: "ACCEPT INVITE",
              subtitle: "You've been invited to \(invitation.placeName ?? "") "
                + "by \(invitation.invitorFirstName ?? "")\(lastName).\nWould "
                + "you like to accept the invitation?",
        buttons: buttons) {
      buttonView.owner = self

      popupWindow = PopupSelectionWindow.popup(self.view,
                                               subview: buttonView,
                                               owner: self,
                                               close: nil,
                                               style: PopupWindowStyleMessageWindow)

    }
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "InvitationAcceptedSegue" {
      if let vc: PersonInvitationPinCodeEntryViewController = segue.destination
        as? PersonInvitationPinCodeEntryViewController {
        vc.personModel = RxCornea.shared.settings?.currentPerson
        vc.invitation = self.selectedInvitation
      }
    }
  }

  func doAccept(_ invitation: Invitation) {
    self.invitationsController.acceptInvitation(invitation)
  }

  func doDecline(_ invitation: Invitation) {
    self.invitationsController.declineInvitation(invitation)
  }

  // MARK: PersonInvitationsCallback
  func showNoInvitations() {
    self.invitationsList.removeAll()
  }

  func showInvitationsPending(_ invitations: [Invitation]) {
    self.invitationsList = invitations
    self.tableView.reloadData()
  }

  func showInvitationAccepted(_ invitation: Invitation) {
    // Navigate Forward
    self.selectedInvitation = invitation
    self.performSegue(withIdentifier: "InvitationAcceptedSegue", sender: self)
  }

  func showInvitationDeclined(_ invitation: Invitation) {
    if let index = self.invitationsList.index(of: invitation) {
      self.invitationsList.remove(at: index)
      self.tableView.reloadData()
    }
  }

  func showInvitationAcceptInvalidError() {
    self.popupErrorWindow("INVITATION NOT VALID",
                          subtitle: "Contact the account owner for details.\n"
                            + "You may need to be re-invited")
  }
}
