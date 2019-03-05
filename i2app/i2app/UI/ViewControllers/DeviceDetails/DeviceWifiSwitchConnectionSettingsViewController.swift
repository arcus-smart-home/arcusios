//
//  DeviceWifiSwitchConnectionSettingsViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/26/16.
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

class DeviceWifiSwitchConnectionSettingsViewController: UIViewController,
UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    internal var deviceModel: DeviceModel!

    // MARK: View LifeCycle
    class func create(_ deviceModel: DeviceModel) -> DeviceWifiSwitchConnectionSettingsViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "DeviceDetailSetting", bundle:nil)
        let viewController: DeviceWifiSwitchConnectionSettingsViewController? =
            storyboard.instantiateViewController(withIdentifier: String(
                describing: DeviceWifiSwitchConnectionSettingsViewController.self))
                as? DeviceWifiSwitchConnectionSettingsViewController
        viewController?.deviceModel = deviceModel

        return viewController!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureBackground()
    }

    // MARK: UI Configuration
    func configureNavBar() {
        navBar(withBackButtonAndTitle: navigationItem.title)
    }

    func configureBackground() {
        setBackgroundColorToDashboardColor()
        addDarkOverlay(BackgroupOverlayLightLevel)
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArcusTitleDetailTableViewCell? = tableView
            .dequeueReusableCell(withIdentifier: "cell")
            as? ArcusTitleDetailTableViewCell

        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .none
        cell?.descriptionLabel!.text = WiFiCapability.getSsidFrom(deviceModel)

        return cell!
    }

    // MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowWifiSettingsModal" {
            if let removeViewController = segue.destination
                as? DeviceMoreRemoveWifiSwitchViewController {
                removeViewController.deviceModel = self.deviceModel
            }
        }
    }
}
