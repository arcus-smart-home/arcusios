//
//  MispairedDeviceViewController.swift
//  i2app
//
//  Arcus Team on 4/30/18.
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

class MispairedDeviceViewController: MispairedBaseViewController {
  
  @IBOutlet weak var descriptionLabel: UILabel!

  override func viewWillAppear(_ animated: Bool) {
  
    // Modify descriptive text when dealing with mispaired Hue
    if mispairedDev?.isPhilipsHue() ?? false {
      
      if let productName = mispairedDev?.productName() {
        let vowels: [Character] = ["a","e","i","o","u"]
        var preamble = "A \(productName) was found."
        
        if vowels.contains(productName.lowercased().first ?? " ") {
          preamble = "An \(productName) was found."
        }
        
        descriptionLabel.text = "\(preamble) To fix the issue, remove the device from Arcus and pair it to the Hue Bridge. Then re-pair the Hue Bridge to Arcus."
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let confirmVc = segue.destination as? MispairedConfirmationViewController {
      confirmVc.delegate = self
    }
  }
  
}

extension MispairedDeviceViewController: ConfirmationDelegate {

  func onConfirmed() {
    self.performSegue(withIdentifier: MispairedSegues.segueToRemove.rawValue, sender: nil)
  }
  
  func onRejected() {
    // Nothing to do
  }
}
