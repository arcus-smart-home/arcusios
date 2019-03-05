//
//  BiometricAuthenticationMixin.swift
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

import LocalAuthentication
import CocoaLumberjack
import Cornea
import RxSwift

extension Constants {
  static let biometricReinstallCheck: String = "AllowTouchID"
}

protocol BiometricAuthShowLoginable {
  func showLogin(completion: (() -> Void)?)
}
extension ApplicationRoutingService: BiometricAuthShowLoginable {}

/**
 * Protocol defines interface for a BiometricAuthenticationMixin:
 *    Provides computed properties needed to perform TouchID Auth
 *    Provides methods to check TouchID availability, get & set enabled, and
 *    process TouchID Authentication.
 **/
protocol BiometricAuthenticationMixin: class {

  /// default to BiometricAuthenticator
  var biometricAuthenticator: BiometricAuthenticator { get set }

  /// default to RxArcusSession
  var session: ArcusSession? { get }

  /// default to ApplicationRoutingService
  var authShowLoginable: BiometricAuthShowLoginable { get }

  var disposeBag: DisposeBag { get set }

  func isTouchAuthenticationAvailable(_ error: NSErrorPointer) -> Bool
  func isTouchAuthenticationEnabled() -> Single<Void> // Account keychain and Enabled Keychain exist
  func isTouchAuthenticationAccountEnabled() -> Single<Void> // The Account keychain still exist
  func enableTouchAuthentication(_ account: String,
                                 password: String)
  func disableTouchAuthentication()
  func disableAccountInformation()
  func requestTouchAuthentication(_ reason: String,
                                  completion: @escaping (_ success: Bool, _ error: NSError?) -> Void)
  func requestLoginAuthentication(_ reason: String)
  func validateTouchIDStateForEmail(_ email: String)
  func isAuthenticationErrorLockout(_ error: NSError?) -> Bool
  func isAuthenticationErrorRetryable(_ error: NSError?) -> Bool
  func shouldDisplayEnableErrorMessage(_ error: NSError?) -> BiometricAuthenticationMessage?
  func disableOnReinstall() -> Bool
  func evaluateBiometricSettings(lockoutHandler: @escaping () -> Void,
                                 notEnrolledHandler: @escaping () -> Void) -> Bool
  func processBiometricLoginFailure()

  // Convience method acts as inverse to `isTouchAuthenticationEnabled()`
  func isBiometricAuthUnavailable() -> Single<Void>
}

/**
 *  Extension to act as a Mix-in of TouchID Auth handling:
 *  ViewControllers can be composed of the BiometricAuthenticationMixin, and will
 *  receive the default implementation of TouchID authentication while still providing
 *  ViewControllers with the ability to provide their own custom implementations
 *  when necessary.
 **/
extension BiometricAuthenticationMixin {

  /// use the shared authenticator unless it needs to be mocked
  var biometricAuthenticator: BiometricAuthenticator {
    get {
      return BiometricAuthenticator.shared
    }
    set {
      BiometricAuthenticator.shared = newValue
    }
  }

  var session: ArcusSession? {
    return RxCornea.shared.session
  }

  var authShowLoginable: BiometricAuthShowLoginable {
    return ApplicationRoutingService.defaultService
  }

  /// returns if BioAuth is available at an OS Level, and an error if not
  func isTouchAuthenticationAvailable(_ error: NSErrorPointer = nil) -> Bool {
    var isAvailable: Bool = false

    isAvailable = biometricAuthenticator.isAvailable(error)

    if let error = error?.pointee {
      print("LAError: \(error.localizedDescription)")
    }
    return isAvailable
  }

  /// returns if BioAuth is available at an Application level
  func isTouchAuthenticationEnabled() -> Single<Void> {
    return biometricAuthenticator.isEnabled()
  }

  /// Returns if the user's account can be logged in, (this is a setting that is independant
  /// of Bio Auth being enabled, this basicaly says if we have the means to log the user in.
  func isTouchAuthenticationAccountEnabled() -> Single<Void> {
    return biometricAuthenticator.isAccountEnabled()
  }

  func isBiometricAuthUnavailable() -> Single<Void> {
    return biometricAuthenticator.isNotEnabled()
  }

  /// set the preference to use Bio Auth to true
  func enableTouchAuthentication(_ account: String,
                                 password: String) {
    try? biometricAuthenticator.setEnabled(true,
                                           account: account,
                                           password: password)
  }

