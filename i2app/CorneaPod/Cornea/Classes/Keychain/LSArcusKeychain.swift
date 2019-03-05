//
//  ArcusToken.swift
//  i2app
//
//  Created by Arcus Team on 7/14/17.
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
import Locksmith

/**
 `LSArcusKeychain` is struct that conforms to `ArcusKeychain`, and Locksmith protocols 
 (`ReadableSecureStorable`, `CreateableSecureStorable`, `DeleteableSecureStorable`, 
 `GenericPasswordSecureStorable`) so that it can be saved & retrieved from iOS Keychain Services.
 */
public struct LSArcusKeychain: ArcusKeychain,
  ReadableSecureStorable,
  CreateableSecureStorable,
  DeleteableSecureStorable,
GenericPasswordSecureStorable {
  public var value: String = ""
  public var account: String = ""
  public var service: String = ""
  public var data: [String: Any] {
    return ["value": value]
  }

  /**
   Init with account & service.  Used when needing to look-up value from the iOS Keychain.

   - Parameters:
   - account: `String` is the first part of the super-key used to look-up the value from the secure store.
   - service: `String` is the second part of the super-key used to look-up the value from the secure store.
   */
  public init(account: String, service: String) {
    self.account = account
    self.service = service
  }

  /**
   Init with value, account & service.  Used when needing to create a new instance to be saved to the iOS 
   Keychain.

   - Parameters:
   - account: `String` is the first part of the super-key used to look-up the value from the secure store.
   - service: `String` is the second part of the super-key used to look-up the value from the secure store.
   */
  public init(value: String, account: String, service: String) {
    self.value = value
    self.account = account
    self.service = service
  }
}
