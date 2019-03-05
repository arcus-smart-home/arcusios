//
//  ZWaveHealStartViewController.swift
//  i2app
//
//  Arcus Team on 9/16/16.
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

open class ZWaveHealStartViewController: UIViewController {

  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  override open func viewDidLoad() {
    super.viewDidLoad()

    configureNavBar()
    configureLabels()
    configureBackground()
    configureNextButton()
  }

  fileprivate func configureLabels() {
    let title = "Z-Wave devices in your home \n link together to form a network. \n If devices are added, "
      + "relocated \n or removed, the network may \n need to be rebuilt."
    let description = "The rebuild process time varies depending \n on the number of Z-Wave devices in "
      + "your \n home. It may take a few minutes or several \n hours to complete. \n\n Your Z-Wave "
      + "devices will not work optimally \n during this process."

    titleLabel
      .attributedText = NSAttributedString(string: title,
                                           attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Medium",
                                                                                    size: 18.0)!,
                                                        NSKernAttributeName: 0.0,
                                                        NSForegroundColorAttributeName: UIColor.white])

    descriptionLabel
      .attributedText = NSAttributedString(string: description,
                                           attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Medium",
                                                                                    size: 14.0)!,
                                                        NSKernAttributeName: 0.0])
  }

  fileprivate func configureNavBar() {
    self.navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  fileprivate func configureBackground () {
    self.setBackgroundColorToDashboardColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
  }

  fileprivate func configureNextButton() {
    nextButton.styleSet("REBUILD Z-WAVE NETWORK", andButtonType: FontDataTypeButtonLight, upperCase: true)
  }

  @IBAction func onNextButton(_ sender: AnyObject) {
    let nextViewController = ZWaveHealProgressViewController.createAndStartRebuild()
    self.navigationController?.pushViewController(nextViewController, animated: true)
  }
}
