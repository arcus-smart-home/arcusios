//
//  PlacePeopleListViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/27/16.
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
import Cornea

private struct PlacePeopleListDataModel {
  let mainText: String
  let descriptionText: String?
  let image: UIImage?
  let type: PlacePeopleCellType
  let associatedPlaceAndRole: PlaceAndRoleModel
  let personVM: PersonViewModel?
}

private enum PlacePeopleCellType {
  case place
  case person
  case invitee
}

private enum PlacePeopleListSection {
  case accountOwner
  case guest
}

class PlacePeopleListViewController: UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  PersonListPresenterDelegate,
PlacesAndRolesWithPeopleListPresenterDelegate {

  @IBOutlet weak var tableView: UITableView!

  internal var placesOwnedByUser: [PlaceAndRoleModel]?
  internal var placesUserIsGuest: [PlaceAndRoleModel]?
  fileprivate var placeAndRoleWithPeoplePresenter: PlacesAndRolesWithPeopleListPresenter!

  fileprivate var ownedPlacePeopleCellData = [PlacePeopleListDataModel]()
  fileprivate var guestPlacePeopleCellData = [PlacePeopleListDataModel]()

  //Data used for segue
  fileprivate var selectedCell: PlacePeopleListDataModel?
  fileprivate var personPresenterToPassAlong: PersonListPresenter?

  fileprivate let headerFooterIdentifier = "headerFooter"
  fileprivate let placeCellIdentifier = "PlaceCell"
  fileprivate let personCellIdentifier = "PersonCell"
  fileprivate let inviteeCellIdentifier = "InviteeCell"
  fileprivate let peopleCarouselSegueIdentifier = "PeopleCarouselSegue"

  fileprivate let placeCellHeight: CGFloat = 90
  fileprivate let placeCellLeftInset: CGFloat = 75
  fileprivate let personCellHeight: CGFloat = 70
  fileprivate let personCellLeftInset: CGFloat = 135

  //Private queue for locking write access to the cell data arrays
  fileprivate let privateQueue = DispatchQueue(label: "", attributes: [])

  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    var placesOwned: [PlaceAndRoleModel] = []
    var placesGuest: [PlaceAndRoleModel] = []

    if let places = placesOwnedByUser {
      placesOwned = places
    }

    if let places = placesUserIsGuest {
      placesGuest = places
    }

    placeAndRoleWithPeoplePresenter =
      ConcretePlacesAndRolesWithPeopleListPresenter(owned: placesOwned,
                                                    guest: placesGuest)
    placeAndRoleWithPeoplePresenter.delegate = self
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    retrieveData()
  }

  func setupViews() {
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: navigationItem.title)

    tableView.register(UINib(nibName: "ArcusTwoLabelTableViewSectionHeader", bundle: nil),
                       forHeaderFooterViewReuseIdentifier: headerFooterIdentifier)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      if let carouselVC = segue.destination as? PeopleSettingsCarouselViewController,
        identifier == peopleCarouselSegueIdentifier {
        carouselVC.personPresenter = personPresenterToPassAlong
        selectedCell = nil
        personPresenterToPassAlong = nil
      }
    }
  }

  // MARK: UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections = 0

    if ownedPlacePeopleCellData.count > 0 {
      numberOfSections = (numberOfSections + 1)
    }

    if guestPlacePeopleCellData.count > 0 {
      numberOfSections = (numberOfSections + 1)
    }

    return numberOfSections
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionType = sectionTypeForSection(section)
    switch sectionType {
    case .accountOwner:
      return ownedPlacePeopleCellData.count
    case .guest:
      return guestPlacePeopleCellData.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dataModel = dataModelForIndexPath(indexPath)
    let cell: ArcusSelectOptionTableViewCell

    switch dataModel.type {
    case .place:
      guard let theCell = tableView.dequeueReusableCell(withIdentifier: placeCellIdentifier)
        as? ArcusSelectOptionTableViewCell else {
          return UITableViewCell()
      }
      cell = theCell
      cell.descriptionLabel.text = dataModel.descriptionText
      cell.separatorInset = UIEdgeInsets(top: 0, left: placeCellLeftInset, bottom: 0, right: 0)
      cell.selectionStyle = .none
      break
    case .person:
      guard let theCell = tableView.dequeueReusableCell(withIdentifier: personCellIdentifier)
        as? ArcusSelectOptionTableViewCell else {
          return UITableViewCell()
      }
      cell = theCell
      cell.separatorInset = UIEdgeInsets(top: 0, left: personCellLeftInset, bottom: 0, right: 0)
      cell.selectionStyle = .default
      break
    case .invitee:
      guard let theCell = tableView.dequeueReusableCell(withIdentifier: inviteeCellIdentifier)
        as? ArcusSelectOptionTableViewCell else {
          return UITableViewCell()
      }
      cell = theCell
      cell.descriptionLabel.text = dataModel.descriptionText
      cell.separatorInset = UIEdgeInsets(top: 0, left: personCellLeftInset, bottom: 0, right: 0)
      cell.selectionStyle = .default
      break
    }

    cell.detailImage.clipsToBounds = true
    cell.detailImage.tintColor = UIColor.white
    cell.detailImage.layer.cornerRadius = cell.detailImage.bounds.width/2
    cell.titleLabel.text = dataModel.mainText
    cell.detailImage.image = dataModel.image
    cell.backgroundColor = UIColor.clear

    return cell
  }

  fileprivate func dataModelForIndexPath(_ indexPath: IndexPath) -> PlacePeopleListDataModel {
    let sectionType = sectionTypeForSection(indexPath.section)
    switch sectionType {
    case .accountOwner:
      return ownedPlacePeopleCellData[indexPath.row]
    case .guest:
      return guestPlacePeopleCellData[indexPath.row]
    }
  }

  fileprivate func sectionTypeForSection(_ section: Int) -> PlacePeopleListSection {
    if section == 0 {
      if ownedPlacePeopleCellData.count > 0 {
        return .accountOwner
      }
      return .guest
    }
    return .guest
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterIdentifier)
      as? ArcusTwoLabelTableViewSectionHeader else {
        return nil
    }

    let sectionType = sectionTypeForSection(section)
    let sectionText: String
    switch sectionType {
    case .accountOwner:
      sectionText = NSLocalizedString("Account Owner", comment: "")
    default:
      sectionText = NSLocalizedString("Guest", comment: "")
    }

    headerCell.mainTextLabel.text = sectionText
    headerCell.accessoryTextLabel.text = nil
    headerCell.hasBlurEffect = true
    return headerCell
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let dataModel = dataModelForIndexPath(indexPath)
    let height: CGFloat

    switch dataModel.type {
    case .place:
      height = placeCellHeight
      break
    case .person:
      fallthrough
    case .invitee:
      height = personCellHeight
    }

    return height
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let dataModel = dataModelForIndexPath(indexPath)
    switch dataModel.type {
    case .person:
      fallthrough
    case .invitee:
      if dataModel.personVM != nil {
        createGif()
        selectedCell = dataModel
        if let place = PlaceModel.createPlaceModelFromPlaceAndRole(dataModel.associatedPlaceAndRole) {
          personPresenterToPassAlong = PersonListPresenter(place: place, delegate: self)

          //Start the fetch to setup the presenter that will be passed to the carousel
          personPresenterToPassAlong?.fetchPeopleList()
        }
      }
      break
    case .place:
      break
    }
  }

  // MARK: PersonListPresenterDelegate
  func didReceivePersonList(_ peopleList: [PersonViewModel], presenter: PersonListPresenter) {
    if let personToPresent = selectedCell?.personVM, presenter == personPresenterToPassAlong {
      for (index, person) in peopleList.enumerated() {
        if let personToPresentModelId = personToPresent.modelId,
          let personFromListModelId = person.modelId,
          personToPresentModelId == personFromListModelId {//Actual people so can be identified by modelId
          //We've obtained the correct person, so set them on presenter and move on
          presenter.setCurrentPersonFromIndex(index)
          break
        }
      }
      //If we didn't find the right person in the for loop above we'll just show a random person
      hideGif()
      performSegue(withIdentifier: peopleCarouselSegueIdentifier, sender: self)
    } else {
      //If there's no person in the selected cell we don't segue
      hideGif()
      personPresenterToPassAlong = nil
      selectedCell = nil
    }
  }

  func didSetCurrentPerson(_ person: PersonViewModel, presenter: PersonListPresenter) {
    //TODO: Implement? Doesn't seem necessary
  }

  func shouldAllowPersonInList(_ person: PersonViewModel, presenter: PersonListPresenter) -> Bool {
    if let personId = person.modelId,
      RxCornea.shared.settings?.currentPerson?.modelId == personId {
      return false
    }
    return true
  }

  // MARK: Data
  func retrieveData() {
    createGif()

    if let places = placesOwnedByUser {
      placeAndRoleWithPeoplePresenter.ownedPlaceAndRoles = places
    } else {
      placeAndRoleWithPeoplePresenter.ownedPlaceAndRoles = []
    }

    if let places = placesUserIsGuest {
      placeAndRoleWithPeoplePresenter.guestPlaceAndRoles = places
    } else {
      placeAndRoleWithPeoplePresenter.guestPlaceAndRoles = []
    }

    placeAndRoleWithPeoplePresenter.fetchList()
  }

  // MARK: PlacesAndRolesWithPeopleListPresenterDelegate
  func didReceivePlacesAndRolesWithPeople(_ ownedPlacesWithPeople: [PlaceAndRoleWithPeople],
                                          guestPlacesWithPeople: [PlaceAndRoleWithPeople]) {
    DispatchQueue.global(qos: .background).async {
      //Sort data and convert to models the VC can use
      let alphaSortPlaceWithPeople = {
        (isOrderedBefore: (PlaceAndRoleWithPeople, PlaceAndRoleWithPeople)) -> Bool in
        return isOrderedBefore.0.placeAndRole.placeName
          .caseInsensitiveCompare(isOrderedBefore.1.placeAndRole.placeName) == .orderedAscending
      }
      let sortedOwnedPlacesPlusPeople = ownedPlacesWithPeople.sorted(by: alphaSortPlaceWithPeople)
      let sortedGuestPlacesPlusPeople = guestPlacesWithPeople.sorted(by: alphaSortPlaceWithPeople)

      //Enter private queue for manipulating the cell data
      self.privateQueue.sync {
        self.ownedPlacePeopleCellData = []
        self.guestPlacePeopleCellData = []

        for placePlusPeople in sortedOwnedPlacesPlusPeople {
          let placeCellData = self.placePeopleListModelFromPlaceAndRoleModel(placePlusPeople.placeAndRole)
          self.ownedPlacePeopleCellData.append(placeCellData)
          for personVM in placePlusPeople.people {
            let personCellData = self
              .placePeopleListModelFromPersonViewModel(personVM,
                                                      associatedPlaceAndRole: placePlusPeople.placeAndRole)
            if let personId = personVM.modelId,
              let currentPersonId = RxCornea.shared.settings?.currentPerson?.modelId  {
              if personId != currentPersonId {
                self.ownedPlacePeopleCellData.append(personCellData)
              }
            } else {
              self.ownedPlacePeopleCellData.append(personCellData)
            }
          }
        }

        for placePlusPeople in sortedGuestPlacesPlusPeople {
          let placeCellData = self.placePeopleListModelFromPlaceAndRoleModel(placePlusPeople.placeAndRole)
          self.guestPlacePeopleCellData.append(placeCellData)
          for personVM in placePlusPeople.people {
            let personCellData = self
              .placePeopleListModelFromPersonViewModel(personVM,
                                                      associatedPlaceAndRole: placePlusPeople.placeAndRole)
            if let personId = personVM.modelId,
              let currentPersonId = RxCornea.shared.settings?.currentPerson?.modelId  {
              if personId != currentPersonId {
                self.guestPlacePeopleCellData.append(personCellData)
              }
            } else {
              self.guestPlacePeopleCellData.append(personCellData)
            }
          }
        }
      }

      DispatchQueue.main.async {
        self.hideGif()
        self.tableView.reloadData()
      }
    }
  }

  // MARK: Converting data
  // swiftlint:disable line_length
  fileprivate func placePeopleListModelFromPlaceAndRoleModel(_ placeAndRole: PlaceAndRoleModel) -> PlacePeopleListDataModel {
    let placeCellData = PlacePeopleListDataModel.init(mainText: placeAndRole.placeName,
                                                      descriptionText: placeAndRole.placeLocation(),
                                                      image: RxCornea.shared.settings?.fetchHomeImage(placeAndRole.placeId),
                                                      type: .place,
                                                      associatedPlaceAndRole: placeAndRole,
                                                      personVM: nil)
    return placeCellData
  }

  fileprivate func placePeopleListModelFromPersonViewModel(_ personVM: PersonViewModel,
                                                           associatedPlaceAndRole: PlaceAndRoleModel) -> PlacePeopleListDataModel {
    var mainText = ""
    if let text = personVM.fullName {
      mainText = text
    }
    var descriptionText: String? = nil
    var image = UIImage(named: "person_filled_white")
    if let personImage = personVM.image {
      image = personImage
    }
    let type: PlacePeopleCellType

    switch personVM.accessType {
    case .pending:
      type = .invitee
      descriptionText = personVM.invitationDateDescription()
    default:
      type = .person
    }

    let placePeopleListModel = PlacePeopleListDataModel.init(mainText: mainText,
                                                             descriptionText: descriptionText,
                                                             image: image,
                                                             type: type,
                                                             associatedPlaceAndRole: associatedPlaceAndRole,
                                                             personVM: personVM)
    return placePeopleListModel
  }
  // swiftlint:enable line_legnth
}
