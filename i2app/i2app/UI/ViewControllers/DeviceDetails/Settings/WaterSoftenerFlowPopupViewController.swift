//
//  WaterSoftenerFlowPopupViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/20/17.
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

class WaterSoftenerFlowPopupViewController: PopupSelectionBaseContainer {
  @IBOutlet var titleLabel: ArcusLabel!
  @IBOutlet var tableView: UITableView!

  var presenter: WaterFlowPopupPresenter?

  private var closeHandler: () -> Void = { _ in }

  override func getHeight() -> CGFloat {
    return 440.0
  }

  static func create() -> WaterSoftenerFlowPopupViewController? {
    let storyboard = UIStoryboard(name: "DeviceDetailSetting", bundle: nil)
    if let viewController = storyboard
      .instantiateViewController(withIdentifier: "WaterSoftenerFlowPopupViewController")
      as? WaterSoftenerFlowPopupViewController {
      viewController.view.frame = CGRect(x: viewController.view.frame.origin.x,
                                         y: viewController.view.frame.origin.y,
                                         width: viewController.view.frame.size.width,
                                         height: 255)
      return viewController
    }
    return nil
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    configureUI()
  }

  // MARK: UI Configuration

  func configurePopup(_ presenter: WaterFlowPopupPresenter, closeBlock: @escaping () -> Void) {
    view.layoutIfNeeded()

    self.presenter = presenter
    closeHandler = closeBlock
  }

  func configureUI() {
    guard presenter != nil else { return }
    configureSelected(presenter!.selectedIndex)
  }

  func configureSelected(_ index: Int) {
    guard let count = presenter?.settingItems.count, index < count else { return }

    let indexPath = IndexPath(item: index, section: 0)
    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
  }

  // MARK: IBAction

  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    closeHandler()
  }
}

extension WaterSoftenerFlowPopupViewController: UITableViewDataSource {
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

    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
      as? ArcusSelectOptionTableViewCell {

      cell.backgroundColor = UIColor.clear
      cell.selectionStyle = .none

      cell.titleLabel.text = settingItem.title
      cell.descriptionLabel.text = settingItem.description

      return cell
    }
    return UITableViewCell()
  }
}

extension WaterSoftenerFlowPopupViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let settingItem = presenter?.settingItems[indexPath.row] else {
      return
    }
    presenter?.updateContinuous(settingItem.value)
  }
}

extension WaterSoftenerFlowPopupViewController: WaterFlowPopupPresenterDelegate {
  func updateLayout() {
    guard tableView != nil else { return }

    DispatchQueue.main.async {
      self.tableView.reloadData()
      if self.presenter != nil {
        self.configureSelected(self.presenter!.selectedIndex)
      }
    }
  }
}
