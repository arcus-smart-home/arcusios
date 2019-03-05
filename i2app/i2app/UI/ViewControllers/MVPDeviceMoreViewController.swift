//
//  WaterSoftenerDeviceMoreViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/14/17.
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

class MVPDeviceMoreViewController: UIViewController, DeviceMoreConfigurable {
  @IBOutlet var tableView: UITableView!
  @IBOutlet var removeDeviceButton: ArcusButton!

  var presenter: DeviceMorePresenter?

  var popupWindow: PopupSelectionWindow?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureUI()
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    title = "More"
  }

  deinit {
    presenter = nil
  }

  func configureUI() {
    tableView.estimatedRowHeight = 120
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  @IBAction func removeDevicePressed(_ sender: AnyObject) {
    presenter?.onRemoveDevicePressed()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? DeviceTextfieldViewController {
      vc.deviceModel = presenter?.device
      vc.inDeviceDetails = true
    } else if let vc = segue.destination as? DeviceProductInformationViewController {
      vc.deviceModel = presenter?.device
    } else if let vc = segue.destination as? UIViewController {
      presenter?.prepareDesination(vc)
    }
  }
}

extension MVPDeviceMoreViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = presenter?.moreItems.count {
      return count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let moreItem = presenter?.moreItems[indexPath.row] else {
        return UITableViewCell()
    }

    if let cell = tableView
      .dequeueReusableCell(withIdentifier: moreItem.cellIdentifier)
      as? ArcusTitleDetailTableViewCell {

      cell.backgroundColor = UIColor.clear
      if moreItem.actionType == .none {
        cell.selectionStyle = .none
      }

      cell.titleLabel.text = moreItem.title
      cell.descriptionLabel.text = moreItem.description

      if let info = moreItem.info, let label = cell.accessoryLabel {
        label.text = info
      }

      return cell
    } else if let cell = tableView
      .dequeueReusableCell(withIdentifier: moreItem.cellIdentifier)
      as? DeviceMoreItemSwitchCell {

      cell.backgroundColor = UIColor.clear
      cell.selectionStyle = .none
      cell.titleLabel.text = moreItem.title
      cell.descriptionLabel.text = moreItem.description

      if let selected = moreItem.metaData?["toggleState"] as? Bool {
        cell.toggleSwitch.setOn(selected, animated: false)
      }

      cell.toggleAction = {
        selected in
        self.presenter?.performAction(moreItem)
      }

      return cell
    }
    return UITableViewCell()
  }
}

extension MVPDeviceMoreViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let moreItem = presenter?.moreItems[indexPath.row] else { return }

    presenter?.performAction(moreItem)
  }
}

extension MVPDeviceMoreViewController: DeviceMorePresenterDelegate {
  func updateLayout() {
    guard tableView != nil else { return }

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  func performSegue(_ identifier: String) {
    performSegue(withIdentifier: identifier, sender: self)
  }

  func present(_ viewController: UIViewController?) {
    guard viewController != nil else { return }

    DispatchQueue.main.async {
      self.navigationController?.pushViewController(viewController!, animated: true)
    }
  }

  func displayRemovePopup() {
    if popupWindow?.displaying == true {
      popupWindow?.close()
    }

    let popupStyle = PopupWindowStyleCautionWindow

    let yesButton: PopupSelectionButtonModel =
      PopupSelectionButtonModel.create(NSLocalizedString("Yes", comment: ""),
                                       event: #selector(removeDevice(_:)))
    let noButton: PopupSelectionButtonModel =
      PopupSelectionButtonModel.create(NSLocalizedString("No", comment: ""),
                                       event: #selector(closePopup(_:)))

    let buttonView: PopupSelectionButtonsView =
      PopupSelectionButtonsView.create(withTitle: "Are You Sure",
                                       subtitle: nil,
                                       buttons: [yesButton, noButton])
    buttonView.owner = self

    popupWindow = PopupSelectionWindow.popup(view,
                                             subview: buttonView,
                                             owner: self,
                                             displyCloseButton: true,
                                             close: #selector(closePopup(_:)),
                                             style: popupStyle)
  }

  func removeDevice(_ sender: AnyObject!) {
    presenter?.removeDevice()
  }

  func closePopup(_ sender: AnyObject!) {}
}

class DeviceMoreItemSwitchCell: ArcusSelectOptionTableViewCell {
  @IBOutlet var toggleSwitch: ArcusSwitch!

  var toggleAction: ((_ selected: Bool) -> Void)?

  @IBAction func switchValueChange(sender: AnyObject) {
    guard let toggle = sender as? ArcusSwitch else { return }

    toggleAction?(toggle.state == .selected)
  }
}
