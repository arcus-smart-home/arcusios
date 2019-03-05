//
//  AddPersonSuccessViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/2/16.
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

class AddPersonSuccessViewController: UIViewController {
  @IBOutlet var successImage: UIImageView!
  @IBOutlet var successLabel: ArcusLabel!
  @IBOutlet var successSubLabel: ArcusLabel!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var topSpacingConstraint: NSLayoutConstraint! {
    didSet {
      if ObjCMacroAdapter.isPhone5() {
        self.topSpacingConstraint.constant = 10.0
      }
    }
  }
  @IBOutlet var bottomSpacingConstraint: NSLayoutConstraint! {
    didSet {
      if ObjCMacroAdapter.isPhone5() {
        self.bottomSpacingConstraint.constant = 10.0
      }
    }
  }

  fileprivate let rows = [AppPersonSuccessInfoModel("Alarm",
                                                    description: "Alarm Notification List¹²",
                                                    imageName: "securityalarm"),
                          AppPersonSuccessInfoModel("Care",
                                                    description: "Care Notification List¹",
                                                    imageName: "CareIconBlack"),
                          AppPersonSuccessInfoModel("Doors & Locks",
                                                    description: "Grant Access to Locks²",
                                                    imageName: "doorslocks")]

  internal var addPersonModel: AddPersonModel?
  var placeTitle: String {
    guard let name = RxCornea.shared.settings?.currentPlace?.name else {
      return ""
    }
    return name
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navigationItem.setHidesBackButton(true, animated: false)
    self.setNavBarTitle(self.navigationItem.title)
    self.addRightButtonItem("button_close", selector: #selector(self.closeButtonPressed))

    self.configureLabels()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if self.isMovingFromParentViewController {
      _ = self.navigationController?.popToRootViewController(animated: true)
    }
  }

  // MARK: UI Configuration
  func configureLabels() {
    self.successLabel.text =
      self.successLabel.text!.replacingOccurrences(of: "<Name>",
                                                   with: "\(self.addPersonModel!.firstName!) \(self.addPersonModel!.lastName!)")
    self.successLabel.text =
      self.successLabel.text!.replacingOccurrences(of: "<Place>",
                                                   with: self.placeTitle)

    if let subtext = self.successSubLabel {
      subtext.text = subtext.text!
        .replacingOccurrences(of: "<Name>",
                              with:(self.addPersonModel?.firstName)!,
                              options: NSString.CompareOptions.literal,
                              range: nil)
    }
  }

  // MARK: IBActions
  @IBAction func closeButtonPressed(_ sender: UIButton) {
    _ = self.navigationController?.popToRootViewController(animated: true)
  }
}

extension AddPersonSuccessViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
      as? ArcusImageTitleDescriptionTableViewCell {

      let rowModel = rows[indexPath.row]

      cell.titleLabel.text = rowModel.title
      cell.descriptionLabel.text = rowModel.description
      cell.detailImage.image = UIImage(named: rowModel.imageName)

      cell.backgroundColor = UIColor.clear

      return cell
    }
    return UITableViewCell()
  }
}

fileprivate struct AppPersonSuccessInfoModel {
  let title: String!
  let description: String!
  let imageName: String!

  init(_ title: String, description: String, imageName: String) {
    self.title = title
    self.description = description
    self.imageName = imageName
  }
}
