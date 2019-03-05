//
//  AccountCreationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/2/18.
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
  static let termsOfServiceLinkKey: String = "arcustermsofservice"
  static let privacyStatementLinkKey: String = "privacystatement"

  static let checkYourEmailSegue: String = "showCheckYourEmailSegue"
}

/**
 Struct defining strings used in `AccountCreationViewController`
 */
struct AccountCreationStrings {
  static let termsOfService: String = "Arcus® Terms of Service"
  static let privacyStatement: String = "Privacy Statement"

  // Error Messages
  static let invalidEmailError: String = "Invalid Email"
  static let invalidPasswordError: String = "Invalid Password"
  static let passwordMismatchError: String = "Passwords Do Not Match"
  static let emailAlreadyRegisteredError: String = "Email Already Registered"
}

class AccountCreationViewController: UIViewController,
  ArcusAccountCreationSubmissionPresenter,
ScrollViewKeyboardAnimatable {
  @IBOutlet weak var errorBanner: ScleraBannerView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var emailTextField: ScleraTextField!
  @IBOutlet weak var passwordTextField: ScleraTextField!
  @IBOutlet weak var confirmTextField: ScleraTextField!
  @IBOutlet weak var checkMarkImage: UIImageView!
  @IBOutlet weak var infoTextView: UITextView!
  @IBOutlet weak var nextButton: ScleraButton!

  // MARK: ScrollViewKeyboardAnimatable Properties
  var keyboardAnimationView: UIScrollView! {
    return scrollView
  }

  var keyboardAnimatableShowObserver: Any?
  var keyboardAnimatableHideObserver: Any?

  // MARK: ArcusAccountCreationSubmissionPresenter Properties
  var accountCreationModel: ArcusAccountCreationViewModel!
  var disposeBag: DisposeBag = DisposeBag()
  var disposable: Disposable?

  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Next button is disabled by default. (Disabling in the storyboard does not update the background color.)
    nextButton.isEnabled = false

    // Configure Info Text View Links.
    configureInfoTextView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Add Sclera font to Navigation Title.
    addScleraStyleToNavigationTitle()

    // Add Sclera back button to Navigation Bar.
    addScleraBackButton()

    // Add observer of `AccountCreationModel.state` to enable/disable Next Button.
    observeAccountCreationModelState()

    // Configure scrolling for keyboard show/hide.
    addKeyboardScrolling()

    // Update checkMark to default to `accountCreationModel.offersAndPromotion`.
    checkMarkImage.isHighlighted = accountCreationModel.offersAndPromotions
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Dispose of `AccountCreationModel.state` observer.
    removeAccountCreationModelStateObserver()

    // Remove keyboard observers.
    cleanUpKeyboardScrollingObservers()
  }

  // MARK: UI Configuration

  func configureInfoTextView() {
    // Range of tos string.
    let tosRange = (infoTextView.text as NSString).range(of: AccountCreationStrings.termsOfService)

    // Range of privacy statement string.
    let privacyRange = (infoTextView.text as NSString).range(of: AccountCreationStrings.privacyStatement)

    // Keep text centerAligned.
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center

    // Underline attributes for tos and privacy range.
    let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
    let font = infoTextView.font

    // Create attributed string
    let attributedString: NSMutableAttributedString =
      NSMutableAttributedString(string: infoTextView.text,
                                attributes: [NSFontAttributeName: font!,
                                             NSParagraphStyleAttributeName: paragraph])

    // Add tos link attributes.
    attributedString.addAttribute(NSLinkAttributeName,
                                  value: Constants.termsOfServiceLinkKey,
                                  range: tosRange)

    // Add privacy link attributes.
    attributedString.addAttribute(NSLinkAttributeName,
                                  value: Constants.privacyStatementLinkKey,
                                  range: privacyRange)

    // Set link attributes.
    infoTextView.linkTextAttributes = underlineAttribute

    // Set attributed text.
    infoTextView.attributedText = attributedString
  }

  // MARK: UI Observers

  /**
   Add observer of `AccountCreationModel.state` to enable/disable Next Button.
   */
  func observeAccountCreationModelState() {
    disposable = accountCreationModel.state.asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] state in
        DDLogError(state.debugDescription)

        // Check that state is valid.
        let valid: Bool = state.contains(.createAccountViewSet)

        // Update next button state.
        self?.nextButton.isEnabled = valid

        // Clear textField errors if valid.
        if valid {
          self?.passwordTextField.removeError()
          self?.confirmTextField.removeError()
        }
      })
    disposable?.disposed(by: disposeBag)
  }

  /**
   Dispose of `AccountCreationModel.state` observer.
   */
  func removeAccountCreationModelStateObserver() {
    disposable?.dispose()
  }

  // MARK: IBActions

  @IBAction func checkMarkPressed(sender: AnyObject) {
    // Flip CheckMark state
    checkMarkImage.isHighlighted = !checkMarkImage.isHighlighted
    userUpdatedOffersAndPromotions(checkMarkImage.isHighlighted)
  }

  @IBAction func termsOfServiceLinkPressed(sender: AnyObject) {
    let webView: WebViewController = WebViewController()
    webView.urlString = ObjCMacroAdapter.arcusTermsOfServiceUrl()
    self.navigationController?.pushViewController(webView, animated: true)
  }

  @IBAction func privacyStatementLinkPressed(sender: AnyObject) {
    let webView: WebViewController = WebViewController()
    webView.urlString = ObjCMacroAdapter.arcusPrivacyStatementUrl()
    self.navigationController?.pushViewController(webView, animated: true)
  }

  @IBAction func nextButtonPressed(sender: AnyObject) {
    // Attempt to create account.
    attemptAccountCreation()
    createGif()
  }

  // MARK: - ArcusAccountCreationSubmissionPresenter

  func processAccountCreationFailure(_ code: String?) {
    hideGif()
    if code == "error.signup.emailinuse" {
      showEmailAlreadyRegisteredError()
    }
  }

  func processAccountCreationCompletion() {
    ArcusAnalytics.tag(named: AnalyticsTags.AccountCreateLogin)
    hideGif()
    performSegue(withIdentifier: Constants.checkYourEmailSegue, sender: self)
  }

  func showEmailAlreadyRegisteredError() {
    errorBanner.isHidden = false
    emailTextField.showError(errorText: AccountCreationStrings.emailAlreadyRegisteredError)
  }

  func hideEmailAlreadyRegisteredError() {
    errorBanner.isHidden = true
    emailTextField.removeError()
  }

  // MARK: ShowKeyboardAnimatable Functions

  /**
   Required by `ScrollViewKeyboardAnimatable`
   */
  func activeViewForKeyboardScroll() -> UIView? {
    if emailTextField.isFirstResponder {
      return emailTextField
    }

    if passwordTextField.isFirstResponder {
      return passwordTextField
    }

    if confirmTextField.isFirstResponder {
      return confirmTextField
    }
    return nil
  }

  // MARK: - Prepare For Segue

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.checkYourEmailSegue {
      guard let currentPerson = RxCornea.shared.settings?.currentPerson,
        let destination = segue.destination as? ArcusResendEmailPresenter else {
          return
      }
      destination.personModel = currentPerson
    }
  }
}

