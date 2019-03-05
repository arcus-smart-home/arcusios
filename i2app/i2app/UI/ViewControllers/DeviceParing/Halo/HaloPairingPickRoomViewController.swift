//
//  HaloPairingPickRoomViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/31/16.
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

class HaloPairingPickRoomViewController: BasePairingViewController,
UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var nextButton: ArcusButton!

  var settingDictionary: OrderedDictionary = [:]

  var selectedIndex: NSInteger = NSNotFound

  @objc class func createWithDeviceStep(_ step: PairingStep,
                                        device: DeviceModel) -> HaloPairingPickRoomViewController {
    let vc: HaloPairingPickRoomViewController = (UIStoryboard(name: "PairHalo", bundle: nil)
      .instantiateViewController(withIdentifier: "HaloPairingPickRoomViewController")
      as? HaloPairingPickRoomViewController)!

    vc.setDeviceStep(step)
    vc.deviceModel = device

    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToParentColor()
    if self.deviceModel != nil {
      self.navBar(withBackButtonAndTitle: self.deviceModel.name)
    }
    self.navBar(withBackButtonAndTitle: self.deviceModel.name)
    self.tableView.backgroundColor = UIColor.clear
    self.tableView.tableFooterView = UIView()
    self.tableView.separatorColor = UIColor.black.withAlphaComponent(0.5)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.loadData()
  }

  func loadData() {
    self.settingDictionary =
      OrderedDictionary(dictionary: HaloCapability.getRoomNames(from: self.deviceModel))
    self.settingDictionary.sortArray()

    self.tableView.reloadData()
  }

  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.settingDictionary.count
  }

  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ArcusSimpleCheckableCell? =
      tableView.dequeueReusableCell(withIdentifier: "cell")!
        as? ArcusSimpleCheckableCell

    // Setting cell background color to clear to override controller settings
    // for cell making white background on iPad:
    cell!.backgroundColor = UIColor.clear
    let item = (self.settingDictionary.allValues[indexPath.item] as? String)!.uppercased()
    cell?.setTitle(item, checked: indexPath.row == self.selectedIndex)
    cell!.backgroundColor = UIColor.clear
    cell!.checkButton.tag = indexPath.row

    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if let cell: ArcusSimpleCheckableCell =
      self.tableView(self.tableView,
                     cellForRowAt: indexPath) as? ArcusSimpleCheckableCell {
      self.checkButtonPressed(cell.checkButton)
    }
  }

  @IBAction func checkButtonPressed(_ sender: UIButton) {
    self.selectedIndex = sender.tag
    self.tableView.reloadData()
  }

  override func nextButtonPressed(_ sender: Any?) {
    if self.selectedIndex == NSNotFound {
      self.displayErrorMessage("Selecting a room is required.", withTitle: "CHOOSE A ROOM")
      return
    }
    DispatchQueue.global(qos: .background).async {() -> Void in
      HaloCapability.setRoom((self.settingDictionary.allKeys[self.selectedIndex] as? String)!,
                             on: self.deviceModel)
      _ = self.deviceModel.commit().swiftThen ({ _ in
        self.tableView.reloadData()
        super.nextButtonPressed(sender)
        return nil
      })
    }
  }
}
