//
//  PlaceModel+Extension.swift
//  i2app
//
//  Created by Arcus Team on 9/29/17.
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

typealias SmartyStreetsDictionary = [AnyHashable: Any]

let kSmartyStreetsLatitudeKey = "metadata/latitude"
let kSmartyStreetsLongitudeKey = "metadata/longitude"
let kSmartyStreetsTimeZoneKey = "metadata/time_zone"
let kSmartyStreetsUTCOffsetKey = "metadata/utc_offset"
let kSmartyStreetsDoesObserveDaylightSavingsKey = "metadata/dst"

// MARK: SmartyStreets Convenience Methods

fileprivate extension PlaceModel {
  static func hasSmartyStreetsLatitude(_ dictionary: SmartyStreetsDictionary) -> Bool {
    guard let _ = dictionary[kSmartyStreetsLatitudeKey] else {
      return false
    }
    return true
  }

  static func hasSmartyStreetsLongitude(_ dictionary: SmartyStreetsDictionary) -> Bool {
    guard let _ = dictionary[kSmartyStreetsLongitudeKey] else {
      return false
    }
    return true
  }

  static func getSmartyStreetsLatitude(_ dictionary: SmartyStreetsDictionary) -> Double {
    guard let lattitude = dictionary[kSmartyStreetsLatitudeKey] as? Double else {
      return 0.0
    }
    return lattitude
  }

  static func getSmartyStreetsLongitude(_ dictionary: SmartyStreetsDictionary) -> Double {
    guard let longitude = dictionary[kSmartyStreetsLongitudeKey] as? Double  else {
      return 0.0
    }
    return longitude
  }

  static func getSmartyStreetsTimeZone(_ dictionary: SmartyStreetsDictionary) -> String? {
    return dictionary[kSmartyStreetsTimeZoneKey] as? String
  }

  static func hasSmartyStreetsUTCOffset(_ dictionary: SmartyStreetsDictionary) -> Bool {
    guard let _ = dictionary[kSmartyStreetsUTCOffsetKey] else {
      return false
    }
    return true
  }

  static func getSmartyStreetsUTCOffset(_ dictionary: SmartyStreetsDictionary) -> Double {
    guard let utcOffset = dictionary[kSmartyStreetsUTCOffsetKey] as? Double  else {
      return 0.0
    }
    return utcOffset
  }

  static func hasSmartyStreetsDoesObserveDaylightSavingsInfo(_ dictionary: SmartyStreetsDictionary) -> Bool {
    guard let _ = dictionary[kSmartyStreetsDoesObserveDaylightSavingsKey] else {
      return false
    }
    return true
  }

  static func getSmartyStreetsDoesObserveDaylightSavings(_ dictionary: SmartyStreetsDictionary) -> Bool {
    guard let observesDLS = dictionary[kSmartyStreetsDoesObserveDaylightSavingsKey] as? Bool else {
      return false
    }
    return observesDLS
  }
}

extension PlaceModel {
  static func createPlaceModelContainingAddressForModelId(_ modelId: String) -> PlaceModel? {
    let placeWithoutAddress = PlaceModel(attributes: [kAttrId: modelId as AnyObject])
    let address = placeWithoutAddress.getAddressForNamespace(PlaceCapability.namespace())
    guard address.count > 0 else {
      return nil
    }
    return PlaceModel(attributes: [kAttrId: modelId as AnyObject,
                                   kAttrAddress: address as AnyObject])
  }

  static func createPlaceModelFromPlaceAndRole(_ placeAndRole: PlaceAndRoleModel) -> PlaceModel? {
    let place = createPlaceModelContainingAddressForModelId(placeAndRole.placeId)
    if var attrs = place?.get() {
      attrs[kAttrPlaceName] = placeAndRole.placeName as AnyObject

      return PlaceModel(attributes: attrs)
    }
    return nil
  }

  static func placeModelFrom(_ homeInfo: AddPlaceHomeInfoData, usingSmartyStreetsTimeZone: Bool) -> PlaceModel {
    var placeAttrs = [String: AnyObject]()
    placeAttrs[kAttrPlaceName] = homeInfo.homeName as AnyObject
    placeAttrs[kAttrPlaceStreetAddress1] = homeInfo.addressOne as AnyObject
    placeAttrs[kAttrPlaceStreetAddress2] = homeInfo.addressTwo as AnyObject
    placeAttrs[kAttrPlaceCity] = homeInfo.city as AnyObject
    placeAttrs[kAttrPlaceZipCode] = homeInfo.postalCode as AnyObject
    placeAttrs[kAttrPlaceState] = homeInfo.state as AnyObject
    placeAttrs[kAttrPlaceCountry] = homeInfo.country as AnyObject
    if !usingSmartyStreetsTimeZone {
      placeAttrs[kAttrPlaceTzName] = homeInfo.timeZoneName as AnyObject
      placeAttrs[kAttrPlaceTzId] = homeInfo.timeZoneID as AnyObject
      placeAttrs[kAttrPlaceTzOffset] = homeInfo.timeZoneOffset
      placeAttrs[kAttrPlaceTzUsesDST] = homeInfo.timeZoneUsesDST as AnyObject
    }

    if let smartyStreetsInfo = homeInfo.smartyStreetsInfo {
      if usingSmartyStreetsTimeZone {
        if hasSmartyStreetsLatitude(smartyStreetsInfo) == true {
          placeAttrs[kAttrPlaceAddrLatitude] = getSmartyStreetsLatitude(smartyStreetsInfo) as AnyObject
        }

        if hasSmartyStreetsLongitude(smartyStreetsInfo) == true {
          placeAttrs[kAttrPlaceAddrLongitude] = getSmartyStreetsLongitude(smartyStreetsInfo) as AnyObject
        }
        // Rest of the information needs to be set in a set attributes call after the place is created.
      }
    }

    return PlaceModel(attributes: placeAttrs)
  }

  func locationString() -> String? {
    if let address1 = PlaceCapability.getStreetAddress1(from: self),
      let city = PlaceCapability.getCityFrom(self),
      let state = PlaceCapability.getStateFrom(self),
      let zipCode = PlaceCapability.getZipCode(from: self) {
      if let address2 = PlaceCapability.getStreetAddress2(from: self) {
        if address2.count > 0 {
          return "\(address1) \(address2)\n\(city), \(state) \(zipCode)"
        }
      }
      return "\(address1)\n\(city), \(state) \(zipCode)"
    }
    return nil
  }

  func cityStateString() -> String? {
    if let city = PlaceCapability.getCityFrom(self),
      let state = PlaceCapability.getStateFrom(self) {
      return "\(city), \(state)"
    }
    return nil
  }

  func getAddressForPlace() -> String {
    var address: String = ""

    if let address1 = PlaceCapabilityLegacy.getStreetAddress1(self) {
      address = "\(address1)\n"
    }

    if let address2 = PlaceCapabilityLegacy.getStreetAddress2(self) {
      address += "\(address2)\n"
    }

    if let city = PlaceCapabilityLegacy.getCity(self),
      let state = PlaceCapabilityLegacy.getState(self),
      let zip = PlaceCapabilityLegacy.getZipCode(self) {
       address += "\(city), \(state), \(zip)"
    }

    return address
  }
}
