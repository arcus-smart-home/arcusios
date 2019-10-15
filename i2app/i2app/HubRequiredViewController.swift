//
//  HubRequiredViewController.swift
//  i2app
//
//  Created by Arcus Team on 2/19/18.
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

/// Modal that warns the user that a Hub is Required when a device is selected in the catalog
/// See "PairingCatalog.storyboard"
class HubRequiredViewController: UIViewController {

  @IBAction func didDismiss() {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }

  @IBAction func buyHubPressed() {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
    UIApplication.shared.open(NSURL.ProductsHub)
  }
}
