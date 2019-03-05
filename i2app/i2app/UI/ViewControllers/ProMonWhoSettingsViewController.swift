//
//  ProMonWhoSettingsViewController.swift
//  i2app
//
//  Arcus Team on 2/15/17.
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
import UIKit
import Cornea

class ProMonWhoSettingsViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate,
ArcusModalSelectionDelegate,
ProMonWhoSettingsDelegate {
  internal var placeId: String = ""

  fileprivate let segueToAdults = "segueToAdults"
  fileprivate let segueToChildren = "segueToChildren"
  fileprivate let segueToPets = "segueToPets"

  fileprivate let adults = NSLocalizedString("ADULTS", comment: "")
  fileprivate let childrenString = NSLocalizedString("CHILDREN", comment: "")
  fileprivate let pets = NSLocalizedString("PETS", comment: "")

  fileprivate var presenter: ProMonWhoSettingsPresenter?
  fileprivate var adultsCount = 0
  fileprivate var childrenCount = 0
  fileprivate var petsCount = 0

  @IBOutlet weak var table: UITableView!

  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)

    table.dataSource = self
    table.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let presenter = ProMonWhoSettingsPresenter(delegate: self, placeId: self.placeId)
    _ = presenter.proMonitoringSettingsModel?.refresh()
    self.presenter = presenter
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let presenter = ProMonWhoSettingsPresenter(delegate: self, placeId: self.placeId)
    _ = presenter.proMonitoringSettingsModel?.refresh()
    self.presenter = presenter
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let selectionViewController = segue.destination as? AdultsKidsPetsPickerViewController {
      selectionViewController.delegate = self
      selectionViewController.allowMultipleSelection = false

      switch segue.identifier! {
      case segueToAdults:
        selectionViewController.displayedTitle = adults
        selectionViewController.selectionArray = buildSelectionModel("ADULT",
                                                                      plural: adults,
                                                                      fromIndex: 1,
                                                                      toIndex: 5,
                                                                      selected: adultsCount)
        break
      case segueToChildren:
        selectionViewController.displayedTitle = childrenString
        selectionViewController.selectionArray = buildSelectionModel("CHILD",
                                                                      plural: childrenString,
                                                                      fromIndex: 0,
                                                                      toIndex: 5,
                                                                      selected: childrenCount)
        break
      default:
        selectionViewController.displayedTitle = pets
        selectionViewController.selectionArray = buildSelectionModel("PET",
                                                                      plural: pets,
                                                                      fromIndex: 0,
                                                                      toIndex: 5,
                                                                      selected: petsCount)
        break
      }
    }
  }

  // MARK: UITableViewDelegate:

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    switch indexPath.row {
    case 0:
      self.performSegue(withIdentifier: segueToAdults, sender: self)
      break
    case 1:
      self.performSegue(withIdentifier: segueToChildren, sender: self)
      break
    default:
      self.performSegue(withIdentifier: segueToPets, sender: self)
      break
    }
  }

  // MARK: UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "WhoLivesHereCell")

    cell?.backgroundColor = UIColor.clear
    cell?.accessoryView = UIImageView(image: UIImage(named: "ChevronWhite"))

    switch indexPath.row {
    case 0:
      cell?.textLabel?.text = adults
      cell?.detailTextLabel?.text = displayedCountString(adultsCount)
      break

    case 1:
      cell?.textLabel?.text = childrenString
      cell?.detailTextLabel?.text = displayedCountString(childrenCount)
      break

    default:
      cell?.textLabel?.text = pets
      cell?.detailTextLabel?.text = displayedCountString(petsCount)
      break
    }

    return cell!
  }

  // MARK: ProMonWhoSettingsDelegate

  func showWhoResidesHere(_ adults: Int, children: Int, pets: Int) {
    self.adultsCount = adults
    self.childrenCount = children
    self.petsCount = pets

    table.reloadData()
  }

  func onSaveError() {
    displayGenericErrorMessage()
  }

  // MARK: ArcusModalSelectionDelegate

  func modalSelectionController(_ selectionController: UIViewController!,
                                didDismissWithSelectedModels selectedIndexes: [ArcusModalSelectionModel]!) {
    let selection = selectedIndexes[0]

    if let theModal = selectionController as? AdultsKidsPetsPickerViewController,
      let title = theModal.displayedTitle {
      switch title {
      case adults:
        presenter?.saveAdultsCount(Int(selection.tag)!)
        break

      case childrenString:
        presenter?.saveChildrenCount(Int(selection.tag)!)
        break

      default:
        presenter?.savePetsCount(Int(selection.tag)!)
        break
      }
    }
  }

  // MARK: Selection Models

  func buildSelectionModel(_ singular: String,
                           plural: String,
                           fromIndex: Int,
                           toIndex: Int,
                           selected: Int) -> [ArcusModalSelectionModel] {
    var selectionModels: [ArcusModalSelectionModel] = []
    var selectedExists = false

    for index in fromIndex...toIndex {
      let selectionModel: ArcusModalSelectionModel = ArcusModalSelectionModel()
      if index == 1 {
        selectionModel.title = "\(displayedCountString(index)) \(singular)"
      } else {
        selectionModel.title = "\(displayedCountString(index)) \(plural)"
      }
      selectionModel.tag = String(index)
      selectionModel.isSelected = index == selected
      selectedExists = selectedExists || index == selected

      selectionModels.append(selectionModel)
    }

    // Special case: selected value doesn't exist as a valid selection, make the first item selected
    if !selectedExists {
      selectionModels[0].isSelected = true
    }

    return selectionModels
  }

  func displayedCountString(_ count: Int) -> String {
    if count >= 5 {
      return "5+"
    }
    return String(count)
  }
}

class AdultsKidsPetsPickerViewController: ArcusModalSelectionViewController {

  internal var displayedTitle: String?
  @IBOutlet weak var titleLabel: ArcusLabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.titleLabel.text = ""
    if let title = displayedTitle {
      self.titleLabel.text = title
    }
  }
}
