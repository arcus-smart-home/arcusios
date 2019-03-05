//
//  AlexaSetupViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/1/16.
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

class AlexaSetupPairingViewController: BaseDeviceStepViewController {

  @IBOutlet var numberButton: UIImageView!

  @objc override class func create(withDeviceStep step: PairingStep) -> AlexaSetupPairingViewController {
    let vc = UIStoryboard(name: "PairDevice", bundle: nil)
      .instantiateViewController(withIdentifier: "AlexaSetupPairingViewController")
      as? AlexaSetupPairingViewController

    vc?.setDeviceStep(step)

    return vc!
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToLastNavigateColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: NSLocalizedString("AMAZON ALEXA", comment: ""))

    self.initializeTemplateViewController()
  }

  override func initializeTemplateViewController() {
    self.numberButton.image = UIImage(named:"Step2")

    self.refreshVideo()
  }

  @IBAction func setupInstructionsButtonPressed(_ sender: ArcusButton) {
    // swiftlint:disable:next line_length
    UIApplication.shared.openURL(NSURL.SupportAlexa)
  }

  @IBAction func done(_ sender: UIButton) {
    // If we found devices then go to found device
    if DevicePairingManager.sharedInstance().justPairedDevices.count > 0 {
      self.navigationController?.pushViewController(FoundDevicesViewController.create(), animated: true)
    } else {
      _ = self.navigationController?.popToRootViewController(animated: true)
    }
  }

}
