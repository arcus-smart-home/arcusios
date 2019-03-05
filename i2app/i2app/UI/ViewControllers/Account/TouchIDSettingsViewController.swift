//
//  TouchIDSettingsViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/26/16.
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
import RxSwift

/// The Storyboard has this string in place of Face ID or Touch ID and the VC should replace it occording to
/// the presenter. We use caps because the sclera button changes the text to use all caps
fileprivate let ServiceTextReplaceString = "<AUTH>"

class TouchIDSettingsViewController: UIViewController, BiometricAuthenticationMixin {
  @IBOutlet var titleLabel: ArcusLabel!
  @IBOutlet var descriptionLabel: ArcusLabel!
  @IBOutlet var switchButton: ArcusButton!

  var biometricAuthenticator: BiometricAuthenticator?
  var activeUserKeychain: LSArcusKeychain?

  var disposeBag: DisposeBag = DisposeBag()

  // MARK: View LifeCycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    biometricAuthenticator = BiometricAuthenticator()
    if let activeUsername: String = RxCornea.shared.session?.activeUser?.value.removingPercentEncoding {
      let single: Single<LSArcusKeychain> = LSArcusKeystore
        .fetchKeychain(activeUsername, service: kKeyArcusActiveCredentialService, retry: 5, delay: 0.5)
      single.subscribe(
        onSuccess: { [weak self] keychain in
          self?.activeUserKeychain = keychain
      }).disposed(by: disposeBag)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigationBar()
    configureBackground()
    configureButtonState()
    configureText()
  }

  // MARK: UI Configuration
  func configureNavigationBar() {
    navBar(withBackButtonAndTitle: AuthProtocols.current.title)
  }

  func configureBackground() {
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
  }

  func configureButtonState() {
    switchButton.isSelected = false

    if isTouchAuthenticationAvailable() {
      isTouchAuthenticationEnabled()
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(
          onSuccess: { [switchButton] _ in
            switchButton?.isSelected = true
          })
        .disposed(by: disposeBag)
    }
  }

  func configureText() {
    titleLabel.text = titleLabel.text?.replacingOccurrences(of: ServiceTextReplaceString,
                                                            with: AuthProtocols.current.title)
    descriptionLabel.text = descriptionLabel.text?.replacingOccurrences(of: ServiceTextReplaceString,
                                                                        with: AuthProtocols.current.title)
  }

  // MARK: IBActions
  @IBAction func switchButtonPressed(_ sender: AnyObject) {
    var error: NSError?
    if isTouchAuthenticationAvailable(&error) {
      if sender.isSelected == true {
        disableTouchAuthentication()
      } else {
        requestTouchAuthentication("Please Authenticate to Proceed.") { (finished, _) in
          if finished {
            if let account = self.activeUserKeychain?.account,
              let password = self.activeUserKeychain?.value {
              self.enableTouchAuthentication(account, password: password)
            } else if let account = RxCornea.shared.session?.activeUser?.value.removingPercentEncoding {
              // Set keychain without password.
              //This will allow biometric authentication to work until next login.
              self.enableTouchAuthentication(account, password: "*")
            }
            DispatchQueue.main.async {
              self.switchButton.isSelected = true
            }
          } else {
            DispatchQueue.main.async {
              self.switchButton.isSelected = false
            }
          }
        }
      }
      // Set Temporarily based on user intent, the block may change the value
      switchButton.isSelected = !sender.isSelected
    } else {
      switchButton.isSelected = false
      if let error = error,
        let errorMessage = shouldDisplayEnableErrorMessage(error) {
        displayMessage(errorMessage)
      }
    }
  }

  private func displayMessage(_ message: BiometricAuthenticationMessage) {
    self.displayErrorMessage( message.message, withTitle: message.title)
  }
}

