//
//  ZWaveToolsViewController.swift
//  i2app
//
//  Arcus Team on 9/15/16.
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

class ZWaveToolsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  override open func viewDidLoad() {
    super.viewDidLoad()

    configureBackground()
    configureTable()
    configureNavBar()
  }

  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(onHealPercentChanged),
                   name: HubModel.attributeChangedNotificationName(kAttrHubZwaveHealPercent),
                   object: nil)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(onHealPercentChanged),
                   name: HubModel.attributeChangedNotificationName("HubListRefreshed"),
                   object: nil)

    NotificationCenter.default
      .addObserver(self, selector: #selector(onHealPercentChanged),
                   name: HubModel.attributeChangedNotificationName(kAttrHubZwaveHealInProgress),
                   object: nil)

    // Force refresh hub attributes and redraw screen
    if let hub = RxCornea.shared.settings?.currentHub {
      DispatchQueue.global(qos: .background).async {
        _ = hub.refresh().swiftThen({_ in
          DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
          })
          return nil
        })
      }
    }

  }

  override open func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    NotificationCenter.default
      .removeObserver(self,
                      name: HubModel.attributeChangedNotificationName(kAttrHubZwaveHealPercent),
                      object: nil)
    NotificationCenter.default
      .removeObserver(self,
                      name: HubModel.attributeChangedNotificationName(kAttrHubZwaveHealInProgress),
                      object: nil)
    NotificationCenter.default
      .removeObserver(self,
                      name: HubModel.attributeChangedNotificationName("HubListRefreshed"),
                      object: nil)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if ZWaveToolsViewController.isZWaveRebuildSupported() {
      return 2
    }
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
      cell?.backgroundColor = UIColor.clear
      cell?.textLabel?.attributedText =
        NSAttributedString(string:  "REMOVE Z-WAVE DEVICES",
                           attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold",
                                                                    size: 11.0)!,
                                       NSKernAttributeName: 2.0])
      cell?.accessoryView = UIImageView(image: UIImage(named: "ChevronWhite"))

      return cell!

    case 1:
      let rebuildProgress = getRebuildProgress()
      var cellIdentifier = "subtitleCell"
      if rebuildProgress == nil {
        cellIdentifier = "basicCell"
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

      cell?.backgroundColor = UIColor.clear
      cell?.textLabel?.attributedText =
        NSAttributedString(string:  "REBUILD Z-WAVE NETWORK",
                           attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold",
                                                                    size: 11.0)!,
                                        NSKernAttributeName: 2.0])

      if let progress = rebuildProgress {
        cell?.detailTextLabel?.attributedText =
          NSAttributedString(string:  "Rebuild in progress... \(progress)%",
            attributes: [ NSFontAttributeName: UIFont(name: "AvenirNext-MediumItalic", size: 10.0)!])
      } else {
        cell?.detailTextLabel?.attributedText =
          NSAttributedString(string:  "Rebuild in progress... 0%",
            attributes: [ NSFontAttributeName: UIFont(name: "AvenirNext-MediumItalic", size: 10.0)!])

      }
      cell?.accessoryView = UIImageView(image: UIImage(named: "ChevronWhite"))

      return cell!

    default:
      assert(false, "Bug! Unimplemented ZWave table row.")
      return UITableViewCell()
    }
  }

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let zWaveToolsStoryboard = UIStoryboard(name: "ZWaveTools", bundle: nil)
    var nextViewController: UIViewController?

    switch indexPath.row {
    case 0:
      nextViewController = zWaveToolsStoryboard
        .instantiateViewController(withIdentifier: "ZWaveRemovalStartViewController")
      break
    case 1:
      if getRebuildProgress() == nil {
        nextViewController = zWaveToolsStoryboard
          .instantiateViewController(withIdentifier: "ZWaveHealStartViewController")
      } else {
        nextViewController = ZWaveHealProgressViewController.create()
      }
      break
    default:
      assert(false, "Bug! Unimplemented ZWave tool.")
      break
    }

    self.navigationController?.pushViewController(nextViewController!, animated: true)
  }

  open func onHealPercentChanged (_ notification: Notification) {
    DispatchQueue.main.async(execute: {
      self.tableView.reloadData()
    })
  }

  fileprivate func getRebuildProgress() -> Int? {
    if let hub = RxCornea.shared.settings?.currentHub {
      let hubZwave = HubZwaveModel(attributes: hub.get())

      if HubZwaveCapability.getHealInProgress(from: hubZwave) {
        return Int(HubZwaveCapability.getHealPercent(from: hubZwave) * 100)
      }
    }

    return nil
  }

  fileprivate func configureNavBar() {
    self.navBar(withBackButtonAndTitle: "Z-WAVE TOOLS")
  }

  fileprivate func configureTable () {
    self.tableView.tableFooterView = UIView()
  }

  fileprivate func configureBackground () {
    self.setBackgroundColorToDashboardColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
  }

  open static func isZWaveRebuildSupported () -> Bool {

    let kMinMajorVersion = 2, kMinMinorVersion = 0, kMinMaintenanceVersion = 2, kMinBuildVersion = 6

    if let agentVerString = HubAdvancedCapability.getOsverFrom(RxCornea.shared.settings?.currentHub) {
      let versionComponentStrings = agentVerString.components(separatedBy: ".")
      if versionComponentStrings.count == 4 {
        if let major = Int(versionComponentStrings[0]),
          let minor = Int(versionComponentStrings[1]),
          let maintenace = Int(versionComponentStrings[2]),
          let build = Int(versionComponentStrings[3]) {
          return major > kMinMajorVersion
            || major == kMinMajorVersion && minor > kMinMinorVersion
            || major == kMinMajorVersion && minor == kMinMinorVersion && maintenace > kMinMaintenanceVersion
            || (major == kMinMajorVersion && minor == kMinMinorVersion
              && maintenace == kMinMaintenanceVersion && build >= kMinBuildVersion)
        }
      }
    }

    return false
  }
}
