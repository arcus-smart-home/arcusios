//
//  UserAuthenticationController.swift
//  i2app
//
//  Created by Aron Crittendon on 11/16/17.
//  Copyright © 2017 Lowes Corporation. All rights reserved.
//

import Foundation

typealias LoginCompletion = (Bool, Error?) -> Void
typealias LogoutCompletion = () -> Void

protocol UserAuthenticationController {
  var userAuthenticationControllerSession: IrisSession? { get }
  func loginUser(_ email: String,
                        password: String,
                        completion: @escaping LoginCompletion)
  func logout(_ completion: LogoutCompletion)
}

extension UserAuthenticationController {

  var userAuthenticationControllerSession: IrisSession? {
    return RxCornea.shared.session
  }

  func loginUser(_ email: String,
                 password: String,
                 completion: @escaping LoginCompletion) {
    guard let session = userAuthenticationControllerSession else {
      // TODO: Return Error
      completion(false, nil)
      return
    }
    session.login(email, password: password, completion: completion)
  }

  func logout(_ completion: LogoutCompletion) {
    guard let session = userAuthenticationControllerSession else {
      completion()
      return
    }
    session.logout()
    completion()
  }
}
