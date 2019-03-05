//
//  BiometricAuthenticator.swift
//  i2app
//
//  Created by Arcus Team on 10/24/16.
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
import Cornea
import RxSwift
import RxSwiftExt

protocol LAContextable {
  func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
  func evaluatePolicy(_ policy: LAPolicy,
                      localizedReason: String,
                      reply: @escaping (Bool, Error?) -> Void)
}

extension LAContext: LAContextable {}

/// Service Key saved to the Secure Keychain
/// Warning do not change without a migration
let kTouchIDService: String = "ArcusTouchIDService"

/// Account Key saved to the Secure Keychain
/// Warning do not change without a migration
let kTouchIDAccount: String = "ArcusTouchIDAccount"

/// Active  Account Service Key (keychain service to use)
/// Warning do not change without a migration
let kKeyArcusActiveCredentialService: String = "ArcusActiveCredentialService"

/// Active Account Credential Key (key for the account password that most recently logged in)
/// Warning do not change without a migration
let kKeyArcusActiveCredentialAccount: String = "ArcusActiveCredentialAccount"

/**
 * Biometric Implementation of LocalAuthenticator:
 *    Provides methods to check TouchID availability, get & set enabled, and
 *    process TouchID Authentication.
 *
 * Because the LAPolicy and LAContext are not reset by users of `BiometricAuthenticator` to invalidate them
 * after being evaluated please recreate the instance of `BiometricAuthenticator` after
 * requestLocalAuthentication(_:completion:_) is called
 *
 */
class BiometricAuthenticator: LocalAuthenticator {

  /// Policy for this evaluation
  let policy: LAPolicy
  /// Context for this evaluation
  let context: LAContextable

  var disposeBag: DisposeBag = DisposeBag()

  static var shared: BiometricAuthenticator  = BiometricAuthenticator()

  // MARK: Initializers

  init(policy: LAPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics,
       context: LAContextable = LAContext()) {
    self.policy = policy
    self.context = context
  }

  // MARK: LocalAuthenticator Implementation

  func isAvailable(_ error: NSErrorPointer) -> Bool {
    return context.canEvaluatePolicy(policy, error: error)
  }

  //  func isAccountEnabled() -> Bool {
  //    return enabledKeychain() != nil
  //  }
  //
  //  func isEnabled() -> Bool {
  //    if isAvailable(nil),
  //      isAccountEnabled(),
  //      accountKeychain() != nil {
  //      return true
  //    }
  //    return false
  //  }

  func setEnabled(_ enable: Bool,
                  account: String,
                  password: String) throws {
    if enable {
      try setEnabledKeychain(account)
      try setAccountKeychain(account,
                             password: password)
    } else {
      try deleteEnabledKeychain()
      try deleteAccountKeychain()
    }
  }

  func requestLocalAuthentication(_ reason: String,
                                  completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    requestLocalAuth(reason,
                     policy: policy,
                     context: context,
                     completion: completion)
  }

  // MARK: Keychain Convenience Methods

  //  func enabledKeychain() -> LSArcusKeychain? {
  //    return LSArcusKeystore.fetchKeychain(kTouchIDAccount, service: kTouchIDService)
  //  }
  //
  //  func accountKeychain() -> LSArcusKeychain? {
  //    var result: LSArcusKeychain?
  //    if let enabledKeychain = enabledKeychain() {
  //      result = LSArcusKeystore.fetchKeychain(enabledKeychain.value, service: kTouchIDService)
  //    }
  //    return result
  //  }

  // MARK: Private Methods - Keychain

  fileprivate func setEnabledKeychain(_ account: String) throws {
    let enabledKeychain: LSArcusKeychain = LSArcusKeychain(value: account,
                                                         account: kTouchIDAccount,
                                                         service: kTouchIDService)
    try LSArcusKeystore.saveKeychain(enabledKeychain)
  }

  fileprivate func setAccountKeychain(_ account: String,
                                      password: String) throws {
    let accountKeychain: LSArcusKeychain = LSArcusKeychain(value: password,
                                                         account: account,
                                                         service: kTouchIDService)
    try LSArcusKeystore.saveKeychain(accountKeychain)
  }

