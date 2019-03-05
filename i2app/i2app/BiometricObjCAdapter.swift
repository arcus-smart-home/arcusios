//
//  BiometricObjCAdapter.swift
//  i2app
//
//  Created by Arcus Team on 11/30/16.
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
import PromiseKit

/**
 * NSObject that can be instantiated by Objective-C to act as an adapter to
 * allow Objective-C classes to consume the Swift Mix-in.
 **/
class BiometricObjCAdapter: NSObject {
  fileprivate class TouchIDMixin: BiometricAuthenticationMixin {
    var disposeBag: DisposeBag = DisposeBag()

    var biometricAuthenticator: BiometricAuthenticator?

    // MARK: View LifeCycle
    required init() {
      biometricAuthenticator = BiometricAuthenticator()
    }
  }

  fileprivate var touchIDMixin: TouchIDMixin = TouchIDMixin()

  func isTouchAuthenticationAvailable() -> Bool {
    return touchIDMixin.isTouchAuthenticationAvailable()
  }

  func isTouchAuthenticationEnabled() -> PMKPromise {
    return PMKPromise.new { [self] (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
      self.touchIDMixin.isTouchAuthenticationEnabled()
        .subscribe(
          onSuccess: { [fulfiller] result in
            fulfiller?(result)
        }).disposed(by: self.touchIDMixin.disposeBag)
    }
  }

  func enableTouchAuthentication(_ account: String,
                                 password: String) {
    touchIDMixin.enableTouchAuthentication(account,
                                           password: password)
  }

  func disableTouchAuthentication() {
    touchIDMixin.disableTouchAuthentication()
  }

  func requestTouchAuthentication(_ reason: String,
                                  completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    touchIDMixin.requestTouchAuthentication(reason, completion: completion)
  }

  func validateTouchIDStateForEmail(_ email: String) {
    touchIDMixin.validateTouchIDStateForEmail(email)
  }

  func disableOnReinstall() {
    touchIDMixin.disableOnReinstall()
  }
}
