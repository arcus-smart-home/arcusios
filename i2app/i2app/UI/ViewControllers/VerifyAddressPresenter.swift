//
//  VerifyAddressPresenter.swift
//  i2app
//
//  Arcus Team on 2/17/17.
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

protocol VerifyAddressPresenterProtocol {
  weak var verifyAddressDelegate: VerifyAddressDelegate? {get set}

  init (currentPlace: PlaceModel)
  func verifyAddress(delegate: VerifyAddressDelegate, address: [String : String])
}

protocol VerifyAddressDelegate: class {
  func onShowSuggestions(isPro: Bool, isValid: Bool,
                         enteredAddress: [String : String],
                         suggestedAddresses: [[String : String]])
  func onShowInvalidAddress(_ isPro: Bool)
  func onShowCantVerifyAddress()
  func onShowProMonNotAvailable()
}

class VerifyAddressPresenter: VerifyAddressPresenterProtocol {

  weak var verifyAddressDelegate: VerifyAddressDelegate?
  var currentPlace: PlaceModel

  required init (currentPlace: PlaceModel) {
    self.currentPlace = currentPlace
  }

  func verifyAddress(delegate: VerifyAddressDelegate, address: [String : String]) {
    self.verifyAddressDelegate = delegate

    DispatchQueue.global(qos: .background).async {
      let isPro = AnyServiceLevelable.isProMonitoredPlace(self.currentPlace)

      if let placeId = self.currentPlace.getAttribute(kAttrId) as? String {
        _ = PlaceService.validateAddress(withPlaceId: placeId,
                                         withStreetAddress: address)
          .swiftThenInBackground { (response) -> (PMKPromise?) in

            if let validateResponse = response as? PlaceServiceValidateAddressResponse,
              let isValid = validateResponse.getValid() {
              let suggestions = VerifyAddressPresenter
                .suggestionsFor(data: validateResponse.getSuggestions() as AnyObject)

              DispatchQueue.main.async {
                if isPro && suggestions.count == 0 {
                  delegate.onShowInvalidAddress(isPro)
                } else if suggestions.count == 0 {
                  delegate.onShowCantVerifyAddress()
                } else {
                  delegate.onShowSuggestions(isPro: isPro,
                                             isValid: isValid,
                                             enteredAddress: address,
                                             suggestedAddresses: suggestions)
                }
              }
            }

            return nil
          }
          .swiftCatch({ (_) -> (PMKPromise?) in
            DispatchQueue.main.async {
              if isPro {
                delegate.onShowProMonNotAvailable()
              }
            }
            return nil
          })
      }
    }
  }

  class func cannonicalizeAddress(address: [String:String]) -> [String : String] {
    var cannonical = address

    // If line2 is missing from chosen address, blank it out; otherwise, any existing line2 will remain
    if address["line2"] == nil {
      cannonical["line2"] = ""
    }

    return cannonical
  }

  class func suggestionsFor(data: AnyObject) -> [[String : String]] {
    var suggestions: [[String : String]] = []

    if let suggestionsArray = data as? [[String : AnyObject]] {

      // Walk each suggestion in the response
      for thisSuggestion in suggestionsArray {
        var suggestion: [String : String] = [:]

        // Walk each key-value pair in the suggestion
        for thisKey in thisSuggestion.keys {

          // Ignore keys which are NSNull
          if let thisValue = thisSuggestion[thisKey] as? String {
            suggestion[thisKey] = thisValue
          }
        }

        suggestions.append(suggestion)
      }
    }

    return suggestions
  }

  class func streetAddressFor(line1: String,
                              line2: String,
                              city: String,
                              state: String,
                              zip: String) -> [String : String] {
    return ["line1": line1, "line2": line2, "city": city, "state": state, "zip": zip]
  }
}
