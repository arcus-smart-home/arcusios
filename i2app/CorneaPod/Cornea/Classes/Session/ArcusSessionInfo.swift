//
//  ArcusSessionInfo.swift
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
 `ArcusSessionInfo` protocol defines the required properties of a class used to hold Session Info received
 from the platform.
 */
public protocol ArcusSessionInfo {
  // Billing
  var billingPublicKey: String? { get }
  var billingTokenUrl: String? { get }

  // Apptentive
  var apptentiveApiKey: String? { get }
  var apptentiveAppKey: String? { get }
  var apptentiveAppSignature: String? { get }

  var cameraPreviewBaseUrl: String? { get }

  // Honeywell Thermostat

  var honeywellClientId: String? { get }
  var honeywellLoginBaseUrl: String? { get }
  var honeywellRedirectUri: String? { get }

  // Nest Thermostat

  var nestClientId: String? { get }
  var nestLoginBaseUrl: String? { get }

  // Lutron
  var lutronLoginBaseUrl: String? { get }

  var personId: String? { get }
  var places: [PlaceInfo]? { get }
  var lastKnownPlaceId: String? { get set }

  var promonAdUrl: String? { get }

  var publicKey: String? { get }

  // Terms & Conditions

  var requiresPrivacyPolicyConsent: Bool? { get set }
  var requiresTermsAndConditionsConsent: Bool? { get set }

  var redirectBaseUrl: String? { get }

  // Smarty Streets

  var smartyAuthID: String? { get }
  var smartyAuthToken: String? { get }

  var staticResourceBaseUrl: String? { get }
  var tokenURL: String? { get }

  // Web URL

  var webLaunchURL: String? { get }

  // Session Start Time

  var startTime: Date { get set }

  func getPlaceInfo(_ placeId: String) -> PlaceInfo?
  func updatePlaceInfo(_ place: PlaceInfo)
  func removePlaceInfo(_ placeId: String)
}
