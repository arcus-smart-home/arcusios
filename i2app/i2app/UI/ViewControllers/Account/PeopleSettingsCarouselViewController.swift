//
//  PeopleSettingsCarouselViewController.swift
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
import PromiseKit
import CocoaLumberjack

struct PeopleSettingsTableViewContstants {
  static let kHobbitOptions: [String] = [NSLocalizedString("Contact Information", comment: ""),
                                         NSLocalizedString("Change PIN", comment: "")]

  static let kCloneOptions: [String] = [NSLocalizedString("Permissions", comment: "")]

  static let kPendingOptions: [String] = [NSLocalizedString("Permissions", comment: "")]

  static let kOwnerOptions: [String] = []

  static let kHobbitActions: [String] = ["ContactInformation",
                                         "PersonChangePinSegue"]

  static let kCloneActions: [String] = ["FullAccessAlert"]

  static let kPendingActions: [String] = ["FullAccessAlert"]

  static let kOwnerActions: [String] = []

  static func optionsForAccessType(_ type: PlaceAccessType) -> [String] {
    var result: [String] = []
    switch type {
    case .unknown:
      break
    case .hobbit:
      result = PeopleSettingsTableViewContstants.kHobbitOptions
      break
    case .fullAccess:
      result = PeopleSettingsTableViewContstants.kCloneOptions
      break
    case .owner:
      result = PeopleSettingsTableViewContstants.kOwnerOptions
      break
    case .pending:
      result = PeopleSettingsTableViewContstants.kPendingOptions
      break
    }
    return result
  }

  static func actionForIndexPath(_ indexPath: IndexPath, accessType: PlaceAccessType) -> String? {
    var result: String?
    var actions: [String] = []
    switch accessType {
    case .unknown:
      break
    case .hobbit:
      actions = PeopleSettingsTableViewContstants.kHobbitActions
      break
    case .fullAccess:
      actions = PeopleSettingsTableViewContstants.kCloneActions
      break
    case .owner:
      actions = PeopleSettingsTableViewContstants.kOwnerActions
      break
    case .pending:
      actions = PeopleSettingsTableViewContstants.kPendingActions
      break
    }

    if indexPath.row < actions.count {
      result = actions[indexPath.row]
    }

    return result
  }
}

class PeopleSettingsCarouselViewController: UIViewController,
  PersonListPresenterDelegate,
  ArcusCarouselDataSource,
  ArcusCarouselDelegate,
  UITableViewDataSource,
  UITableViewDelegate,
  RemovePersonAlertDelegate,
