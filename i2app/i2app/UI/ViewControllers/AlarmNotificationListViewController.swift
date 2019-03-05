//
//  AlarmNotificationListViewController.swift
//  i2app
//
//  Created by Arcus Team on 1/9/17.
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

let ShowSecurityRecommendationSegueIdentifier = "ShowSecurityRecommendation"
let PromptToAddMonitoringStationContactSegue = "promptToAddContact"

class AlarmNotificationListViewController: UIViewController,
  AlarmNotificationListDelegate,
ClearTableConfigurator {

  @IBOutlet weak var tableView: UITableView!

  let doneText = NSLocalizedString("DONE", comment: "DONE")
  let editText = NSLocalizedString("EDIT", comment: "EDIT")
  var editButton: UIButton!
  var editbarButtonItem: UIBarButtonItem!

  var presenter: AlarmNotificationListPresenterProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70.0
    tableView.allowsSelectionDuringEditing = true

    editButton = UIButton(type: .custom)
    editButton.setAttributedTitle(FontData.getString(editText, withFont: FontDataTypeNavBar),
                                  for: UIControlState())
    editButton.frame = CGRect(x: 0, y: 0, width: 50, height: 12)
    editButton.addTarget(self, action: #selector(self.editPressed(_:)), for: .touchUpInside)
    editbarButtonItem = UIBarButtonItem(customView: editButton)

    presenter = AlarmNotificationListPresenter(delegate: self)
    configureClearLayout()
    updateLayout()
    presenter?.fetch()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsNotification)
    
    // This bit of nonsense brought to you by the need to hide the "Add Monitoring Station Phone Number" link
    // after adding it and dismissing the popup.
    tableView.reloadData()
  }

  func updateLayout() {
    DispatchQueue.main.async {
      guard let tableView = self.tableView else {
        return
      }
      if let presenter = self.presenter,
        presenter.canEditPeopleList {
        self.navigationItem.rightBarButtonItem = self.editbarButtonItem
      } else {
        self.navigationItem.rightBarButtonItem = nil
      }
      tableView.reloadData()
    }
  }

  func displayListErrorNotification() {
    DispatchQueue.main.async {
      self.popupErrorWindow(AlarmNotificationListConstants.maxNotifiedWarningTitle,
                            subtitle: AlarmNotificationListConstants.maxNotifiedWarningMessage)
      self.editPressed(self)
    }
  }

  @IBAction func editPressed(_ sender: AnyObject) {
    //Save changes if we just finished editing
    if isEditing {
      presenter?.saveChanges()
    }
    isEditing = !isEditing
    tableView.setEditing(isEditing, animated: true)
    if isEditing {
      editButton.setAttributedTitle(FontData.getString(doneText, withFont: FontDataTypeNavBar),
                                    for: UIControlState())
    } else {
      editButton.setAttributedTitle(FontData.getString(editText, withFont: FontDataTypeNavBar),
                                    for: UIControlState())
    }
    tableView.reloadData()
  }

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == ShowSecurityRecommendationSegueIdentifier {
      if presenter?.text == .promod {
        return true
      } else {
        return false
      }
    }
    return false
  }
}

extension AlarmNotificationListViewController : UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.isEditing {
      presenter?.toggleModelAtIndex(indexPath.row)
    } else if let cell = tableView.cellForRow(at: indexPath) as? NotificationListPremiumFooterTableViewCell {
      if !cell.chevronWhite.isHidden {
        self.performSegue(withIdentifier: ShowSecurityRecommendationSegueIdentifier, sender: self)
      }
    } else if (tableView.cellForRow(at: indexPath) as? AddMonitioringStationContactTableViewCell) != nil {
      self.performSegue(withIdentifier: PromptToAddMonitoringStationContactSegue, sender: self)
    }
  }

  func tableView(_ tableView: UITableView,
                 editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .insert
  }

  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
}

