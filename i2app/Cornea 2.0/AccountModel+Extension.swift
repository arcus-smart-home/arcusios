//
//  AccountModel+Extension.swift
//  i2app
//
//  Created by Arcus Team on 9/19/17.
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
import PromiseKit
import Cornea

extension AccountModel {
  func ownsPlace(_ place: PlaceModel) -> Bool {
    if let accountId = PlaceCapability.getAccountFrom(place),
      let currentId = self.modelId as String? {
      return currentId == accountId
    }
    return false
  }

  static func createAccountModelContainingAddressForModelId(_ modelId: String?) -> AccountModel? {
    // Updated method signature to accept optional string to help prevent crashing when attempting to send
    // a nil modelId
    guard modelId != nil else {
      return nil
    }

    let accountWithoutAddress = AccountModel(attributes: [kAttrId : modelId as AnyObject])
    let address = accountWithoutAddress.getAddressForNamespace(AccountCapability.namespace())

    return AccountModel(attributes: [kAttrId: modelId as AnyObject,
                                     kAttrAddress: address as AnyObject])
  }

  static func accountOwner() -> PersonModel? {
    let currentAccount = RxCornea.shared.settings?.currentAccount
    if let ownerId = AccountCapability.getOwnerFrom(currentAccount) {
      let address = PersonModel.addressForId(ownerId)
      if let ownerModel = RxCornea.shared.modelCache?.fetchModel(address) as? PersonModel {
        return ownerModel
      }
    }
    return nil
  }
}
