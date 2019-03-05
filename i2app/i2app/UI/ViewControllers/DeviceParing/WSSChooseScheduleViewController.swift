//
//  WSSChooseScheduleViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/10/16.
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

class WSSChooseScheduleViewController: BaseDeviceStepViewController, PostPairingSchedulerUIProtocol {

  // MARK: View Life Cycle
  class func create() -> WSSChooseScheduleViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "PairDevice", bundle:nil)
    let viewController: WSSChooseScheduleViewController? =
      storyboard.instantiateViewController(withIdentifier: String(
        describing: WSSChooseScheduleViewController.self))
        as? WSSChooseScheduleViewController

    return viewController!
  }

  class func create(_ pairingStep: PairingStep) -> WSSChooseScheduleViewController {
    let viewController: WSSChooseScheduleViewController =
      WSSChooseScheduleViewController.create()
    viewController.setDeviceStep(pairingStep)

    return viewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    DevicePairingManager.sharedInstance().stopSubscribingToNofitications()
    DevicePairingManager.sharedInstance().pairingProcessDone()

    configureNavigationBar(self, title: self.navigationItem.title!, showClose: false)
    configureBackgroundView(self)
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PostPairSelectStartSegue" {
      if let chooseStartViewController = segue.destination as? WSSChooseScheduleStartViewController {
        if let device = DevicePairingManager.sharedInstance().currentDevice {
          chooseStartViewController.scheduler = WSSPostPairingScheduler(device)
        }
      }
    }
  }
}
