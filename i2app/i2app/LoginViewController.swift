//
//  LoginViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/27/17.
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

import Foundation
import Cornea
import RxSwift

/**
 View controller used for login. It contains a login/password mechanism as well as Biometric Auth.
 */
class LoginViewController: UIViewController,
//  LoginPresenterProtocol,
  EmailValidator,
  DebugMenuMixin {

  // MARK: Outlets

  /*
   Text field for the email entry.
   */
  @IBOutlet weak var emailField: ScleraTextField!

  /*
   Biometric Auth views
   */
  @IBOutlet weak var biometricAuthImageButton: UIButton!
  @IBOutlet weak var biometricAuthTextButton: UIButton!
  @IBOutlet weak var biometricView: UIView!

  /*
   Text field for the password entry.
   */
  @IBOutlet weak var passwordField: ScleraTextField!

  /*
   Button to trigger login.
   */
  @IBOutlet weak var loginButton: ArcusButton!

  /*
   Button to active forgot password flow.
   */
  @IBOutlet weak var forgotButton: UIButton!

  /*
   Button to activate the invitation flow.
   */
  @IBOutlet weak var invitationCodeButton: UIButton!

  /*
   Button to activate the create an account flow.
   */
  @IBOutlet weak var createAccountButton: UIButton!

  /*
   Element to be displayed while loading.
   */
  @IBOutlet weak var loadingView: ScleraLoadingView!

  /*
   Banner view for a failed login attempt with an unknown error.
   */
  @IBOutlet weak var errorBannerUnknown: ScleraBannerView!

  /*
   Banner view for a failed login attemp with bad credentials.
   */
  @IBOutlet weak var errorBannerCredentials: ScleraBannerView!

  /*
   Scroll area containing the elements of the login view.
   */
  @IBOutlet weak var contentScrollView: UIScrollView!

  // MARK: DebugMenuMixin

  var pinchCount: Int = 0
  var pinchStart: Date = Date()

  // MARK: Properties

  var disposeBag: DisposeBag = DisposeBag()

  /*
   Helper required by BiometricAuthenticationMixin for Biometric Auth authentication.
   */
  var biometricAuthenticator: BiometricAuthenticator?

  /*
   Popup view used to display Biometric Auth information.
   */
  var touchIdPopupWindow: PopupSelectionWindow!

  // MARK: Functions

  /**
   Action triggered when the login button is pressed.
   - parameter sender: The element that triggered the action.
   */
  @IBAction func loginButtonPressed(_ sender: Any) {
    // Dismiss Keyboard
    _ = emailField.resignFirstResponder()
    _ = passwordField.resignFirstResponder()

    // If there is a platform error clear it before attempting to call the platform again.
    if hasPlatformError() {
      removeAllErrors()
    }

    loginUser()
  }

  /**
   Action triggered when the create account button is pressed.
   - parameter sender: The element that triggered the action.
   */
  @IBAction func createAccountPressed(_ sender: Any) {
    if let createAccount = CreateAccountViewController.create() {
      let navigationController = UINavigationController(rootViewController: createAccount)

      present(navigationController, animated: true, completion: nil)
    }
  }

  @IBAction func biometricAuthPressed(_ sender: Any) {
    requestLoginAuthentication()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navBarWithTitleImage()
    configureFields()
    configureDebugGestureRecognizer(#selector(pinchGestureReceived(_:)))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Biometric State may change in the background
    biometricAuthenticator = BiometricAuthenticator()
    // Configure Biometric Auth Button
    configureBiometricAuthButton()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    registerKeyboardNotifications()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "LoginToAccountCreationCreate" {
      if let navigation = segue.destination as? UINavigationController {
        if let create = navigation.topViewController as? AccountCreationCreateViewController {
          create.presenter = AccountCreationCreatePresenter()
        }
      }
    }
  }

  private func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWasShown),
                                           name: Notification.Name.UIKeyboardDidShow,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillBeHidden),
                                           name: Notification.Name.UIKeyboardWillHide,
                                           object: nil)
  }

  @objc private func keyboardWasShown(_ notification: Notification) {
    guard let info = notification.userInfo,
      let keyboardRect = info[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
        return
    }

    let keyboardSize = keyboardRect.size
    let height = keyboardRect.height > 0 ? keyboardRect.height : 260
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)

    contentScrollView.contentInset = contentInsets
    contentScrollView.scrollIndicatorInsets = contentInsets

    var frame = view.frame
    frame.size.height -= keyboardSize.height

    if passwordField.isFirstResponder {
      contentScrollView.scrollRectToVisible(passwordField.frame, animated: true)
    } else if emailField.isFirstResponder {
      contentScrollView.scrollRectToVisible(emailField.frame, animated: true)
    }
  }

  @objc private func keyboardWillBeHidden(_ notification: Notification) {
    contentScrollView.contentInset = UIEdgeInsets.zero
    contentScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
  }

  private func configureFields() {
    // Email inline validation
    emailField.inlineValidation = {
      guard let text = self.emailField.text else {
        return
      }

      if text.isEmpty {
        self.emailField.showError(errorText: "Missing Email")
      } else if !self.isValid(email: text) {
        self.emailField.showError(errorText: "Invalid Email")
      }
    }

    // Password inline validation
    passwordField.inlineValidation = {
      guard let text = self.passwordField.text else {
        return
      }

      if text.isEmpty {
        self.passwordField.showError(errorText: "Missing Password")
      }
    }
  }

  fileprivate func configureBiometricAuthButton() {

    biometricAuthTextButton.setTitle(AuthProtocols.current.title, for: .normal)
    biometricAuthTextButton.layoutIfNeeded()

    switch AuthProtocols.current {
    /// These UIImages are tested in TestTouchIDPromptToEnableViewController
    case .touchID:
      biometricAuthImageButton.setImage(UIImage(named:"touchid_icon")!, for:.normal)
    case .faceID:
      biometricAuthImageButton.setImage(UIImage(named:"faceid_icon")!, for:.normal)
    case .none: break
    }
    biometricAuthImageButton.layoutIfNeeded()

    isTouchAuthenticationEnabled()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onSuccess: { [weak self] _ in
          self?.biometricView.isHidden = false
          self?.biometricView.layoutIfNeeded()
          self?.view.layoutIfNeeded()
        },
        onError: { [weak self] _ in
          self?.biometricView.isHidden = true
          self?.biometricView.layoutIfNeeded()
          self?.view.layoutIfNeeded()
      }).disposed(by: disposeBag)
  }

  fileprivate func loginUser() {
    validateLoginFields()
  }

  fileprivate func showLoadingOverlay() {
    loadingView.show()
  }

  fileprivate func hideLoadingOverlay() {
    loadingView.hide()
  }

  fileprivate func removeAllErrors() {
    emailField.removeError()
    passwordField.removeError()
    errorBannerUnknown.hide()
    errorBannerCredentials.hide()
  }

  fileprivate func validateLoginFields() {
    // Validate email and password
    emailField.inlineValidation()
    passwordField.inlineValidation()

    // If all fields are valid then login the user
    if !emailField.hasError, !passwordField.hasError {
      showLoadingOverlay()

      let username = emailField.text ?? ""
      let password = passwordField.text ?? ""

      loginUser(withUsername: username, andPassword: password)
    }
  }

  fileprivate func hasPlatformError() -> Bool {
    return !errorBannerCredentials.isHidden || !errorBannerUnknown.isHidden
  }

  /// handle login failure after successful biometric auth.
  /// can occur when the user changes their password.
  func processBiometricLoginFailure() {
    // Bad account info.  Must disable account info and logout.
    disableAccountInformation()
    session?.logout()
    DispatchQueue.main.async {
      ApplicationRoutingService.defaultService.displayMessage(.lockout)
      self.configureBiometricAuthButton()
    }
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if let field = textField as? ScleraTextField {
      field.removeError()
    }

    if hasPlatformError() {
      removeAllErrors()
    }

    return true
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    if let field = textField as? ScleraTextField {
      field.removeError()
    }

    if hasPlatformError() {
      removeAllErrors()
    }

    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailField {
      _ = passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      loginUser()
      _ = passwordField.resignFirstResponder()
    }

    return true
  }
}

extension LoginViewController: LoginPresenterProtocol {
  func userLoginDidSucceed() {
    DispatchQueue.main.async {
      self.hideLoadingOverlay()

      self.removeAllErrors()
    }
  }

  func userLoginFailed(withErrorType errorType: UserLoginError) {
    DispatchQueue.main.async {
      self.hideLoadingOverlay()

      self.emailField.showError()
      self.passwordField.showError()

      if errorType == .credentialsInvalid {
        self.errorBannerCredentials.show()
        self.errorBannerUnknown.hide()
      } else {
        self.errorBannerUnknown.show()
        self.errorBannerCredentials.hide()
      }
    }
  }
}
