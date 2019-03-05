//
//  CamerasMoreViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/22/17.
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

class CamerasMoreViewController: UIViewController, ArcusTabBarComponent {
  @IBOutlet weak var segmentedControl: ArcusSegmentedControl!
  @IBOutlet var tableView: UITableView!

  var presenter: CamerasMoreTabPresenter?

  // MARK: View Life Cycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    presenter = CamerasMorePresenter(delegate: self)
    configureUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configureSegmentedControl(self.tabBarController)
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    title = "More"
  }

  deinit {
    presenter = nil
  }

  // MARK:  UI Configuration

  func configureUI() {
    configureSegmentedControl(self.tabBarController)
    configureNavBar()
    configureBackground()
    configureTableView()
  }

  func configureNavBar() {
    navBar(withBackButtonAndTitle: title)
  }

  func configureBackground() {
    setBackgroundColorToLastNavigateColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
  }

  func configureTableView() {
    tableView.estimatedRowHeight = 120
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  // MARK: IBActions

  @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
    tabSegmentedControlValueChanged(sender)
  }

  // MARK: Prepare For Segue

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  }
}

extension CamerasMoreViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = presenter?.options.count {
      return count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let optionItem = presenter?.options[indexPath.row] else {
      return UITableViewCell()
    }

    if let cell = tableView
      .dequeueReusableCell(withIdentifier: optionItem.cellIdentifier)
      as? ArcusTitleDetailTableViewCell {

      cell.backgroundColor = UIColor.clear
      if optionItem.actionType == .none {
        cell.selectionStyle = .none
      }

      cell.titleLabel.text = optionItem.title
      cell.descriptionLabel.text = optionItem.description

      return cell
    } else if let cell = tableView
      .dequeueReusableCell(withIdentifier: optionItem.cellIdentifier)
      as? CameraMoreToggleCell {

      cell.backgroundColor = UIColor.clear
      cell.selectionStyle = .none
      cell.titleLabel.text = optionItem.title
      cell.descriptionLabel.text = optionItem.description

      if let selected = optionItem.metaData?["toggleState"] as? Bool {
        cell.toggleSwitch.setOn(selected, animated: false)
      }

      cell.toggleAction = {
        selected in
        self.presenter?.performAction(optionItem)
      }

      return cell
    }
    return UITableViewCell()
  }
}

extension CamerasMoreViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let optionItem = presenter?.options[indexPath.row] else { return }

    presenter?.performAction(optionItem)
  }
}

extension CamerasMoreViewController: CamerasMoreTabDelegate {
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
}
