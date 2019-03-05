
//
// PersonCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var personNamespace: String = "person"
  public static var personName: String = "Person"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let personFirstName: String = "person:firstName"
  static let personLastName: String = "person:lastName"
  static let personEmail: String = "person:email"
  static let personEmailVerified: String = "person:emailVerified"
  static let personMobileNumber: String = "person:mobileNumber"
  static let personMobileNotificationEndpoints: String = "person:mobileNotificationEndpoints"
  static let personCurrPlace: String = "person:currPlace"
  static let personCurrPlaceMethod: String = "person:currPlaceMethod"
  static let personCurrLocation: String = "person:currLocation"
  static let personCurrLocationTime: String = "person:currLocationTime"
  static let personCurrLocationMethod: String = "person:currLocationMethod"
  static let personConsentOffersPromotions: String = "person:consentOffersPromotions"
  static let personConsentStatement: String = "person:consentStatement"
  static let personHasPin: String = "person:hasPin"
  static let personPlacesWithPin: String = "person:placesWithPin"
  static let personHasLogin: String = "person:hasLogin"
  static let personSecurityAnswerCount: String = "person:securityAnswerCount"
  
}

public protocol ArcusPersonCapability: class, RxArcusService {
  /** First name of the person */
  func getPersonFirstName(_ model: PersonModel) -> String?
  /** First name of the person */
  func setPersonFirstName(_ firstName: String, model: PersonModel)
/** Last name of the person */
  func getPersonLastName(_ model: PersonModel) -> String?
  /** Last name of the person */
  func setPersonLastName(_ lastName: String, model: PersonModel)
/** The email address for the person */
  func getPersonEmail(_ model: PersonModel) -> String?
  /** The email address for the person */
  func setPersonEmail(_ email: String, model: PersonModel)
/** Indicates the user has verified the current email address.  This field is reset if the user changes their email address. */
  func getPersonEmailVerified(_ model: PersonModel) -> Bool?
  /** The mobile phone number for the person */
  func getPersonMobileNumber(_ model: PersonModel) -> String?
  /** The mobile phone number for the person */
  func setPersonMobileNumber(_ mobileNumber: String, model: PersonModel)
/** The list of mobile endpoints where notifications may be sent */
  func getPersonMobileNotificationEndpoints(_ model: PersonModel) -> [String]?
  /** The list of mobile endpoints where notifications may be sent */
  func setPersonMobileNotificationEndpoints(_ mobileNotificationEndpoints: [String], model: PersonModel)
/** The ID of the current place where the person is present */
  func getPersonCurrPlace(_ model: PersonModel) -> String?
  /** The ID of the current place where the person is present */
  func setPersonCurrPlace(_ currPlace: String, model: PersonModel)
/** The methodology used for determining the current place */
  func getPersonCurrPlaceMethod(_ model: PersonModel) -> String?
  /** The methodology used for determining the current place */
  func setPersonCurrPlaceMethod(_ currPlaceMethod: String, model: PersonModel)
/** The current location of the person */
  func getPersonCurrLocation(_ model: PersonModel) -> String?
  /** The current location of the person */
  func setPersonCurrLocation(_ currLocation: String, model: PersonModel)
/** The time that the current location was determined */
  func getPersonCurrLocationTime(_ model: PersonModel) -> Date?
  /** The time that the current location was determined */
  func setPersonCurrLocationTime(_ currLocationTime: Date, model: PersonModel)
/** The methodology used for determining the current location */
  func getPersonCurrLocationMethod(_ model: PersonModel) -> String?
  /** The methodology used for determining the current location */
  func setPersonCurrLocationMethod(_ currLocationMethod: String, model: PersonModel)
/** The date and time when this person provided consent to receive communications of offers and promotions */
  func getPersonConsentOffersPromotions(_ model: PersonModel) -> Date?
  /** The date and time when this person provided consent to receive communications of offers and promotions */
  func setPersonConsentOffersPromotions(_ consentOffersPromotions: Date, model: PersonModel)
/** The date and time where person provided consent to receive monthly statement communications */
  func getPersonConsentStatement(_ model: PersonModel) -> Date?
  /** The date and time where person provided consent to receive monthly statement communications */
  func setPersonConsentStatement(_ consentStatement: Date, model: PersonModel)
/** Returns true if the person has a pin, false otherwise.  This is deprecated and only returns true if the person at a pin at currPlace, placesWithPin is preferred */
  func getPersonHasPin(_ model: PersonModel) -> Bool?
  /** Returns the set of places the person has a pin assigned */
  func getPersonPlacesWithPin(_ model: PersonModel) -> [String]?
  /** Returns true if the person has a login, false otherwise */
  func getPersonHasLogin(_ model: PersonModel) -> Bool?
  /** The number of security answers the user has filled out */
  func getPersonSecurityAnswerCount(_ model: PersonModel) -> Int?
  