PeopleSettingsCarouselViewCellDelegate {

  @IBOutlet var carouselView: ArcusCarouselView!
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var removeButton: ArcusButton!
  @IBOutlet weak var cancelInvitationAlertView: RemovePersonAlertView! {
    didSet {
      cancelInvitationAlertView.delegate = self
    }
  }
  @IBOutlet weak var cancelInvitationBottomConstraint: NSLayoutConstraint!

  internal var personPresenter: PersonListPresenter? {
    didSet {
      self.personPresenter?.delegate = self
      if let placeName = self.personPresenter?.currentPlace?.name {
        self.navBar(withBackButtonAndTitle: placeName)
      }
    }
  }

  var selectedIndex: Int {
    return (self.personPresenter?.selectedIndex())!
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.backgroundColor = UIColor.clear
    self.tableView.backgroundView = nil
    self.cancelInvitationAlertView.isHidden = true

    if let placeName = self.personPresenter?.currentPlace?.name {
      self.navBar(withBackButtonAndTitle: placeName)
    }

    self.setBackgroundColorToDashboardColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    personPresenter?.removeObserverOfPersonAddRemovedEvents()
    personPresenter?.observePersonAddedRemovedEvents()
    personPresenter?.fetchPeopleList()

    self.createGif()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    personPresenter?.removeObserverOfPersonAddRemovedEvents()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    self.carouselView.decelerationRate = UIScrollViewDecelerationRateFast
    self.carouselView.contentInset = UIEdgeInsets(top: 0,
                                                  left: (self.carouselView.frame.size.width - 230) / 2,
                                                  bottom: 0,
                                                  right: (self.carouselView.frame.size.width - 230) / 2)
  }

  // MARK: UI Configuration
  func configureBackground() {
    let dummyImage: ArcusBorderedImageView = ArcusBorderedImageView()
    if let personViewModel = self.personPresenter?.currentPerson {
      if personViewModel.image != nil {
        self.updateBackgroundImage(personViewModel.modelId!,
                                   forImageView:dummyImage)
      } else {
        self.updateBackgroundImage((self.personPresenter?.currentPlace!.modelId)! as String,
                                   forImageView:dummyImage)
      }
    } else {
      self.updateBackgroundImage((self.personPresenter?.currentPlace!.modelId)! as String,
                                 forImageView:dummyImage)
    }
  }

  func updateBackgroundImage(_ imageName: String,
                             forImageView imageView: ArcusBorderedImageView) {
    UIView.animate(withDuration: 0.5,
                   delay: 0.0,
                   options: UIViewAnimationOptions.transitionCrossDissolve,
                   animations: {
                    self.view.renderLogoAndBackground(withImageNamed: imageName, forLogoControl: imageView)
                    self.navigationController?.view.backgroundColor = self.view.backgroundColor
                    self.view.setNeedsLayout()
                    self.navigationController?.view.setNeedsLayout()
    }) { (_: Bool) in

    }
  }

  func updateRemoveButtonForPerson(_ personVM: PersonViewModel) {
    switch personVM.accessType {
    case .fullAccess:
      fallthrough
    case .hobbit:
      removeButton.isHidden = false
      removeButton.setTitle(NSLocalizedString("Remove Person", comment: ""), for: UIControlState())
      break
    case .pending:
      removeButton.isHidden = false
      removeButton.setTitle(NSLocalizedString("Cancel Invitation", comment: ""), for: UIControlState())
      break
    default:
      removeButton.isHidden = true
    }
  }

  // MARK: PersonListPresenterDelegate
  func didReceivePersonList(_ placeList: [PersonViewModel], presenter: PersonListPresenter) {
    if placeList.count == 0 {
      _ = navigationController?.popToRootViewController(animated: true)
      return
    }

    self.carouselView.reloadData()
    self.tableView.reloadData()
    if let currentPerson = self.personPresenter?.currentPerson {
      updateRemoveButtonForPerson(currentPerson)
    }
    self.hideGif()

    if self.selectedIndex >= 0 {
      self.carouselView.configureCarouselForIndex(self.selectedIndex)
      self.configureBackground()
    }
  }

  func didSetCurrentPerson(_ person: PersonViewModel, presenter: PersonListPresenter) {

  }

  func shouldAllowPersonInList(_ person: PersonViewModel, presenter: PersonListPresenter) -> Bool {
    if let personId = person.modelId,
      let currentPersonId = RxCornea.shared.settings?.currentPerson?.modelId,
      currentPersonId == personId {
      return false
    }
    return true
  }

  // MARK: PeopleSettingsCarouselViewCellDelegate
  func changeImageButtonPressed(_ button: UIButton, cell: PeopleSettingsCarouselViewCell) {
    let personViewModel = self.personPresenter?.currentPerson

    if personViewModel?.accessType != .pending {
      ImagePicker.sharedInstance().present(self,
                                           withImageId: "tempId",
                                           withCompletionBlock: {
                                            (image: UIImage?) -> Void in
                                            guard let personImage: UIImage = image else {
                                              return
                                            }

                                            if personImage.isKind(of: UIImage.self) {
                                              personViewModel!.image = personImage
                                              ImagePicker.save(personViewModel!.image,
                                                               imageName: personViewModel!.modelId)

                                              cell.personImageView
                                                .borderedModeEnabled = true
                                              cell.personImageView.image = personImage
                                              cell.layoutIfNeeded()

                                              self.configureBackground()
                                            }
      })
    }
  }

  // MARK: ArcusCarouselViewDataSource
  func carouselView(_ carouselView: ArcusCarouselView, numberOfItemsInSection section: Int) -> Int {
    return self.personPresenter!.personList.count
  }

  func carouselView(_ carouselView: ArcusCarouselView,
                    cellForIndexPath indexPath: IndexPath,
                    itemAtIndexPath dataIndexPath: IndexPath) -> UICollectionViewCell {
    let cell: PeopleSettingsCarouselViewCell? =
      carouselView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        as? PeopleSettingsCarouselViewCell

    let personViewModel = self.personPresenter?.personList[dataIndexPath.row]

    cell?.delegate = self
    cell?.nameLabel.text = personViewModel?.fullName
    cell?.tag = (personViewModel?.accessType.rawValue)!

    if personViewModel?.accessType == PlaceAccessType.pending {
      cell?.descriptionLabel.text = personViewModel?.invitationDateDescription()
      cell?.cameraIcon.isHidden = true
    } else {
      cell?.descriptionLabel.text = personViewModel?.phoneEmailDescription()
      cell?.cameraIcon.isHidden = false
    }

    if personViewModel?.image != nil {
      cell?.personImageView.image = personViewModel?.image
      cell?.personImageView.borderedModeEnabled = true
    } else {
      cell?.personImageView.image = UIImage(named: "account_user_white")
      cell?.personImageView.borderedModeEnabled = false
    }

    return cell!
  }

  func carouselView(_ carouselView: ArcusCarouselView,
                    didEndOnIndexPath indexPath: IndexPath,
                    dataIndexPath: IndexPath) {
    self.personPresenter?.setCurrentPersonFromIndex(dataIndexPath.row)

    if let currentPerson = self.personPresenter?.currentPerson {
      updateRemoveButtonForPerson(currentPerson)
    }
    hideCancelInvitationAlertView()
    self.tableView.reloadData()
    self.configureBackground()
  }

  // MARK: ArcusCarouselViewDelegate
  func carouselView(_ carouselView: ArcusCarouselView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    if ObjCMacroAdapter.isPhone5() {
      return CGSize(width: 200, height: 290)
    } else {
      return CGSize(width: 230, height: 320)
    }
  }

  func carouselView(_ carouselView: ArcusCarouselView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }

  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let personViewModel: PersonViewModel? = self.personPresenter?.currentPerson

    let optionsArray: [String]? =
      PeopleSettingsTableViewContstants.optionsForAccessType(personViewModel!.accessType)

    return optionsArray!.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
      as? ArcusTitleDetailTableViewCell else {
        return UITableViewCell()
    }

    if let personViewModel = self.personPresenter?.currentPerson {
      let optionsArray: [String] =
        PeopleSettingsTableViewContstants.optionsForAccessType(personViewModel.accessType)

      cell.titleLabel.text = optionsArray[indexPath.row]
      cell.backgroundColor = UIColor.clear

      if optionsArray[indexPath.row] == "Permissions" {
        if personViewModel.accessType == PlaceAccessType.fullAccess {
          cell.descriptionLabel.text = NSLocalizedString("Full Access", comment: "")
        } else if personViewModel.accessType == PlaceAccessType.pending {
          cell.descriptionLabel.text = NSLocalizedString("Full Access", comment: "")
        } else {
          cell.descriptionLabel.text = ""
        }
      } else {
        cell.descriptionLabel.text = ""
      }
    }

    return cell
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let personViewModel = self.personPresenter?.currentPerson
    if let action = PeopleSettingsTableViewContstants
      .actionForIndexPath(indexPath,
                          accessType: personViewModel!.accessType) {

      if action.contains("Segue") == true {
        self.performSegue(withIdentifier: action, sender: self)
      } else {
        if action == "ContactInformation" {
          self.loadContactInfoView()
        } else if action == "FullAccessAlert" {
          self.showFullAccessAlert()
        } else if action == "CancelInvitation" {
          self.cancelInvitation()
        }
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: Actions
  func loadContactInfoView() {
    let personViewModel = self.personPresenter?.currentPerson

    let contactInfoViewController = ContactInfoViewController.create()
    contactInfoViewController.currentPerson = personViewModel?.personModel
    contactInfoViewController.accessType = personViewModel?.accessType
    self.navigationController?.pushViewController(contactInfoViewController,
                                                  animated: true)
  }

  func showFullAccessAlert() {
    self.popupMessageWindow(NSLocalizedString("Full Access", comment: ""),
                            subtitle:
      NSLocalizedString("People with Full Access manage \ntheir own Profile information", comment: ""))
  }

  func cancelInvitation() {
    let person = self.personPresenter?.currentPerson
    self.personPresenter?.deleteInvitation(person!)
  }

  func removePersonAccess() {
    slideOutTwoButtonAlert()
    if let person = personPresenter?.currentPerson,
      let place = personPresenter?.currentPlace,
      let createdPerson = PersonModel.createPersonModelContainingAddressForModelId(person.modelId!),
      person.modelId != nil {
      DispatchQueue.global(qos: .background).async {
        _ = PersonCapability
          .removeFromPlace(withPlaceId: place.modelId, on: createdPerson)
          .swiftThen({ (_) -> (PMKPromise?) in
            self.personPresenter?.fetchPeopleList()
            return nil
          })
      }
    }

  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PersonChangePinSegue" {
      if let pinCodeViewController: PersonChangePinViewController =
        segue.destination as? PersonChangePinViewController {
        let personViewModel = self.personPresenter?.currentPerson

        pinCodeViewController.currentPlace = self.personPresenter?.currentPlace
        if let modelId = personViewModel?.modelId {
          pinCodeViewController.currentPersonId = modelId
        }
      }
    }
  }

  // MARK: IBAction
  @IBAction func removeButtonTapped(_ sender: AnyObject) {
    let currPerson = (personPresenter?.currentPerson)!
    switch currPerson.accessType {
    case .fullAccess:
      fallthrough
    case .hobbit:
      let localSub = NSLocalizedString("Removing this person means they will no longer have access to %@.",
                                       comment: "")
      var subtitle = "this place"
      if let name = personPresenter?.currentPlace?.name {
        let title = String(format: localSub, name)
        subtitle = title
      }
      displayMessage(NSLocalizedString("Are You Sure?", comment: ""),
                     subtitle: subtitle,
                     backgroundColor: UIColor.white,
                     buttonOne: NSLocalizedString("Remove", comment: "Cancel"),
                     buttonTwo: NSLocalizedString("Cancel", comment: ""),
                     buttoneOneStyle: FontDataTypeButtonPink,
                     buttonTwoStyle: FontDataTypeButtonDark,
                     withTarget: self,
                     withButtonOneSelector: #selector(removePersonAccess),
                     andButtonTwoSelector: #selector(slideOutTwoButtonAlert))
    case .pending:
      showCancelInvitationAlertView()
    default:
      break
    }
  }

  // MARK: Show/hide cancel invitation
  func showCancelInvitationAlertView() {
    cancelInvitationAlertView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: {
      self.cancelInvitationBottomConstraint.constant = 0
      self.cancelInvitationAlertView.layoutIfNeeded()
      self.view.layoutIfNeeded()
    })
  }

  func hideCancelInvitationAlertView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.cancelInvitationBottomConstraint.constant = -self.cancelInvitationAlertView.frame.size.height
      self.cancelInvitationAlertView.layoutIfNeeded()
      self.view.layoutIfNeeded()
    }) { _ in
      self.cancelInvitationAlertView.isHidden = true
    }
  }

  // MARK: RemovePersonAlertDelegate for cancel invitation popup
  func confirmButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView) {
    cancelInvitation()
    hideCancelInvitationAlertView()
  }

  func cancelButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView) {
    hideCancelInvitationAlertView()
  }

  func closeButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView) {
    hideCancelInvitationAlertView()
  }
}
