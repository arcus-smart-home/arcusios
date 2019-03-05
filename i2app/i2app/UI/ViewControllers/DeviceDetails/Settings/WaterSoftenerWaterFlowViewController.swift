//
//  WaterSoftenerWaterFlowViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/19/17.
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

class WaterSoftenerWaterFlowViewController: UIViewController {
  @IBOutlet var tableView: UITableView!

  var presenter: WaterSoftenerSettingPresenter?
  var popupWindow: PopupSelectionWindow = PopupSelectionWindow()

  fileprivate var waterFlowPopupViewController: WaterSoftenerFlowPopupViewController? =
    WaterSoftenerFlowPopupViewController.create()

  override func viewDidLoad() {
    super.viewDidLoad()

    configureUI()
  }

  deinit {
    presenter = nil
  }

  // MARK: UI Configuration

  func configureUI() {
    navBar(withTitle: "Water Flow", enableBackButton: true)
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    tableView.estimatedRowHeight = 120
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  // MARK: Popup Handling

  func displayFlowPopup() {
    guard presenter != nil else { return }

    let popupPresenter = WaterSoftenerFlowPopupPresenter(waterFlowPopupViewController,
                                                         device: presenter!.device)
    waterFlowPopupViewController?.configurePopup(popupPresenter, closeBlock: {
      self.dismissPopup()
    })

    dismissPopup()

    popupWindow.container = view
    popupWindow.subview = waterFlowPopupViewController
    popupWindow.owner = self
    popupWindow.displayCloseButton = false

    waterFlowPopupViewController?.window = popupWindow

    if let height = waterFlowPopupViewController?.getHeight() {
      popupWindow.open(withHeight: height, offset: 0)
    }
  }

  func dismissPopup() {
    if popupWindow.displaying == true {
      popupWindow.close()
    }
  }
}

extension WaterSoftenerWaterFlowViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = presenter?.settingItems.count {
      return count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let settingItem = presenter?.settingItems[indexPath.row] else {
      return UITableViewCell()
    }

    if let cell = tableView
      .dequeueReusableCell(withIdentifier: settingItem.cellIdentifier)
      as? ArcusTitleDetailTableViewCell {

      cell.backgroundColor = UIColor.clear
      if settingItem.actionType == .none {
        cell.selectionStyle = .none
      }

      cell.titleLabel.text = settingItem.title
      cell.descriptionLabel.text = settingItem.description

      if let info = settingItem.info, let label = cell.accessoryLabel {
        label.text = info
      }

      return cell
    } else if let cell = tableView
      .dequeueReusableCell(withIdentifier: settingItem.cellIdentifier)
      as? DeviceMoreItemSwitchCell {

      cell.backgroundColor = UIColor.clear
      cell.selectionStyle = .none
      cell.titleLabel.text = settingItem.title
      cell.descriptionLabel.text = settingItem.description

      if let selected = settingItem.metaData?["toggleState"] as? Bool {
        cell.toggleSwitch.setOn(selected, animated: false)
      }

      cell.toggleAction = {
        selected in
        self.presenter?.toggle(!selected)
      }

      return cell
    }
    return UITableViewCell()
  }
}

extension WaterSoftenerWaterFlowViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let settingItem = presenter?.settingItems[indexPath.row] else {
      return
    }

    if settingItem.actionType == .popup {
      displayFlowPopup()
    } else if settingItem.actionType == .toggle {
      if let selected = settingItem.metaData?["toggleState"] as? Bool {
        presenter?.toggle(!selected)
      }
    }
  }
}

extension WaterSoftenerWaterFlowViewController: WaterSoftenerSettingPresenterDelegate {
  func updateLayout() {
    guard tableView != nil else { return }

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
