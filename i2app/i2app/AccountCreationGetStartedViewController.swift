//
//  AccountCreationGetStartedViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/12/17.
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

/*
 This screen shows a message gretting the user after account creation has been completed. It also shows
 a confetti animation when the user view appears.
 */
class AccountCreationGetStartedViewController: UIViewController {

  /*
   View used to display the confetti animation.
   */
  @IBOutlet weak var confettiView: AccountCreationConfettiView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    ArcusAnalytics.tag(named: AnalyticsTags.AccountCreateNavIOS)
    
    navBarWithTitleImage()
    navigationItem.hidesBackButton = true
    
    // When this view loads ensure that the Current Account is marked as just created.
    UserDefaults.standard.set(true, forKey: "accountJustCreated")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIApplication.shared.isIdleTimerDisabled = true
    confettiView.startConfetti()
  }
}