  /// unset the preference to use Bio Auth
  func disableTouchAuthentication() {
    biometricAuthenticator.accountKeychain().subscribe(onSuccess: { [weak self] keychain in
      try? self?.biometricAuthenticator.setEnabled(false,
                                                   account: keychain.account,
                                                   password: keychain.value)
    })
      .disposed(by: disposeBag)
  }

  /// remove the means for the user to log in using Bio Auth
  func disableAccountInformation() {
    try? biometricAuthenticator.deleteAccountKeychain()
  }

  /// Facade to evaluate the Bio Auth
  func requestTouchAuthentication(_ reason: String,
                                  completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    biometricAuthenticator
      .requestLocalAuthentication(reason,
                                  completion: { (success, err) in
                                    self.biometricAuthenticator = BiometricAuthenticator()
                                    completion(success, err)
      })
  }

  func requestLoginAuthentication(_ reason: String = "Please Authenticate to Proceed.") {
    biometricAuthenticator.requestLocalAuthentication(reason) {
      (success, error) in
      if success == true,
        error == nil {
        self.enabledUserCredentials().subscribe(
          onSuccess: { keychain in
            self.biometricAuthenticator = BiometricAuthenticator()

            if self.session?.token != nil {
              self.session?.connect()
            } else {
              self.session?.login(keychain.account,
                                  password: keychain.value,
                                  completion: { succes, error in
                                    if !succes || error != nil {
                                      self.processBiometricLoginFailure()
                                    }
              })
            }
        }, onError: { _ in
          if let err = error {
            if self.isAuthenticationErrorRetryable(err) {
              // Retry
              DispatchQueue.main.async {
                self.authShowLoginable.showLogin(completion: nil)
              }
              return
            }
            self.session?.logout()

            // When the OS removes the Overlay do this work
            // Toggle Force the User to Log int
            self.disableAccountInformation()
            self.biometricAuthenticator = BiometricAuthenticator()
          }
        }).disposed(by: self.disposeBag)
      } else if let err = error {
        if self.isAuthenticationErrorRetryable(err) {
          // Retry
          DispatchQueue.main.async {
            self.authShowLoginable.showLogin(completion: nil)
          }
          return
        }
        self.session?.logout()

        // When the OS removes the Overlay do this work
        // Toggle Force the User to Log int
        self.disableAccountInformation()
        self.biometricAuthenticator = BiometricAuthenticator()
      }
    }
  }

  /// If the user wants to use Bio Auth these credentials exist
  func enabledUserCredentials() -> Single<LSArcusKeychain> {
    return biometricAuthenticator.accountKeychain()
  }

  /// Set the Account Credentials
  func saveUserCredentials(_ email: String,
                           password: String) {
    // Clear all of Keychains for kKeyArcusActiveCredentialService
    deleteUserCredentials(email) { _ in
      let userKeychain = LSArcusKeychain(value: password,
                                        account: email,
                                        service: kKeyArcusActiveCredentialService)
      try? LSArcusKeystore.saveKeychain(userKeychain)

      // Restore TouchID credentials
      self.isTouchAuthenticationEnabled()
        .flatMap { _ in
          return self.biometricAuthenticator.enabledKeychain()
        }
        .subscribe(
          onSuccess: { [weak self, email] keychain in
            if keychain.value == email {
              self?.enableTouchAuthentication(email, password: password)
            }
        }).disposed(by: self.disposeBag)
    }
  }

  /// Fetch the account credentials
  func fetchUserCredentials(_ email: String) -> Single<LSArcusKeychain> {
    return LSArcusKeystore.fetchKeychain(email, service: kKeyArcusActiveCredentialService, retry: 5, delay: 0.5)
  }

  /// remove the account credentials
  func deleteUserCredentials(_ email: String, completion: (() -> Void)?) {
    fetchUserCredentials(email).subscribe(
      onSuccess: { keychain in
        try? LSArcusKeystore.deleteKeychain(keychain)
        completion?()
    }, onError: { _ in
      completion?()
    }).disposed(by: disposeBag)
  }

  /// the preference to use TouchID is on a per account basis
  func validateTouchIDStateForEmail(_ email: String) {
    // If TouchID is enabled, but account changes, then we need to disable TouchID.
    isTouchAuthenticationEnabled()
      .flatMap { [self, email] _ in
        return self.fetchUserCredentials(email)
      }
      .subscribe(
        onSuccess: { [weak self, email] keychain in
          if keychain.value != email {
            self?.disableTouchAuthentication()
          }
      }).disposed(by: disposeBag)
  }

