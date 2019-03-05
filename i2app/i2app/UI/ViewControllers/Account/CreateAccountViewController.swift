//
//  CreateAccountViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/17/16.
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

enum SwiftAccountState: Int {
  case accountStateNone = 0
  case accountStateSignUp1 = 1
  case accountStateSignUpAboutYou = 2
  case accountStateSignUpAboutYourHome = 3
  case accountStateSignUpTimeZone = 4
  case accountStateSignUpPinCode = 5
  case accountStateSignUpSecurityQuestions = 6
  case accountStateSignUpNotifications = 7
  case accountStateSignUpPremiumPlan = 8
  case accountStateSignUpBillingInformation = 9
  case accountStateSignUpComplete = 10

  static func fromString(_ string: String) -> SwiftAccountState {
    switch string.uppercased() {
    case "NONE": return accountStateNone
    case "SIGNUP1": return accountStateSignUp1
    case "ABOUT_YOU": return accountStateSignUpAboutYou
    case "ABOUT_YOUR_HOME": return accountStateSignUpAboutYourHome
    case "TIME_ZONE": return accountStateSignUpTimeZone
    case "PIN_CODE": return accountStateSignUpPinCode
    case "SECURITY_QUESTIONS": return accountStateSignUpSecurityQuestions
    case "NOTIFICATIONS": return accountStateSignUpNotifications
    case "PREMIUM_PLAN": return accountStateSignUpPremiumPlan
    case "BILLING_INFO": return accountStateSignUpBillingInformation
    case "COMPLETE": return accountStateSignUpComplete
    default: return accountStateNone
    }
  }

  func toViewController() -> UIViewController {
    switch self {
    case .accountStateNone:
      return PersonalInfoViewController.create()
    case .accountStateSignUp1:
      return PersonalInfoViewController.create()
    case .accountStateSignUpAboutYou:
      return AccountCreationHomeInfoViewController.create()
    case .accountStateSignUpAboutYourHome:
      return AccountCreationTimeZoneViewController.create()
    case .accountStateSignUpTimeZone:
      return PinCodeEntryViewController.create()
    case .accountStateSignUpPinCode:
      return SecurityQuestionsViewController.create()
    case .accountStateSignUpSecurityQuestions:
      return NotificationViewController.create()
    case .accountStateSignUpBillingInformation:
      return SuccessAccountViewController.create()
    case .accountStateSignUpComplete:
      return SuccessAccountViewController.create()
    default:
      return UIViewController()
    }
  }
}

typealias NeedsNavConfig = (needsConfig: Bool, accountState: SwiftAccountState?)

