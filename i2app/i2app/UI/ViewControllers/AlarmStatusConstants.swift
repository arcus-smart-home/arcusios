//
//  AlarmStatusConstants.swift
//  i2app
//
//  Created by Arcus Team on 9/13/17.
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

// These values have to match the names from platform
enum AlarmType: String {
  case Panic = "PANIC"
  case Security = "SECURITY"
  case Water = "WATER"
  case Smoke = "SMOKE"
  case CO = "CO"
}

enum AlarmSecurityStatusState {
  case on
  case partial
  case off
  case arming
  case prealerting
  case alarming
}

enum AlarmStatusMessage {
  static let armFailedTitle = NSLocalizedString("UNABLE TO ARM", comment: "")
  static let disarmFailedTitle = NSLocalizedString("UNABLE TO DISARM", comment: "")

  static let armFailedHubOfflineText = NSLocalizedString("An error occurred when trying to arm your " +
    "Security Alarm. Please try again later.", comment: "")
  static let armFailedInsufficientDevicesText = NSLocalizedString("There are too many devices Open or "
    + "Offline.\n\nReview these devices or adjust your Alarm Requirements.", comment: "")
  static let armFailedGenericText = NSLocalizedString("Please try again in a few seconds.", comment: "")
  static let armFailedProMonClearingText = NSLocalizedString("The Monitoring Station has an alarm event " +
    "in progress at your place that must be resolved before you can re-arm.\n\nTo resolve this event, " +
    "call the Monitoring Station at 1-0.", comment: "")

  static let disarmFailedHubOfflineText = NSLocalizedString("An error occurred when trying to disarm your " +
    "Security Alarm. Please try again later.", comment: "")

  static let armFailedCloseButton = NSLocalizedString("Okay", comment: "")

  static let alarming = NSLocalizedString("Alarming", comment: "")
  static let ready = NSLocalizedString("Ready", comment: "")
  static let off = NSLocalizedString("Off", comment: "")
  static let offline = NSLocalizedString("Offline", comment: "")
  static let detectingSmoke = NSLocalizedString("Detecting Smoke", comment: "")
  static let detectingCO = NSLocalizedString("Detecting CO", comment: "")
  static let detectingWater = NSLocalizedString("Detecting Water", comment: "")
  static let detectingSecurity = NSLocalizedString("Bypassed", comment: "")

  static let securityArming = NSLocalizedString("Arming...", comment: "")
  static let securityPrealerting = NSLocalizedString("Grace Period Countdown", comment: "")
  static let securityOffSince = NSLocalizedString("Off Since", comment: "")
  static let securityOnSince = NSLocalizedString("On Since", comment: "")
  static let securityPartialSince = NSLocalizedString("Partial Since", comment: "")

  static let emptyCO = NSLocalizedString(
    "The CO Alarm service helps protect your family from danger when CO is detected in your home.",
    comment: "")
  static let emptySecurity = NSLocalizedString(
    "The Security Alarm service helps you protect what matters most.", comment: "")
  static let emptySmoke = NSLocalizedString(
    "The Smoke Alarm service helps protect your family and home from fire emergencies.", comment: "")
  static let emptyWater = NSLocalizedString(
    "The Water Leak Alarm service helps prevent water damage or flooding from occurring.", comment: "")
}
