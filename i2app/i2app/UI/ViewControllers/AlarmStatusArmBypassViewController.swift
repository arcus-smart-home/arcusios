//
//  AlarmStatusArmBypassViewController.swift
//  i2app
//
//  Created by Arcus Team on 2/19/17.
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

let kBypassedLabelHeight: CGFloat = 58.0
let kOfflineLabelHeight: CGFloat = 39.0

let kBypassedNormalBottomSpacing: CGFloat = 20.0

let kOfflineNormalBottomSpacing: CGFloat = 12.0
let kOfflineOnlyBottomSpacing: CGFloat = 45.0

class AlarmStatusArmBypassViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var titleLabel: ArcusLabel!
  @IBOutlet weak var bypassedLabelHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bypassedLabelBottomrSpacingConstraint: NSLayoutConstraint!
  @IBOutlet weak var offlineLabelHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var offlineLabelBottomrSpacingConstraint: NSLayoutConstraint!
  @IBOutlet weak var isOfflineIcon: UIImageView!

  var devicePresenter: BypassedSecurityDevicesPresenter?

  var isPartial = false
  var statusViewController: AlarmStatusViewController?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if devicePresenter != nil {
      configureHeader(devicePresenter!)
    }
  }

  func configureHeader(_ presenter: BypassedSecurityDevicesPresenter) {
    if presenter.bypassedIncluded && presenter.offlineIncluded {
      titleLabel.text = "Bypassed or offline device(s)"
      bypassedLabelHeightConstraint.constant = kBypassedLabelHeight
      bypassedLabelBottomrSpacingConstraint.constant = kBypassedNormalBottomSpacing
      offlineLabelHeightConstraint.constant = kOfflineLabelHeight
      offlineLabelBottomrSpacingConstraint.constant = kOfflineNormalBottomSpacing
    } else if presenter.bypassedIncluded && !presenter.offlineIncluded {
      titleLabel.text = "Bypassed device(s)"
      bypassedLabelHeightConstraint.constant = kBypassedLabelHeight
      bypassedLabelBottomrSpacingConstraint.constant = kBypassedNormalBottomSpacing
      offlineLabelHeightConstraint.constant = 0
      offlineLabelBottomrSpacingConstraint.constant = 0
    } else if !presenter.bypassedIncluded && presenter.offlineIncluded {
      titleLabel.text = "Offline device(s)"
      bypassedLabelHeightConstraint.constant = 0
      bypassedLabelBottomrSpacingConstraint.constant = 0
      offlineLabelHeightConstraint.constant = kOfflineLabelHeight
      offlineLabelBottomrSpacingConstraint.constant = kOfflineOnlyBottomSpacing
    }

    isOfflineIcon.isHidden = !presenter.offlineIncluded

    view.layoutIfNeeded()
  }

  @IBAction func cancelButtonPressed(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func continueButtonPressed(_ sender: AnyObject) {
    dismiss(animated: true, completion: {
      self.statusViewController?.callArmBypass()
    })
  }
}

extension AlarmStatusArmBypassViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard devicePresenter != nil else {
      return 0
    }
    return devicePresenter!.devices.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "armBypassBasicCell")
      as? BypassedOfflineDeviceCell {
      if let deviceVM = devicePresenter?.devices[indexPath.row] {
        cell.nameLabel?.text = deviceVM.name
        cell.offlineIcon.isHidden = !deviceVM.isOffline
      }

      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }
}

extension AlarmStatusArmBypassViewController: BypassedSecurityDevicesDelegate {
  func updateLayout() {
    DispatchQueue.main.async {
      guard self.isViewLoaded == true else { return }

      if self.devicePresenter != nil {
        self.configureHeader(self.devicePresenter!)
        self.tableView.reloadData()
      }
    }
  }
}
