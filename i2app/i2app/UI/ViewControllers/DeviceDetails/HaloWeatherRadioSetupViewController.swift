//
//  HaloWeatherRadioSetupViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/20/16.
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

class HaloWeatherRadioSetupViewController: UITableViewController {

  var deviceModel: DeviceModel!

  class func create(_ deviceModel: DeviceModel) -> HaloWeatherRadioSetupViewController {
    let viewController: HaloWeatherRadioSetupViewController? =
      UIStoryboard(name: "DeviceDetailSettingHalo", bundle:nil)
        .instantiateViewController(withIdentifier: "HaloWeatherRadioSetupViewController")
        as? HaloWeatherRadioSetupViewController
    viewController?.deviceModel = deviceModel
    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToLastNavigateColor()

    navBar(withBackButtonAndTitle: "Weather Radio")

    tableView.tableFooterView = UIView()
    view.bringSubview(toFront: tableView)
  }

  override func tableView(_ tableView: UITableView,
                          willDisplay cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if indexPath.row == 0 {
      let vc: UIViewController = HaloPlusPickCountyViewController.createWithDevice(deviceModel)
      navigationController?.pushViewController(vc, animated: true)
    } else {
      if deviceModel.getAttribute(kAttrWeatherRadioLocation) != nil
        && WeatherRadioCapability.getLocationFrom(deviceModel).count > 0 {
        let vc: UIViewController = HaloPlusPickWeatherStationViewController.create(deviceModel)
        navigationController?.pushViewController(vc, animated: true)
      } else {
        displayErrorMessage("You must select a state and a " +
          "county in order to identify the location for the weather radio.",
                            withTitle:"Location Information")
      }
    }
  }
}
