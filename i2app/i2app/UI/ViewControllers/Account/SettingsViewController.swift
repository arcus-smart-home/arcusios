//
//  SettingsViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/4/16.
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

private enum SettingsCellType {
  case profile
  case places
  case people
  case invitationCode
}

private struct Setting {
  let title: String
  let description: String
  let type: SettingsCellType
}

private struct SettingsConstants {
  fileprivate static let profileSetting =
    Setting.init(title: NSLocalizedString("Profile", comment: ""),
                 description: NSLocalizedString("Edit & Update Your Information", comment: ""),
                 type: .profile)
  fileprivate static let placesSetting =
    Setting.init(title: NSLocalizedString("Places", comment: ""),
                 description: NSLocalizedString("Manage Places", comment: ""),
                 type: .places)
  fileprivate static let peopleSetting =
    Setting.init(title: NSLocalizedString("People", comment: ""),
                 description: NSLocalizedString("Manage People", comment: ""),
                 type:  .people)
  fileprivate static let invitationCodeSetting =
    Setting.init(title: NSLocalizedString("Invitation Code", comment: ""),
                 description: NSLocalizedString("Accept Invitation(s) to Someone's Place", comment: ""),
                 type: .invitationCode)

  static let settings = [profileSetting, peopleSetting, placesSetting, invitationCodeSetting]
}

class SettingsViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate,
PlaceListPresenterDelegate {
  @IBOutlet var settingsTableView: UITableView!

  //These will be updated by the place list presenter delegate upon receiving the list of places
  fileprivate var settingsToDisplay: [Setting] = SettingsConstants.settings
  fileprivate var placesOwnedByUser: [PlaceAndRoleModel]?
  fileprivate var placesUserIsGuest: [PlaceAndRoleModel]?
  fileprivate var placeListPresenter: PlaceListPresenter!

  fileprivate let profileSegueIdentifier = "ProfileSegue"
  fileprivate let placesSegueIdentifier  = "PlacesSegue"
  fileprivate let peopleSegueIdentifier = "PeopleSegue"

  // MARK: View LifeCycle
  class func create() -> SettingsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Settings",
                                                bundle:nil)
    let viewController: SettingsViewController? =
      storyboard.instantiateInitialViewController() as? SettingsViewController

    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    settingsTableView.backgroundColor = UIColor.clear
    settingsTableView.backgroundView = nil

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)

    placeListPresenter = PlaceListPresenter.init(delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    createGif()
    placeListPresenter.fetchPlaceList()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      if let vc = segue.destination as? AccountSettingsViewController,
        identifier == profileSegueIdentifier {
        vc.placesOwnedByUser = placesOwnedByUser
        vc.placesUserIsGuest = placesUserIsGuest
      } else if let vc = segue.destination as? PlacesListViewController,
        identifier == placesSegueIdentifier {
        if let placesOwnedByUser = placesOwnedByUser {
          vc.placesOwnedByUser = placesOwnedByUser
        }
        if let placesUserIsGuest = placesUserIsGuest {
          vc.placesUserIsGuest = placesUserIsGuest
        }
      } else if let vc = segue.destination as? PlacePeopleListViewController,
        identifier == peopleSegueIdentifier {
        vc.placesOwnedByUser = placesOwnedByUser
        vc.placesUserIsGuest = placesUserIsGuest
      }
    }
  }

  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingsToDisplay.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "AccountSettingsCell"

    let cell: ArcusTitleDetailTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusTitleDetailTableViewCell

    let setting = settingsToDisplay[indexPath.row]

    cell?.backgroundColor = UIColor.clear

    cell?.titleLabel.text = setting.title
    cell?.descriptionLabel.text = setting.description

    return cell!
  }

  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let setting = settingsToDisplay[indexPath.row]
    switch setting.type {
    case .profile:
      performSegue(withIdentifier: profileSegueIdentifier, sender: self)
      break
    case .places:
      performSegue(withIdentifier: placesSegueIdentifier, sender: self)
      break
    case .people:
      performSegue(withIdentifier: peopleSegueIdentifier, sender: self)
      break
    case .invitationCode:
      let personInvitationViewController: PersonInvitationViewController =
        PersonInvitationViewController.create()
      navigationController?.pushViewController(personInvitationViewController, animated: true)
      break
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: - PlaceListPresenterDelegate
  func didReceivePlaceList(_ placeList: [PlaceAndRoleModel], presenter: PlaceListPresenter) {
    DispatchQueue.global(qos: .background).async {
      var newOwnedList = [PlaceAndRoleModel]()
      var newGuestList = [PlaceAndRoleModel]()

      let sortedPlaceList = placeList.sorted {
        return $0.0.placeName.caseInsensitiveCompare($0.1.placeName) == .orderedAscending
      }
      for placeAndRole in sortedPlaceList {
        if placeAndRole.role == PlaceAndRoleModel.ownerString {
          newOwnedList.append(placeAndRole)
        } else {
          newGuestList.append(placeAndRole)
        }
      }

      //Switch to main for updating UI
      DispatchQueue.main.async {
        self.placesOwnedByUser = newOwnedList
        self.placesUserIsGuest = newGuestList
        self.hideGif()
      }

    }
  }
}