  fileprivate func deleteEnabledKeychain() throws {
    enabledKeychain().subscribe(
      onSuccess: { keychain in
        try? LSArcusKeystore.deleteKeychain(keychain)
    }).disposed(by: disposeBag)
  }

  func deleteAccountKeychain() throws {
    accountKeychain().subscribe(
      onSuccess: { keychain in
        try? LSArcusKeystore.deleteKeychain(keychain)
    }).disposed(by: disposeBag)
  }

  func isAccountEnabled() -> Single<Void> {
    return enabledKeychain().map { _ in
      return
    }
  }

  func isEnabled() -> Single<Void> {
    if isAvailable(nil) {
      return accountKeychain().flatMap { [self] _ in
        return self.isAccountEnabled()
      }
    } else {
      return Single<Void>.create { single in
        single(.error(ArcusKeystoreError(type: .keychainNotFound)))
        return Disposables.create()
      }
    }
  }

  func isAccountNotEnabled() -> Single<Void> {
    return Single<Void>.create { [weak self, disposeBag] single in
      let disposable = self?.nonRetryEnabledKeychain().subscribe(
        onSuccess: { _ in },
        onError: { [single] _ in
          single(.success())
      })
      disposable?.disposed(by: disposeBag)

      return Disposables.create()
    }
  }

  func isNotEnabled() -> Single<Void> {
    if isAvailable(nil) {
      return Single<Void>.create { [self, disposeBag] single in
        self.nonRetryAccountKeychain()
          .subscribe(
            onSuccess: { [single] _ in
              single(.error(ClientError(errorType: .genericError)))
            },
            onError: { [single] _ in
              single(.success())
          }).disposed(by: disposeBag)

        return Disposables.create()
      }
    } else {
      return Single<Void>.create { single in
        single(.success())
        return Disposables.create()
      }
    }
  }

  // MARK: Private Methods - Authentication

  fileprivate func requestLocalAuth(_ reason: String,
                                    policy: LAPolicy,
                                    context: LAContextable,
                                    completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    var error: NSError? = nil

    if isAvailable(&error) {
      context.evaluatePolicy(policy,
                             localizedReason: reason) {
                              (success, evaluateError) in
                              completion(success, evaluateError as NSError?)

      }
    } else {
      DispatchQueue.main.async {
        completion(false, error)
      }
    }
  }
}

extension BiometricAuthenticator {
  func nonRetryEnabledKeychain() -> Single<LSArcusKeychain> {
    let single: Single<LSArcusKeychain> = LSArcusKeystore.fetchKeychain(kTouchIDAccount,
                                                                      service: kTouchIDService,
                                                                      retry: 0,
                                                                      delay: 0.0)
    return single
  }

  func enabledKeychain() -> Single<LSArcusKeychain> {
    let single: Single<LSArcusKeychain> = LSArcusKeystore.fetchKeychain(kTouchIDAccount,
                                                                      service: kTouchIDService,
                                                                      retry: 5,
                                                                      delay: 2.0)
    return single
  }

  func nonRetryAccountKeychain() -> Single<LSArcusKeychain> {
    let single: Single<LSArcusKeychain> = nonRetryEnabledKeychain()
    return single.flatMap { keychain in
      let single: Single<LSArcusKeychain> = LSArcusKeystore.fetchKeychain(keychain.value,
                                                                        service: kTouchIDService,
                                                                        retry: 0,
                                                                        delay: 0.0)
      return single
    }
  }

  func accountKeychain() -> Single<LSArcusKeychain> {
    let single: Single<LSArcusKeychain> = enabledKeychain()
    return single.flatMap { keychain in
      let single: Single<LSArcusKeychain> = LSArcusKeystore.fetchKeychain(keychain.value,
                                                                        service: kTouchIDService,
                                                                        retry: 5,
                                                                        delay: 2.0)
      return single
    }
  }
}
