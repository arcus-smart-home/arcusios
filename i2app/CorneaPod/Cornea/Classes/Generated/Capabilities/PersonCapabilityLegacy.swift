
//
// PersonCapabilityLegacy.swift
//
// Generated on 20/09/18
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

import Foundation
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class PersonCapabilityLegacy: NSObject, ArcusPersonCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PersonCapabilityLegacy  = PersonCapabilityLegacy()
  

  
  public static func getFirstName(_ model: PersonModel) -> String? {
    return capability.getPersonFirstName(model)
  }
  
  public static func setFirstName(_ firstName: String, model: PersonModel) {
    
    
    capability.setPersonFirstName(firstName, model: model)
  }
  
  public static func getLastName(_ model: PersonModel) -> String? {
    return capability.getPersonLastName(model)
  }
  
  public static func setLastName(_ lastName: String, model: PersonModel) {
    
    
    capability.setPersonLastName(lastName, model: model)
  }
  
  public static func getEmail(_ model: PersonModel) -> String? {
    return capability.getPersonEmail(model)
  }
  
  public static func setEmail(_ email: String, model: PersonModel) {
    
    
    capability.setPersonEmail(email, model: model)
  }
  
  public static func getEmailVerified(_ model: PersonModel) -> NSNumber? {
    guard let emailVerified: Bool = capability.getPersonEmailVerified(model) else {
      return nil
    }
    return NSNumber(value: emailVerified)
  }
  
  public static func getMobileNumber(_ model: PersonModel) -> String? {
    return capability.getPersonMobileNumber(model)
  }
  
  public static func setMobileNumber(_ mobileNumber: String, model: PersonModel) {
    
    
    capability.setPersonMobileNumber(mobileNumber, model: model)
  }
  
  public static func getMobileNotificationEndpoints(_ model: PersonModel) -> [String]? {
    return capability.getPersonMobileNotificationEndpoints(model)
  }
  
  public static func setMobileNotificationEndpoints(_ mobileNotificationEndpoints: [String], model: PersonModel) {
    
    
    capability.setPersonMobileNotificationEndpoints(mobileNotificationEndpoints, model: model)
  }
  
  public static func getCurrPlace(_ model: PersonModel) -> String? {
    return capability.getPersonCurrPlace(model)
  }
  
  public static func setCurrPlace(_ currPlace: String, model: PersonModel) {
    
    
    capability.setPersonCurrPlace(currPlace, model: model)
  }
  
  public static func getCurrPlaceMethod(_ model: PersonModel) -> String? {
    return capability.getPersonCurrPlaceMethod(model)
  }
  
  public static func setCurrPlaceMethod(_ currPlaceMethod: String, model: PersonModel) {
    
    
    capability.setPersonCurrPlaceMethod(currPlaceMethod, model: model)
  }
  
  public static func getCurrLocation(_ model: PersonModel) -> String? {
    return capability.getPersonCurrLocation(model)
  }
  
  public static func setCurrLocation(_ currLocation: String, model: PersonModel) {
    
    
    capability.setPersonCurrLocation(currLocation, model: model)
  }
  
  public static func getCurrLocationTime(_ model: PersonModel) -> Date? {
    guard let currLocationTime: Date = capability.getPersonCurrLocationTime(model) else {
      return nil
    }
    return currLocationTime
  }
  
  public static func setCurrLocationTime(_ currLocationTime: Double, model: PersonModel) {
    
    let currLocationTime: Date = Date(milliseconds: currLocationTime)
    capability.setPersonCurrLocationTime(currLocationTime, model: model)
  }
  
  public static func getCurrLocationMethod(_ model: PersonModel) -> String? {
    return capability.getPersonCurrLocationMethod(model)
  }
  
  public static func setCurrLocationMethod(_ currLocationMethod: String, model: PersonModel) {
    
    
    capability.setPersonCurrLocationMethod(currLocationMethod, model: model)
  }
  
  public static func getConsentOffersPromotions(_ model: PersonModel) -> Date? {
    guard let consentOffersPromotions: Date = capability.getPersonConsentOffersPromotions(model) else {
      return nil
    }
    return consentOffersPromotions
  }
  
  public static func setConsentOffersPromotions(_ consentOffersPromotions: Double, model: PersonModel) {
    
    let consentOffersPromotions: Date = Date(milliseconds: consentOffersPromotions)
    capability.setPersonConsentOffersPromotions(consentOffersPromotions, model: model)
  }
  
  public static func getConsentStatement(_ model: PersonModel) -> Date? {
    guard let consentStatement: Date = capability.getPersonConsentStatement(model) else {
      return nil
    }
    return consentStatement
  }
  
  public static func setConsentStatement(_ consentStatement: Double, model: PersonModel) {
    
    let consentStatement: Date = Date(milliseconds: consentStatement)
    capability.setPersonConsentStatement(consentStatement, model: model)
  }
  
  public static func getHasPin(_ model: PersonModel) -> NSNumber? {
    guard let hasPin: Bool = capability.getPersonHasPin(model) else {
      return nil
    }
    return NSNumber(value: hasPin)
  }
  
  public static func getPlacesWithPin(_ model: PersonModel) -> [String]? {
    return capability.getPersonPlacesWithPin(model)
  }
  
  public static func getHasLogin(_ model: PersonModel) -> NSNumber? {
    guard let hasLogin: Bool = capability.getPersonHasLogin(model) else {
      return nil
    }
    return NSNumber(value: hasLogin)
  }
  
  public static func getSecurityAnswerCount(_ model: PersonModel) -> NSNumber? {
    guard let securityAnswerCount: Int = capability.getPersonSecurityAnswerCount(model) else {
      return nil
    }
    return NSNumber(value: securityAnswerCount)
  }
  
  public static func setSecurityAnswers(_  model: PersonModel, securityQuestion1: String, securityAnswer1: String, securityQuestion2: String, securityAnswer2: String, securityQuestion3: String, securityAnswer3: String) -> PMKPromise {
  
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonSetSecurityAnswers(model, securityQuestion1: securityQuestion1, securityAnswer1: securityAnswer1, securityQuestion2: securityQuestion2, securityAnswer2: securityAnswer2, securityQuestion3: securityQuestion3, securityAnswer3: securityAnswer3))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getSecurityAnswers(_ model: PersonModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPersonGetSecurityAnswers(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func addMobileDevice(_  model: PersonModel, name: String, appVersion: String, osType: String, osVersion: String, formFactor: String, phoneNumber: String, deviceIdentifier: String, deviceModel: String, deviceVendor: String, resolution: String, notificationToken: String, lastLatitude: Double, lastLongitude: Double) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonAddMobileDevice(model, name: name, appVersion: appVersion, osType: osType, osVersion: osVersion, formFactor: formFactor, phoneNumber: phoneNumber, deviceIdentifier: deviceIdentifier, deviceModel: deviceModel, deviceVendor: deviceVendor, resolution: resolution, notificationToken: notificationToken, lastLatitude: lastLatitude, lastLongitude: lastLongitude))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func removeMobileDevice(_  model: PersonModel, deviceIndex: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonRemoveMobileDevice(model, deviceIndex: deviceIndex))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listMobileDevices(_ model: PersonModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPersonListMobileDevices(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHistoryEntries(_  model: PersonModel, limit: Int, token: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonListHistoryEntries(model, limit: limit, token: token))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: PersonModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPersonDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func removeFromPlace(_  model: PersonModel, placeId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonRemoveFromPlace(model, placeId: placeId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func changePin(_  model: PersonModel, currentPin: String, newPin: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonChangePin(model, currentPin: currentPin, newPin: newPin))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func changePinV2(_  model: PersonModel, place: String, pin: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonChangePinV2(model, place: place, pin: pin))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func verifyPin(_  model: PersonModel, place: String, pin: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonVerifyPin(model, place: place, pin: pin))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func acceptInvitation(_  model: PersonModel, code: String, inviteeEmail: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonAcceptInvitation(model, code: code, inviteeEmail: inviteeEmail))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func rejectInvitation(_  model: PersonModel, code: String, inviteeEmail: String, reason: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonRejectInvitation(model, code: code, inviteeEmail: inviteeEmail, reason: reason))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func pendingInvitations(_ model: PersonModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPersonPendingInvitations(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func promoteToAccount(_  model: PersonModel, place: Any) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonPromoteToAccount(model, place: place))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func deleteLogin(_ model: PersonModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPersonDeleteLogin(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listAvailablePlaces(_ model: PersonModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPersonListAvailablePlaces(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func acceptPolicy(_  model: PersonModel, type: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonAcceptPolicy(model, type: type))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func rejectPolicy(_  model: PersonModel, type: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonRejectPolicy(model, type: type))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func sendVerificationEmail(_  model: PersonModel, source: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonSendVerificationEmail(model, source: source))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func verifyEmail(_  model: PersonModel, token: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPersonVerifyEmail(model, token: token))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
