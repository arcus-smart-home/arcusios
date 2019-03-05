//
//  AlarmGenericDevicesViewController.swift
//  i2app
//
//  Created by Arcus Team on 2/20/17.
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

class AlarmDevicesViewController: UIViewController {
  var alarmType: AlarmType = .Smoke
  var presenter: AlarmDevicesPresenterProtocol!

  // MARK: IBOutlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    presenter = AlarmDevicesPresenter(delegate: self)
    presenter.fetchAlarmDevices()

    navBar(withTitle: presenter.navigationTitle(), enableBackButton: true)

    // Set the background of the view
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    tableView.backgroundColor = UIColor.clear
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    tableView.register(UINib.init(nibName: "AlarmDevicesTableViewSectionHeader",
                                     bundle: nil),
                          forHeaderFooterViewReuseIdentifier: "header")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    presenter.fetchAlarmDevices()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AlarmDevicesToDeviceMode" {
      guard let address = sender as? String,
        let vc = segue.destination as? AlarmDeviceModeViewController else {
        return
      }

      vc.deviceAddress = address
    }
  }
}

// MARK: AlarmDevicesDelegate
extension AlarmDevicesViewController: AlarmDevicesDelegate {
  func shouldUpdateViews() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

// MARK: UITableViewDelegate
extension AlarmDevicesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if alarmType == .Security {
      performSegue(withIdentifier: "AlarmDevicesToDeviceMode",
                                 sender: presenter.deviceAddressForIndexPath(indexPath))
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let tableHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
      as? AlarmDevicesTableViewSectionHeader {

      tableHeader.mainTextLabel.text = presenter.titleForSection(section)
      tableHeader.hasBlurEffect = true

      return tableHeader
    }

    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 44
  }
}

// MARK: UITableViewDataSource
extension AlarmDevicesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.rowsForSection(section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if alarmType == .Security {
      if let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDeviceSecurityCell") as?
        AlarmDeviceSecurityTableViewCell {

        let deviceList = presenter.deviceListForSection(indexPath.section)

        // Ensure that the device list does not go out of bounds
        if deviceList.count > indexPath.row {
          return bindSecurityCellToDeviceViewModel(cell, device: deviceList[indexPath.row])
        }
      }
    } else {
      if let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDeviceGenericCell") as?
        AlarmDeviceGenericTableViewCell {

        let deviceList = presenter.alarmDevicesViewModel.devicesParticipating

        // Ensure that the device list does not go out of bounds
        if deviceList.count > indexPath.row {
          return bindGenericCellToDeviceViewModel(cell, device: deviceList[indexPath.row])
        }
      }
    }

    return UITableViewCell()
  }
}

// MARK: Data Binding
extension AlarmDevicesViewController {
  fileprivate func bindGenericCellToDeviceViewModel(_ cell: AlarmDeviceGenericTableViewCell,
                                                    device: AlarmDeviceViewModel) -> UITableViewCell {
    cell.backgroundColor = UIColor.clear
    cell.title.text = device.title
    cell.deviceImage.image = device.image
    cell.redDot.backgroundColor = ObjCMacroAdapter.arcusPinkAlertColor()
    cell.redDot.layer.cornerRadius = 3.5
    cell.subtitle.text = device.subtitle

    if device.isOffline {
      cell.title.alpha = 0.80
      cell.subtitle.alpha = 0.80
      cell.deviceImage.alpha = 0.80
      cell.redDot.isHidden = false
    } else {
      cell.title.alpha = 1.0
      cell.deviceImage.alpha = 1.0
      cell.redDot.isHidden = true
    }

    return cell
  }

  fileprivate func bindSecurityCellToDeviceViewModel(_ cell: AlarmDeviceSecurityTableViewCell,
                                                     device: AlarmDeviceViewModel) -> UITableViewCell {
    cell.backgroundColor = UIColor.clear
    cell.title.text = device.title
    cell.deviceImage.image = device.image
    cell.redDot.backgroundColor = ObjCMacroAdapter.arcusPinkAlertColor()
    cell.redDot.layer.cornerRadius = 3.5
    cell.subtitle.text = device.subtitle
    cell.alarmMode.text = device.mode
    if device.isOffline {
      cell.redDotContainerWidth.priority = 200
    } else {
      cell.redDotContainerWidth.priority = 999
    }

    if device.isOffline || device.isBypassed {
      cell.title.alpha = 0.80
      cell.deviceImage.alpha = 0.80
    } else {
      cell.title.alpha = 1.0
      cell.deviceImage.alpha = 1.0
    }

    return cell
  }
}
