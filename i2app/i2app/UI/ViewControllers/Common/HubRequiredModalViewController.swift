//
//  HubRequiredModalViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/25/16.
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

@objc protocol HubRequiredModalDelegate {
  func showWifiBasedDevices()
}

class HubRequiredModalViewController: UIViewController {
  let gradientLayer = CAGradientLayer()

  weak var delegate: HubRequiredModalDelegate?

  // MARK: View LifeCycle
  class func create(_ delegate: HubRequiredModalDelegate) -> HubRequiredModalViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Common", bundle:nil)
    let viewController: HubRequiredModalViewController? =
      storyboard
        .instantiateViewController(withIdentifier: String(describing: HubRequiredModalViewController.self))
        as? HubRequiredModalViewController
    viewController?.delegate = delegate

    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureBackgroundGradient()
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: UI COnfiguration
  func configureBackgroundGradient() {
    let color1 = UIColor(red: 137.0/255.0,
                         green: 45.0/255.0,
                         blue: 120.0/255.0,
                         alpha: 1.0).cgColor as CGColor
    let color2 = UIColor(red: 67.0/255.0,
                         green: 92.0/255.0,
                         blue: 173.0/255.0,
                         alpha: 1.0).cgColor as CGColor

    gradientLayer.frame = view.bounds
    gradientLayer.colors = [color1, color2]
    gradientLayer.locations = [0.0, 1.0]

    view.layer.insertSublayer(gradientLayer, at: 0)
  }

  // MARK: IBActions
  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: {})
  }

  @IBAction func tapHerePressed(_ sender: AnyObject) {
    if delegate != nil {
      delegate?.showWifiBasedDevices()
    }
    self.dismiss(animated: true, completion: {})
  }
}
