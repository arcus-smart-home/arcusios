//
//  UpdateEmailAddressViewController.swift
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
  static let kUnwindUpdateEmail: String = "unwindUpdateEmailSegue"
}

class UpdateEmailAddressViewController: UIViewController,
ArcusUpdateEmailAddressPresenter,
ScrollViewKeyboardAnimatable {
  var personModel: PersonModel!

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var emailTextField: ScleraTextField!
  @IBOutlet weak var updateEmailButton: ScleraButton!

  // MARK: ScrollViewKeyboardAnimatable Properties
  var keyboardAnimationView: UIScrollView! {
    return scrollView
  }

  var keyboardAnimatableShowObserver: Any?
  var keyboardAnimatableHideObserver: Any?

  // MARK: ArcusAccountCreationPresenter Properties
  var accountCreationModel: ArcusAccountCreationViewModel! = AccountCreationViewModel()
  var disposeBag: DisposeBag = DisposeBag()
  var disposable: Disposable?


  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Disable updateEmailButton by default.
    // (Disabling in the storyboard does not update the background color.)
    updateEmailButton.isEnabled = false

    // Add Sclera font to Navigation Title.
    addScleraStyleToNavigationTitle()

    // Add Sclera back button to Navigation Bar.
    addScleraBackButton()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Add observer of `AccountCreationModel.state` to enable/disable Next Button.
    observeAccountCreationModelState()

    // Configure scrolling for keyboard show/hide.
    addKeyboardScrolling()

    // Configure textfield text.
    configureEmailTextField(emailAddress)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Dispose of `AccountCreationModel.state` observer.
    removeAccountCreationModelStateObserver()

    // Remove keyboard observers.
    cleanUpKeyboardScrollingObservers()
  }

  // MARK: - UI Configuration

  /**
   Configure textField text.
   */
  func configureEmailTextField(_ text: String) {
    emailTextField.text = text
  }

  // MARK: - UI Observers

  /**
   Add observer of `AccountCreationModel.state` to enable/disable Next Button.
   */
  func observeAccountCreationModelState() {
    disposable = accountCreationModel.state.asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] state in
        self?.updateEmailButton.isEnabled = state.contains(.emailSet)
      })
    disposable?.disposed(by: disposeBag)
  }

  /**
   Dispose of `AccountCreationModel.state` observer.
   */
  func removeAccountCreationModelStateObserver() {
    disposable?.dispose()
  }

  // MARK: - IBActions

  @IBAction func updateEmailPressed(_ sender: AnyObject) {
    attemptUpdateEmailAddress().subscribe(onNext: { [weak self] success in
      if success {
        self?.performSegue(withIdentifier: Constants.kUnwindUpdateEmail, sender: self)
      }
    })
    .disposed(by: disposeBag)
  }

  @IBAction func cancelButtonPressed(_ sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
  }

  // MARK: ShowKeyboardAnimatable Functions

  /**
   Required by `ScrollViewKeyboardAnimatable`
   */
  func activeViewForKeyboardScroll() -> UIView? {
    if emailTextField.isFirstResponder {
      return emailTextField
    }
    return nil
  }
}

// MARK: - UITextFieldDelegate

extension UpdateEmailAddressViewController: UITextFieldDelegate {
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
    return true
  }
}
