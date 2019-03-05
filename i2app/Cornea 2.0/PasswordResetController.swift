//
//  PasswordResetController.swift
//  i2app
//
//  Created by Aron Crittendon on 11/17/17.
//  Copyright © 2017 Lowes Corporation. All rights reserved.
//

import Foundation

typealias PasswordResetCompletion = (Bool, Error?) -> Void

// TODO: Find appropriate Controller for this functionality.  Likely PersonController since it relies on
// PersonService.
protocol PasswordResetController {
  static func sendPasswordReset(_ email: String, completion: PasswordResetCompletion)
  static func resetPassword(_ email: String,
                            resetToken: String,
                            password: String,
                            completion: PasswordResetCompletion)
  static func changePassword(_ email: String,
                             currentPassword: String,
                             newPassword: String,
                             completion: PasswordResetCompletion)
}


// TODO: Implement or Delete
/*
extension PasswordResetController {
  static func sendPasswordReset(_ email: String,
                                completion: PasswordResetCompletion) {
    completion(true, nil)
  }

  static func resetPassword(_ email: String,
                            resetToken: String,
                            password: String,
                            completion: PasswordResetCompletion) {
    completion(true, nil)
  }

  static func changePassword(_ email: String,
                             currentPassword: String,
                             newPassword: String,
                             completion: PasswordResetCompletion) {
    completion(true, nil)
  }
}
*/
