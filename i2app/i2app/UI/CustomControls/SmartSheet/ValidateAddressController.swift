//
//  ValidateAddressController.swift
//  i2app
//
//  Arcus Team on 3/13/17.
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
import Cornea
import PromiseKit

@objc class ValidateAddressController: NSObject {
  class func verifyAddress(_ placeId: String,
                           street: String,
                           city: String,
                           state: String,
                           zip: String,
                           completionHandler: ((Bool) -> Void)?) {
    DispatchQueue.global(qos: .background).async {
      let address: [String:String] = ["line1": street, "city": city, "state": state, "zip": zip]
      _ = PlaceService.validateAddress(withPlaceId: placeId, withStreetAddress: address)
        .swiftThenInBackground { response in
          if let validateResponse = response as? PlaceServiceValidateAddressResponse {
            if let isValid = validateResponse.getValid() {
              DispatchQueue.main.async {
                completionHandler?(isValid)
              }
            }
          }
          return nil
        }.swiftCatch({ (_) -> (PMKPromise?) in
          completionHandler?(false)
          return nil
        })
    }
  }
}