  /// given an optional error return true if the error is `LAError.Code.touchIDNotEnrolled`
  func isAuthenticationNotEnrolled(_ error: NSError?) -> Bool {
    if let err = error,
      err.domain == LAErrorDomain,
      let code = LAError.Code(rawValue: err.code),
      code == LAError.Code.touchIDNotEnrolled {
      return true
    }
    return false
  }

  /// given an optional error return true if the error is `LAError.Code.touchIDLockout`
  func isAuthenticationErrorLockout(_ error: NSError?) -> Bool {
    if let err = error,
      err.domain == LAErrorDomain,
      let code = LAError.Code(rawValue: err.code),
      code == LAError.Code.touchIDLockout {
      return true
    }
    return false
  }

  /// given an optional error return true if the error is `LAError.Code.systemCancel`
  func isAuthenticationErrorRetryable(_ error: NSError?) -> Bool {
    if let err = error,
      err.domain == LAErrorDomain,
      let code = LAError.Code(rawValue: err.code),
      (code == LAError.Code.systemCancel ||
        code == LAError.Code.userCancel ||
        code == LAError.Code.userFallback) {
      return true
    }
    return false
  }

  func shouldDisplayEnableErrorMessage(_ error: NSError?) -> BiometricAuthenticationMessage? {

    var isIphoneX = false
    if UIDevice().userInterfaceIdiom == .phone {
      let screenSize = UIScreen.main.nativeBounds.height
      if screenSize == 2436 {
        isIphoneX = true
      }
    }

    if #available(iOS 11.0, *) {
      if let err = error,
        err.domain == LAErrorDomain,
        let code = LAError.Code(rawValue: err.code) {
        if code == LAError.Code.biometryNotAvailable && isIphoneX {
          return .accessRevoked
        } else if code == .biometryNotEnrolled {
          return .biometryNotEnrolled
        } else if code == .biometryNotAvailable {
          return .biometryNotAvailable
        }
      }
    } else {
      if let err = error,
        err.domain == LAErrorDomain,
        let code = LAError.Code(rawValue: err.code) {
        if code == LAError.Code.touchIDNotAvailable {
          return .biometryNotAvailable
        } else if code == .touchIDNotEnrolled {
          return .biometryNotEnrolled
        }
      }
    }
    return nil
  }

  /// Helper function to reset all Bio Auth preferences when the user uninstalls the app
  /// This function should be called on App Startup to check if user preferences has
  /// deleted the app and run logic if the app has been deleted before eash app start
  /// Return True if needed to to logic
  func disableOnReinstall() -> Bool {
    DDLogInfo("BiometricAuthenticationMixin.deleteOnReinstall()")
    let prefs = UserDefaults.standard
    let allowed: Bool = prefs.bool(forKey: Constants.biometricReinstallCheck)
    if !allowed {
      DDLogInfo("No key found, disabling BiometricAuthentication")
      disableTouchAuthentication()
      prefs.set(true, forKey: Constants.biometricReinstallCheck)
      prefs.synchronize()
      return true
    }
    return false
  }

  /// return true if their are no lockout or enrollment errors
  func evaluateBiometricSettings(lockoutHandler: @escaping () -> Void,
                                 notEnrolledHandler: @escaping () -> Void) -> Bool {
    var error: NSError? = nil
    _ = biometricAuthenticator.isAvailable(&error)

    // Check that the user has not locked themselves out
    if isAuthenticationErrorLockout(error) {
      isTouchAuthenticationAccountEnabled().subscribe(onSuccess: { _ in
        DDLogWarn("Lockout")
        lockoutHandler()

      }).disposed(by: disposeBag)

      return false
    }

    // Check that fingerprints or face is still registered.
    if isAuthenticationNotEnrolled(error) {
      isTouchAuthenticationAccountEnabled().subscribe(onSuccess: { _ in
        DDLogWarn("Finger's Removed while bio auth is active")
        notEnrolledHandler()

      }).disposed(by: disposeBag)

      return false
    }

    return true
  }

  /// handle login failure after successful biometric auth.
  /// can occur when the user changes their password.
  func processBiometricLoginFailure() {
    // Bad account info.  Must disable account info and logout.
    disableAccountInformation()
    session?.logout()
    // Will display message once app has routed to login.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      ApplicationRoutingService.defaultService.displayMessage(.lockout)
    }
  }
}
