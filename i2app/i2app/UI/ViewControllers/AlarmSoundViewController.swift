//
//  AlarmSoundViewController.swift
//  i2app
//
//  Created by Arcus Team on 1/6/17.
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

class AlarmSoundViewController: UIViewController,
 SimpleTableViewGenericPresenterDelegate, ClearTableConfigurator {

  @IBOutlet weak var tableView: UITableView!

  var presenter: AlarmSoundTogglePresenterProtocol!

  override func viewDidLoad() {
    super.viewDidLoad()
    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsGlobalSounds)
    
    presenter = AlarmSoundTogglePresenter(delegate: self)
    configureClearLayout()

    // This has to happen after configureClearLayout() otherwise it will get overwritten
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))

    presenter.fetch()
  }

  func didToggle(Switch toggle: UISwitch) {
    let cell = toggle.superTableViewCell!
    let indexPath = self.tableView.indexPath(for: cell)!
    presenter.toggleObject(toggle.isOn, atIndex:indexPath.row)
  }
}

// MARK: UITableViewDelegate
extension AlarmSoundViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

// MARK: UITableViewDataSource
extension AlarmSoundViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let data = presenter.data else {
      return 0
    }
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let data = presenter.data else {
      return UITableViewCell()
    }

    let cellConfigure = data[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: AlarmToggleSoundTableViewCell.reuseIdentifier,
                                             for: indexPath)
    self.configureCell(cell, withObject: cellConfigure)
    return cell
  }

  func configureCell(_ cell: UITableViewCell, withObject object: AlarmSoundToggleViewModel) {
    guard let cell = cell as? AlarmToggleSoundTableViewCell else {
      fatalError("Cell is misconfirgured")
    }
    cell.backgroundColor = UIColor.clear
    cell.alarmNameLabel.text = object.type.title
    cell.toggle.isOn = object.alarmWillSound
    cell.toggle.removeTarget(self, action: nil, for: .valueChanged)
    cell.toggle.addTarget(self,
                          action: #selector(AlarmSoundViewController.didToggle(Switch:)),
                          for: .valueChanged)
  }
}
