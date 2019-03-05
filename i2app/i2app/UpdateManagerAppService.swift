//
//  UpdateManagerAppService.swift
//  i2app
//
//  Created by Arcus Team on 11/14/17.
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

import RxSwift
import CocoaLumberjack
import Cornea
import RxSwift

/**

 */
class UpdateManagerAppService: ArcusApplicationServiceProtocol, BiometricAuthenticationMixin, UrlBuilder {
  var disposeBag: DisposeBag = DisposeBag()

  /**

   */
  required init(eventPublisher: ArcusApplicationServiceEventPublisher) {
    observeApplicationEvents(eventPublisher)
  }

  func serviceDidFinishLaunching(_ event: ArcusApplicationServiceEvent) {
    let updateManager = UpdateManager()
    updateManager
      .initialUpgrade {
      AKFileManager.default().removeAllCachedImages(forHeight: 90, width: 90)
      }
      .upgrade(fromVersion: "2.8", action: {
        self.processArcusClientTokenUpgrade()
      })
      .finalizeUpdate()
  }

  /**
   Function used to update user's token from old ObjC Cornea client to the Swift Cornea 2.0 client.
   */
  fileprivate func processArcusClientTokenUpgrade() {
    // First, verify the previous platform is set.
    processPlatformTypeCheck()

    // Keys used for previous Keystore/ArcusClient.
    let emailKey: NSString = "ArcusEmail"
    let tokenService: NSString = "ArcusTokenService"
    let activeUserService: NSString = "ArcusActiveUserService"

    // Attempt to fetch legacy keychains.
    if let accountKeychain = KeychainStore
      .fetchKeychain(emailKey as String,
                     service: activeUserService as String,
                     error: nil) {

      let tokenKey: NSString = NSString.init(string: accountKeychain.value)
      if let tokenKeychain = KeychainStore
        .fetchKeychain(tokenKey as String,
                       service: tokenService as String,
                       error: nil) {

        // If found, save them in LSArcusKeystore.
        saveKeychain(LSArcusKeychain(value: accountKeychain.value,
                                    account: "arcusSession",
                                    service: "activeUser"))
        saveKeychain(LSArcusKeychain(value: tokenKeychain.value,
                                    account: accountKeychain.value,
                                    service: "token"))

        // Attempt to connect.
        RxCornea.shared.session?.connect()
      }
    }
  }

  /**
   Function used to keep the users existing platform set from previous versions when updating to Cornea 2.0.
   */
  fileprivate func processPlatformTypeCheck() {
    if let urlString = UserDefaults.standard.object(forKey: "CurrentPlatformUrl") as? String,
      let url: URL = url(true, instanceType: .devTest),
      let host = url.host {
      if urlString.contains(host) {
        // Maintain existing platform url. (Should only matter if previously using DevTest.)
        RxCornea.shared.session?.configureSessionUrl(.devTest, host: nil, port: nil)
      }
    }
  }

  /**
   Private convenience function used to save a `LSArcusKeychain` to `LSArcusKeystore`.

   - Parameters:
   - keychain: `LSArcusKeychain` to save.
   */
  private func saveKeychain(_ keychain: LSArcusKeychain) {
    do {
      try LSArcusKeystore.saveKeychain(keychain)
    } catch {
      DDLogDebug(error.localizedDescription)
    }
  }
}
