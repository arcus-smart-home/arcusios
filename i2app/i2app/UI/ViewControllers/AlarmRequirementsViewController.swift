//
//  AlarmRequirementsViewController.swift
//  i2app
//
//  Created by Arcus Team on 1/10/17.
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

class AlarmRequirementsViewController: UIViewController,
  SimpleTableViewGenericPresenterDelegate,
ClearTableConfigurator {

  @IBOutlet weak var tableView: UITableView!

  var presenter: AlarmRequirementsPresenterProtocol!
  var popupWindow: PopupSelectionWindow!
  let showAlarmRequirementsSegue = "ShowAlarmRequirementsInfo"

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 70.0
    presenter = AlarmRequirementsPresenter(delegate: self)
    configureClearLayout()
    presenter.fetch()

    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsRequirements)
  }

}

extension AlarmRequirementsViewController : UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 1 else {
      return
    }

    let alarm = presenter.data.requirements[indexPath.row]
    guard alarm.canChange else {
      return
    }

    let min = CGFloat(1.0)
    let max = CGFloat(alarm.motionSensorCount)
    let current = NSNumber(integerLiteral: alarm.toTrigger)

    if max == 0 {
      self.performSegue(withIdentifier: showAlarmRequirementsSegue, sender: self)
    } else {

      // Ugh. PopupSelectionNumberView should not try to be smarter than its caller (i.e., ignoreMinMaxRule)
      // If there's a rule, let the caller implement the rule, not the popup
      let popupSelection = PopupSelectionNumberView.create("Choose Number of Devices",
                                                           withMinNumber: min,
                                                           maxNumber: max,
                                                           andPostfix: "",
                                                           ignoreMinMaxRule: true)
      popupSelection?.setCurrentKey(current)

      popupWindow = PopupSelectionWindow
        .popup(withBlock: view,
               subview: popupSelection,
               owner: self) { selection in
                if let sel = selection as? Int {
                  if indexPath.row == 0 {
                    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsRequirementsOn)
                    self.presenter.setAlarmOnCount(sel)
                  } else {
                    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsRequirementsPartial)
                    self.presenter.setPartialOnCount(sel)
                  }
                }
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
}

extension AlarmRequirementsViewController : UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 || section == 2 {
      return 1
    } else {
      return 2
    }
  }

  // TODO: Remove Headers and Footers from TableViewCells
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Display a header cell
    if indexPath.section == 0 {
      if let cell = tableView.dequeueReusableCell(withIdentifier: AlarmRequirementsHeaderCell.reuseIdentifier,
                                                  for: indexPath) as? AlarmRequirementsHeaderCell {
        cell.backgroundColor = UIColor.clear
        return cell
      }
    } else if indexPath.section == 1 {
      // else is an alarm cell
      if let cell = tableView.dequeueReusableCell(withIdentifier: AlarmRequirementsChangeCell.reuseIdentifier,
                                               for: indexPath) as? AlarmRequirementsChangeCell {
        let alarm = presenter.data.requirements[indexPath.row]
        cell.titleLabel.text = alarm.title
        cell.numberParticipatingLabel.text = alarm.displayToTrigger
        cell.chevronView?.isHidden = alarm.motionSensorCount == 0

        // To set the last row's seperator to be full width while others match the titleLabel
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1 {
          cell.leadingToEdgeConstraint.isActive = true
          cell.leadingToTitleConstraint.isActive = false
        } else {
          cell.leadingToEdgeConstraint.isActive = false
          cell.leadingToTitleConstraint.isActive = true
        }
        // Consider adding `view.layoutIfNeeded()` because http://stackoverflow.com/a/28717185/283460
        cell.backgroundColor = UIColor.clear
        return cell
      }
    } else { /*if indexPath.section == 2 { */
      if let cell = tableView.dequeueReusableCell(withIdentifier: AlarmRequirementsFooterCell.reuseIdentifier,
                                                  for: indexPath) as? AlarmRequirementsFooterCell {
        cell.backgroundColor = UIColor.clear
        return cell
      }
    }

    return UITableViewCell()
  }
}