extension AlarmNotificationListViewController : UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 || section == 2 {
      return 1
    }

    guard let presenter = self.presenter else { return 0 }

    if tableView.isEditing {
      return presenter.allPeople.count
    } else {
      return presenter.notifiedPeople.count
    }
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let presenter = self.presenter else {
      return UITableViewCell()
    }
    if indexPath.section == 0 {
      // Display a header cell
      if let cell =
        tableView.dequeueReusableCell(withIdentifier: NotificationListHeaderTableViewCell.reuseIdentifier,
                                      for: indexPath) as? NotificationListHeaderTableViewCell {
        cell.titleLabel.text = presenter.text.titleText
        cell.backgroundColor = UIColor.clear
        return cell
      }
    } else if indexPath.section == 2 {
      // Display "Add monitoring station contact" cell
      if !tableView.isEditing
        && presenter.text == .promod
        && !UserDefaults.standard.bool(forKey: AlarmAddContactConstants.kUserAddedContact) {
        let cell = tableView
          .dequeueReusableCell(withIdentifier: AddMonitioringStationContactTableViewCell.reuseIdentifier,
                               for: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
      }

      // Display the "Don't see who you're looking for" cell
      if tableView.isEditing {
        let identifier = AlarmNotificationListEditingFooterTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                               for: indexPath)

        cell.backgroundColor = UIColor.clear
        return cell
      } else if presenter.notifiedPeople.count < 2 {
        switch presenter.text {
        case .promod, .premium:
          if let cell = tableView
            .dequeueReusableCell(withIdentifier: NotificationListPremiumFooterTableViewCell.reuseIdentifier,
                                 for: indexPath) as? NotificationListPremiumFooterTableViewCell {
            // Set Chevron based on service Level
            if presenter.text == .promod {
              cell.chevronWhite.isHidden = false
            } else {
              cell.chevronWhite.isHidden = true
            }
            cell.backgroundColor = UIColor.clear
            return cell
          }
        case .basic:
          let cell = UITableViewCell()
          cell.backgroundColor = UIColor.clear
          return cell
        }
      } else {
        // Don't display the footer if more than 2 people are selected
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        return cell
      }
    }

    var displayList: [AlarmNotificationListModel] {
      if tableView.isEditing {
        return presenter.allPeople
      } else {
        return presenter.notifiedPeople
      }
    }

    // Display a User cell
    guard displayList.count > indexPath.row else {
      return UITableViewCell()
    }

    if let cellConfigure = displayList[safe: indexPath.row],
      let cell = tableView
      .dequeueReusableCell(withIdentifier: NotificationListNotifiedUserTableViewCell.reuseIdentifier,
                           for: indexPath) as? NotificationListNotifiedUserTableViewCell {
      tableView.configureCellHairline(cell, withIndexPath: indexPath)
      self.configureCell(cell, withObject: cellConfigure)
      return cell
    }

    return UITableViewCell()
  }

  func configureCell(_ cell: NotificationListNotifiedUserTableViewCell,
                     withObject object: AlarmNotificationListModel) {
    cell.backgroundColor = UIColor.clear
    cell.detailImage.image = object.image()
    cell.titleLabel.text = object.userName
    object.addState.configureSelectionImageView(cell.selectionImage)
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    if indexPath.section != 1 {
      return false
    }
    return true
  }

  func tableView(_ tableView: UITableView,
                 moveRowAt sourceIndexPath: IndexPath,
                 to destinationIndexPath: IndexPath) {
    if destinationIndexPath.row == 0 || sourceIndexPath.row == 0 {
      //reset the data and do nothing to the presenter
      tableView.reloadData()
      return
    }
    presenter?.movePersonAtRow(sourceIndexPath.row, toRow: destinationIndexPath.row)
  }

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section != 1 || indexPath.row == 0 {
      return false
    }
    return true
  }
}

extension NotificationPersonAddState {
  func configureSelectionImageView(_ imageView: UIImageView) {
    switch self {
    case .selectedAndCannotBeChanged:
      imageView.image = UIImage(named:"RoleCheckedIconWhite")
      imageView.alpha = 0.5
    case .notSelected:
      imageView.image = UIImage(named:"RoleUncheckButtonWhite")
      imageView.alpha = 1.0
    case .selected:
      imageView.image = UIImage(named:"RoleCheckedIconWhite")
      imageView.alpha = 1.0
    }
  }
}

extension AlarmNotificationListModel {
  func image() -> UIImage? {
    guard let person = RxCornea.shared.modelCache?.fetchModel(self.userId),
      let personModel = person as? PersonModel else { return nil }

    var imageIcon = personModel.image
    if imageIcon == nil {
      imageIcon = UIImage(named: "person_filled_white")
    }
    imageIcon = imageIcon?.exactZoomScaleAndCutSize(
      inCenter: CGSize(width: 32, height: 32))
    imageIcon = imageIcon?.roundCornerImageWithsize(
      CGSize(width: 30, height: 30))
    return imageIcon
  }
}
