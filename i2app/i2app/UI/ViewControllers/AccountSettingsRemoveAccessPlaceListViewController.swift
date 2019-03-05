//
//  AccountSettingsRemoveAccessPlaceListViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/24/16.
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
import PromiseKit

private enum RemoveAccessPlaceListTableSection {
  case accountOwner
  case guest
}

class AccountSettingsRemoveAccessPlaceListViewController: UIViewController, PlaceListPresenterDelegate {

  @IBOutlet weak var tableView: UITableView!

  fileprivate let cellIdentifier = "PlaceListCell"
  fileprivate let headerFooterIdentifier = "headerFooter"
  fileprivate let deleteAccountSegueIdentifier = "DeleteAccountSegue"
  fileprivate let deletePlaceSegueIdentifier = "DeletePlaceSegue"
  fileprivate let deleteGuestPersonSegueIdentifier = "DeleteGuestPersonSegue"
  fileprivate let removePlaceAccessSegueIdentifier = "RemovePlaceAccessSegue"

  var placePresenter: PlaceListPresenter!
  fileprivate var selectedPlaceRoleModel: PlaceAndRoleModel?
  fileprivate var selectedAccountToDelete: AccountModel?

  fileprivate var placesOwnedByUser = [PlaceAndRoleModel]()
  fileprivate var placesUserIsGuest = [PlaceAndRoleModel]()

  //-------------------------------------------------------------------------------
  // MARK: - UIViewController
  //-------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()

