//
//  PendantCoverageInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/30/16.
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

class PendantCoverageInfoViewController: BaseDeviceStepViewController {

    @IBOutlet weak var nextButton: UIButton!

    @objc class func createWithDeviceStep(_ step: PairingStep,
                                          device: DeviceModel) -> PendantCoverageInfoViewController {
        if let vc: PendantCoverageInfoViewController = UIStoryboard(name: "PairDevice", bundle: nil)
            .instantiateViewController(withIdentifier: "PendantCoverageInfoViewController")
          as? PendantCoverageInfoViewController {
          vc.setDeviceStep(step)
          vc.deviceModel = device

          return vc
      }
      return PendantCoverageInfoViewController()
    }

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackgroundColorToLastNavigateColor()
        self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

        self.navBar(withBackButtonAndTitle: DevicePairingManager.sharedInstance().currentDevice.name)

        nextButton.styleSet("NEXT", andButtonType: FontDataTypeButtonDark)
    }

    @IBAction func nextPressed(_ sender: AnyObject) {
        if self.deviceModel != nil {
            DevicePairingManager .sharedInstance().mark(asUpdated: self.deviceModel)
        }

        self.nextButtonPressed(sender)
    }
}
