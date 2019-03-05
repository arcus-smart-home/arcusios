//
//  ProMonNoAgenciesViewController.swift
//  i2app
//
//  Arcus Team on 5/12/17.
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

class ProMonNoAgenciesViewController: UIViewController, ContactSupportHandler {

  class func create() -> ProMonNoAgenciesViewController {
    if let vc: ProMonNoAgenciesViewController = UIStoryboard(name: "PlacesPeopleSettings", bundle: nil)
      .instantiateViewController(withIdentifier: "ProMonNoAgencies")
      as? ProMonNoAgenciesViewController {
      return vc
    }
    return ProMonNoAgenciesViewController()
  }

  @IBAction func onClose(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction func onCallSupport(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    contactMonitoringSupport()
  }
}
