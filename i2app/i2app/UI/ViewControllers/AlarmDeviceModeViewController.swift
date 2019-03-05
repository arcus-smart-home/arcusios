//
//  AlarmDeviceModeViewController.swift
//  i2app
//
//  Created by Arcus Team on 2/21/17.
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

class AlarmDeviceModeViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  var deviceAddress = ""
  var presenter: AlarmDeviceModePresenterProtocol!

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    presenter = AlarmDeviceModePresenter(delegate: self, deviceAddress: deviceAddress)

    navBar(withTitle: presenter.navigationTitle(), enableBackButton: true)

    // Set the background of the view
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    tableView.backgroundColor = UIColor.clear
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
  }
}

// MARK: AlarmDeviceModePresenterDelegate
extension AlarmDeviceModeViewController: AlarmDeviceModePresenterDelegate {
  func shouldUpdateViews() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

// MARK: UITableViewDelegate
extension AlarmDeviceModeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.selectModeAtIndex(indexPath.row)
  }
}

// MARK: UITableDataSource
extension AlarmDeviceModeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.deviceModes.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: "AlarmDeviceModeCell") as? AlarmDeviceModesTableViewCell {

      cell.mode.text = presenter.deviceModes[indexPath.row].title
      cell.check.isSelected = presenter.deviceModes[indexPath.row].isSelected
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }
}