    placePresenter = PlaceListPresenter(delegate: self)
    placePresenter.fetchPlaceList()
    createGif()
  }

  func setupView() {
    tableView.backgroundColor = UIColor.clear
    tableView.backgroundView = nil

    tableView.register(UINib.init(nibName: "ArcusTwoLabelTableViewSectionHeader", bundle: nil),
                       forHeaderFooterViewReuseIdentifier: headerFooterIdentifier)

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      if identifier == deleteAccountSegueIdentifier {
        if let vc = segue.destination as? DeleteAccountViewController,
          let accountToDelete = selectedAccountToDelete {
          vc.accountModelToDelete = accountToDelete
        }
      } else if identifier == deletePlaceSegueIdentifier {
        if let vc = segue.destination as? DeletePlaceViewController {
          vc.placeIdToDelete = selectedPlaceRoleModel?.placeId
          vc.nameOfPlaceToDelete = selectedPlaceRoleModel?.placeName
        }
      } else if identifier == removePlaceAccessSegueIdentifier {
        if let vc = segue.destination as? RemovePlaceAccessViewController {
          vc.placeIdToRemoveAccessTo = selectedPlaceRoleModel?.placeId
        }
      } else if identifier == deleteGuestPersonSegueIdentifier {
        if let vc = segue.destination as? DeleteGuestPersonViewController {
          vc.guestPersonToDelete = RxCornea.shared.settings?.currentPerson
        }
      }
    }

  }

  @IBAction func didTapDeleteMyAccount(_ sender: AnyObject) {
    if placesOwnedByUser.count > 0 {
      //It doesn't matter which place we use here; we just need to fetch the account model, and
      //every place in this array is owned by the current person
      fetchAccountModelAndSegueToAccountDeletionForPlaceId(placesOwnedByUser[0].placeId)
    } else if placesUserIsGuest.count > 0 {
      performSegue(withIdentifier: deleteGuestPersonSegueIdentifier, sender: self)
    }
  }

  fileprivate func sectionTypeForSection(_ section: Int) -> RemoveAccessPlaceListTableSection {
    if section == 0 {
      if placesOwnedByUser.count > 0 {
        return .accountOwner
      }
      return .guest
    } else {
      return .guest
    }
  }

  fileprivate func fetchAccountModelAndSegueToAccountDeletionForPlaceId(_ placeId: String) {
    createGif()
    let place = PlaceModel(attributes: [kAttrId: placeId as AnyObject])
    place.set([kAttrAddress: place.getAddressForNamespace(PlaceCapability.namespace()) as AnyObject])
    DispatchQueue.global(qos: .background).async {
      _ = place.refresh()
        .swiftThenInBackground { _ in
          let accountToDelete =
            AccountModel(attributes: [kAttrId: PlaceCapability.getAccountFrom(place) as AnyObject])
          accountToDelete
            .set([kAttrAddress:
                  accountToDelete.getAddressForNamespace(AccountCapability.namespace()) as AnyObject])
        return accountToDelete
          .refresh()
          .swiftThen { (_) -> (PMKPromise?) in
          self.hideGif()
          self.selectedAccountToDelete = accountToDelete
          self.performSegue(withIdentifier: self.deleteAccountSegueIdentifier, sender: self)
          return nil
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------
extension AccountSettingsRemoveAccessPlaceListViewController: UITableViewDataSource {
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
      as? ArcusSelectOptionTableViewCell else {
      return UITableViewCell()
    }

    let placeAndRoleModel: PlaceAndRoleModel
    switch sectionTypeForSection(indexPath.section) {
    case .accountOwner:
      placeAndRoleModel = placesOwnedByUser[indexPath.row]
      break
    case .guest:
      placeAndRoleModel = placesUserIsGuest[indexPath.row]
      break
    }

    cell.backgroundColor = UIColor.clear
    cell.titleLabel.text = placeAndRoleModel.placeName
    cell.descriptionLabel.text = placeAndRoleModel.placeLocation()

    if placeAndRoleModel.image != nil {
      cell.detailImage.image = placeAndRoleModel.image
      cell.detailImage.layer.cornerRadius = cell.detailImage.bounds.size.width / 2
      cell.detailImage.clipsToBounds = true
    }

    return cell
  }
}

//-------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------
extension AccountSettingsRemoveAccessPlaceListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    switch sectionTypeForSection(indexPath.section) {
    case .accountOwner:
      selectedPlaceRoleModel = placesOwnedByUser[indexPath.row]

      if placesOwnedByUser.count > 1 {
        performSegue(withIdentifier: deletePlaceSegueIdentifier, sender: self)
      } else if placesOwnedByUser.count == 1 {
        if selectedPlaceRoleModel?.role == PlaceAndRoleModel.ownerString {
          fetchAccountModelAndSegueToAccountDeletionForPlaceId(selectedPlaceRoleModel!.placeId)
        }
      }

      break
    case .guest:
      selectedPlaceRoleModel = placesUserIsGuest[indexPath.row]

      if placesUserIsGuest.count > 1 {
        performSegue(withIdentifier: removePlaceAccessSegueIdentifier, sender: self)
      } else if placesUserIsGuest.count == 1 {
        if placesOwnedByUser.count > 0 {
          performSegue(withIdentifier: removePlaceAccessSegueIdentifier, sender: self)
        } else {
          performSegue(withIdentifier: deleteGuestPersonSegueIdentifier, sender: self)
        }
      }
      break
    }
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
}

//-------------------------------------------------------------------------------
// MARK: - PlaceListPresenterDelegate
//-------------------------------------------------------------------------------
extension AccountSettingsRemoveAccessPlaceListViewController {
  func didReceivePlaceList(_ placeList: [PlaceAndRoleModel], presenter: PlaceListPresenter) {
    hideGif()
    placesOwnedByUser = [PlaceAndRoleModel]()
    placesUserIsGuest = [PlaceAndRoleModel]()

    for place in placeList {
      if place.role == PlaceAndRoleModel.ownerString {
        placesOwnedByUser.append(place)
      } else {
        placesUserIsGuest.append(place)
      }
    }

    if placesOwnedByUser.count == 1 && placesUserIsGuest.count == 0 {
      let onlyPlaceOwned = placesOwnedByUser[0]
      if onlyPlaceOwned.role == PlaceAndRoleModel.ownerString {
        fetchAccountModelAndSegueToAccountDeletionForPlaceId(onlyPlaceOwned.placeId)
      }
    } else if placesOwnedByUser.count == 0 && placesUserIsGuest.count == 1 {
      performSegue(withIdentifier: deleteGuestPersonSegueIdentifier, sender: self)
    }

    tableView.reloadData()
  }
}
