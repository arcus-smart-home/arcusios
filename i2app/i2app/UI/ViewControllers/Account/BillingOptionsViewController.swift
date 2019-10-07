//
//  BillingOptionsViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/18/16.
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

class BillingOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var placesArray: [PlaceModel] = [PlaceModel]()

  var isAccountOwner: Bool?
  //The place and role models passed off by the settings screen for obtaining account model id
  var placesOwnedByUser: [PlaceAndRoleModel]?
  //The account model associated with this account owner
  var usersAccountModel: AccountModel?

  @IBOutlet weak var paymentInfoView: UIView! {
    didSet {
      let tap = UITapGestureRecognizer(target: self,
                                       action: #selector(BillingOptionsViewController.handleTap))
      //  tap.delegate = self
      self.paymentInfoView.addGestureRecognizer(tap)
    }
  }

  @IBOutlet var tableView: UITableView! {
    didSet {
      self.tableView.backgroundColor = UIColor.clear
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.estimatedRowHeight = 80
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.alwaysBounceVertical = false
    }
  }

  @IBOutlet weak var nonAccountOwnerHeader: UIView!
  @IBOutlet weak var accountOwnerHeader: UIView!
  @IBOutlet weak var shopButton: ArcusButton!

  // MARK: View LifeCycle
  class func create() -> BillingOptionsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "BillingSettings", bundle:nil)
    let viewController: BillingOptionsViewController? =
      storyboard.instantiateInitialViewController() as? BillingOptionsViewController

    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navBar(withBackButtonAndTitle: "Billing")
    self.setBackgroundColorToDashboardColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)

    if let isAccountOwner = isAccountOwner,
      let placesOwnedByUser = placesOwnedByUser,
      placesOwnedByUser.count > 0 && isAccountOwner {
      fetchAndDisplayBillingInfo(placesOwnedByUser)
    } else {
      hideBillingTableForNonAccountOwner()
    }
  }

  // MARK: UI Helpers
  func fetchAndDisplayBillingInfo(_ placesOwnedByUser: [PlaceAndRoleModel]) {
    self.createGif()

    //Just used to get a place model to pull an account id out of
    let randomOwnedPlace = placesOwnedByUser[0]
    DispatchQueue.global(qos: .background).async {
      let placeModel = PlaceModel.createPlaceModelFromPlaceAndRole(randomOwnedPlace)
      _ = placeModel?.refresh().swiftThenInBackground { _ in
        guard let usersAccountId = PlaceCapability.getAccountFrom(placeModel) else { return nil }

        let usersAccount = AccountModel.createAccountModelContainingAddressForModelId(usersAccountId)
        _ = usersAccount?.refresh().swiftThenInBackground { _ in

          self.usersAccountModel = usersAccount
          _ = AccountController.getOwnedPlacesOnModel(usersAccount!).swiftThen { places in
            self.hideGif()

            if let places = places as? [PlaceModel] {
              self.placesArray = places.sorted {
                let firstName = PlaceCapability.getNameFrom($0.0)
                let secondName = PlaceCapability.getNameFrom($0.1)
                return firstName!.caseInsensitiveCompare(secondName!) == .orderedAscending
              }
            }

            DispatchQueue.main.async(execute: {
              self.accountOwnerHeader.isHidden = false
              self.tableView.isHidden = false
              self.nonAccountOwnerHeader.isHidden = true
              self.shopButton.isHidden = true
              self.tableView.reloadData()
            })
            return nil
            }.swiftCatch { error in
              self.hideGif()

              if let caughtError = error as? Error {
                self.displayGenericErrorMessageWithError(caughtError)
              }
              return nil
          }

          return nil
          }.swiftCatch { error in
            self.hideGif()

            if let caughtError = error as? Error {
              self.displayGenericErrorMessageWithError(caughtError)
            }

            return nil
        }
        return nil
        }.swiftCatch { error in
          self.hideGif()

          if let caughtError = error as? Error {
            self.displayGenericErrorMessageWithError(caughtError)
          }

          return nil
      }
    }
  }

  func hideBillingTableForNonAccountOwner() {
    tableView.isHidden = true
    accountOwnerHeader.isHidden = true
    nonAccountOwnerHeader.isHidden = false
    shopButton.isHidden = false
  }

  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.placesArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "ArcusSelectionCell"

    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusSelectOptionTableViewCell

    let place = self.placesArray[indexPath.row]
    cell?.isUserInteractionEnabled = false
    cell?.titleLabel.text = PlaceCapability.getNameFrom(place)

    cell?.backgroundColor = UIColor.clear

    let address = place.getAddressForPlace()

    let servicePlan = AnyServiceLevelable.getServiceLevelDescription(place)

    var hasCellularBackup = false

    if let addons = PlaceCapability.getServiceAddons(from: place) {
      hasCellularBackup = addons.contains(where: { ($0 as? String) == "CELLBACKUP" })
    }

    var cellBackupText = ""
    if hasCellularBackup {
      cellBackupText = "Backup Cellular"
    }
    if address.count > 0 {
      cell?.descriptionLabel.text = address
        + "\n"
        + servicePlan
        + "\n"
        + cellBackupText
    } else {
      cell?.descriptionLabel.text = servicePlan
        + "\n"
        + cellBackupText
    }
    cell?.detailImage.clipsToBounds = true
    cell?.detailImage.layer.cornerRadius = cell!.detailImage.bounds.size.width / 2
    cell?.detailImage.image =
      RxCornea.shared.settings?.fetchHomeImage(place.modelId)

    return cell!
  }

  func handleTap() {
    if let usersAccountModel = usersAccountModel {
      let vc: BillingViewController = BillingViewController.createInEditMode(withAccount: usersAccountModel)
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  // MARK: IBActions
  @IBAction func shopButtonTapped(_ sender: AnyObject) {
    if let shopURL = URL(string:"") {
      UIApplication.shared.openURL(shopURL)
    }
  }
}
