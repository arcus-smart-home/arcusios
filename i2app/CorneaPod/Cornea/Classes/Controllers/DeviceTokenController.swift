//
//  DeviceTokenController.swift
//  i2app
//
//  Created by Arcus Team on 11/21/17.
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
import RxSwift
import CocoaLumberjack

public extension Constants {
  public static let kDeviceToken = "deviceToken"
  public static let kDeviceTokenService = "deviceTokenService"
  public static let kDeviceUDID = "deviceUDID"
  public static let kDeviceUDIDService = "deviceUDIDService"
  public static let kLegacyDeviceUDID = "DeviceUDID"
}

public protocol DeviceTokenController {
  var disposeBag: DisposeBag { get set }

  func saveDeviceToken(_ value: String)
  func getDeviceToken() -> Single<LSArcusKeychain>
  func deleteDeviceToken()

  func saveDeviceUDID(_ udid: String)
  func getDeviceUDID() -> Single<LSArcusKeychain>
  func deleteStoredDeviceUDID()
}

extension DeviceTokenController {
  public func saveDeviceToken(_ value: String) {
    let token = LSArcusKeychain(value: value,
                               account: Constants.kDeviceToken,
                               service: Constants.kDeviceTokenService)
    do {
      try LSArcusKeystore.saveKeychain(token)
    } catch {
      DDLogDebug(error.localizedDescription)
    }
  }

  public func getDeviceToken() -> Single<LSArcusKeychain> {
    return LSArcusKeystore.fetchKeychain(Constants.kDeviceToken,
                                        service: Constants.kDeviceTokenService,
                                        retry: 5,
                                        delay: 0.5)
  }

  public func deleteDeviceToken() {
    getDeviceToken().subscribe(
      onSuccess: { keychain in
        do {
          try LSArcusKeystore.deleteKeychain(keychain)
        } catch {
          DDLogDebug(error.localizedDescription)
        }
    },
      onError: { error in
        DDLogDebug(error.localizedDescription)
    }).disposed(by: disposeBag)
  }

  public func saveDeviceUDID(_ udid: String) {
    let udidKeychain = LSArcusKeychain(value: udid,
                                      account: Constants.kDeviceUDID,
                                      service: Constants.kDeviceUDIDService)
    do {
      try LSArcusKeystore.saveKeychain(udidKeychain)
    } catch {
      DDLogDebug(error.localizedDescription)
    }
  }

  public func getDeviceUDID() -> Single<LSArcusKeychain> {
    return LSArcusKeystore.fetchKeychain(Constants.kDeviceUDID,
                                        service: Constants.kDeviceUDIDService,
                                        retry: 5,
                                        delay: 0.5)
  }

  public func deleteStoredDeviceUDID() {
    getDeviceUDID().subscribe(
      onSuccess: { keychain in
        do {
          try LSArcusKeystore.deleteKeychain(keychain)
        } catch {
          DDLogDebug(error.localizedDescription)
        }
    },
      onError: { error in
        DDLogDebug(error.localizedDescription)
    }).disposed(by: disposeBag)
  }
}
