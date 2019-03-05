//
//  PlaceDetailViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/9/16.
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
import CocoaLumberjack

class PlaceDetailViewController: UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  PlaceEditor,
ProMonitoringSettingsController {

  enum PlaceSettingMenuItem {
    case placeInfo
    case proMonitoring
  }

  var proMonitoringSettingsModel: ProMonitoringSettingsModel?
  var emptyProMonitoringSettingsModel: ProMonitoringSettingsModel?
  var settingsProvider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

  @IBOutlet var photoButton: ArcusButton!
  @IBOutlet var placeImage: ArcusBorderedImageView!
  @IBOutlet var placeNameLabel: ArcusLabel!
  @IBOutlet var placeLocationLabel: ArcusLabel!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var placeInfoSeparator: UIView!
  @IBOutlet var removeButton: ArcusButton!

  internal var currentPlaceAndRole: PlaceAndRoleModel?
  internal var currentPlace: PlaceModel?
  internal var numberOfOwnedPlaces: Int?
  internal var numberOfGuestPlaces: Int?

  fileprivate var menuItems: [PlaceSettingMenuItem] = []
  fileprivate let editPlaceInfoSegueIdentifier = "EditPlaceInfoSegue"
  fileprivate let deletePlaceSegueIdentifier = "DeletePlaceSegue"
  fileprivate let removePlaceAccessSegueIdentifier = "RemoveAccessSegue"
  fileprivate let editProMonPlaceInfoSequeIdentifier = "EditProMonPlaceInfo"

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    oneTimeUIConfig()
    configureLabels()

    configureProMonSettings()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    //We need to keep the currentPlace object up to date as we do not get model update notifications
    //for this; it may not be our signed-in place
    if let currentPlaceAndRole = currentPlaceAndRole {
      if currentPlace == nil {
        currentPlace = PlaceModel.createPlaceModelContainingAddressForModelId(currentPlaceAndRole.placeId)
      }

      _ =  self.currentPlace?.refresh().swiftThen { _ in
        if let address = self.currentPlace?.address {
          self.currentPlace = RxCornea.shared.modelCache?.fetchModel(address) as? PlaceModel
        }

        self.hideGif()
        self.configureLabels()
        return nil
      }
    }

    configureProMonSettings()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      if let vc = segue.destination as? EditPlaceInfoViewController,
        identifier == editPlaceInfoSegueIdentifier {
        if let placeAndRole = currentPlaceAndRole {
          currentPlace = PlaceModel.createPlaceModelContainingAddressForModelId(placeAndRole.placeId)
        }

        currentPlace?.refresh().swiftThen({ [weak vc] result in
          guard let result = result as? BaseGetAttributesResponse else { return nil }
          vc?.currentPlace = PlaceModel(attributes: result.attributes)
          vc?.refreshAndConfigure()
          return nil
        })

        // Set anyway, to prevent possible crash if refresh is delayed.
        vc.currentPlace = self.currentPlace
      } else if let vc = segue.destination as? DeletePlaceViewController,
        identifier == deletePlaceSegueIdentifier {
        if let currentPlaceAndRole = currentPlaceAndRole {
          vc.placeIdToDelete = currentPlaceAndRole.placeId
          vc.nameOfPlaceToDelete = currentPlaceAndRole.placeName
        }
      } else if let vc = segue.destination as? RemovePlaceAccessViewController,
        identifier == removePlaceAccessSegueIdentifier {
        if let currentPlaceAndRole = currentPlaceAndRole {
          vc.placeIdToRemoveAccessTo = currentPlaceAndRole.placeId
          vc.placeName = currentPlaceAndRole.placeName
        }
      } else if let vc = segue.destination as? PlaceProMonSettingsViewController,
        identifier == editProMonPlaceInfoSequeIdentifier {
        if let currentPlaceAndRole = currentPlaceAndRole {
          vc.placeId = currentPlaceAndRole.placeId
          vc.isOwned = currentPlaceAndRole.role == PlaceAndRoleModel.ownerString
        }
      }
    }
  }

  // MARK: ProMonSettings

  func configureProMonSettings() {
    let address = ProMonitoringSettingsModel.addressForId(currentPlaceAndRole!.placeId)
    if let model = RxCornea.shared.modelCache?.fetchModel(address) as? ProMonitoringSettingsModel {
      // Check activation date on ProMon object to see if this place is professionally monitored
      if let _ = ProMonitoringSettingsCapability.getActivatedOn(from: model) {
        self.proMonitoringSettingsModel = model
        self.tableView.reloadData()
      }
    } else {
      emptyProMonitoringSettingsModel =
        ProMonitoringSettingsModel(attributes: [kAttrAddress: address as AnyObject])

      // Attempt to load the pro mon settings object, and if succeed, reload the table to review extra settings

      _ = emptyProMonitoringSettingsModel?.refresh().swiftThen { [address] _ in
        if let settings = RxCornea.shared.modelCache?.fetchModel(address) as? ProMonitoringSettingsModel {
          // Check activation date on ProMon object to see if this place is professionally monitored
          if let _ = ProMonitoringSettingsCapability.getActivatedOn(from: settings) {
            self.proMonitoringSettingsModel = settings
            self.tableView.reloadData()
          }
        }
        return nil
      }
    }
  }

  // MARK: UI Configuration
  func oneTimeUIConfig() {
    tableView.backgroundColor = UIColor.clear
    tableView.backgroundView = nil

    configurePlaceImage()
    addDarkOverlay(BackgroupOverlayLightLevel)

    navBar(withBackButtonAndTitle: self.navigationItem.title)

    if let currentPlaceAndRole = currentPlaceAndRole,
      currentPlaceAndRole.role == PlaceAndRoleModel.ownerString {
      removeButton.setTitle(NSLocalizedString("Remove Place", comment: ""), for: UIControlState())
    } else {
      removeButton.setTitle(NSLocalizedString("Remove Access", comment: ""), for: UIControlState())
      placeInfoSeparator.isHidden = true
    }
  }

  func updateBackgroundImage(_ image: UIImage, forImageView imageView: ArcusBorderedImageView) {
    view.renderLogoAndBackground(with: image, forLogoControl: imageView)
    navigationController!.view.backgroundColor = self.view.backgroundColor
    view.setNeedsLayout()
    navigationController!.view.setNeedsLayout()
  }

  func configurePlaceImage() {
    if let currentPlaceAndRole = currentPlaceAndRole {
      let thePlaceImage = RxCornea.shared.settings?.fetchHomeImage(currentPlaceAndRole.placeId)
      placeImage.borderedModeEnabled = true
      placeImage.image = thePlaceImage
      updateBackgroundImage(thePlaceImage!, forImageView: self.placeImage)
    }
  }

  func configureLabels() {
    if let currentPlace = currentPlace {
      self.setNavBarTitle(PlaceCapability.getNameFrom(currentPlace))
      placeLocationLabel.text = currentPlace.locationString()
      placeNameLabel.text = PlaceCapability.getNameFrom(currentPlace)
    } else {
      self.setNavBarTitle(currentPlaceAndRole?.placeName)
      placeLocationLabel.text = currentPlaceAndRole?.placeLocation()
      placeNameLabel.text = currentPlaceAndRole?.placeName
    }

  }

  // MARK: UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    menuItems = []

    if shouldDisplayPlaceInfoSettings() {
      menuItems.append(PlaceSettingMenuItem.placeInfo)
    }

    if shouldDisplayProMonitoringSetting() {
      menuItems.append(PlaceSettingMenuItem.proMonitoring)
    }

    return menuItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "EditPlaceInfoCell"
    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusSelectOptionTableViewCell

    switch menuItems[indexPath.row] {
    case .placeInfo:
      cell?.titleLabel.text = "Place Info"
      cell?.descriptionLabel.text = "Edit Address, Time Zone, and More"
      break
    case .proMonitoring:
      cell?.titleLabel.text = "Professional Monitoring"
      cell?.descriptionLabel.text = "Edit your professional monitoring information"
      break
    }

    return cell!
  }

  func shouldDisplayProMonitoringSetting() -> Bool {
    if let currentPlaceAndRole = currentPlaceAndRole,
      currentPlaceAndRole.role == PlaceAndRoleModel.ownerString
        || currentPlaceAndRole.role == PlaceAndRoleModel.guestString {
      return proMonitoringSettingsModel != nil
    }

    return false
  }

  func shouldDisplayPlaceInfoSettings() -> Bool {
    return currentPlaceAndRole?.role == PlaceAndRoleModel.ownerString
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    switch menuItems[indexPath.row] {
    case .placeInfo:
      performSegue(withIdentifier: editPlaceInfoSegueIdentifier, sender: self)
      break
    case .proMonitoring:
      performSegue(withIdentifier: editProMonPlaceInfoSequeIdentifier, sender: self)
      break
    }
  }

  // MARK: IBActions
  @IBAction func photoButtonPressed(_ sender: ArcusButton) {
    ImagePicker.sharedInstance()
      .present(self,
               withImageId: "tempId",
               withCompletionBlock: {
                (image: UIImage?) -> Void in
                guard let placeImage = image else {
                  DDLogInfo("Image selection has been canceled.")
                  return
                }

                if placeImage.isKind(of: UIImage.self) {
                  if let settings = RxCornea.shared.settings,
                    let placeId = self.currentPlaceAndRole?.placeId {
                    settings.saveHomeImage(placeImage, placeId: placeId)
                  }

                  self.placeImage.borderedModeEnabled = true
                  self.placeImage.image = placeImage
                  self.updateBackgroundImage(placeImage, forImageView: self.placeImage)

                  if let navController = self.navigationController {
                    for vc in navController.viewControllers {
                      vc.setBackgroundColorToDashboardColor()
                    }
                  }
                } else {
                  self.placeImage.borderedModeEnabled = false
                }
      })
  }

  @IBAction func removeButtonPressed(_ sender: AnyObject) {
    if let currentPlaceAndRole = currentPlaceAndRole,
      let numberOfOwnedPlaces = numberOfOwnedPlaces,
      let numberOfGuestPlaces = numberOfGuestPlaces {
      if currentPlaceAndRole.primary {//If this is their primary place we show a specific message
        let subtitle = String(format: NSLocalizedString("%@ cannot be removed. To ensure you are not being "
          + ""
          + "delete your entire Arcus account, go to Settings > Profile > Delete My Arcus Account.",
                                                        comment: ""),
                              currentPlaceAndRole.placeName)

        popupMessageWindow("Cannot Remove Place",
                           subtitle: subtitle)
        //Since not primary and they only have one place, this clone is trying to remove their last access
      } else if (numberOfOwnedPlaces + numberOfGuestPlaces) == 1 {
        let subtitle = "Access to your last place cannot be removed. To delete your Arcus account, "
          + "go to\nSettings > Profile > Delete My Arcus Account."

        popupMessageWindow("Cannot Remove Access",
                           subtitle: subtitle)
        //Users cannot remove the place their session is active in
      } else if let settings = RxCornea.shared.settings,
        let currentPlaceId = settings.currentPlace?.modelId,
        currentPlaceId == currentPlaceAndRole.placeId {
        let subtitle = "You are currently viewing this place. To remove, first switch to a different place, "
          + "then return here to remove."

        popupMessageWindow("Switch Places",
                           subtitle: subtitle)
      } else {
        if currentPlaceAndRole.role == PlaceAndRoleModel.ownerString {
          performSegue(withIdentifier: deletePlaceSegueIdentifier, sender: self)
        } else {
          performSegue(withIdentifier: removePlaceAccessSegueIdentifier, sender: self)
        }
      }
    }
  }
}
