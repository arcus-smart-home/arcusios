//
//  HubOrKitSelectionViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/10/18.
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

enum KitSegues: String {
  case v3Kit
  case v2Kit
  case v3Hub
  case v2Hub
}

class HubOrKitSelectionViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? HubPairingStepsParentViewController {
      if segue.identifier == KitSegues.v3Hub.rawValue {
        vc.hubVersion = .version3
      } else if segue.identifier == KitSegues.v2Hub.rawValue {
        vc.hubVersion = .version2
      }
    }
  }
}
