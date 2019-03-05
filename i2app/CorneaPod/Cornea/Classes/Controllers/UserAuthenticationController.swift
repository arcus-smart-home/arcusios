//
//  UserAuthenticationController.swift
//  i2app
//
//  Created by Arcus Team on 11/16/17.
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

public typealias LoginCompletion = (Bool, Error?) -> Void
public typealias LogoutCompletion = () -> Void

public protocol UserAuthenticationController {
  var userAuthenticationControllerSession: ArcusSession? { get }
  func loginUser(_ email: String,
                        password: String,
                        completion: @escaping LoginCompletion)
  func logout(_ completion: LogoutCompletion)
}

public extension UserAuthenticationController {

  public var userAuthenticationControllerSession: ArcusSession? {
    return RxCornea.shared.session
  }

  public func loginUser(_ email: String,
                 password: String,
                 completion: @escaping LoginCompletion) {
    guard let session = userAuthenticationControllerSession else {
      // TODO: Return Error
      completion(false, nil)
      return
    }
    session.login(email, password: password, completion: completion)
  }

  public func logout(_ completion: LogoutCompletion) {
    guard let session = userAuthenticationControllerSession else {
      completion()
      return
    }
    session.logout()
    completion()
  }
}
