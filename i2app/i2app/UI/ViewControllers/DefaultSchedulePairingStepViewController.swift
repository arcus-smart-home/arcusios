//
//  DefaultSchedulePairingStepViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/29/17.
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

class DefaultSchedulePairingStepViewController: BasePairingViewController {
  // swiftlint:disable line_length
  @objc override class func create(withDeviceStep step: PairingStep) -> DefaultSchedulePairingStepViewController {
    let storyboard = UIStoryboard(name: "PairDevice", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "DefaultSchedulePairingStepViewController")
      as? DefaultSchedulePairingStepViewController else {
        print("DefaultSchedulePairingStepViewController could not be created")
        return DefaultSchedulePairingStepViewController()
    }
    vc.setDeviceStep(step)
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let title = NSLocalizedString("DEFAULT SCHEDULE", comment: "")
    self.setNavBarTitle(title)
  }
}
