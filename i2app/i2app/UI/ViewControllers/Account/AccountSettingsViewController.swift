//
//  AccountSettingsViewController.swift
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
import PromiseKit
import CocoaLumberjack

class AccountSettingsViewController: UIViewController {
  @IBOutlet var photoButton: ArcusButton!
  @IBOutlet var profileImage: ArcusBorderedImageView!
  @IBOutlet var nameLabel: ArcusLabel!
  @IBOutlet var accountTableView: UITableView!

  //This screen does not fetch these place and role models, they're passed in by the previous VC
  var placesOwnedByUser: [PlaceAndRoleModel]?
  var placesUserIsGuest: [PlaceAndRoleModel]?

  var currentPerson: PersonModel? = RxCornea.shared.settings?.currentPerson
  var personImageName: String = ""

  var accountInfoTitles: [String] = [NSLocalizedString("Contact Information", comment: ""),
                                     NSLocalizedString("Security Questions", comment: ""),
                                     NSLocalizedString("Pin Code", comment: ""),
                                     AuthProtocols.current.title,
                                     NSLocalizedString("Push Notifications", comment: ""),
                                     NSLocalizedString("Marketing", comment: ""),
                                     NSLocalizedString("Terms of Use", comment: ""),
                                     NSLocalizedString("Delete My Arcus Account", comment: "")]

  fileprivate let contactInfoSegueIdentifier = "SettingsAccountContactInfoSegue"
  fileprivate let securityQuestionsSegueIdentifier = "SettingsAccountSecurityQuestionsSegue"
  fileprivate let deleteAccountSegueIdentifier = "SettingsAccountDeleteAccountSegue"
  fileprivate let deleteGuestPersonSegueIdentifier = "SettingsAccountDeleteGuestPersonSegue"
  fileprivate let pinCodeSegueIdentifier = "SettingsAccountPinCodePlacePickerSegue"
  fileprivate let touchIDSegueIdentifier = "SettingsAccountTouchIDSegue"

  //This is only fetched and set if the user is an account owner and taps to delete their account
  var accountModelOwnedByThisUser: AccountModel?

  // MARK: - View LifeCycle
  class func create() -> AccountSettingsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "AccountSettings", bundle:nil)
    let viewController: AccountSettingsViewController? =
      storyboard.instantiateInitialViewController() as? AccountSettingsViewController

    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    accountTableView.backgroundColor = UIColor.clear
    accountTableView.backgroundView = nil

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    navBar(withBackButtonAndTitle: self.navigationItem.title)

    configureLabelText()

    configurePersonImage()
  }

  // MARK: - UI Configuration
  func updateBackgroundImage(_ imageName: String, forImageView imageView: ArcusBorderedImageView) {
    view.renderLogoAndBackground(withImageNamed: imageName, forLogoControl: imageView)
    navigationController!.view.backgroundColor = self.view.backgroundColor
    view.setNeedsLayout()
    navigationController!.view.setNeedsLayout()
  }

  func configurePersonImage() {
    let personImage: UIImage? = ImagePicker.loadImage(self.currentPerson!.modelId as String!,
                                                      for: self.photoButton.imageView)
    if personImage != nil {
      self.profileImage.borderedModeEnabled = true
      self.profileImage.image = personImage
      self.updateBackgroundImage(self.currentPerson!.modelId as String, forImageView: self.profileImage)
    } else {
      self.profileImage.borderedModeEnabled = false
    }
  }

  func configureLabelText() {
    if let nameString: String? = self.currentPerson?.fullName {
      self.nameLabel.text = nameString
    }
  }

  @IBAction func photoButtonPressed(_ sender: ArcusButton) {
    ImagePicker.sharedInstance()
      .present(self,
               withImageId: "tempId",
               withCompletionBlock: { (image: UIImage?) -> Void in
                guard let accountImage: UIImage = image else {
                  DDLogInfo("Image selection has been canceled.")
                  return
                }

                if accountImage.isKind(of: UIImage.self) {
                  if let modelId = RxCornea.shared.settings?.currentPerson?.modelId {
                    ImagePicker.save(accountImage,
                                     imageName: modelId)
                  }

                  self.profileImage.borderedModeEnabled = true
                  self.profileImage.image = accountImage
                  self.updateBackgroundImage(self.currentPerson!.modelId as String,
                                             forImageView: self.profileImage)
                } else {
                  self.profileImage.borderedModeEnabled = false
                }
      })
  }

  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.accountInfoTitles.count
  }

  func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "AccountCell"
    let cell: ArcusTitleDetailTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusTitleDetailTableViewCell

    cell?.backgroundColor = UIColor.clear

    cell?.titleLabel.text = self.accountInfoTitles[indexPath.row]

    return cell!
  }

  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    var segueName: String? = nil

    switch indexPath.row {
    case 0:
      segueName = contactInfoSegueIdentifier
      break
    case 1:
      segueName = securityQuestionsSegueIdentifier
      break
    case 2:
      segueName = pinCodeSegueIdentifier
      break
    case 3:
      segueName = touchIDSegueIdentifier
      break
    case 4:
      segueName = "SettingsAccountPushNotificationsSegue"
      break
    case 5:
      segueName = "SettingsAccountMarketingSegue"
      break
    case 6:
      segueName = "SettingsAccountLegalMainSegue"
      break
    case 7:
      //They're an account owner if this array is nonempty
      if let placesOwnedByUser = placesOwnedByUser, placesOwnedByUser.count > 0 {
        if accountModelOwnedByThisUser == nil {
          createGif()
          DispatchQueue.global(qos: .background).async {
            let anyOwnedPlaceRole = placesOwnedByUser[0]
            let placeModel = PlaceModel
              .createPlaceModelContainingAddressForModelId(anyOwnedPlaceRole.placeId)
            _ = placeModel?.refresh().swiftThen { (_) -> (PMKPromise?) in
              if let place = RxCornea.shared.modelCache?.fetchModel(placeModel!.address) as? PlaceModel {
                self.hideGif()
                self.accountModelOwnedByThisUser = AccountModel
                  .createAccountModelContainingAddressForModelId(PlaceCapability
                    .getAccountFrom(place))
                self.performSegue(withIdentifier: self.deleteAccountSegueIdentifier, sender: self)
              }
              return nil
            }
          }
        } else {
          segueName = deleteAccountSegueIdentifier
        }
      } else {
        segueName = deleteGuestPersonSegueIdentifier
      }
      break
    default:
      break
    }

    if segueName != nil {
      self.performSegue(withIdentifier: segueName!, sender: self)
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      if let vc = segue.destination
        as? SecurityQuestionsViewController, identifier == securityQuestionsSegueIdentifier {
        vc.viewMode = .ViewModeSettingsChange
      } else if let vc = segue.destination
        as? ContactInfoViewController, identifier == contactInfoSegueIdentifier {
        vc.currentPerson = self.currentPerson
      } else if let vc = segue.destination
        as? DeleteAccountViewController, identifier == deleteAccountSegueIdentifier {
        vc.accountModelToDelete = accountModelOwnedByThisUser
      } else if let vc = segue.destination
        as? DeleteGuestPersonViewController, identifier == deleteGuestPersonSegueIdentifier {
        vc.guestPersonToDelete = RxCornea.shared.settings?.currentPerson
      }
    }
  }
}
