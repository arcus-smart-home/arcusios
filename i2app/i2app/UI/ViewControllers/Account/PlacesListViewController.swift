//
//  PlacesListViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/6/16.
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

private enum PlaceListSection {
  case accountOwner
  case guest
}

protocol PlaceEditor {
  var currentPlaceAndRole: PlaceAndRoleModel? {get set}
  var numberOfGuestPlaces: Int? {get set}
  var numberOfOwnedPlaces: Int? {get set}
}

class PlacesListViewController: UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
PlaceListPresenterDelegate {
  @IBOutlet var tableView: UITableView!
  fileprivate let headerFooterIdentifier = "headerFooter"
  fileprivate let placeDetailSegueIdentifier = "PlaceDetailSegue"

  var placePresenter: PlaceListPresenter!
  var placesOwnedByUser: [PlaceAndRoleModel]!
  var placesUserIsGuest: [PlaceAndRoleModel]!
  var selectedPlaceRole: PlaceAndRoleModel?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    if placesOwnedByUser == nil {
      placesOwnedByUser = [PlaceAndRoleModel]()
    }

    if placesUserIsGuest == nil {
      placesUserIsGuest = [PlaceAndRoleModel]()
    }

    placePresenter = PlaceListPresenter(delegate: self)

    setupView()
  }

  func setupView() {
    tableView.backgroundColor = UIColor.clear
    tableView.backgroundView = nil

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    navBar(withBackButtonAndTitle: self.navigationItem.title)
    tableView.register(UINib.init(nibName: "ArcusTwoLabelTableViewSectionHeader",
                                  bundle: nil),
                       forHeaderFooterViewReuseIdentifier: headerFooterIdentifier)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    createGif()
    placePresenter.fetchPlaceList()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      if var vc = segue.destination as? PlaceEditor,
        identifier == placeDetailSegueIdentifier {
        vc.currentPlaceAndRole = selectedPlaceRole
        vc.numberOfGuestPlaces = placesUserIsGuest.count
        vc.numberOfOwnedPlaces = placesOwnedByUser.count
      }
    }
  }

  // MARK: PlaceListPresenterDelegate
  func didReceivePlaceList(_ placeList: [PlaceAndRoleModel], presenter: PlaceListPresenter) {
    placesOwnedByUser = [PlaceAndRoleModel]()
    placesUserIsGuest = [PlaceAndRoleModel]()

    let sortedPlaceList = placeList.sorted {
      return $0.0.placeName.caseInsensitiveCompare($0.1.placeName) == .orderedAscending
    }
    for place in sortedPlaceList {
      if place.role == PlaceAndRoleModel.ownerString {
        placesOwnedByUser.append(place)
      } else {
        placesUserIsGuest.append(place)
      }
    }

    tableView.reloadData()
    hideGif()
  }

  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionType = sectionTypeForSection(section)

    switch sectionType {
    case .accountOwner:
      return placesOwnedByUser.count
    case .guest:
      return placesUserIsGuest.count
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections = 0

    if placesOwnedByUser.count > 0 {
      numberOfSections += 1
    }

    if placesUserIsGuest.count > 0 {
      numberOfSections += 1
    }

    return numberOfSections
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListCell")
      as? ArcusSelectOptionTableViewCell
    let placeAndRoleModel = placeAndRoleModelForIndexPath(indexPath)

    cell?.backgroundColor = UIColor.clear
    cell?.titleLabel.text = placeAndRoleModel.placeName
    cell?.descriptionLabel.text = placeAndRoleModel.placeLocation()

    if placeAndRoleModel.image != nil {
      cell?.detailImage.image = placeAndRoleModel.image
      cell?.detailImage.layer.cornerRadius = cell!.detailImage.bounds.size.width / 2
      cell?.detailImage.clipsToBounds = true
    }

    return cell!
  }

  // MARK: Data source helpers
  func placeAndRoleModelForIndexPath(_ indexPath: IndexPath) -> PlaceAndRoleModel {
    let sectionType = sectionTypeForSection(indexPath.section)
    let placeRole: PlaceAndRoleModel
    switch sectionType {
    case .accountOwner:
      placeRole = placesOwnedByUser[indexPath.row]
      break
    case .guest:
      placeRole = placesUserIsGuest[indexPath.row]
      break
    }
    return placeRole
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedPlaceRole = placeAndRoleModelForIndexPath(indexPath)
    performSegue(withIdentifier: placeDetailSegueIdentifier, sender: self)
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterIdentifier)
      as? ArcusTwoLabelTableViewSectionHeader {
      let title: String
      switch sectionTypeForSection(section) {
      case .accountOwner:
        title = NSLocalizedString("Account Owner", comment: "")
        break
      case .guest:
        title = NSLocalizedString("Guest", comment: "")
        break
      }

      sectionHeader.mainTextLabel.text = title
      sectionHeader.accessoryTextLabel.text = nil
      sectionHeader.hasBlurEffect = true

      return sectionHeader
    }

    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  // MARK: Helpers
  fileprivate func sectionTypeForSection(_ section: Int) -> PlaceListSection {
    if section == 0 {
      if placesOwnedByUser.count > 0 {
        return .accountOwner
      }
      return .guest
    } else {
      return .guest
    }
  }
}
