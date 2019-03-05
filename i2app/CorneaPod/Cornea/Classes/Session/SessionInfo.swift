//
//  SessionInfo.swift
//  i2app
//
//  Created by Arcus Team on 8/7/17.
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

/**
 `SessionInfo` class is used to conform to `ArcusSessionInfo`, and can be used by classes 
 conforming `ArcusSession`.
 */
public class SessionInfo: NSObject, ArcusSessionInfo {
  // Billing
  public var billingPublicKey: String?
  public var billingTokenUrl: String?

  // Apptentive
  public var apptentiveApiKey: String?
  public var apptentiveAppKey: String?
  public var apptentiveAppSignature: String?

  public var cameraPreviewBaseUrl: String?

  // Honeywell Thermostat

  public var honeywellClientId: String?
  public var honeywellLoginBaseUrl: String?
  public var honeywellRedirectUri: String?

  // Nest Thermostat

  public var nestClientId: String?
  public var nestLoginBaseUrl: String?

  // Lutron

  public var lutronLoginBaseUrl: String?

  public var personId: String?
  public var places: [PlaceInfo]?
  public var lastKnownPlaceId: String? {
    didSet {
      if let personId = self.personId, let newValue = self.lastKnownPlaceId {
        let prefixedWithPerson = Constants.kLastKnownPlaceIdForAccountPrefix.appending(personId)
        UserDefaults.standard.setValue(newValue, forKeyPath: prefixedWithPerson)
      }
    }
  }

  public var promonAdUrl: String?
  public var publicKey: String?

  // Terms & Conditions

  public var requiresPrivacyPolicyConsent: Bool?
  public var requiresTermsAndConditionsConsent: Bool?

  public var redirectBaseUrl: String?

  // Smarty Streets

  public var smartyAuthID: String?
  public var smartyAuthToken: String?

  public var staticResourceBaseUrl: String?

  public var tokenURL: String?

  // Web URL

  public var webLaunchURL: String?

  // Session Start Time
  public var startTime: Date = Date()

  required public init(_ attributes: [String: AnyObject]?) {
    if let apptentiveApiKey = attributes?["apptentiveKey"] as? String {
      self.apptentiveApiKey = apptentiveApiKey
    }

    if let apptentiveAppKey = attributes?["apptentiveAppKey"] as? String {
      self.apptentiveAppKey = apptentiveAppKey
    }

    if let apptentiveAppSignature = attributes?["apptentiveAppSignature"] as? String {
      self.apptentiveAppSignature = apptentiveAppSignature
    }

    if let cameraPreviewBaseUrl = attributes?["cameraPreviewBaseUrl"] as? String {
      self.cameraPreviewBaseUrl = cameraPreviewBaseUrl
    }

    if let honeywellLoginBaseUrl = attributes?["honeywellLoginBaseUrl"] as? String {
      self.honeywellLoginBaseUrl = honeywellLoginBaseUrl
    }

    if let honeywellClientId = attributes?["honeywellClientId"] as? String {
      self.honeywellClientId = honeywellClientId
    }

    if let honeywellRedirectUri = attributes?["honeywellRedirectUri"] as? String {
      self.honeywellRedirectUri = honeywellRedirectUri
    }

    if let nestClientId = attributes?["nestClientId"] as? String {
      self.nestClientId = nestClientId
    }

    if let nestLoginBaseUrl = attributes?["nestLoginBaseUrl"] as? String {
      self.nestLoginBaseUrl = nestLoginBaseUrl
    }

    if let lutronLoginBaseUrl = attributes?["lutronLoginBaseUrl"] as? String {
      self.lutronLoginBaseUrl = lutronLoginBaseUrl
    }

    if let personId = attributes?["personId"] as? String {
      self.personId = personId
      if let lastKnown = UserDefaults.standard
        .string(forKey: Constants.kLastKnownPlaceIdForAccountPrefix.appending(personId)) {
        self.lastKnownPlaceId = lastKnown
      }
    }

    if let placesAttrs = attributes?["places"] as? [[String: AnyObject]] {
      var places = [PlaceInfo]()
      for placeInfo in placesAttrs {
        places.append(PlaceInfo(placeInfo))
      }
      self.places = places
    }

    if let promonAdUrl = attributes?["promonAdUrl"] as? String {
      self.promonAdUrl = promonAdUrl
    }

    if let publicKey = attributes?["publicKey"] as? String {
      self.publicKey = publicKey
    }

    if let redirectBaseUrl = attributes?["redirectBaseUrl"] as? String {
      self.redirectBaseUrl = redirectBaseUrl
    }

    if let requiresPrivacyPolicyConsent = attributes?["requiresPrivacyPolicyConsent"] as? Bool {
      self.requiresPrivacyPolicyConsent = requiresPrivacyPolicyConsent
    }

    if let requiresTermsAndConditionsConsent = attributes?["requiresTermsAndConditionsConsent"] as? Bool {
      self.requiresTermsAndConditionsConsent = requiresTermsAndConditionsConsent
    }

    if let smartyAuthID = attributes?["smartyAuthID"] as? String {
      self.smartyAuthID = smartyAuthID
    }

    if let smartyAuthToken = attributes?["smartyAuthToken"] as? String {
      self.smartyAuthToken = smartyAuthToken
    }

    if let staticResourceBaseUrl = attributes?["staticResourceBaseUrl"] as? String {
      self.staticResourceBaseUrl = staticResourceBaseUrl
    }

    if let tokenURL = attributes?["tokenURL"] as? String {
      self.tokenURL = tokenURL
    }

    if let webLaunchURL = attributes?["webLaunchUrl"] as? String {
      self.webLaunchURL = webLaunchURL
    }
  }

  public func getPlaceInfo(_ placeId: String) -> PlaceInfo? {
    guard let places = self.places?.filter({ $0.placeId == placeId }) else { return nil }

    return places.first
  }

  public func updatePlaceInfo(_ place: PlaceInfo) {
    guard let placeId = place.placeId else {
      return
    }
    removePlaceInfo(placeId)
    places?.append(place)
  }

  public func removePlaceInfo(_ placeId: String) {
    if let index = places?.index(where: {$0.placeId == placeId}) {
      places?.remove(at: index)
    }
  }
}
