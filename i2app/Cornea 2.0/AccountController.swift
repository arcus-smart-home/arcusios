//
//  AccountController.swift
//  i2app
//
//  Created by Arcus Team on 10/31/17.
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
import RxSwift
import CocoaLumberjack
import UIKit // Required for UIDevice extension
import Cornea

// TODO: MOVE ME!
extension UIDevice {
  var modelName: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }

    switch identifier {
    case "iPod5,1":                                 return "iPod Touch 5"
    case "iPod7,1":                                 return "iPod Touch 6"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
    case "iPhone4,1":                               return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
    case "iPhone7,2":                               return "iPhone 6"
    case "iPhone7,1":                               return "iPhone 6 Plus"
    case "iPhone8,1":                               return "iPhone 6s"
    case "iPhone8,2":                               return "iPhone 6s Plus"
    case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
    case "iPhone8,4":                               return "iPhone SE"
    case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
    case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
    case "iPhone10,3", "iPhone10,6":                return "iPhone X"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
    case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
    case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
    case "iPad6,11", "iPad6,12":                    return "iPad 5"
    case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
    case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
    case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
    case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
    case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
    case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
    case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
    case "AppleTV5,3":                              return "Apple TV"
    case "AppleTV6,2":                              return "Apple TV 4K"
    case "AudioAccessory1,1":                       return "HomePod"
    case "i386", "x86_64":                          return "Simulator"
    default:                                        return identifier
    }
  }
}

extension Notification.Name {
  static let userLoginRequired = Notification.Name(Constants.kUserLoginRequiredNotification)
  static let userLogInStarted = Notification.Name(Constants.kUserLogInStartedNotification)
  static let userLoggedIn = Notification.Name(Constants.kUserLoggedInNotification)

  static let allUserStatesCleared = Notification.Name(Constants.kAllUserStatesClearedNotification)
  static let networkActivityChanged = Notification.Name(Constants.kNetworkActivityChangedNotification)

  static let connectionEstablished = Notification.Name(Constants.kConnectionEstablishedNotification)
  static let socketClosed = Notification.Name(Constants.kSocketClosedNotification)

  static let networkConnectionAvailable = Notification.Name(Constants.kNetworkConnectionAvailableNotification)
  static let networkConnectionNotAvailable = Notification
    .Name(Constants.kNetworkConnectionNotAvailableNotification)
  static let activePlaceCleared = Notification.Name(Constants.kActivePlaceClearedNotification)
  static let swannPairingAttempt = Notification.Name(Constants.kSwannPairingAttemptNotification)
}

extension Constants {
  static let kUserLoginRequiredNotification = "UserLoginRequired"
  static let kUserLogInStartedNotification = "UserLogInStarted"
  static let kUserLoggedInNotification = "UserLoggedIn"

  static let kAllUserStatesClearedNotification = "AllUserStatesCleared"
  static let kNetworkActivityChangedNotification = "NetworkActivityChanged"

  static let kConnectionEstablishedNotification = "ConnectionEstablished"
  static let kSocketClosedNotification = "SocketClosed"

  static let kNetworkConnectionAvailableNotification = "NetworkConnectionAvailable"
  static let kNetworkConnectionNotAvailableNotification = "NetworkConnectionNotAvailable"
  static let kActivePlaceClearedNotification = "sess:ActivePlaceCleared"
  static let kSwannPairingAttemptNotification = "SwannPairingAttempt"

