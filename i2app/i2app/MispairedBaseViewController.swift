//
//  MispairedBaseViewController.swift
//  i2app
//
//  Arcus Team on 4/20/18.
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

public class MispairedBaseViewController: UIViewController {

  var mispairedDev: PairingDeviceModel? {
    get {
      return (self.navigationController as? MispairedNavigationController)?.mispairedDev
    }
    set {
      (self.navigationController as? MispairedNavigationController)?.mispairedDev = mispairedDev
    }
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    // Apply default title when subclass doesn't provide one
    if navigationItem.title?.isEmpty ?? true {
      navigationItem.title = "Remove"
    }
    
    addScleraStyleToNavigationTitle()
    removeScleraBackButton()
  }

  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == MispairedSegues.segueToRemove.rawValue {
      segue.destination.navigationItem.title = "Remove Device"
    } else if segue.identifier == MispairedSegues.segueToSuccess.rawValue {
      segue.destination.navigationItem.title = "Success"
    } else if segue.identifier == MispairedSegues.segueToFailure.rawValue {
      segue.destination.navigationItem.title = "Remove Device"
    }
  }

  @IBAction func unwindByDismissing(segue: UIStoryboardSegue) {
  }
}

enum MispairedSegues: String {
  case segueToRemove = "SegueToRemove"
  case segueToForceConfirmation = "SegueToForceConfirmation"
  case segueToForceSuccess = "SegueToForceSuccess"
  case segueToSuccess = "SegueToSuccess"
  case segueToFailure = "SegueToFailure"
  case segueToPairingCart = "SegueToPairingCart"
}

extension PairingDeviceModel: ArcusPairingDeviceCapability,
                              ArcusProductCapability {

  func productName() -> String? {
    if let productAddress = getPairingDeviceProductAddress(self),
       let product = RxCornea.shared.modelCache?.fetchModel(productAddress) as? ProductModel {
      
      return getProductName(product)
    }
    
    return nil
  }

  func isPhilipsHue() -> Bool {    
    if let productAddress = getPairingDeviceProductAddress(self),
       let product = RxCornea.shared.modelCache?.fetchModel(productAddress) as? ProductModel {
      
      return getProductVendor(product) == "Philips Hue"
    }
    
    return false
  }
}
