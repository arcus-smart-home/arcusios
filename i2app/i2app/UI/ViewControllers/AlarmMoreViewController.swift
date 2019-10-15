//
//  AlarmMoreViewController.swift
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
 This AlarmMoreViewController is broke down into three sections:

 * Global Settings (Alarm Subsystem)
 * Security Settings
 * Water Leak Settings

 - seealso: `AlarmMorePresenter` for the Presenter that drives this ViewController
 */
class AlarmMoreViewController: UIViewController,
  ArcusTabBarComponent,
  SimpleTableViewGenericPresenterDelegate,
  ClearTableConfigurator {

  @IBOutlet var segmentedControl: ArcusSegmentedControl!
  @IBOutlet weak var tableView: UITableView!

  var presenter: AlarmMorePresenterProtocol!

  let headerIdentifier = "header"

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AlarmMorePresenter(delegate: self)
    tableView.register(UINib.init(nibName: AlarmMoreTableViewSectionHeader.reuseIdentifier, bundle: nil),
                       forHeaderFooterViewReuseIdentifier: headerIdentifier)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70.0
    configureClearLayout()

    // This has to happen after configureClearLayout() otherwise it will get overwritten
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configureSegmentedControl(self.tabBarController)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.fetch()
  }

  // MARK: IBActions

  @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
    tabSegmentedControlValueChanged(sender)
  }

  // MARK: SimpleTableViewGenericPresenterDelegate
  // func updateLayout() should be handled via the extension

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let identifier = AlarmMoreSegueIdentifier(rawValue: identifier) else {
      fatalError("Don't preform undocumented segues")
    }
    switch identifier {
    case .None:
      return false
    default:
      return true
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let stringID = segue.identifier,
      let identifier = AlarmMoreSegueIdentifier(rawValue: stringID) else {
        fatalError("Don't preform undocumented segues")
    }
    // Catch .None here
    switch identifier {

    case .AlarmSounds: break
    case .NotificationList: break
    case .GracePeriod: break
    case .AlarmRequirements: break
    case .AlarmRequirementsInfo: break
    case .None:
      fatalError("None Should Not Be Used")
    }
  }

  func didToggle(Switch toggle: UISwitch) {
    let cell = toggle.superTableViewCell!
    let indexPath = self.tableView.indexPath(for: cell)!
    presenter.toggleObject(toggle.isOn, atIndexPath: indexPath)
  }

  @IBAction func discoverMorePressed() {
    UIApplication.shared.open(AlarmMoreConstants.discoverMoreUrl as URL)
  }

  deinit {
    presenter = nil
  }
}

extension AlarmMoreViewController : StoryboardCreatable {
  class var storyboardName: String { return "AlarmMore" }
  class var storyboardIdentifier: String { return "AlarmMoreViewController" }
}

extension AlarmMoreSection {
  var images: [UIImage] {
    return self.imageNames.map({name -> UIImage in
      return UIImage(named: name)!
    })
  }

  static func bind(_ header: AlarmMoreTableViewSectionHeader, section: AlarmMoreSection) {
    header.titleLabel.text = section.title
    header.hasBlurEffect = true
    header.setImages(section.images)
  }
}

extension AlarmMoreViewController : UITableViewDelegate {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let data = presenter.data else {
      // One Section if no data to display the Discover More Cell
      return nil
    }
    let section = data[section]
    if let tableHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
      as? AlarmMoreTableViewSectionHeader {
      AlarmMoreSection.bind(tableHeader, section: section)
      return tableHeader
    }
    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard presenter.data != nil else {
      // One Section if no data to display the Discover More Cell
      return 0
    }
    return 44
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let data = presenter.data else {
      // Can't select the Discover More Cell
      return
    }
    let cellConfigure = data[indexPath.section].cells[indexPath.row]

    let segueIdentifier = cellConfigure.destination
    if (self.shouldPerformSegue(withIdentifier: segueIdentifier.rawValue, sender: self)) {
      self.performSegue(withIdentifier: segueIdentifier.rawValue, sender: self)
    }
  }
}

extension AlarmMoreViewController : UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    guard let data = presenter.data else {
      // One Section if no data to display the Discover More Cell
      return 1
    }
    return data.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let data = presenter.data else {
      // One Row if no data to display the Discover More Cell
      return 1
    }
    let section = data[section]
    return section.cells.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let data = presenter.data else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmMoreDiscoverCell",
                                               for: indexPath)
      cell.backgroundColor = UIColor.clear
      return cell
    }
    let cellConfigure = data[indexPath.section].cells[indexPath.row]

    if let cell = tableView.dequeueReusableCell(withIdentifier: AlarmMoreGenericTableViewCell.reuseIdentifier,
                                                for: indexPath)
      as? AlarmMoreGenericTableViewCell {
      self.configureCell(cell, withObject: cellConfigure)
      return cell
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return false
  }

  func configureCell(_ cell: AlarmMoreGenericTableViewCell, withObject object: AlarmMoreCellViewModel) {
    cell.backgroundColor = UIColor.clear
    cell.titleLabel.text = object.title
    cell.subtitleLabel.text = object.subtitle
    switch object.type {
    case .toggle:
      cell.chevronView.isHidden = true
      cell.toggleSwitch.isHidden = false
      cell.toggleSwitch.isOn = object.toggled
      cell.toggleSwitch.addTarget(self,
                                  action: #selector(AlarmMoreViewController.didToggle(Switch:)),
                                  for: .valueChanged)
    default:
      cell.chevronView.isHidden = false
      cell.toggleSwitch.isHidden = true
      cell.toggleSwitch.removeTarget(self,
                                     action: #selector(AlarmMoreViewController.didToggle(Switch:)),
                                     for: .valueChanged)
    }
    cell.setNeedsLayout()
  }
}
