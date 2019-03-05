//
//  ProMonCantVerifyViewController.swift
//  i2app
//
//  Arcus Team on 3/7/17.
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
import UIKit
import Cornea
import PromiseKit

class ProMonCantVerifyViewController: UIViewController {

  @IBOutlet weak var locationField: UILabel!

  internal var currentPlace: PlaceModel!
  internal var address: [String:String]!
  fileprivate var unwindIntoEditMode = false

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)

    locationField.text = locationField.text?
      .replacingOccurrences(of: "<place-name>",
                            with: PlaceCapability.getNameFrom(currentPlace))
    locationField.text = locationField.text?
      .replacingOccurrences(of: "<address>",
                            with: prettyPrintedAddress())

  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? EditPlaceInfoViewController {
      vc.updateEditDoneButtonState(!self.unwindIntoEditMode)
      vc.onClickTimeZone(vc)
    }
  }

  func back(_ sender: AnyObject) {
    unwindIntoEditMode = true
    performSegue(withIdentifier: "unwindToPlaceInfo", sender: self)
  }

  @IBAction func onSave(_ sender: AnyObject) {
    DispatchQueue.global(qos: .background).async {
      _ = PlaceCapability.updateAddress(withStreetAddress: self.address,
                                        on: self.currentPlace).swiftThen({ (_) -> (PMKPromise?) in
        self.unwindIntoEditMode = false
        self.performSegue(withIdentifier: "unwindToPlaceInfo", sender: self)
        return nil
      })
    }
  }

  fileprivate func prettyPrintedAddress() -> String {
    var pretty = ""

    if let line1 = address["line1"] {
      pretty += line1
    }

    if let line2 = address["line2"] {
      pretty += " \(line2)"
    }

    if let city = address["city"] {
      pretty += ", \(city)"
    }

    if let state = address["state"] {
      pretty += ", \(state)"
    }

    if let zip = address["zip"] {
      pretty += " \(zip)"
    }

    return pretty
  }
}
