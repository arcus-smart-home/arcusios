//
//  ProMonNewAlarmActivated.swift
//  i2app
//
//  Arcus Team on 2/10/17.
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

class ProMonNewAlarmActivatedViewController: BasePairingViewController, UITableViewDataSource {

  @IBOutlet weak var authoritiesMayCome: UILabel!
  @IBOutlet weak var activatedAlarmsTable: UITableView!

  // swiftlint:disable:next line_length
  @objc override class func create(withDeviceStep step: PairingStep) -> ProMonNewAlarmActivatedViewController {
    let vc: ProMonNewAlarmActivatedViewController = (UIStoryboard(name: "PairDevice", bundle: nil)
      .instantiateViewController(withIdentifier: "ProMonNewAlarmActivatedViewController")
      as? ProMonNewAlarmActivatedViewController)!

    vc.setDeviceStep(step)
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let currentPlace = RxCornea.shared.settings?.currentPlace {
      authoritiesMayCome.text = authoritiesMayCome.text!
        .replacingOccurrences(of: "<placename>", with: currentPlace.name)
    }

    activatedAlarmsTable.dataSource = self
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DevicePairingManager.sharedInstance().alertsActivatedDuringPairing().count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let alert = DevicePairingManager.sharedInstance()
      .alertsActivatedDuringPairing()[indexPath.row] as? String {
      return tableView.dequeueReusableCell(withIdentifier: alert)!
    }
    return UITableViewCell()
  }

  @IBAction func onWhatToExpectTapped(_ sender: AnyObject) {
    UIApplication.shared.open(URL(string: "")!)
  }
}