  /** Sets the security answers for the given person.  The first question and answer are required, those for the second and third are optional. */
  func requestPersonSetSecurityAnswers(_  model: PersonModel, securityQuestion1: String, securityAnswer1: String, securityQuestion2: String, securityAnswer2: String, securityQuestion3: String, securityAnswer3: String)
   throws -> Observable<ArcusSessionEvent>/** Retrieves the security responses for the given person */
  func requestPersonGetSecurityAnswers(_ model: PersonModel) throws -> Observable<ArcusSessionEvent>/** Adds and associates a mobile device for the given person */
  func requestPersonAddMobileDevice(_  model: PersonModel, name: String, appVersion: String, osType: String, osVersion: String, formFactor: String, phoneNumber: String, deviceIdentifier: String, deviceModel: String, deviceVendor: String, resolution: String, notificationToken: String, lastLatitude: Double, lastLongitude: Double)
   throws -> Observable<ArcusSessionEvent>/** Removes/disassociates a mobile device from this person */
  func requestPersonRemoveMobileDevice(_  model: PersonModel, deviceIndex: Int)
   throws -> Observable<ArcusSessionEvent>/** Lists all mobile devices associated with this person */
  func requestPersonListMobileDevices(_ model: PersonModel) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the history log entries associated with this person */
  func requestPersonListHistoryEntries(_  model: PersonModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent>/** Remove/Deactivate the person record indicated. */
  func requestPersonDelete(_ model: PersonModel) throws -> Observable<ArcusSessionEvent>/** Removes a person from a specific place.  If the person is a hobbit they will be completely deleted. */
  func requestPersonRemoveFromPlace(_  model: PersonModel, placeId: String)
   throws -> Observable<ArcusSessionEvent>/** Changes the person&#x27;s pin at their currPlace.  Deprecated, use ChangePinV2 instead. */
  func requestPersonChangePin(_  model: PersonModel, currentPin: String, newPin: String)
   throws -> Observable<ArcusSessionEvent>/** Changes the person&#x27;s pin at the specified place.  People are allowed to change their own pin or a hobbit at the specified place assuming the person invoking the call has access to the place. */
  func requestPersonChangePinV2(_  model: PersonModel, place: String, pin: String)
   throws -> Observable<ArcusSessionEvent>/** Verifies that the pins match and that the requester is logged in as the person that the pin is being verified for. */
  func requestPersonVerifyPin(_  model: PersonModel, place: String, pin: String)
   throws -> Observable<ArcusSessionEvent>/** Accepts an invitation */
  func requestPersonAcceptInvitation(_  model: PersonModel, code: String, inviteeEmail: String)
   throws -> Observable<ArcusSessionEvent>/** Rejects an invitation */
  func requestPersonRejectInvitation(_  model: PersonModel, code: String, inviteeEmail: String, reason: String)
   throws -> Observable<ArcusSessionEvent>/** Retrieves the list of pending invitations for this user */
  func requestPersonPendingInvitations(_ model: PersonModel) throws -> Observable<ArcusSessionEvent>/** Promotes a user with a login to full fledged IRIS account */
  func requestPersonPromoteToAccount(_  model: PersonModel, place: Any)
   throws -> Observable<ArcusSessionEvent>/** Deletes complete the login and any associations with it */
  func requestPersonDeleteLogin(_ model: PersonModel) throws -> Observable<ArcusSessionEvent>/** Lists the available places for a person.  Returns the same structure as the session service&#x27;s method */
  func requestPersonListAvailablePlaces(_ model: PersonModel) throws -> Observable<ArcusSessionEvent>/** Accept terms &amp; conditions and/or privacy policy */
  func requestPersonAcceptPolicy(_  model: PersonModel, type: String)
   throws -> Observable<ArcusSessionEvent>/** Reject terms &amp; conditions and/or privacy policy. NOTE THIS IS GENERALLY FOR TESTING ONLY */
  func requestPersonRejectPolicy(_  model: PersonModel, type: String)
   throws -> Observable<ArcusSessionEvent>/** Generates an email address verification email. */
  func requestPersonSendVerificationEmail(_  model: PersonModel, source: String)
   throws -> Observable<ArcusSessionEvent>/** Verifies that the user has access to their current email address by providing the token from the email. */
  func requestPersonVerifyEmail(_  model: PersonModel, token: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusPersonCapability {
  public func getPersonFirstName(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personFirstName] as? String
  }
  
  public func setPersonFirstName(_ firstName: String, model: PersonModel) {
    model.set([Attributes.personFirstName: firstName as AnyObject])
  }
  public func getPersonLastName(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personLastName] as? String
  }
  
  public func setPersonLastName(_ lastName: String, model: PersonModel) {
    model.set([Attributes.personLastName: lastName as AnyObject])
  }
  public func getPersonEmail(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personEmail] as? String
  }
  
