//
//  AlarmGracePeriodsViewController.swift
//  i2app
//
//  Created by Arcus Team on 1/9/17.
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

class AlarmGracePeriodsViewController: UIViewController,
  SimpleTableViewGenericPresenterDelegate,
ClearTableConfigurator {

  @IBOutlet weak var tableView: UITableView!

  var presenter: AlarmGracePeriodsPresenterProtocol!

  var popupWindow: PopupSelectionWindow!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 90.0
    presenter = AlarmGracePeriodsPresenter(delegate: self)
    configureClearLayout()

    // This has to happen after configureClearLayout() otherwise it will get overwritten
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    
    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsMoreGrace)
  }

  func didToggle(Switch toggle: UISwitch) {
    presenter.toggleShouldSound(toggle.isOn)
  }
}

extension AlarmGracePeriodsViewController : UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 1 else {
      return
    }
    let cell = tableView.cellForRow(at: indexPath)!
    cell.setSelected(false, animated: true)
    let gracePeriod = presenter.data.timeIntervals[indexPath.row]
    let currentDelay = Int32( gracePeriod.interval )
    let selectedDelayToDate = NSDate(forTotalDelaySeconds: currentDelay)
    let popupSelection: PopupSelectionMinsTimerView =
      PopupSelectionMinsTimerView.create("Delay",
                                         with:selectedDelayToDate as Date!,
                                         withMaxMinutes: 10)

    popupWindow = PopupSelectionWindow
      .popup(withBlock: view,
             subview: popupSelection,
             owner: self,
             close: { delay in
              if let delayDate = delay as? NSDate {
                let secondsToDelay = Int(delayDate.getSeconds())
                self.presenter.timeIntervalOfType(gracePeriod.type,
                                                  didChangeToInterval: secondsToDelay)
              }
      })
  }
}

extension AlarmGracePeriodsViewController : UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return presenter.data.timeIntervals.count
    }
  }

  // TODO: Remove Header and Footer from TableViewCells
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    // Display a header cell
    if indexPath.section == 0 {
      if let cell = tableView.dequeueReusableCell(withIdentifier: GracePeriodSoundsToggleCell.reuseIdentifier,
                                                  for: indexPath) as? GracePeriodSoundsToggleCell {
        if cell.toggle.actions(forTarget: self, forControlEvent: .valueChanged) == nil {
          cell.toggle.addTarget(self,
                                action: #selector(AlarmGracePeriodsViewController.didToggle(Switch:)),
                                for: .valueChanged)
        }
        cell.toggle.isOn = presenter.data.shouldSound
        cell.backgroundColor = UIColor.clear

        return cell
      }
    }

    // else is an Alarm Cell
    let cellConfigure = presenter.data.timeIntervals[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: GracePeriodDelaySelectCell.reuseIdentifier,
                                                for: indexPath)
    self.configureCell(cell, withObject: cellConfigure)
    return cell
  }

  func configureCell(_ cell: UITableViewCell, withObject object: GracePeriodTimeInterval) {
    guard let cell = cell as? GracePeriodDelaySelectCell else {
      fatalError("Cell is misconfirgured")
    }
    cell.backgroundColor = UIColor.clear
    cell.titleLabel.text = object.type.title
    cell.subtitleLabel.text = object.type.subtitle
    cell.timeIntervalLabel.text = object.stringForInterval
  }
}
