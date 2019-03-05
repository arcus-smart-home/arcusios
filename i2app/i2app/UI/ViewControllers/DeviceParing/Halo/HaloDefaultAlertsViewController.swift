//
//  HaloDefaultAlertsViewControllerr.swift
//  i2app
//
//  Created by Arcus Team on 9/1/16.
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

class HaloDefaultAlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
HaloEasCodesPresenterDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var alerts: [EasCode]!

    @objc class func create() -> HaloDefaultAlertsViewController {
        let vc: HaloDefaultAlertsViewController = (UIStoryboard(name: "PairHalo", bundle: nil)
            .instantiateViewController(withIdentifier: "HaloDefaultAlertsViewController")
            as? HaloDefaultAlertsViewController)!

        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackgroundColorToDashboardColor()
        self.navBar(withBackButtonAndTitle: "Default Emergency & Weather Alerts")
        self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

        if UIDevice.isIPhone5() {
            self.titleLabel.text =
                self.titleLabel.text?.replacingOccurrences(of: "\n", with: " ")
        }
        HaloEasCodesPresenter.getEasCodes(self)
    }

    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.alerts == nil {
            return 0
        }
        return self.alerts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? =
            UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell?.backgroundColor = UIColor.clear

        // cell?.textLabel?.text = self.alerts[indexPath.row]
        cell?.textLabel?.alpha = 0.6
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.attributedText = FontData.getString(self.alerts[indexPath.row].name,
                                        withFont: FontDataType_Medium_14_BlackAlpha_NoSpace)

        return cell!
    }
}

//MARK - HaloEasCodesPresenterDelegate
extension HaloDefaultAlertsViewController {
    func getEasCodes(_ states: [EasCode]) {
        DispatchQueue.main.async {
            self.alerts = [
                EasCode(easCode: "", name: "Avalanche Warning", group: ""),
                EasCode(easCode: "", name: "Biological Hazard Warning", group: ""),
                EasCode(easCode: "", name: "Blizzard Warning", group: ""),
                EasCode(easCode: "", name: "Chemical Hazard Warning", group: ""),
                EasCode(easCode: "", name: "Civil Danger Warning", group: ""),
                EasCode(easCode: "", name: "Civil Emergency Message", group: ""),
                EasCode(easCode: "", name: "Coastal Flood Warning", group: ""),
                EasCode(easCode: "", name: "Contagious Disease Warning", group: ""),
                EasCode(easCode: "", name: "Contaminated Water Warning", group: ""),
                EasCode(easCode: "", name: "Dam Break Warning", group: ""),
                EasCode(easCode: "", name: "Dam Watch", group: ""),
                EasCode(easCode: "", name: "Dust Storm Warning", group: ""),
                EasCode(easCode: "", name: "Earthquake Warning", group: ""),
                EasCode(easCode: "", name: "Emergency Action Notification", group: ""),
                EasCode(easCode: "", name: "Emergency Action Termination", group: ""),
                EasCode(easCode: "", name: "Evacuation Immediate", group: ""),
                EasCode(easCode: "", name: "Extreme Wind Warning", group: ""),
                EasCode(easCode: "", name: "Fire Warning", group: ""),
                EasCode(easCode: "", name: "Flash Flood Warning", group: ""),
                EasCode(easCode: "", name: "Flash Freeze Warning", group: ""),
                EasCode(easCode: "", name: "Flood Warning", group: ""),
                EasCode(easCode: "", name: "Food Contamination Warning", group: ""),
                EasCode(easCode: "", name: "Freeze Warning", group: ""),
                EasCode(easCode: "", name: "Hazardous Materials Warning", group: ""),
                EasCode(easCode: "", name: "High Wind Warning", group: ""),
                EasCode(easCode: "", name: "Hurricane Warning", group: ""),
                EasCode(easCode: "", name: "Industrial Fire Warning", group: ""),
                EasCode(easCode: "", name: "Land Slide Warning", group: ""),
                EasCode(easCode: "", name: "Law Enforcement Warning", group: ""),
                EasCode(easCode: "", name: "Local Area Emergency", group: ""),
                EasCode(easCode: "", name: "Nuclear Power Plant Warning", group: ""),
                EasCode(easCode: "", name: "Radiological Hazard Warning", group: ""),
                EasCode(easCode: "", name: "Severe Thunderstorm Warning", group: ""),
                EasCode(easCode: "", name: "Shelter In-place Warning", group: ""),
                EasCode(easCode: "", name: "Storm Surge Warning", group: ""),
                EasCode(easCode: "", name: "Tornado Warning", group: ""),
                EasCode(easCode: "", name: "Tropical Storm Warning", group: ""),
                EasCode(easCode: "", name: "Tsunami Warning", group: ""),
                EasCode(easCode: "", name: "Tsunami Watch", group: ""),
                EasCode(easCode: "", name: "Unrecognized Warning", group: ""),
                EasCode(easCode: "", name: "Volcano Warning", group: ""),
                EasCode(easCode: "", name: "Wild Fire Warning", group: ""),
                EasCode(easCode: "", name: "Winter Storm Warning", group: "")]
            self.tableView.reloadData()
        }

// TODO: Disabling platform-provided EAS codes for 1.16 release
//        dispatch_async(dispatch_get_main_queue()) {
//            self.alerts = states
//            self.tableView.reloadData()
//        }
    }
}