@objc class CreateAccountViewController: BaseTextViewController,
  AccountInvitationCallback,
  BiometricAuthenticationMixin,
  UserAuthenticationController,
  RegistrationConfigHolder {

  internal static var sharedConfig: RegistrationConfig?
  internal var config: RegistrationConfig?

  internal var emailTextField: AccountTextField!
  internal var passwordFirstTextField: PasswordTextField!
  internal var passwordSecondTextField: PasswordTextField!
  internal var checkmarkButton: Checkbox!
  internal var mainText: UIButton!
  internal var nextButton: UIButton!

  internal var newslettersToVerifyLabelConstraint: NSLayoutConstraint!
  internal var emailToTopConstraint: NSLayoutConstraint!

  internal var controller: AccountInvitationController?

  var biometricAuthenticator: BiometricAuthenticator?
  var disposeBag: DisposeBag = DisposeBag()

  class func create() -> CreateAccountViewController? {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc: CreateAccountViewController? = storyboard
      .instantiateViewController(withIdentifier: "CreateAccountViewController")
      as? CreateAccountViewController

    vc?.config = AccountRegistrationConfig()
    sharedConfig = vc?.config
    return vc
  }

  class func create(_ config: RegistrationConfig) -> CreateAccountViewController? {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc: CreateAccountViewController? = storyboard
      .instantiateViewController(withIdentifier: "CreateAccountViewController")
      as? CreateAccountViewController

    vc?.config = config
    sharedConfig = vc?.config
    return vc
  }

  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navBar(withCloseButtonAndTitle: NSLocalizedString("Sign up", comment: ""))

    self.navigationController?.view.createBlurredBackground(self.presentingViewController)
    self.view.backgroundColor = self.navigationController?.view.backgroundColor

    self.controller = AccountInvitationController(callback: self)

    setupView()
  }

  // MARK: View Setup

  func setupView() {
    //_emailTextField.text = "http://iotmacmini.dillonkane.com:8081!"
    self.emailTextField.placeholder = NSLocalizedString("Email address", comment: "")
    self.emailTextField.setupType(AccountTextFieldTypeEmail)
    self.emailTextField.setAccountFieldStyle(AccountTextFieldStyleBlack)

    self.passwordFirstTextField.attributedPlaceholder = FontData
      .getString(NSLocalizedString("Password", comment: "").uppercased(),
                 andString2: NSLocalizedString("  (min 8 characters)", comment: ""),
                 withCombineFont: FontDataCombineTypeAccountTextFieldPlaceholder)
    self.passwordFirstTextField.setupType(AccountTextFieldTypePassword)
    self.passwordFirstTextField.setAccountFieldStyle(AccountTextFieldStyleBlack)

    self.passwordSecondTextField.attributedPlaceholder = FontData
      .getString(NSLocalizedString("Confirm Password", comment: "").uppercased(),
                 andString2:NSLocalizedString("  (min 8 characters)", comment: ""),
                 withCombineFont:FontDataCombineTypeAccountTextFieldPlaceholder)
    self.passwordSecondTextField.setupType(AccountTextFieldTypePassword)
    self.passwordSecondTextField.setAccountFieldStyle(AccountTextFieldStyleBlack)

    self.mainText.titleLabel?.attributedText = FontData
      .getString(NSLocalizedString("Send me newsletters and updates", comment: ""),
                 withFont:FontDataTypeAccountMainText)

    self.checkmarkButton.isChecked = true

    self.nextButton.styleSet(NSLocalizedString(NSLocalizedString("next", comment: ""), comment: ""),
                             andButtonType:FontDataTypeButtonDark, upperCase:true)

    if UIDevice.isIPhone5() {
      emailToTopConstraint.constant = 21
      newslettersToVerifyLabelConstraint.constant = 19
    }

    if #available(iOS 11.0, *) {
      emailTextField.textContentType = UITextContentType("")
      passwordFirstTextField.textContentType = UITextContentType("")
      passwordSecondTextField.textContentType = UITextContentType("")
    }
  }

  func close(_ sender: UIButton) {
    self.dismiss(animated: true) { }

    // Tag that the user abandoned account creation:
    ArcusAnalytics.tag("Sign Up Abandoned", attributes: [String: AnyObject]())
  }

  // MARK: Data Validation

  fileprivate func isStringValid(_ errorMessageKey: inout NSString?) -> Bool {
    configurePasswordTextFieldForValidation()

    return super.isDataValid(&errorMessageKey)
  }

  func configurePasswordTextFieldForValidation() {
    self.passwordFirstTextField.confirmationString = self.passwordSecondTextField.text
    self.passwordSecondTextField.confirmationString = self.passwordFirstTextField.text

    if let emailText: String = self.emailTextField.text {
      let components: [String] = emailText.components(separatedBy: "@")
      if components.count > 0 {
        self.passwordFirstTextField.restrictedValues = [components[0]]
      }
    }
  }

  // MARK: Actions

  @IBAction func createAccountPressed(_ sender: UIButton) {
    super.validateTextFields()
  }

  @IBAction func termsOfServicePressed(_ sender: UIButton) {
    let webView: WebViewController = WebViewController()
    webView.urlString = ObjCMacroAdapter.arcusTermsOfServiceUrl()
    self.navigationController?.pushViewController(webView, animated: true)
  }

  @IBAction func privacyPolicyPressed(_ sender: UIButton) {
    let webView: WebViewController = WebViewController()
    webView.urlString = ObjCMacroAdapter.arcusPrivacyStatementUrl()
    self.navigationController?.pushViewController(webView, animated: true)
  }

  @IBAction func checkmarkButtonPressed(_ sender: Checkbox) {
    self.checkmarkButton.isChecked = !self.checkmarkButton.isChecked
  }

  override func saveRegistrationContext() {
    createGif()
    
    guard let email = self.emailTextField.text,
      let password = self.passwordFirstTextField.text else {
        return
    }
    
    DispatchQueue.global(qos: .background).async {
      if self.config is AccountRegistrationConfig {
        
        let selected = self.checkmarkButton.isChecked ? "true" : "false"
        
        _ = AccountController.createAccountWithEmail(email, withPassword: password, withOptin: selected)
          .swiftThen { _ in
            self.hideGif()
            
            if let email = self.emailTextField.text,
              let password = self.passwordFirstTextField.text {
              self.updateTouchIDConfig(email, password: password)
            }
            
            self.loginUser(email, password: password, completion: { success, error in
              if let error = error as NSError? {
                self.presentError(error)
              } else if success == true {
                // Check if TouchID is enabled, and if user has changed, disable.
                self.validateTouchIDStateForEmail(email)
                
                // Cache User Creds for use with Biometric Auth
                self.saveUserCredentials(email,
                                         password: password)
              }
            })
            
            return nil
          }
          .swiftCatch { error in
            if let error = error as? NSError {
              self.presentError(error)
            }
            
            return nil
        }
      } else if let invitationConfig: InvitationRegistrationConfig = self.config
        as? InvitationRegistrationConfig {

        // TODO: Capture textfields outside of the background thread to prevent a runtime error here
        self.controller?
          .acceptInvitationCreateLogin(self.passwordFirstTextField.text!,
                                       email: self.emailTextField.text!,
                                       code: invitationConfig.invitation!.code!,
                                       inviteeEmail: invitationConfig.invitation!.inviteeEmail!)
      }
    }
  }
  
  private func presentError(_ error: NSError) {
    guard let error = error as? NSError else { return }
    DispatchQueue.main.async {
      self.hideGif()
      if (error.code == 104) {
        self.displayErrorMessage("This email is associated with an existing"
          + " Arcus account.\nPlease choose another one.",
                                 withTitle: "Email Already Registered")
      } else {
        self.displayGenericErrorMessage(withMessage: error.localizedDescription)
      }
    }
  }

  func updateTouchIDConfig(_ email: String, password: String) {
    // Check if Biometric Auth is enabled, and if user has changed, disable.
    self.validateTouchIDStateForEmail(email)

    // Cache User Creds for use with Biometric Auth
    self.saveUserCredentials(email,
                             password: password)
  }

  class func needsAccountNavController() -> NeedsNavConfig {
    let state: String? = AccountCapability.getStateFrom(RxCornea.shared.settings?.currentAccount)
    if let accountStateString: String = state, !state!.isEmpty {
      let accountState: SwiftAccountState? = SwiftAccountState.fromString(accountStateString)
      if accountState != nil && accountState != SwiftAccountState.accountStateSignUpComplete {
        if accountState!.rawValue <= SwiftAccountState.accountStateSignUpComplete.rawValue
          && accountState!.rawValue > SwiftAccountState.accountStateNone.rawValue {
          return (true, accountState!)
        }
      } else if accountState != nil && accountState == SwiftAccountState.accountStateSignUpComplete,
        let person = RxCornea.shared.settings?.currentPerson {
        let saCount = PersonCapability.getSecurityAnswerCount(from: person)
        if saCount <= 0 {
          return (true, .accountStateSignUp1)
        }
      }
    }
    return (false, nil)
  }

  class func getAccountNavController() -> UINavigationController? {
    let navConfig = CreateAccountViewController.needsAccountNavController()
    guard navConfig.needsConfig == true,
      let accountState = navConfig.accountState else {
      return nil
    }

    func needsPinConfigured() -> Bool {
      if let person = RxCornea.shared.settings?.currentPerson,
        !person.hasPin {
        return true
      }
      return false
    }

    var config: RegistrationConfig
    var viewController: UIViewController
    if needsPinConfigured() {
      config = sharedConfig ?? InvitationRegistrationConfig()
      viewController = accountState.toViewController()
    } else {
      config = sharedConfig ?? AccountRegistrationConfig()
      viewController = SuccessAccountViewController.create()
    }
    // Cleanup the shared Config which should have been used already if we are animating away
    sharedConfig = nil

    if let viewController = viewController as? RegistrationConfigHolder {
      viewController.config = config
    }

    let navController = UINavigationController(rootViewController: viewController)
    navController.view.createBlurredBackground(fromImageNamed: "InitialLaunch4.jpg")
    viewController.view.backgroundColor = navController.view.backgroundColor
    return navController
  }

  // MARK: AccountInvitationCallback Methods

  func invitationNotFound(_ error: AccountInvitationError) {}

  func invitationFound(_ invitation: Invitation) {}

  func invitationAcceptSuccess(_ person: PersonModel, email: String, password: String) {
    AccountController
      .loginUser(email,
                 password: password,
                 completion: { (success: Bool, error: Error?) in
                  DispatchQueue.main.async {
                    if success && error != nil {
                      self.hideGif()

                      let vc: PersonalInfoViewController = PersonalInfoViewController.create(self.config!)
                      self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                      if error != nil {
                        self.hideGif()
                        self.displayErrorMessage(error!.localizedDescription)
                      }
                    }
                  }
      })
  }

  func invitationAcceptError(_ error: AccountInvitationError) {
    self.hideGif()

    if case let .failed(message) = error {
      self.displayErrorMessage(message)
    }
  }
}
