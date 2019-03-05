//
//  DebugMenuViewController.swift
//  i2app
//
//  Created by Arcus Team on 12/1/17.
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

class DebugMenuViewController: UIViewController {
  @IBOutlet var tableView: UITableView!

  var presenter: ArcusDebugMenuPresenter?

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureLayout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if presenter != nil {
      presenter!.setUp()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if presenter != nil {
      presenter!.tearDown()
    }
  }

  func configureLayout() {
    setBackgroundColorToParentColor()
    navBar(withCloseButtonAndTitle: NSLocalizedString("Debug Info", comment: "").uppercased())
  }

  func close(_ sender: NSObject) {
    dismiss(animated: true, completion: nil)
  }
}

extension DebugMenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count: Int = presenter?.debugItems.count else {
      return 0
    }
    return count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel: ArcusDebugMenuViewModel = presenter?.debugItems[indexPath.row] else {
      return UITableViewCell()
    }

    guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.identifier)
      as? ArcusTitleDetailTableViewCell else {
      return UITableViewCell()
    }

    cell.titleLabel.text = viewModel.title
    if let description: String = viewModel.description {
      cell.descriptionLabel.text = description
    }

    if let switchCell = cell as? DebugItemSwitchCell,
      let state: Bool = viewModel.switchState,
      let handler: DebugSwitchHandler = viewModel.switchHandler {
      switchCell.toggleSwitch.setOn(state, animated: false)
      switchCell.toggleAction = handler
    }

    return cell
  }
}

extension DebugMenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel: ArcusDebugMenuViewModel = presenter?.debugItems[indexPath.row] else {
        return
    }
    
    // TODO: TEMP
    if viewModel.title.lowercased() == "ble test" {
      let storyboard = UIStoryboard(name: "DebugMenu", bundle: nil)
      if let bleList = storyboard.instantiateViewController(withIdentifier: "BLEListNavigationController") as? UINavigationController {
        present(bleList, animated: true, completion: nil)
        return
      }
    }

    if let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.identifier)
      as? DebugItemSwitchCell {
      cell.toggleSwitch.setOn(!cell.toggleSwitch.isOn, animated: false)
    }
  }
}

extension DebugMenuViewController: ArcusDebugMenuPresenterDelegate {
  func updateLayout() {
    DispatchQueue.main.async {
      if self.tableView != nil {
        self.tableView.reloadData()
      }
    }
  }
}

class DebugItemSwitchCell: ArcusTitleDetailTableViewCell {
  @IBOutlet var toggleSwitch: ArcusSwitch!

  var toggleAction: ((_ selected: Bool) -> Void)?

  @IBAction func switchValueChange(sender: AnyObject) {
    guard let toggle = sender as? ArcusSwitch else { return }

    toggleAction?(toggle.isOn)
  }
}