// MARK: UITextFieldDelegate

extension AccountCreationViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let textField = textField as? ScleraTextField else { return }

    var isValid: Bool = true

    defer {
      if isValid {
        textField.removeError()
      }
    }

    if textField == emailTextField {
      if let email: String = textField.text, validateEmailAddress(email) {
      } else {
        textField.showError(errorText: AccountCreationStrings.invalidEmailError)
        isValid = false
      }
    } else if textField == passwordTextField {
      if let password: String = textField.text {
        if !validatePassword(password) {
          textField.showError(errorText: AccountCreationStrings.invalidPasswordError)
          isValid = false
        }
        if let confirm: String = confirmTextField.text, confirm.count > 0 {
          if !validateConfirmPassword(password, confirmPassword: confirm) {
            if !isValid {
              textField.showError()
            }
            confirmTextField.showError(errorText: AccountCreationStrings.passwordMismatchError)
            isValid = false
          } else {
            confirmTextField.removeError()
          }
        }
      }
    } else if textField == confirmTextField {
      if let password: String = passwordTextField.text,
        let confirm: String = textField.text,
        validateConfirmPassword(password, confirmPassword: confirm) {

        passwordTextField.removeError()
        textField.removeError()
      } else {
        if !validatePassword(textField.text) {
          textField.showError()
        } else {
          // If password isn't valid then don't show empty error (invalid password should be shown.)
          if validatePassword(passwordTextField.text) {
            passwordTextField.showError()
          }
          textField.showError(errorText: AccountCreationStrings.passwordMismatchError)
        }

        isValid = false
      }
    }
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    var newValue: String?
    if let text = textField.text as NSString? {
      newValue = text.replacingCharacters(in: range, with: string)
    }

    if textField == emailTextField {
      // Attempt to update email address.
      userUpdatedEmail(newValue)
    } else if textField == passwordTextField {
      // Attempt to update password.
      userUpdatedPassword(newValue, confirmPassword: confirmTextField.text)
    } else if textField == confirmTextField {
      // Attempt to update confirm password.
      userUpdatedPassword(passwordTextField.text, confirmPassword: newValue)
    }
    return true
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    if let textField = textField as? ScleraTextField {
      textField.removeError()
    }

    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      _ = passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      _ = confirmTextField.becomeFirstResponder()
    } else if textField == confirmTextField {
      _ = confirmTextField.resignFirstResponder()

      // Attempt to create account.
      attemptAccountCreation()
      createGif()
    }

    return true
  }
}

// MARK: UITextViewDelegate

extension AccountCreationViewController: UITextViewDelegate {
  @available(iOS 10.0, *)
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange,
                interaction: UITextItemInteraction) -> Bool {
    return processURLInteraction(textView, URL: URL)
  }

  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    return processURLInteraction(textView, URL: URL)
  }

  func processURLInteraction(_ textView: UITextView, URL: URL) -> Bool {
    if URL.absoluteString == Constants.termsOfServiceLinkKey {
      termsOfServiceLinkPressed(sender: textView)
      return false
    } else if URL.absoluteString == Constants.privacyStatementLinkKey {
      privacyStatementLinkPressed(sender: textView)
      return false
    }
    return true
  }
}
