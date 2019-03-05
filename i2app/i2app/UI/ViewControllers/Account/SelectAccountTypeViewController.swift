//
//  SelectAccountTypeViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/5/16.
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

class SelectAccountTypeViewController: UIViewController {
  @IBOutlet var haveHubImageView: UIImageView!
  @IBOutlet var noHubImageView: UIImageView!
  @IBOutlet var haveHubButton: ArcusButton!
  @IBOutlet var noHubButton: ArcusButton!
  @IBOutlet var infoButton: ArcusButton!
  
  @IBOutlet weak var topImageVertical: NSLayoutConstraint!
  @IBOutlet weak var bottomImageVertical: NSLayoutConstraint!
  @IBOutlet weak var dividerVertical: NSLayoutConstraint!
  
  // MARK: View LifeCycle
  
  static func create () -> SelectAccountTypeViewController {
    if let vc = UIStoryboard(name: "CreateAccount", bundle: nil)
      .instantiateViewController(withIdentifier: "SelectAccountTypeViewController")
      as? SelectAccountTypeViewController {
      return vc
    }
    return SelectAccountTypeViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar()
    configureBackground()
    configureSmallScreen()
  }
  
  // MARK: UI Configuration
  func configureNavBar() {
    navigationItem.hidesBackButton = true
  }
  
  func configureBackground() {
    navigationController?.view.createBlurredBackground(presentingViewController)
    view.backgroundColor = navigationController?.view.backgroundColor
    addWhiteOverlay(BackgroupOverlayLightLevel)
  }
  
  func configureSmallScreen() {
    if UIDevice.isIPhone5() {
      topImageVertical.constant = 20
      dividerVertical.constant = 20
      bottomImageVertical.constant = 20
    }
  }
  
  // MARK: IBActions
  
  @IBAction func haveHubButtonPressed(_ sender: ArcusButton) {
    ApplicationRoutingService.defaultService.showHubPairing()
  }
  
  @IBAction func closeButtonPressed(_ sender: Any) {
    ApplicationRoutingService.defaultService.showDashboard()
  }
  
  @IBAction func noHubButtonPressed(_ sender: ArcusButton) {
    ApplicationRoutingService.defaultService.showPairingCatalog(true)
  }
}
