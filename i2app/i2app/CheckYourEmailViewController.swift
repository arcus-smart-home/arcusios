//
//  CheckYourEmailViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/9/18.
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
import RxSwift
import Cornea

extension Constants {
  static let changeEmailSegue: String = "changeEmailSegue"
}

class CheckYourEmailViewController: UIViewController, ArcusResendEmailPresenter, ArcusLogoutPresenter, ArcusMessageBoxViewable {
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var errorBanner: ScleraBannerView!

  // MARK: - ArcusMessageBoxViewable Properties
  @IBOutlet weak var messageBox: UIView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var messageBoxTopConstraint: NSLayoutConstraint!

  // MARK: - ArcusResendEmailPresenter Properties

  var personModel: PersonModel!
  var disposeBag: DisposeBag = DisposeBag()

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Add Sclera font to Navigation Title.
    addScleraStyleToNavigationTitle()

    // Remove back button from naviationItem
    navigationItem.setHidesBackButton(true, animated: false)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureEmailLabel(emailAddress)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  // MARK: - UI Configuration

  func configureEmailLabel(_ email: String) {
    emailLabel.text = email
  }

  // MARK: - IBActions

  @IBAction func resendEmailButtonPressed(_ sender: AnyObject) {
    attemptResend()
  }

  @IBAction func logoutButtonPressed(_ sender: AnyObject) {
    logout()
  }

  @IBAction func unwindFromUpdateEmail(segue:UIStoryboardSegue) {
    guard segue.identifier == Constants.kUnwindUpdateEmail else { return }
    guard let source = segue.source as? ArcusUpdateEmailAddressPresenter else { return }

    personModel = source.personModel

    attemptResend()
  }

  // MARK: -

  /**
   Convenience method that can be called by IBActions to attempt resend email.
   */
  func attemptResend() {
    resendEmail()
      .subscribe(
        onNext: { [weak self] success in
          if success {
            // Show Success Banner
            self?.shouldPresentBanner(withText: "Email Sent!")
            self?.errorBanner.isHidden = true
            self?.runEmailSentDismissTimer()
          } else {
            // Show Error Banner
            self?.shouldHideBanner()
            self?.errorBanner.isHidden = false
          }
      })
      .disposed(by: disposeBag)
  }

  /**
   Run an RxSwift interval to dimsis the Email Sent banner.
   */
  func runEmailSentDismissTimer() {
    let timer = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
    var disposable: Disposable!
    disposable = timer.subscribe(
      onNext: { [weak self] interval in
        if interval >= 7 {
          self?.shouldHideBanner()
          disposable.dispose()
        }
    })
    disposable.disposed(by: disposeBag)
  }

  func showError() {
    errorBanner.isHidden = false
  }

  func hideEmailAlreadyRegisteredError() {
    errorBanner.isHidden = true
  }

  // MARK: - Prepare For Segue

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == Constants.changeEmailSegue else { return }

    guard let destination = segue.destination as? ArcusUpdateEmailAddressPresenter else { return }

    destination.personModel = personModel
  }
}