  static let kLastKnownPlaceIdForAccountPrefix = "lastKnownPlace:"
  static let kPasswordPlaceholder = "************"
  static let kMaxLoginRetry = 5
  static let usStatesAbbreviated: [String] =
    ["AL", "AK", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE",
     "FM", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS",
     "KY", "LA", "MA", "MD", "ME", "MH", "MI", "MN", "MO", "MP",
     "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY",
     "OH", "OK", "OR", "PA", "PR", "PW", "RI", "SC", "SD", "TN",
     "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
  static let usStates: [String] =
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

  static func getMonths() -> [String] {
    return DateFormatter().monthSymbols
  }

  static func validCardYears() -> [String] {
    let year: Int32 = NSDate().getYear()
    var years: [String] = []

    var i: Int32 = 0
    while i < 11 {
      years.append(String(describing: year + i))
      i += 1
    }

    return years
  }
}

protocol DeleteAccountController {
  static func deleteAccount(_ account: AccountModel) -> PMKPromise
}

extension DeleteAccountController {
  static func deleteAccount(_ account: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.delete(account, deleteOwnerLogin: true)
  }
}

protocol AccountPlaceController {
  static func addPlace(_ place: PlaceModel,
                       population: String,
                       serviceLevel: String,
                       addOns: Any,
                       account: AccountModel) -> PMKPromise

  static func getOwnedPlacesOnModel(_ account: AccountModel) -> PMKPromise
  static func getLastKnownPlaceIdForPersonId(_ personId: String) -> String
  static func setLastKnownPlaceId(_ placeId: String, personId: String)
  static func changeToPlaceId(_ placeId: String, person: PersonModel) -> PMKPromise
}

extension AccountPlaceController {
  static func addPlace(_ place: PlaceModel,
                       population: String,
                       serviceLevel: String,
                       addOns: Any,
                       account: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.addPlace(account,
                                            place: place,
                                            population: population,
                                            serviceLevel: serviceLevel,
                                            addons: addOns)
      .swiftThenInBackground({ response in
        PMKPromise.new({ (fulfiller: PMKFulfiller!, rejector: PMKRejecter!) in
          if let response = response as? AccountAddPlaceResponse,
            let createdPlace = response.getPlace() as? PlaceModel {
            fulfiller(createdPlace)
          }
          rejector(nil)
        })
      })
  }

