//
//  FactoryResetConfirmationViewController.swift
//  i2app
//
//  Arcus Team on 5/8/18.
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

class FactoryResetConfirmationViewController: FactoryResetBaseViewController {

  let presenter = FactoryResetConfirmationPresenter()

  override func viewDidLoad() {
    super.viewDidLoad()
  
    presenter.delegate = self
    presenter.startMonitoringForTimeout()
  }

  override func viewWillDisappear(_ animated: Bool) {
    presenter.stopMonitoringForTimeout()
  }
}

extension FactoryResetConfirmationViewController: FactoryResetConfirmationDelegate {
  func onPairingTimeout() {
    performSegue(withIdentifier: FactoryResetSegues.unwindToPairingCartSegue.rawValue,
                 sender: nil)
  }
}

enum FactoryResetSegues: String {
  case unwindToPairingCartSegue = "UnwindToPairingCart"
}
