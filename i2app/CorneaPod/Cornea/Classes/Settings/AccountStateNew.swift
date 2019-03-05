//
//  AccountStateNew.swift
//  Cornea
//
//  Created by Arcus Team on 3/15/18.
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

extension Constants {
  public static let kAccountStateNone: String = "NONE"
  public static let kAccountStateSignUp1: String = "SIGNUP1"
  public static let kAccountStateSignUpAboutYou: String = "ABOUT_YOU"
  public static let kAccountStateSignUpAboutYourHome: String = "ABOUT_YOUR_HOME"
  public static let kAccountStateSignUpTimeZone: String = "TIME_ZONE"
  public static let kAccountStateSignUpPinCode: String = "PIN_CODE"
  public static let kAccountStateSignUpSecurityQuestions: String = "SECURITY_QUESTIONS"
  public static let kAccountStateSignUpNotifications: String = "NOTIFICATIONS"
  public static let kAccountStateSignUpPremiumPlan: String = "PREMIUM_PLAN"
  public static let kAccountStateSignUpBillingInformation: String = "BILLING_INFO"
  public static let kAccountStateSignUpComplete: String = "COMPLETE"
}

@objc public enum AccountStateNew: Int {
  case none
  case signUp1
  case signUpAboutYou
  case signUpAboutYourHome
  case signUpTimeZone
  case signUpPinCode
  case signUpSecurityQuestions
  case signUpNotifications
  case signUpPremiumPlan
  case signUpBillingInformation
  case signUpComplete

  public func stringValue() -> String {
    switch self {
    case .none:
      return Constants.kAccountStateNone
    case .signUp1:
      return Constants.kAccountStateSignUp1
    case .signUpAboutYou:
      return Constants.kAccountStateSignUpAboutYou
    case .signUpAboutYourHome:
      return Constants.kAccountStateSignUpAboutYourHome
    case .signUpTimeZone:
      return Constants.kAccountStateSignUpTimeZone
    case .signUpPinCode:
      return Constants.kAccountStateSignUpPinCode
    case .signUpSecurityQuestions:
      return Constants.kAccountStateSignUpSecurityQuestions
    case .signUpNotifications:
      return Constants.kAccountStateSignUpNotifications
    case .signUpPremiumPlan:
      return Constants.kAccountStateSignUpPremiumPlan
    case .signUpBillingInformation:
      return Constants.kAccountStateSignUpBillingInformation
    case .signUpComplete:
      return Constants.kAccountStateSignUpComplete
    }
  }

  public static func state(forString: String) -> AccountStateNew {
    switch forString.uppercased() {
    case Constants.kAccountStateNone:
      return .none
    case Constants.kAccountStateSignUp1:
      return .signUp1
    case Constants.kAccountStateSignUpAboutYou:
      return .signUpAboutYou
    case Constants.kAccountStateSignUpAboutYourHome:
      return .signUpAboutYourHome
    case Constants.kAccountStateSignUpTimeZone:
      return .signUpTimeZone
    case Constants.kAccountStateSignUpPinCode:
      return .signUpPinCode
    case Constants.kAccountStateSignUpSecurityQuestions:
      return .signUpSecurityQuestions
    case Constants.kAccountStateSignUpNotifications:
      return .signUpNotifications
    case Constants.kAccountStateSignUpPremiumPlan:
      return .signUpPremiumPlan
    case Constants.kAccountStateSignUpBillingInformation:
      return .signUpBillingInformation
    case Constants.kAccountStateSignUpComplete:
      return .signUpComplete
    default:
      return .none
    }
  }
}

public extension Constants {
  public static let kUserLoginRequiredNotification = "UserLoginRequired"
  public static let kUserLogInStartedNotification = "UserLogInStarted"
  public static let kUserLoggedInNotification = "UserLoggedIn"

  public static let kAllUserStatesClearedNotification = "AllUserStatesCleared"
  public static let kNetworkActivityChangedNotification = "NetworkActivityChanged"

  public static let kConnectionEstablishedNotification = "ConnectionEstablished"
  public static let kSocketClosedNotification = "SocketClosed"

  public static let kNetworkConnectionAvailableNotification = "NetworkConnectionAvailable"
  public static let kNetworkConnectionNotAvailableNotification = "NetworkConnectionNotAvailable"
  public static let kActivePlaceClearedNotification = "sess:ActivePlaceCleared"
  public static let kSwannPairingAttemptNotification = "SwannPairingAttempt"

  public static let kLastKnownPlaceIdForAccountPrefix = "lastKnownPlace:"
  public static let kPasswordPlaceholder = "************"
  public static let kMaxLoginRetry = 5
  public static let usStatesAbbreviated: [String] =
    ["AL", "AK", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE",
     "FM", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS",
     "KY", "LA", "MA", "MD", "ME", "MH", "MI", "MN", "MO", "MP",
     "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY",
     "OH", "OK", "OR", "PA", "PR", "PW", "RI", "SC", "SD", "TN",
     "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
  public static let usStates: [String] =
    ["AL - Alabama",
     "AK - Alaska",
     "AR - Arkansas",
     "AS - America Samoa",
     "AZ - Arizona",
     "CA - California",
     "CO - Colorado",
     "CT - Connecticut",
     "DC - District of Columbia",
     "DE - Delaware",
     "FM - Federated States of Micronesia",
     "FL - Florida",
     "GA - Georgia",
     "GU - Guam",
     "HI - Hawaii",
     "IA - Iowa",
     "ID - Idaho",
     "IL - Illinois",
     "IN - Indiana",
     "KS - Kansas",
     "KY - Kentucky",
     "LA - Louisiana",
     "MA - Massachusetts",
     "MD - Maryland",
     "ME - Maine",
     "MH - Marshall Islands",
     "MI - Michigan",
     "MN - Minnesota",
     "MO - Missouri",
     "MP - Northern Mariana Islands",
     "MS - Mississippi",
     "MT - Montana",
     "NC - North Carolina",
     "ND - North Dakota",
     "NE - Nebraska",
     "NH - New Hampshire",
     "NJ - New Jersey",
     "NM - New Mexico",
     "NV - Nevada",
     "NY - New York",
     "OH - Ohio",
     "OK - Oklahoma",
     "OR - Oregon",
     "PA - Pennsylvania",
     "PR - Puerto Rico",
     "PW - Palau",
     "RI - Rhode Island",
     "SC - South Carolina",
     "SD - South Dakota",
     "TN - Tennessee",
     "TX - Texas",
     "UT - Utah",
     "VA - Virginia",
     "VI - Virgin Islands",
     "VT - Vermont",
     "WA - Washington",
     "WI - Wisconsin",
     "WV - West Virginia",
     "WY - Wyoming"]

  public static func getMonths() -> [String] {
    return DateFormatter().monthSymbols
  }

  public static func validCardYears() -> [String] {
    let year = Int32(NSCalendar.current.component(.year, from: Date()))
    //    let year: Int32 = NSDate().getYear()
    var years: [String] = []

    var i: Int32 = 0
    while i < 11 {
      years.append(String(describing: year + i))
      i += 1
    }

    return years
  }
}
