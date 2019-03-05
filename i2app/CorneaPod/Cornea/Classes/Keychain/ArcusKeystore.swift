//
//  ArcusKeystore.swift
//  i2app
//
//  Created by Arcus Team on 7/13/17.
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

public struct ArcusKeystoreError: Error {
  public enum ErrorType {
    case keychainNotFound
  }

  public let type: ErrorType

  public init(type: ErrorType) {
    self.type = type
  }
}

/*
`ArcusKeystore` protocol establishes the expected functionality of a conforming class to allow for interaction
 with the iOS Keychain Services.
 **/
public protocol ArcusKeystore {
  /**
   Save the data (value, account, service) from class conforming to `ArcusKeychain` in the iOS Keychain

   - Parameters:
   - keychain: Any class/struct conforming to `ArcusKeychain` that is to be saved.
   - error:  An optional `ErrorPointer` allowing for errors occurring during operation to be returned to the
   calling class.
   */
  static func saveKeychain<T: ArcusKeychain>(_ keychain: T) throws

  /**
   Fetch an `ArcusKeychain` from the iOS Keychain.

   - Parameters:
   - account: A `String` that acts as the first part of super-key used to look-up the `ArcusKeychain`
   - service: A `String` that acts as the second part of the super-key used to look-up the `ArcusKeychain`
   calling class.

   - Returns: Instance of a class conforming to `ArcusKeychain`
   */
  static func fetchKeychain<T: ArcusKeychain>(_ account: String, service: String) -> T?

  /**
   Delete an `ArcusKeychain` from the iOS Keychain.

   - Parameters:
   - keychain: Any class/struct conforming to `ArcusKeychain` that is to be deleted..
   - error:  An optional `ErrorPointer` allowing for errors occurring during operation to be returned to the
   calling class.
   */
  static func deleteKeychain<T: ArcusKeychain>(_ keychain: T) throws
}
