//
//  PersonInvitationTutorialViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/10/16.
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

protocol PersonInvitationTutorialCallback {
  func didDismissTutorial()
}

class PersonInvitationTutorialViewController: UIViewController {
  var callback: PersonInvitationTutorialCallback?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    _ = prefersStatusBarHidden
    self.createGradientBackground(withTopColor: UIColor(red: 110.0/255.0,
                                                        green: 137.0/255.0,
                                                        blue: 200.0/255.0,
                                                        alpha: 1),
                                  bottomColor: UIColor(red: 77.0/255.0,
                                                       green:71.0/255.0,
                                                       blue:143.0/255.0,
                                                       alpha:1))
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  @IBAction func closeButtonPressed(_ sender: ArcusButton) {
    self.dismiss(animated: true) {
      self.callback?.didDismissTutorial()
    }
  }
}
