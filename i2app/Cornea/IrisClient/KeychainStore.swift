//
//  KeychainStore.swift
//  i2app
//
//  Created by Arcus Team on 10/12/16.
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
import SSKeychain

class Keychain: NSObject {
    internal let value: String!
    internal let account: String!
    internal let service: String!

    required init(value: String, account: String, service: String) {
        self.value = value
        self.account = account
        self.service = service
        super.init()
    }
}

class KeychainStore: NSObject {
    class func saveKeychain(_ keychain: Keychain!, error: NSErrorPointer) {
        SSKeychain.setPassword(keychain.value,
                               forService: keychain.service,
                               account: keychain.account,
                               error: error)
    }

    class func fetchKeychain(_ account: String!,
                             service: String!,
                             error: NSErrorPointer) -> Keychain? {
        var result: Keychain? = nil

        if let value: String? = SSKeychain.password(forService: service,
                                                              account: account,
                                                              error: error) {
            if value != nil {
                result = Keychain(value: value!,
                                  account: account,
                                  service: service)
            }
        }

        return result
    }

    class func deleteKeychain(_ keychain: Keychain!, error: NSErrorPointer) {
        KeychainStore.deleteKeychain(keychain.service,
                                     account: keychain.account,
                                     error: error)
    }

    class func deleteKeychain(_ service: String!,
                              account: String!,
                              error: NSErrorPointer) {
        SSKeychain.deletePassword(forService: service,
                                            account: account,
                                            error: error)
    }

    class func deleteKeychainsForService(_ service: String, error: NSErrorPointer) {
        guard let serviceAccounts = SSKeychain.accounts(forService: service) else {
            return
        }

        for accountDictionary in serviceAccounts {
            guard let account = accountDictionary["acct"] as? String else {
                return
            }
            KeychainStore.deleteKeychain(service,
                                         account: account,
                                         error: error)
        }
    }
}
