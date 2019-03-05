//
//  CreateAccountController.swift
//  i2app
//
//  Created by Arcus Team on 11/26/17.
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
import CocoaLumberjack
import Cornea

protocol CreateAccountController {
  static func createAccountWithEmail(_ email: String,
                                     withPassword password: String,
                                     withOptin optin: String) -> PMKPromise
  
  static func completedAccountStep(_ stepCompleted: AccountStateNew,
                                   model: Model,
                                   withAccountModel accountModel: AccountModel) -> PMKPromise
  
  static func setPersonDetails(_ firstName: String,
                               lastName: String,
                               phoneNumber: String,
                               personModel: PersonModel,
                               accountModel: AccountModel) -> PMKPromise
  
  static func setPersonDetailsAndCompleteStep(_ firstName: String,
                                              lastName: String,
                                              phoneNumber: String,
                                              personModel: PersonModel,
                                              accountModel: AccountModel) -> PMKPromise
  
  static func setPlaceDetails(_ nickName: String,
                              address1: String,
                              address2: String,
                              city: String,
                              state: String,
                              postalCode: String,
                              country: String,
                              placeModel: PlaceModel,
                              accountModel: AccountModel,
                              smartyStreetsDetails: [String: AnyObject]) -> PMKPromise
  
  static func setPin(_ pin: String,
                     personModel: PersonModel,
                     placeModel: PlaceModel,
                     accountModel: AccountModel) -> PMKPromise
  
  static func setSecurityAnswersWithSecurityQuestions(_ securityQuestion1: String,
                                                      securityAnswer1: String,
                                                      securityQuestion2: String,
                                                      securityAnswer2: String,
                                                      securityQuestion3: String,
                                                      securityAnswer3: String,
                                                      personModel: PersonModel,
                                                      accountModel: AccountModel) -> PMKPromise
  
  static func setSecurityAnswersWithSecurityQuestionsAndCompleteStep(_ securityQuestion1: String,
                                                                     securityAnswer1: String,
                                                                     securityQuestion2: String,
                                                                     securityAnswer2: String,
                                                                     securityQuestion3: String,
                                                                     securityAnswer3: String,
                                                                     personModel: PersonModel,
                                                                     accountModel: AccountModel) -> PMKPromise
  
  static func skipPremiumTrial(_ accountModel: AccountModel) -> PMKPromise
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
                             accountModel: AccountModel) -> PMKPromise
  
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
                                accountModel: AccountModel) -> PMKPromise
  
  static func getPlaceTimezones() -> PMKPromise
  static func setTzCoordinates(_ place: PlaceModel,
                               latitude: Double,
                               longitude: Double,
                               tzName: String,
                               tzOffset: String,
                               tzDST: Bool) -> PMKPromise
  static func setTimeZone(_ place: PlaceModel,
                          account: AccountModel,
                          tzName: String,
                          tzId: String) -> PMKPromise
}

extension CreateAccountController {
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
        accountModel.setValue(stepCompleted.stringValue(), forKey: kAttrAccountState)
        
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
    if let double = Double(tzOffset) {
      offset = double
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
}
