//
//  AlarmActivityViewController.swift
//  i2app
//
//  Created by Arcus Team on 12/12/16.
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

/**
 This view shows the history activity of the alarm system (Smoke, CO, & Water).
 Implements a filter to filter amongst Security, Smoke and CO, and Water events.
 Special items in the list called Incidents/Events are actually items that
 have even more data rolled up underneath them.

 Tapping on the filter area to the right hand side of the screen in the Filter
 section header provides a button that allows a user to select from Security & Panic, Smoke & CO,
 and Water Leak history views.

 The data provided back is determined by service level. Basic is 24 hours worth of history.

 If the given filter selected produces no data returned then show the user that they have no
 alarm, smoke or CO, or water leak activity.

 - seealso: `AlarmActivityPresenter` for the Presenter that drives this ViewController
 */
class AlarmActivityViewController: UIViewController, ArcusTabBarComponent, ClearTableConfigurator {

  @IBOutlet var segmentedControl: ArcusSegmentedControl!

  var presenter: AlarmActivityPresenterProtocol!

  @IBOutlet weak var tableView: UITableView!

  let headerIdentifier = "header"

  var popupWindow: PopupSelectionWindow!

  @IBOutlet weak var filterTitleLabel: UILabel!

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 90.0
    presenter = AlarmActivityPresenter(delegate: self)
    configureClearLayout()
    // This has to happen after configureClearLayout() otherwise it will get overwritten
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))

    tableView.register(UINib.init(nibName: "ArcusTwoLabelTableViewSectionHeader", bundle: nil),
                       forHeaderFooterViewReuseIdentifier: headerIdentifier)
    filterTitleLabel.text = presenter.selectedFilter.title
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.fetch()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsActivity)
    configureSegmentedControl(self.tabBarController)
  }

  // MARK: IBActions

  @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
    tabSegmentedControlValueChanged(sender)
  }

  @IBAction func filterPressed(_ sender: UIButton) {

    var models = [PopupSelectionModel]()
    for filter in AlarmActivityFilter.orderedValues {
      let numberVal = NSNumber(value: filter.rawValue)
      models.append(
        PopupSelectionModel.create(filter.title,
                                   value: nil,
                                   selected: (presenter.selectedFilter == filter),
                                   obj: numberVal))
    }

    let popupSelection: PopupSelectionTitleTableView = PopupSelectionTitleTableView.create("Choose and Alarm",
                                                                                           data: models)
    popupWindow = PopupSelectionWindow.popup(withBlock: view,
                                             subview: popupSelection,
                                             owner: self,
                                             close: { rawFilter in
                                              if let num = rawFilter as? NSNumber {
                                                let filterInt = num.intValue
                                                if let selection = AlarmActivityFilter(rawValue: filterInt) {
                                                  self.presenter.selectedFilter = selection
                                                }
                                              }
    })
  }

  // MARK: Segues

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let identifier = AlarmActivitySegueIdentifier(rawValue: identifier) else {
      fatalError("Don't preform undocumented segues")
    }
    // Catch .None here and don't perform it!
    switch identifier {
    case .None:
      return false
    default:
      return true

    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = AlarmActivitySegueIdentifier(rawValue: segue.identifier!) else {
      fatalError("Don't preform undocumented segues")
    }
    switch identifier {
    case .AlarmIncidentInformation:
      if let incidentAddress = sender as? String,
        let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem(),
        let alarmTrackerViewController: AlarmTrackerViewController = segue.destination
          as? AlarmTrackerViewController {
        alarmTrackerViewController.incidentPresenter = AlarmTrackerPresenter(
          delegate: alarmTrackerViewController,
          subsystemModel: alarmSubsystem,
          incidentId: incidentAddress)
      }
      return
    case .None:
      fatalError("None Should Not Be Used")
    }
  }
}

// MARK: UITableViewDelegate
extension AlarmActivityViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cells = presenter.data[indexPath.section].cells, cells.count > 0,
      let cellConfigure = cells[safe: indexPath.row],
      let incidentAddress = cellConfigure.incidentAddress else {
        return
    }
    let segueIdentifier = cellConfigure.destination
    if (self.shouldPerformSegue(withIdentifier: segueIdentifier.rawValue, sender: incidentAddress)) {
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsActivityIncident)
      self.performSegue(withIdentifier: segueIdentifier.rawValue, sender: incidentAddress)
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    let isLastSection = indexPath.section == self.numberOfSections(in: tableView) - 1
    let isLastRow = indexPath.row == self.tableView(tableView,
                                                    numberOfRowsInSection: indexPath.section) - 1
    if isLastSection && isLastRow {
      presenter.fetchNext()
    }
  }
}

// MARK: UITableViewDataSource
extension AlarmActivityViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.data.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let cells = presenter.data[section].cells, cells.count > 0 {
      return cells.count
    } else {
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let cells = presenter.data[indexPath.section].cells, cells.count > 0,
      let cellConfigure = cells[safe: indexPath.row] else {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmNoActivityCell.reuseIdentifier)!
        cell.backgroundColor = UIColor.clear
        return cell
    }

    if let cell = tableView.dequeueReusableCell(withIdentifier: AlarmActivityCell.reuseIdentifier,
                                                for: indexPath)
      as? AlarmActivityCell {
      self.configureCell(cell, withObject: cellConfigure)
      return cell
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 45
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let tableHeader =
      tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
        as? ArcusTwoLabelTableViewSectionHeader {
      tableHeader.mainTextLabel.text = presenter.data[section].title
      tableHeader.accessoryTextLabel.text = nil
      tableHeader.hasBlurEffect = true
      return tableHeader
    }
    return nil
  }

  func configureCell(_ cell: AlarmActivityCell,
                     withObject object: AlarmActivityCellViewModel) {
    cell.titleLabel.text = object.title
    cell.subtitleLabel.text = object.subtitle
    cell.timeLabel.text = object.time
    cell.moreIndicator.image = object.image
    switch object.cellType {
    case .expandable:
      cell.moreIndicator.isHidden = false
      cell.chevron.isHidden = false
    case .generic:
      cell.moreIndicator.isHidden = true
      cell.chevron.isHidden = true
    }
  }

}

// MARK: GenericPresenterDelegate
extension AlarmActivityViewController: GenericPresenterDelegate {
  func updateLayout() {
    DispatchQueue.main.async {
      if self.tableView != nil {
        self.filterTitleLabel.text = self.presenter.selectedFilter.title
        self.tableView.reloadData()
      }
    }
  }
}

extension AlarmActivityCellViewModel {
  var image: UIImage? {
    guard let incidentType = incidentType else { return UIImage(named: "SafetyIconWhite") }
    switch incidentType {
    case "CO Alarm":
      return UIImage(named: "co_icon_white")
    case "Smoke Alarm":
      return UIImage(named: "smoke_icon_white")
    case "Water Leak Alarm":
      return UIImage(named: "leak_icon_white")
    case "Security Alarm":
      return UIImage(named: "SafetyIconWhite")
    case "Panic Alarm":
      return UIImage(named: "SafetyIconWhite")
    default:
      return UIImage(named: "SafetyIconWhite")
    }
  }
}
