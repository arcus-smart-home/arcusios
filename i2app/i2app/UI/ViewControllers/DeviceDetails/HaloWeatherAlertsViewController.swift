//
//  HaloWeatherAlertsViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/7/16.
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

class HaloWeatherAlertsViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource, HaloEasCodesPresenterDelegate {

  var deviceModel: DeviceModel!
  var alerts: OrderedDictionary! = OrderedDictionary()

  var isDirty: Bool = false

  @IBOutlet weak var tableView: UITableView!

  var myAlerts: OrderedDictionary = [:]
  var popularAlerts: OrderedDictionary! = [:]
  var moreAlerts: OrderedDictionary! = [:]

  @objc class func create(_ deviceModel: DeviceModel) -> HaloWeatherAlertsViewController {
    let viewController: HaloWeatherAlertsViewController? = UIStoryboard(name: "DeviceDetailSettingHalo",
                                                                        bundle:nil)
      .instantiateViewController(withIdentifier: "HaloWeatherAlertsViewController")
      as? HaloWeatherAlertsViewController
    viewController?.deviceModel = deviceModel
    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToLastNavigateColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
    self.navBar(withBackButtonAndTitle: "Weather Alerts")

    self.tableView.register(UINib(nibName: "ArcusTwoLabelTableViewSectionHeader",
                                  bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "sectionHeader")

    DispatchQueue.global(qos: .background).async {
      HaloEasCodesPresenter.getEasCodes(self)
    }
  }

  func back(_ sender: NSObject) {
    if self.isDirty {
      var codes: [String] = [String]()
      for easCode in (self.myAlerts.allValues as? [EasCode])! {
        codes.append(easCode.easCode)
      }
      self.createGif()
      DispatchQueue.global(qos: .background).async {
        HaloEasCodesPresenter
          .setSelectedEasCodes(codes,
                               deviceModel: self.deviceModel,
                               completionBlock: { success in
                                if success {
                                  self.hideGif()
                                  self.navigationController?.popViewController(animated: true)
                                } else {
                                  self.displayGenericErrorMessage()
                                }
          })
      }
      return
    }
    DispatchQueue.main.async {
      self.navigationController!.popViewController(animated: true)
    }
  }
  // MARK: - UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if self.myAlerts.count == 0 {
        return 1
      }
      return self.myAlerts.count
    } else if section == 1 {
      return self.popularAlerts.count
    }
    return self.moreAlerts.count
  }

  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 && self.myAlerts.count == 0 {
      let cellIdentifier: String = "emptyMyAlertsCell"
      let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!

      cell.backgroundColor = UIColor.clear
      return cell
    }

    let cellIdentifier: String = "cell"
    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusSelectOptionTableViewCell

    cell?.backgroundColor = UIColor.clear

    cell?.selectionStyle = .none
    cell?.managesSelectionState = false

    if indexPath.section == 0 {
      cell?.titleLabel.text = (myAlerts.allKeys[indexPath.row] as? String)!
      cell?.selectionImage.isHighlighted = true
    } else if indexPath.section == 1 {
      cell?.titleLabel.text = (popularAlerts.allKeys[indexPath.row] as? String)!
    } else {
      cell?.titleLabel.text = (moreAlerts.allKeys[indexPath.row] as? String)!
    }
    return cell!
  }

  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var header: ArcusTwoLabelTableViewSectionHeader? =
      tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader")
        as? ArcusTwoLabelTableViewSectionHeader
    if header == nil {
      header = ArcusTwoLabelTableViewSectionHeader(reuseIdentifier: "sectionHeader")
    }

    header?.hasBlurEffect = true
    header?.backingView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

    switch section {
    case 0:
      header?.mainTextLabel.text = "My Alerts"
      break
    case 1:
      header?.mainTextLabel.text = "Popular Alerts"
      break
    case 2:
      header?.mainTextLabel.text = "More Alerts"
      break
    default:
      break
    }
    header?.mainTextLabel.textColor = UIColor.white
    header?.accessoryTextLabel.text = ""

    return header
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 && self.myAlerts.count == 0 {
      return 70
    }
    return 55
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    isDirty = true

    if indexPath.section == 0 {
      let easCode: EasCode = (self.myAlerts.allValues[indexPath.row] as? EasCode)!
      // Remove it from MyAlerts
      self.myAlerts.removeObject(forKey: easCode.name)

      // Add it back to the array that it belongs to
      if easCode.group == "Other" {
        self.moreAlerts.setObject(easCode, forKey: easCode.name as NSCopying)
        self.moreAlerts.sortArray()
      } else {
        self.popularAlerts.setObject(easCode, forKey: easCode.name as NSCopying)
        self.popularAlerts.sortArray()
      }
    } else {
      var easCode: EasCode!
      // And remove it from its current array
      if indexPath.section == 1 {
        easCode = (self.popularAlerts.allValues[indexPath.row] as? EasCode)!
        self.popularAlerts.removeObject(forKey: easCode.name)
      } else {
        easCode = (self.moreAlerts.allValues[indexPath.row] as? EasCode)!
        self.moreAlerts.removeObject(forKey: easCode.name)
      }
      // We need to add it to My Alerts
      self.myAlerts.setObject(easCode, forKey: easCode.name as NSCopying)
      self.myAlerts.sortArray()
    }
    self.tableView.reloadData()
  }
}

//MARK - HaloEasCodesPresenterDelegate
extension HaloWeatherAlertsViewController {
  func getEasCodes(_ alertCodes: [EasCode]) {
    if self.deviceModel.getAttribute(kAttrWeatherRadioAlertsofinterest) != nil {
      let myCodes: [String] =
        (WeatherRadioCapability.getAlertsofinterestFrom(self.deviceModel) as? [String])!
      for alertCode in alertCodes {
        let results = myCodes.filter { $0 == alertCode.easCode }
        if results.count > 0 {
          self.myAlerts.setObject(alertCode, forKey: alertCode.name as NSCopying)
        } else if alertCode.group == "Other" {
          self.moreAlerts.setObject(alertCode, forKey: alertCode.name as NSCopying)
        } else {
          self.popularAlerts.setObject(alertCode, forKey: alertCode.name as NSCopying)
        }
      }
      self.myAlerts.sortArray()
      self.moreAlerts.sortArray()
      self.popularAlerts.sortArray()

    } else {
      for alertCode in alertCodes {
        if alertCode.group == "Other" {
          self.moreAlerts.setObject(alertCode, forKey: alertCode.name as NSCopying)
        } else {
          self.popularAlerts.setObject(alertCode, forKey: alertCode.name as NSCopying)
        }
      }
      self.moreAlerts.sortArray()
      self.popularAlerts.sortArray()
    }
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
