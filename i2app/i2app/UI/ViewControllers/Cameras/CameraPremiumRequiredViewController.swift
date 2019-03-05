//
//  CameraPremiumRequiredViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/23/16.
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

class CameraPremiumRequiredViewController: UIViewController {
  fileprivate var gradientLayer: CAGradientLayer?

  @IBOutlet weak var titleImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var upgradeLabel: UILabel!
  @IBOutlet var viewsHiddenSaveSpace: [UIView]!

  @IBOutlet weak var descriptionLabel: UILabel!

  @objc class func create() -> CameraPremiumRequiredViewController {
    if let vc: CameraPremiumRequiredViewController = UIStoryboard(name: "Common",
                                                                  bundle: nil)
      .instantiateViewController(withIdentifier: "CameraPremiumRequiredViewController")
      as? CameraPremiumRequiredViewController {
      return vc
    }
    return CameraPremiumRequiredViewController()
  }

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUpUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
  }

  // MARK: UI

  fileprivate func setUpUI() {
    self.createGradientBackground()
    self.titleImageView.image = UIImage(named: "icon_unfilled_camera")
    self.titleImageView.tintColor = UIColor.white
    self.titleLabel.text = NSLocalizedString("Unavailable On Your Plan", comment: "")
    self.subtitleLabel.text = NSLocalizedString("Store your video clips in the cloud (3 GB Storage). "
      + "Download clips to your personal devices.", comment: "")
    self.descriptionLabel.text = NSLocalizedString("See what triggered the alarm, or who left the back "
      + "door open with Premium. Record video anytime, or with Rules, e.g. If Alarm is Triggered, "
      + "Record Video.", comment: "")
  }

  func createGradientBackground() {
    self.gradientLayer = CAGradientLayer()
    self.gradientLayer?.frame = self.view.bounds
    self.gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
    self.gradientLayer?.endPoint = CGPoint(x: 0, y: 1)
    self.gradientLayer?.colors = [
      UIColor(red: 155.0 / 255.0, green: 70.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0).cgColor,
      UIColor(red:85.0/255.0, green:116.0/255.0, blue:185.0/255.0, alpha:1.0).cgColor
    ]
    self.gradientLayer?.locations = nil
    self.view.layer.insertSublayer(self.gradientLayer!, at: 0)
  }

  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: { _ in })
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
