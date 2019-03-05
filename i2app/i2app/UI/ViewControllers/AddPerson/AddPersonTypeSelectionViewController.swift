//
//  AddPersonTypeSelectionViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/21/16.
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

struct AddPersonTypeConstants {
  static let kTitle = "PersonTitle"
  static let kDescription = "PersonDescription"
  static let kInfoTitle = "PersonInfoTitle"
  static let kInfoDescription = "PersonInfoDescription"

  static let typeOptionsArray: [[String : String]] =
    [[kTitle: "Full Access (Email Required)",
      kDescription: "This person will have login access to your Place and " +
        "will be able to view your Dashboard, Scenes, Rules, Devices, Schedules, " +
        "People, History, and have limited access to your settings. They will " +
        "never see your billing information.\n\n" +
        "Commonly assigned to a spouse/partner or roommate. Ideal for anyone " +
      "living at this Place."],
     [kTitle: "Partial Access",
      kDescription: "Great for anyone you want to let into your home " +
        "or to receive Rule Notifications without providing them login or " +
        "digital access to your Place. Perfect for children or individuals " +
        "who do not have smartphones.\n\n" +
      "Ideal for family, close friends, children, and service professionals."]]
}

class AddPersonTypeSelectionViewController: UIViewController,
  UITableViewDataSource,
UITableViewDelegate {
  @IBOutlet var headerLabel: UILabel!
  @IBOutlet var typeTableView: UITableView!

  let addPersonModel: AddPersonModel = AddPersonModel()

  // MARK: View LifeCycle
  class func create() -> AddPersonTypeSelectionViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Person", bundle:nil)
    let viewController: AddPersonTypeSelectionViewController? =
      storyboard.instantiateInitialViewController() as? AddPersonTypeSelectionViewController

    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.typeTableView.backgroundColor = UIColor.clear
    self.typeTableView.estimatedRowHeight = 180
    self.typeTableView.rowHeight = UITableViewAutomaticDimension

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AddPersonTypeConstants.typeOptionsArray.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let CellIdentifier = "PersonTypeCell"

    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        as? ArcusSelectOptionTableViewCell

    cell?.managesSelectionState = true
    cell?.selectionImageWidth = 20
    cell?.selectionImageLeadingSpace = 16
    cell?.selectionImageTrailingSpace = 10

    cell?.backgroundColor = UIColor.clear

    let optionInfo = AddPersonTypeConstants.typeOptionsArray[indexPath.row]

    cell?.titleLabel.text = optionInfo[AddPersonTypeConstants.kTitle]

    cell?.descriptionLabel.text = optionInfo[AddPersonTypeConstants.kDescription]

    cell?.selectionStyle = UITableViewCellSelectionStyle.none

    cell?.accessoryImage.isHidden = true

    return cell!
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      self.addPersonModel.accessType = PersonAccessType.fullAccess
      break
    case 1:
      self.addPersonModel.accessType = PersonAccessType.locksAlarmNotifications
      break
    default:
      break
    }

    self.performSegue(withIdentifier: "AddPersonSelectContactTypeSegue", sender: self)
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonSelectContactTypeSegue" {
      let contactSelectionViewController = segue.destination as? AddPersonContactTypeSelectionViewController
      contactSelectionViewController?.addPersonModel = self.addPersonModel
    }
  }
}
