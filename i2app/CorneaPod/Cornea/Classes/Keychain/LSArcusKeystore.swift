//
//  LSArcusKeystore.swift
//  i2app
//
//  Created by Arcus Team on 7/31/17.
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
import RxSwift
import RxSwiftExt
import CocoaLumberjack

/**
 `LSArcusKeystore` is class that conforms to `ArcusKeystore` and implements functionality from `Locksmith` to
 enable data I/O with the iOS Keychain Service.
 */
public class LSArcusKeystore: ArcusKeystore {
  /**
   Save the data (value, account, service) from class conforming to `ArcusKeychain` in the iOS Keychain

   - Parameters:
   - keychain: Any class/struct conforming to `ArcusKeychain` that is to be saved.

   - Throws: Error if saving the keychain fails.
   */
  public static func saveKeychain<T: ArcusKeychain>(_ keychain: T) throws {
    // `keychain` must conform to `CreateableSecureStorable` in order to save with Locksmith
    guard let creatable = keychain as? CreateableSecureStorable else {
      return
    }

    var shouldUpdate = false

    // Attempt to save the Keychain
    do {
      try creatable.createInSecureStore()
    } catch LocksmithError.duplicate {
      shouldUpdate = true
    } catch {
      throw error
    }

    if shouldUpdate == true {
      // Attempt to update the Keychain
      do {
        try creatable.updateInSecureStore()
      } catch {
        throw error
      }
    }
  }

  /**
   Fetch an `ArcusKeychain` from the iOS Keychain.

   - Parameters:
   - account: A `String` that acts as the first part of super-key used to look-up the `ArcusKeychain`
   - service: A `String` that acts as the second part of the super-key used to look-up the `ArcusKeychain`

   - Returns: Instance of a class conforming to `ArcusKeychain`
   */
  public static func fetchKeychain<T: ArcusKeychain>(_ account: String, service: String) -> T? {
    // Create Instance of `LSArcusKeychain` in order to read the data from the secure store.
    let keychain = LSArcusKeychain(account: account, service: service)

    // Return `ArcusKeychain` if found.
    if let result = LSArcusKeystore.create(keychain.readFromSecureStore()) as? T {
      return result
    }

    // swiftlint:disable:next line_length
    DDLogError("LSArcusKeystore Error: Key not found.  If you don't expect a value then this is fine.  Otherwise feel free to panic.")
    return nil
  }

  /**
   Delete an `ArcusKeychain` from the iOS Keychain.

   - Parameters:
   - keychain: Any class/struct conforming to `ArcusKeychain` that is to be deleted.

   - Throws: Error if deleting the keychain fails.
   */
  public static func deleteKeychain<T: ArcusKeychain>(_ keychain: T) throws {
    // `keychain` must conform to `DeleteableSecureStorable` in order to delete with Locksmith
    guard let deletable = keychain as? DeleteableSecureStorable else {
      return
    }

    // Attempt to delete the keychain
    do {
      try deletable.deleteFromSecureStore()
    } catch {
      throw error
    }
  }

  // MARK: Private Functions

  /**
   Private function used to create an instance of `LSArcusKeychain` from
   `GenericPasswordSecureStorableResultType`.

   - Parameters:
   - result: optional `GenericPasswordSecureStorableResultType` used to create instance of `LSArcusKeychain`

   - Returns: optional `LSArcusKeychain` created from result.
   */
  fileprivate static func create(_ result: GenericPasswordSecureStorableResultType?) -> LSArcusKeychain? {
    // Return nil if the result is not set properly.
    guard result != nil,
      let value = result?.data?["value"] as? String,
      let account = result?.account,
      let service = result?.service else { return nil }

    return LSArcusKeychain(value: value, account: account, service: service)
  }
}

/**
 `LSArcusFirstUnlockKeychain` is a duplicate of the `LSArcusKeychain` struct that conforms to `ArcusKeychain`,
 and Locksmith protocols (`ReadableSecureStorable`, `CreateableSecureStorable`, `DeleteableSecureStorable`,
 `GenericPasswordSecureStorable`) so that it can be saved & retrieved from iOS Keychain Services.

 This struct is intended to ONLY be used by LSArcusKeystore when saving a keychain.
 */
fileprivate struct LSArcusFirstUnlockKeychain: ArcusKeychain,
  ReadableSecureStorable,
  CreateableSecureStorable,
  DeleteableSecureStorable,
GenericPasswordSecureStorable {
  var accessible: LocksmithAccessibleOption? = .afterFirstUnlock
  var value: String = ""
  var account: String = ""
  var service: String = ""
  var data: [String: Any] {
    return ["value": value]
  }

  /**
   Init with account & service.  Used when needing to look-up value from the iOS Keychain.

   - Parameters:
   - account: `String` is the first part of the super-key used to look-up the value from the secure store.
   - service: `String` is the second part of the super-key used to look-up the value from the secure store.
   */
  init(account: String, service: String) {
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
  init(value: String, account: String, service: String) {
    self.value = value
    self.account = account
    self.service = service
  }
}

public extension LSArcusKeystore {
  public static func fetchKeychain<T: ArcusKeychain>(_ account: String,
                                             service: String,
                                             retry: UInt,
                                             delay: Double) -> Single<T> {
    let observable: Observable<T> = fetchKeychainObservable(account, service: service)
    return observable.retry(RepeatBehavior.delayed(maxCount: retry, time: delay)).asSingle()
  }

  private static func fetchKeychainObservable<T: ArcusKeychain>(_ account: String,
                                                               service: String) -> Observable<T> {
    return Observable<T>.create { observer in
      if let keychain: T = fetchKeychain(account, service: service) {
        observer.onNext(keychain)
        observer.onCompleted()
      } else {
        observer.onError(ArcusKeystoreError(type: .keychainNotFound))
      }
      return Disposables.create()
    }
  }
}