  public func setPersonEmail(_ email: String, model: PersonModel) {
    model.set([Attributes.personEmail: email as AnyObject])
  }
  public func getPersonEmailVerified(_ model: PersonModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personEmailVerified] as? Bool
  }
  
  public func getPersonMobileNumber(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personMobileNumber] as? String
  }
  
  public func setPersonMobileNumber(_ mobileNumber: String, model: PersonModel) {
    model.set([Attributes.personMobileNumber: mobileNumber as AnyObject])
  }
  public func getPersonMobileNotificationEndpoints(_ model: PersonModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personMobileNotificationEndpoints] as? [String]
  }
  
  public func setPersonMobileNotificationEndpoints(_ mobileNotificationEndpoints: [String], model: PersonModel) {
    model.set([Attributes.personMobileNotificationEndpoints: mobileNotificationEndpoints as AnyObject])
  }
  public func getPersonCurrPlace(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personCurrPlace] as? String
  }
  
  public func setPersonCurrPlace(_ currPlace: String, model: PersonModel) {
    model.set([Attributes.personCurrPlace: currPlace as AnyObject])
  }
  public func getPersonCurrPlaceMethod(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personCurrPlaceMethod] as? String
  }
  
  public func setPersonCurrPlaceMethod(_ currPlaceMethod: String, model: PersonModel) {
    model.set([Attributes.personCurrPlaceMethod: currPlaceMethod as AnyObject])
  }
  public func getPersonCurrLocation(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personCurrLocation] as? String
  }
  
  public func setPersonCurrLocation(_ currLocation: String, model: PersonModel) {
    model.set([Attributes.personCurrLocation: currLocation as AnyObject])
  }
  public func getPersonCurrLocationTime(_ model: PersonModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.personCurrLocationTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func setPersonCurrLocationTime(_ currLocationTime: Date, model: PersonModel) {
    model.set([Attributes.personCurrLocationTime: currLocationTime.millisecondsSince1970 as AnyObject])
  }
  public func getPersonCurrLocationMethod(_ model: PersonModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personCurrLocationMethod] as? String
  }
  
  public func setPersonCurrLocationMethod(_ currLocationMethod: String, model: PersonModel) {
    model.set([Attributes.personCurrLocationMethod: currLocationMethod as AnyObject])
  }
  public func getPersonConsentOffersPromotions(_ model: PersonModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.personConsentOffersPromotions] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func setPersonConsentOffersPromotions(_ consentOffersPromotions: Date, model: PersonModel) {
    model.set([Attributes.personConsentOffersPromotions: consentOffersPromotions.millisecondsSince1970 as AnyObject])
  }
  public func getPersonConsentStatement(_ model: PersonModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.personConsentStatement] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func setPersonConsentStatement(_ consentStatement: Date, model: PersonModel) {
    model.set([Attributes.personConsentStatement: consentStatement.millisecondsSince1970 as AnyObject])
  }
  public func getPersonHasPin(_ model: PersonModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personHasPin] as? Bool
  }
  
  public func getPersonPlacesWithPin(_ model: PersonModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personPlacesWithPin] as? [String]
  }
  
  public func getPersonHasLogin(_ model: PersonModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personHasLogin] as? Bool
  }
  
  public func getPersonSecurityAnswerCount(_ model: PersonModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.personSecurityAnswerCount] as? Int
  }
  
  
  public func requestPersonSetSecurityAnswers(_  model: PersonModel, securityQuestion1: String, securityAnswer1: String, securityQuestion2: String, securityAnswer2: String, securityQuestion3: String, securityAnswer3: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonSetSecurityAnswersRequest = PersonSetSecurityAnswersRequest()
    request.source = model.address
    
    
    
    request.setSecurityQuestion1(securityQuestion1)
    
    request.setSecurityAnswer1(securityAnswer1)
    
    request.setSecurityQuestion2(securityQuestion2)
    
    request.setSecurityAnswer2(securityAnswer2)
    
    request.setSecurityQuestion3(securityQuestion3)
    
    request.setSecurityAnswer3(securityAnswer3)
    
    return try sendRequest(request)
  }
  
  public func requestPersonGetSecurityAnswers(_ model: PersonModel) throws -> Observable<ArcusSessionEvent> {
    let request: PersonGetSecurityAnswersRequest = PersonGetSecurityAnswersRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPersonAddMobileDevice(_  model: PersonModel, name: String, appVersion: String, osType: String, osVersion: String, formFactor: String, phoneNumber: String, deviceIdentifier: String, deviceModel: String, deviceVendor: String, resolution: String, notificationToken: String, lastLatitude: Double, lastLongitude: Double)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonAddMobileDeviceRequest = PersonAddMobileDeviceRequest()
    request.source = model.address
    
    
    
    request.setName(name)
    
    request.setAppVersion(appVersion)
    
    request.setOsType(osType)
    
    request.setOsVersion(osVersion)
    
    request.setFormFactor(formFactor)
    
    request.setPhoneNumber(phoneNumber)
    
    request.setDeviceIdentifier(deviceIdentifier)
    
    request.setDeviceModel(deviceModel)
    
    request.setDeviceVendor(deviceVendor)
    
    request.setResolution(resolution)
    
    request.setNotificationToken(notificationToken)
    
    request.setLastLatitude(lastLatitude)
    
    request.setLastLongitude(lastLongitude)
    
    return try sendRequest(request)
  }
  
  public func requestPersonRemoveMobileDevice(_  model: PersonModel, deviceIndex: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonRemoveMobileDeviceRequest = PersonRemoveMobileDeviceRequest()
    request.source = model.address
    
    
    
    request.setDeviceIndex(deviceIndex)
    
    return try sendRequest(request)
  }
  
  public func requestPersonListMobileDevices(_ model: PersonModel) throws -> Observable<ArcusSessionEvent> {
    let request: PersonListMobileDevicesRequest = PersonListMobileDevicesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPersonListHistoryEntries(_  model: PersonModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonListHistoryEntriesRequest = PersonListHistoryEntriesRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    return try sendRequest(request)
  }
  
  public func requestPersonDelete(_ model: PersonModel) throws -> Observable<ArcusSessionEvent> {
    let request: PersonDeleteRequest = PersonDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPersonRemoveFromPlace(_  model: PersonModel, placeId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonRemoveFromPlaceRequest = PersonRemoveFromPlaceRequest()
    request.source = model.address
    
    
    
    request.setPlaceId(placeId)
    
    return try sendRequest(request)
  }
  
  public func requestPersonChangePin(_  model: PersonModel, currentPin: String, newPin: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonChangePinRequest = PersonChangePinRequest()
    request.source = model.address
    request.isRequest = true
    
    request.setNewPin(newPin)
    if (currentPin.characters.count > 0) {
      request.setCurrentPin(currentPin)
    }
    
    return try sendRequest(request)
  }
  
  public func requestPersonChangePinV2(_  model: PersonModel, place: String, pin: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonChangePinV2Request = PersonChangePinV2Request()
    request.source = model.address
    request.isRequest = true
    
    
    request.setPlace(place)
    
    request.setPin(pin)
    
    return try sendRequest(request)
  }
  
  public func requestPersonVerifyPin(_  model: PersonModel, place: String, pin: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonVerifyPinRequest = PersonVerifyPinRequest()
    request.source = model.address
    request.isRequest = true
    
    
    request.setPlace(place)
    
    request.setPin(pin)
    
    return try sendRequest(request)
  }
  
  public func requestPersonAcceptInvitation(_  model: PersonModel, code: String, inviteeEmail: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonAcceptInvitationRequest = PersonAcceptInvitationRequest()
    request.source = model.address
    
    
    
    request.setCode(code)
    
    request.setInviteeEmail(inviteeEmail)
    
    return try sendRequest(request)
  }
  
  public func requestPersonRejectInvitation(_  model: PersonModel, code: String, inviteeEmail: String, reason: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonRejectInvitationRequest = PersonRejectInvitationRequest()
    request.source = model.address
    
    
    
    request.setCode(code)
    
    request.setInviteeEmail(inviteeEmail)
    
    request.setReason(reason)
    
    return try sendRequest(request)
  }
  
  public func requestPersonPendingInvitations(_ model: PersonModel) throws -> Observable<ArcusSessionEvent> {
    let request: PersonPendingInvitationsRequest = PersonPendingInvitationsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPersonPromoteToAccount(_  model: PersonModel, place: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonPromoteToAccountRequest = PersonPromoteToAccountRequest()
    request.source = model.address
    
    
    
    request.setPlace(place)
    
    return try sendRequest(request)
  }
  
  public func requestPersonDeleteLogin(_ model: PersonModel) throws -> Observable<ArcusSessionEvent> {
    let request: PersonDeleteLoginRequest = PersonDeleteLoginRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPersonListAvailablePlaces(_ model: PersonModel) throws -> Observable<ArcusSessionEvent> {
    let request: PersonListAvailablePlacesRequest = PersonListAvailablePlacesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPersonAcceptPolicy(_  model: PersonModel, type: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonAcceptPolicyRequest = PersonAcceptPolicyRequest()
    request.source = model.address
    
    
    
    request.setType(type)
    
    return try sendRequest(request)
  }
  
  public func requestPersonRejectPolicy(_  model: PersonModel, type: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonRejectPolicyRequest = PersonRejectPolicyRequest()
    request.source = model.address
    
    
    
    request.setType(type)
    
    return try sendRequest(request)
  }
  
  public func requestPersonSendVerificationEmail(_  model: PersonModel, source: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonSendVerificationEmailRequest = PersonSendVerificationEmailRequest()
    request.source = model.address
    request.isRequest = true
    
    
    request.setSource(source)
    
    return try sendRequest(request)
  }
  
  public func requestPersonVerifyEmail(_  model: PersonModel, token: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PersonVerifyEmailRequest = PersonVerifyEmailRequest()
    request.source = model.address
    request.isRequest = true
    
    
    request.setToken(token)
    
    return try sendRequest(request)
  }
  
}