  static func getOwnedPlacesOnModel(_ account: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.listPlaces(account)
      .swiftThenInBackground({ response in
        guard let response = response as? AccountListPlacesResponse else {
          return nil
        }
        return PMKPromise.new({ (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(response.getPlaces())
        })
      })
  }

  static func getLastKnownPlaceIdForPersonId(_ personId: String) -> String {
    guard let lastKnownPrefix = UserDefaults.standard
      .string(forKey: Constants.kLastKnownPlaceIdForAccountPrefix.appending(personId)) else {
        return ""
    }
    return lastKnownPrefix
  }

  static func setLastKnownPlaceId(_ placeId: String, personId: String) {
    let defaults = UserDefaults.standard

    defaults.set(placeId, forKey: Constants.kLastKnownPlaceIdForAccountPrefix.appending(personId))

    defaults.synchronize()
  }

  static func changeToPlaceId(_ placeId: String, person: PersonModel) -> PMKPromise {
    // TODO: Re-evaluate.
    RxCornea.shared.modelCache?.flush()
    SubsystemsController.sharedInstance().clearCurrentUserStates()

    let place = PlaceModel(attributes: [kAttrId: placeId as AnyObject])
    let namespace = place.getAddressForNamespace("place")
    place.setValue(namespace, forKey: kAttrAddress)

    setLastKnownPlaceId(placeId, personId: person.modelId)

    return SessionController.setActivePlace(placeId)
      .swiftThenInBackground({ _ in
        return place.refresh()
          .swiftThenInBackground({ _ in
            //          let accountId = PlaceCapabilityLegacy.getPlaceAccount(place)
            //          let newAccountModel = AccountModel(attributes:[kAttrId: accountId])
            return nil
          })
      })
  }
}

class AccountController: NSObject,
  PlatformSwitchingController,
  UserAuthenticationController,
  CreateAccountController,
  DeleteAccountController,
AccountPlaceController {

  // Duplicate implementation of UserAuthenticationController is required to expose to ObjC
  static func loginUser(_ email: String,
                        password: String,
                        completion: @escaping LoginCompletion) {
    guard let session = RxCornea.shared.session else {
      // TODO: Return Error
      completion(false, nil)
      return
    }
    session.login(email, password: password, completion: completion)
  }

  static func logout(_ completion: LogoutCompletion) {
    guard let session = RxCornea.shared.session else {
      completion()
      return
    }
    session.logout()
    completion()
  }

  // MARK: Swift version of legacy password reset.

  static func sendPasswordReset(_ email: String) -> PMKPromise {
    return PersonServiceLegacy.sendPasswordReset(email, method: "email")
  }

  static func resetPassword(_ email: String,
                            resetToken: String,
                            password: String) -> PMKPromise {
    return PersonServiceLegacy.resetPassword(email,
                                             token: resetToken,
                                             password: password)
  }

  static func changePassword(_ email: String,
                             currentPassword: String,
                             newPassword: String) -> PMKPromise {
    return PersonServiceLegacy.changePassword(currentPassword,
                                              newPassword: newPassword,
                                              emailAddress: email)
  }

  // Duplicate implementation of CreateAccountController is required to expose to ObjC

  static func createAccountWithEmail(_ email: String,
                                     withPassword password: String,
                                     withOptin optin: String) -> PMKPromise {
    let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = password.trimmingCharacters(in: .whitespacesAndNewlines)

    return AccountServiceLegacy.createAccount(email,
                                              password: password,
                                              optin: optin,
                                              isPublic: "false",
                                              person: NSNull(),
                                              place: NSNull())
  }

  static func completedAccountStep(_ stepCompleted: AccountStateNew,
                                   model: Model,
                                   withAccountModel accountModel: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.signupTransition(accountModel,
                                                    stepcompleted: stepCompleted.stringValue())
      .swiftThenInBackground({ _ in
        accountModel.attributes[kAttrAccountState] = stepCompleted.stringValue() as AnyObject

        RxCornea.shared.modelCache?.addModel(accountModel)

        return PMKPromise.new { (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller([Constants.kModel: model, "Step": stepCompleted.stringValue()])
        }
      })
  }

  static func setPersonDetails(_ firstName: String,
                               lastName: String,
                               phoneNumber: String,
                               personModel: PersonModel,
                               accountModel: AccountModel) -> PMKPromise {
    PersonCapabilityLegacy.setFirstName(firstName, model: personModel)
    PersonCapabilityLegacy.setLastName(lastName, model: personModel)
    PersonCapabilityLegacy.setMobileNumber(phoneNumber, model: personModel)

    return personModel.commit()
  }

  static func setPersonDetailsAndCompleteStep(_ firstName: String,
                                              lastName: String,
                                              phoneNumber: String,
                                              personModel: PersonModel,
                                              accountModel: AccountModel) -> PMKPromise {
    return setPersonDetails(firstName,
                            lastName: lastName,
                            phoneNumber: phoneNumber,
                            personModel: personModel,
                            accountModel: accountModel)
      .swiftThenInBackground({ _ in
        return completedAccountStep(.signUpAboutYou,
                                    model: personModel,
                                    withAccountModel: accountModel)
          .swiftThenInBackground({ _ in
            return personModel.refresh()
          })
      })
  }

  static func setPlaceDetails(_ nickName: String,
                              address1: String,
                              address2: String,
                              city: String,
                              state: String,
                              postalCode: String,
                              country: String,
                              placeModel: PlaceModel,
                              accountModel: AccountModel,
                              smartyStreetsDetails: [String: AnyObject]) -> PMKPromise {
    PlaceCapabilityLegacy.setName(nickName, model: placeModel)
    PlaceCapabilityLegacy.setStreetAddress1(address1, model: placeModel)
    PlaceCapabilityLegacy.setStreetAddress2(address2, model: placeModel)
    PlaceCapabilityLegacy.setCity(city, model: placeModel)
    PlaceCapabilityLegacy.setState(state, model: placeModel)
    PlaceCapabilityLegacy.setZipCode(postalCode, model: placeModel)
    PlaceCapabilityLegacy.setCountry(country, model: placeModel)

    return placeModel.commit().swiftThenInBackground({ _ in
      completedAccountStep(.signUpAboutYourHome,
                           model: placeModel,
                           withAccountModel: accountModel)
        .swiftThenInBackground({ _ in
          if let latitude = smartyStreetsDetails["metadata/latitude"] as? Double,
            let longitude = smartyStreetsDetails["metadata/longitude"] as? Double,
            let timeZone = smartyStreetsDetails["metadata/time_zone"] as? String,
            let offset = smartyStreetsDetails["metadata/utc_offset"] as? Float,
            let usesDST = smartyStreetsDetails["metadata/dst"] as? Bool {
            //            [self setTzCoordinates:placeModel withLatitude:latitude withLongitude:longitude withTzName:timezone withTzOffset:utcOffset withDST:dateTimeSavings].thenInBackground(^(ClientEvent *event) {
            //              return [placeModel refresh];
            //              });
          } else {
            // Get the Location Details
            //            return [self startLocationManager:placeModel];
          }
          // Refresh the Person model
          return placeModel.refresh()
        })
    })
  }

  static func setPin(_ pin: String,
                     personModel: PersonModel,
                     placeModel: PlaceModel,
                     accountModel: AccountModel) -> PMKPromise {
    return PersonCapabilityLegacy.changePinV2(personModel,
                                              place: placeModel.modelId,
                                              pin: pin)
      .swiftThenInBackground({ _ in
        _ = completedAccountStep(.signUpPinCode,
                                 model: placeModel,
                                 withAccountModel: accountModel).swiftThenInBackground({ _ in
                                  return personModel.refresh()
                                 })
        return nil
      })
  }

  static func setSecurityAnswersWithSecurityQuestions(_ securityQuestion1: String,
                                                      securityAnswer1: String,
                                                      securityQuestion2: String,
                                                      securityAnswer2: String,
                                                      securityQuestion3: String,
                                                      securityAnswer3: String,
                                                      personModel: PersonModel,
                                                      accountModel: AccountModel) -> PMKPromise {
    return PersonCapabilityLegacy
      .setSecurityAnswers(personModel,
                          securityQuestion1: securityQuestion1,
                          securityAnswer1: securityAnswer1,
                          securityQuestion2: securityQuestion2,
                          securityAnswer2: securityAnswer2,
                          securityQuestion3: securityQuestion3,
                          securityAnswer3: securityAnswer3)
  }

  static func setSecurityAnswersWithSecurityQuestionsAndCompleteStep(_ securityQuestion1: String,
                                                                     securityAnswer1: String,
                                                                     securityQuestion2: String,
                                                                     securityAnswer2: String,
                                                                     securityQuestion3: String,
                                                                     securityAnswer3: String,
                                                                     personModel: PersonModel,
                                                                     accountModel: AccountModel) -> PMKPromise {
    return setSecurityAnswersWithSecurityQuestions(securityQuestion1,
                                                   securityAnswer1: securityAnswer1,
                                                   securityQuestion2: securityQuestion2,
                                                   securityAnswer2: securityAnswer2,
                                                   securityQuestion3: securityQuestion3,
                                                   securityAnswer3: securityAnswer3,
                                                   personModel: personModel,
                                                   accountModel: accountModel)
      .swiftThenInBackground({ _ in
        _ = completedAccountStep(.signUpSecurityQuestions,
                                 model: personModel,
                                 withAccountModel: accountModel).swiftThenInBackground({ _ in
                                  return personModel.refresh()
                                 })
        return nil
      })
  }

  static func skipPremiumTrial(_ accountModel: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.skipPremiumTrial(accountModel)
      .swiftThenInBackground({ _ in
        let step: AccountStateNew = .signUpBillingInformation
        return completedAccountStep(step,
                                    model: accountModel,
                                    withAccountModel: accountModel)
      })
  }

  static func setBillingInfo(_ cardNumber: String,
                             month: String,
                             year: String,
                             firstName: String,
                             lastName: String,
                             verificationValue: String,
                             address1: String,
                             address2: String,
                             city: String,
                             state: String,
                             postalCode: String,
                             country: String,
                             vatNumber: String,
                             placeId: String,
                             accountModel: AccountModel) -> PMKPromise {
    guard let tokenUrl = RxCornea.shared.session?.sessionInfo?.tokenURL,
      let publicKey = RxCornea.shared.session?.sessionInfo?.publicKey,
      let billingBuilder = BillingRequestBuilder(url: tokenUrl, withPublicKey: publicKey) else {
        return PMKPromise.new { (_: PMKFulfiller!, rejector: PMKRejecter!) in
          rejector(nil)
        }
    }

    billingBuilder.cardNumber = cardNumber
    billingBuilder.month = billingBuilder.setMonthFrom(month)
    billingBuilder.year = billingBuilder.setYearFrom(year)
    billingBuilder.firstName = firstName
    billingBuilder.lastName = lastName
    billingBuilder.verificationValue = verificationValue
    billingBuilder.address1 = address1
    billingBuilder.address2 = address2
    billingBuilder.city = city
    billingBuilder.state = state
    billingBuilder.postalCode = postalCode
    billingBuilder.country = country
    billingBuilder.vatNumber = vatNumber

    return BillingTokenClient.getBillingToken(using: billingBuilder)
      .swiftThenInBackground({ token in
        guard let token = token as? String else { return nil }

        return AccountCapabilityLegacy.createBillingAccount(accountModel,
                                                            billingToken: token,
                                                            placeID: placeId)
          .swiftThenInBackground({ _ in
            let step: AccountStateNew = .signUpBillingInformation
            return AccountCapabilityLegacy.signupTransition(accountModel,
                                                            stepcompleted: step.stringValue())
              .swiftThenInBackground({ response in
                return PMKPromise.new { (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
                  fulfiller([Constants.kModel: accountModel,
                             "Step": step.stringValue()])
                }
              })
          })
      })
  }

  static func updateBillingInfo(_ cardNumber: String,
                                month: String,
                                year: String,
                                firstName: String,
                                lastName: String,
                                verificationValue: String,
                                address1: String,
                                address2: String,
                                city: String,
                                state: String,
                                postalCode: String,
                                country: String,
                                vatNumber: String,
                                accountModel: AccountModel) -> PMKPromise {
    guard let tokenUrl = RxCornea.shared.session?.sessionInfo?.tokenURL,
      let publicKey = RxCornea.shared.session?.sessionInfo?.publicKey,
      let billingBuilder = BillingRequestBuilder(url: tokenUrl, withPublicKey: publicKey) else {
        return PMKPromise.new { (_: PMKFulfiller!, rejector: PMKRejecter!) in
          let error = NSError(domain: "Arcus",
                              code: 605,
                              userInfo: [NSLocalizedDescriptionKey: "Could not retrieve billing information"])
          rejector(error)
        }
    }

    billingBuilder.cardNumber = cardNumber
    billingBuilder.month = billingBuilder.setMonthFrom(month)
    billingBuilder.year = billingBuilder.setYearFrom(year)
    billingBuilder.firstName = firstName
    billingBuilder.lastName = lastName
    billingBuilder.verificationValue = verificationValue
    billingBuilder.address1 = address1
    billingBuilder.address2 = address2
    billingBuilder.city = city
    billingBuilder.state = state
    billingBuilder.postalCode = postalCode
    billingBuilder.country = country
    billingBuilder.vatNumber = vatNumber

    return BillingTokenClient.getBillingToken(using: billingBuilder)
      .swiftThenInBackground({ token in
        guard let token = token as? String else { return nil }

        return AccountCapabilityLegacy.updateBillingInfoCC(accountModel, billingToken: token)
          .swiftThenInBackground({ _ in
            return accountModel.refresh()
          })
      })
  }

  static func getPlaceTimezones() -> PMKPromise {
    return PlaceServiceLegacy.listTimezones()
      .swiftThenInBackground({ response in
        guard let response = response as? PlaceServiceListTimezonesResponse else {
          return nil
        }
        return PMKPromise.new({ (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(response.getTimezones())
        })
      })
  }

  static func setTzCoordinates(_ place: PlaceModel,
                               latitude: Double,
                               longitude: Double,
                               tzName: String,
                               tzOffset: String,
                               tzDST: Bool) -> PMKPromise {
    PlaceCapabilityLegacy.setAddrLatitude(latitude, model: place)
    PlaceCapabilityLegacy.setAddrLongitude(longitude, model: place)

    PlaceCapabilityLegacy.setTzName(tzName, model: place)

    var offset: Double = 0
    if let tzOff = Double(tzOffset) {
      offset = tzOff
    }

    PlaceCapabilityLegacy.setTzOffset(offset, model: place)

    PlaceCapabilityLegacy.setTzUsesDST(tzDST, model: place)

    return place.commit()
  }

  static func setTimeZone(_ place: PlaceModel,
                          account: AccountModel,
                          tzName: String,
                          tzId: String) -> PMKPromise {
    PlaceCapabilityLegacy.setTzName(tzName, model: place)
    PlaceCapabilityLegacy.setTzId(tzId, model: place)

    return place.commit()
      .swiftThenInBackground({ _ in
        completedAccountStep(.signUpTimeZone,
                             model: place,
                             withAccountModel: account)
          .swiftThenInBackground({ _ in
            return place.refresh()
          })
      })
  }

  // Duplicate implementation of PlaceAccountController is required to expose to ObjC

  static func addPlace(_ place: PlaceModel,
                       population: String,
                       serviceLevel: String,
                       addOns: Any,
                       account: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.addPlace(account,
                                            place: place,
                                            population: population,
                                            serviceLevel: serviceLevel,
                                            addons: addOns)
      .swiftThenInBackground({ response in
        return PMKPromise.new({ (fulfiller: PMKFulfiller!, rejector: PMKRejecter!) in
          if let response = response as? AccountAddPlaceResponse,
            let createdPlaceAttrs = response.getPlace() as? [String:AnyObject] {
            fulfiller(PlaceModel(attributes: createdPlaceAttrs))
          } else {
            rejector(nil)
          }
        })
      })
  }

  static func getOwnedPlacesOnModel(_ account: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.listPlaces(account)
      .swiftThenInBackground({ response in
        guard let response = response as? AccountListPlacesResponse else {
          return nil
        }
        return PMKPromise.new({ (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(response.getPlaces())
        })
      })
  }

  static func getLastKnownPlaceIdForPersonId(_ personId: String) -> String {
    guard let lastKnownPrefix = UserDefaults.standard
      .string(forKey: Constants.kLastKnownPlaceIdForAccountPrefix.appending(personId)) else {
        return ""
    }
    return lastKnownPrefix
  }

  static func setLastKnownPlaceId(_ placeId: String, personId: String) {
    let defaults = UserDefaults.standard

    defaults.set(placeId, forKey: Constants.kLastKnownPlaceIdForAccountPrefix.appending(personId))

    defaults.synchronize()
  }

  static func changeToPlaceId(_ placeId: String, person: PersonModel) -> PMKPromise {
    // TODO: Re-evaluate.
    RxCornea.shared.modelCache?.flush()
    SubsystemsController.sharedInstance().clearCurrentUserStates()

    let place = PlaceModel(attributes: [kAttrId: placeId as AnyObject])
    let namespace = place.getAddressForNamespace("place")
    place.set([kAttrAddress : namespace as AnyObject])

    setLastKnownPlaceId(placeId, personId: person.modelId)

    return SessionController.setActivePlace(placeId)
      .swiftThenInBackground({ _ in
        return place.refresh()
      })
      .swiftThenInBackground({ refreshedPlaceAttributes in
        //          let accountId = PlaceCapabilityLegacy.getPlaceAccount(place)
        //          let newAccountModel = AccountModel(attributes:[kAttrId: accountId])
        return nil
      })
  }

  // Duplicate implementation of DeleteAccountController is required to expose to ObjC

  static func deleteAccount(_ account: AccountModel) -> PMKPromise {
    return AccountCapabilityLegacy.delete(account, deleteOwnerLogin: true)
  }

  static func getSessionStartTime() -> Date {
    return Date()
  }

  static func disconnectAndResetLastUser() {

  }

  static func getDeviceUDID() -> String {
    return ""
  }

  static func deviceModelName() -> String {
    return ""
  }
}
