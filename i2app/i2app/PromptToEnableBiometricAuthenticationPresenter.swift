//
//  PromptToEnableBiometricAuthenticationPresenter.swift
//  i2app
//
//  Created by Arcus Team on 10/17/17.
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
import LocalAuthentication
import Cornea
import RxSwift

let biometricPromptDisplayedKey = "BiometricEnrollmentPromptDisplayed_1"

/// Enum to answer the question Display TouchID or FaceID?
@objc enum AuthProtocols: Int {
  case faceID
  case touchID
  case none

  static var current: AuthProtocols {
    guard #available(iOS 11.0, *) else {
      return .touchID
    }
    let authContext = LAContext()
    _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    // This could also be `biometryType.none` but we will ignore that case here, it should not be displayed
    if authContext.biometryType == .faceID {
      return .faceID
    } else if authContext.biometryType == .touchID {
      return .touchID
    } else {
      return .none
    }
  }

  var title: String {
    switch self {
    case .faceID:
      return NSLocalizedString("Face ID", comment:"")
    case .touchID:
      return NSLocalizedString("Touch ID", comment:"")
    case .none:
      return NSLocalizedString("Touch ID or Face ID", comment:"")
    }
  }
}

class AuthProtocolsObjcHelper: NSObject {
  class var currentAuthProtocolTitle: String {
    return AuthProtocols.current.title
  }

  class var current: AuthProtocols {
    return AuthProtocols.current
  }
}

protocol PromptToEnableBiometricAuthenticationDelegateProtocol: class {
  /// Success!, View should display success and dismiss itself
  func shouldShowSuccessAndExit()
}

protocol PromptToEnableBiometricAuthenticationPresenterFetchProtocol {
  /**
   Check if Biometric Auth Prompt should be displayed

   Requirements:
   - Phone is eleigable for Biometric Auth
   - User has not already enabled Biometric Auth before
   */
  func shouldDisplayPromptToEnableBiometricAuthentication() -> Single<Void>
}

protocol PromptToEnableBiometricAuthenticationPresenterProtocol: class {
  /// Call to enable Biometric Auth
  func shouldEnableBiometricAuthentication()

  /// will set the preference that view has been displayed
  func enrollmentHasDisplayed()

  var delegate: PromptToEnableBiometricAuthenticationDelegateProtocol? { get set }
}

/// Presenter to handle all actions to Enabled Biometric Authentication
/// - seealso: PromptToEnableBiometricAuthenticationViewController
class PromptToEnableBiometricAuthenticationPresenter: BiometricAuthenticationMixin,
  PromptToEnableBiometricAuthenticationPresenterFetchProtocol,
PromptToEnableBiometricAuthenticationPresenterProtocol {
  var biometricAuthenticator: BiometricAuthenticator?
  var activeUserKeychain: LSArcusKeychain?
  var userDefaults: UserDefaults!

  var disposeBag: DisposeBag = DisposeBag()

  // MARK: View LifeCycle
  required init(_ userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults
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

  // MARK: View LifeCycle

  func shouldDisplayPromptToEnableBiometricAuthentication() -> Single<Void> {
    return Single<Void>.create { [weak self, disposeBag] single in
      let displayed: Bool? = self?.userDefaults.bool(forKey: biometricPromptDisplayedKey)
      let available = self?.isTouchAuthenticationAvailable()
      if displayed != nil, available != nil, available! && !displayed! {
        self?.isTouchAuthenticationEnabled().subscribe(
          onSuccess: { [single] _ in
            single(.error(ClientError(errorType: .genericError)))
          },
          onError: { [single] _ in
            single(.success())
        }).disposed(by: disposeBag)

      }
      return Disposables.create()
    }
  }

  weak var delegate: PromptToEnableBiometricAuthenticationDelegateProtocol?

  func shouldEnableBiometricAuthentication() {
    requestTouchAuthentication("Please Authenticate to Proceed.") { (finished, _) in
      if finished {
        if self.activeUserKeychain != nil {
          self.enableTouchAuthentication(self.activeUserKeychain!.account,
                                         password: self.activeUserKeychain!.value)
        } else if let account = RxCornea.shared.session?.activeUser?.value.removingPercentEncoding {
          // Set keychain without password.
          //This will allow biometric authentication to work until next login.
          self.enableTouchAuthentication(account, password: "*")
        }
        DispatchQueue.main.async {
          self.delegate?.shouldShowSuccessAndExit()
        }
      } else {
        // DO NOTHING here, the user will need to dismiss themselves
      }
    }
  }

  /// will set the preference that view has been displayed
  func enrollmentHasDisplayed() {
    userDefaults.set(true, forKey: biometricPromptDisplayedKey)
    userDefaults.synchronize()
  }
}
