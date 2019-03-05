//
//  AccountCreationCreatePresenter.swift
//  i2app
//
//  Created by Arcus Team on 10/23/17.
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

import Cornea

/**
 Protocol defining the interface of the AccountCreationCreatePresenter.
 */
protocol AccountCreationCreatePresenterProtocol {
  
  /**
   Retrieves the URL to be used for web account creation. When the app is using a dev platform url this function
   will provide a URL to the dev version.
   
   - returns: The URL for web account creation.
   */
  func urlForWebCreation() -> URL?

}

/**
 This presenter provides the data needed to present the web account creation.
 */
class AccountCreationCreatePresenter {

}

// MARK: AccountCreationCreatePresenterProtocol

extension AccountCreationCreatePresenter: AccountCreationCreatePresenterProtocol, PlatformSwitchingController {
  func urlForWebCreation() -> URL? {
    // TODO: MOVE URL's TO Constants. (Use existing?)
    let devURL = ""
    let prodURL = ""
    var createAccount = prodURL
    if AccountCreationCreatePresenter
      .isUsingDev() {
      createAccount = devURL
    }
    createAccount += "/create-account/ios"

    return URL(string: createAccount)
  }
}
