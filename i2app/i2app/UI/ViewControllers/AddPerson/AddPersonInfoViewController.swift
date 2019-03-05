//
//  AddPersonInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/2/16.
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

class AddPersonInfoViewController: UIViewController {
  @IBOutlet var infoMidLabel: ArcusLabel!
  @IBOutlet var infoLowerLabel: ArcusLabel!

  internal var addPersonModel: AddPersonModel?
  let placeTitle: String = "Temp"

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)

    self.configureLabels()
  }

  // MARK: UI Configuration
  func configureLabels() {
    self.infoMidLabel.text =
      self.infoMidLabel.text!.replacingOccurrences(of: "<name>",
                                                   with:(self.addPersonModel?.firstName)!,
                                                   options: NSString.CompareOptions.literal,
                                                   range: nil)

    self.infoMidLabel.text =
      self.infoMidLabel.text!.replacingOccurrences(of: "<place>",
                                                   with:self.placeTitle,
                                                   options: NSString.CompareOptions.literal,
                                                   range: nil)

    self.infoLowerLabel.text =
      self.infoLowerLabel.text!.replacingOccurrences(of: "<name>",
                                                     with:(self.addPersonModel?.firstName)!,
                                                     options: NSString.CompareOptions.literal,
                                                     range: nil)

    self.infoLowerLabel.text =
      self.infoLowerLabel.text!.replacingOccurrences(of: "<place>",
                                                     with:self.placeTitle,
                                                     options: NSString.CompareOptions.literal, range: nil)
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonDLASuccessSegue" {
      let successViewController: AddPersonSuccessViewController? =
        segue.destination as? AddPersonSuccessViewController
      successViewController?.addPersonModel = self.addPersonModel
    }
  }
}
