
//
// AccountCap.swift
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
  public static var accountNamespace: String = "account"
  public static var accountName: String = "Account"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let accountState: String = "account:state"
  static let accountTaxExempt: String = "account:taxExempt"
  static let accountBillingFirstName: String = "account:billingFirstName"
  static let accountBillingLastName: String = "account:billingLastName"
  static let accountBillingCCType: String = "account:billingCCType"
  static let accountBillingCCLast4: String = "account:billingCCLast4"
  static let accountBillingStreet1: String = "account:billingStreet1"
  static let accountBillingStreet2: String = "account:billingStreet2"
  static let accountBillingCity: String = "account:billingCity"
  static let accountBillingState: String = "account:billingState"
  static let accountBillingZip: String = "account:billingZip"
  static let accountBillingZipPlusFour: String = "account:billingZipPlusFour"
  static let accountOwner: String = "account:owner"
  static let accountMyArcusEmail: String = "account:myArcusEmail"
  static let accountCreated: String = "account:created"
  static let accountModified: String = "account:modified"
  
}

public protocol ArcusAccountCapability: class, RxArcusService {
  /** Platform-owned state of the account */
  func getAccountState(_ model: AccountModel) -> String?
  /** Platform-owned state of the account */
  func setAccountState(_ state: String, model: AccountModel)
/** Platform-owned indicator of whether or not the billing account is tax-exempt.  If not present it implies that it is not */
  func getAccountTaxExempt(_ model: AccountModel) -> Bool?
  /** Platform-owned first name on the billing account. */
  func getAccountBillingFirstName(_ model: AccountModel) -> String?
  /** Platfrom-owned last name on the billing account. */
  func getAccountBillingLastName(_ model: AccountModel) -> String?
  /** Platform-owned type of CC on the billing account. */
  func getAccountBillingCCType(_ model: AccountModel) -> String?
  /** Platform-owned last 4 digits of the CC on the billing account */
  func getAccountBillingCCLast4(_ model: AccountModel) -> String?
  /** Platform-owned street address on the billing account */
  func getAccountBillingStreet1(_ model: AccountModel) -> String?
  /** Platform-owned street address on the billing account */
  func getAccountBillingStreet2(_ model: AccountModel) -> String?
  /** Platform-owned city on the billing account&#x27;s address */
  func getAccountBillingCity(_ model: AccountModel) -> String?
  /** Platform-owned state on the billing account&#x27;s address */
  func getAccountBillingState(_ model: AccountModel) -> String?
  /** Platform-owned zip code on the billing account&#x27;s address */
  func getAccountBillingZip(_ model: AccountModel) -> String?
  /** Platform-owned digits of the zip code after the plus sign on the billing account&#x27;s address */
  func getAccountBillingZipPlusFour(_ model: AccountModel) -> String?
  /** The person ID of the account owner */
  func getAccountOwner(_ model: AccountModel) -> String?
  /** The MyArcus email address of the account owner.  Present when the MyArcus discount has been applied to this account. */
  func getAccountMyArcusEmail(_ model: AccountModel) -> String?
  /** Date of creation of the account. */
  func getAccountCreated(_ model: AccountModel) -> Date?
  /** Last time that something was changed on the account. */
  func getAccountModified(_ model: AccountModel) -> Date?
  
  /** Lists all devices associated with this account */
  func requestAccountListDevices(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>/** Lists all hubs associated with this account */
  func requestAccountListHubs(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>/** Lists all the places associated with this account */
  func requestAccountListPlaces(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>/** Lists all Recurly invoices associated with this account */
  func requestAccountListInvoices(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>/** Lists all adjustments associated with this account */
  func requestAccountListAdjustments(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>/** Send a state transition to indicate where in the sign-up process the account is */
  func requestAccountSignupTransition(_  model: AccountModel, stepcompleted: String)
   throws -> Observable<ArcusSessionEvent>/** Updates billing info that contains Credit Card information using a token from ReCurly. */
  func requestAccountUpdateBillingInfoCC(_  model: AccountModel, billingToken: String)
   throws -> Observable<ArcusSessionEvent>/** Method invoked to inform the platform that the user has explicitly decided to skip the premium trial. */
  func requestAccountSkipPremiumTrial(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>/** Create a users billing account and sets up the initial subscription */
  func requestAccountCreateBillingAccount(_  model: AccountModel, billingToken: String, placeID: String)
   throws -> Observable<ArcusSessionEvent>/** Updates the subscription level and addons for the specified place ID. */
  func requestAccountUpdateServicePlan(_  model: AccountModel, placeID: String, serviceLevel: String, addons: Any)
   throws -> Observable<ArcusSessionEvent>/** Adds a place for this account */
  func requestAccountAddPlace(_  model: AccountModel, place: Any, population: String, serviceLevel: String, addons: Any)
   throws -> Observable<ArcusSessionEvent>/** Deletes an account with optional removal of the login */
  func requestAccountDelete(_  model: AccountModel, deleteOwnerLogin: Bool)
   throws -> Observable<ArcusSessionEvent>/** An account has be marked Delinquent */
  func requestAccountDelinquentAccountEvent(_  model: AccountModel, accountId: String)
   throws -> Observable<ArcusSessionEvent>/** Creates a credit adjustment using ReCurly. */
  func requestAccountIssueCredit(_  model: AccountModel, amountInCents: String, description: String)
   throws -> Observable<ArcusSessionEvent>/** Creates a refund of an entire invoice using ReCurly. */
  func requestAccountIssueInvoiceRefund(_  model: AccountModel, invoiceNumber: String)
   throws -> Observable<ArcusSessionEvent>/** Method invoked to signal that account signup is complete. */
  func requestAccountActivate(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>
  func requestAccountApplyMyArcusDiscount(_  model: AccountModel, myArcusEmail: String, myArcusPassword: String)
   throws -> Observable<ArcusSessionEvent>
  func requestAccountRemoveMyArcusDiscount(_ model: AccountModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusAccountCapability {
  public func getAccountState(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountState] as? String
  }
  
  public func setAccountState(_ state: String, model: AccountModel) {
    model.set([Attributes.accountState: state as AnyObject])
  }
  public func getAccountTaxExempt(_ model: AccountModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountTaxExempt] as? Bool
  }
  
  public func getAccountBillingFirstName(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingFirstName] as? String
  }
  
  public func getAccountBillingLastName(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingLastName] as? String
  }
  
  public func getAccountBillingCCType(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingCCType] as? String
  }
  
  public func getAccountBillingCCLast4(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingCCLast4] as? String
  }
  
  public func getAccountBillingStreet1(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingStreet1] as? String
  }
  
  public func getAccountBillingStreet2(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingStreet2] as? String
  }
  
  public func getAccountBillingCity(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingCity] as? String
  }
  
  public func getAccountBillingState(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingState] as? String
  }
  
  public func getAccountBillingZip(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingZip] as? String
  }
  
  public func getAccountBillingZipPlusFour(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountBillingZipPlusFour] as? String
  }
  
  public func getAccountOwner(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountOwner] as? String
  }
  
  public func getAccountMyArcusEmail(_ model: AccountModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.accountMyArcusEmail] as? String
  }
  
  public func getAccountCreated(_ model: AccountModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.accountCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getAccountModified(_ model: AccountModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.accountModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestAccountListDevices(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountListDevicesRequest = AccountListDevicesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAccountListHubs(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountListHubsRequest = AccountListHubsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAccountListPlaces(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountListPlacesRequest = AccountListPlacesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAccountListInvoices(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountListInvoicesRequest = AccountListInvoicesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAccountListAdjustments(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountListAdjustmentsRequest = AccountListAdjustmentsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAccountSignupTransition(_  model: AccountModel, stepcompleted: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountSignupTransitionRequest = AccountSignupTransitionRequest()
    request.source = model.address
    
    
    
    request.setStepcompleted(stepcompleted)
    
    return try sendRequest(request)
  }
  
  public func requestAccountUpdateBillingInfoCC(_  model: AccountModel, billingToken: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountUpdateBillingInfoCCRequest = AccountUpdateBillingInfoCCRequest()
    request.source = model.address
    
    
    
    request.setBillingToken(billingToken)
    
    return try sendRequest(request)
  }
  
  public func requestAccountSkipPremiumTrial(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountSkipPremiumTrialRequest = AccountSkipPremiumTrialRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAccountCreateBillingAccount(_  model: AccountModel, billingToken: String, placeID: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountCreateBillingAccountRequest = AccountCreateBillingAccountRequest()
    request.source = model.address
    
    
    
    request.setBillingToken(billingToken)
    
    request.setPlaceID(placeID)
    
    return try sendRequest(request)
  }
  
  public func requestAccountUpdateServicePlan(_  model: AccountModel, placeID: String, serviceLevel: String, addons: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountUpdateServicePlanRequest = AccountUpdateServicePlanRequest()
    request.source = model.address
    
    
    
    request.setPlaceID(placeID)
    
    request.setServiceLevel(serviceLevel)
    
    request.setAddons(addons)
    
    return try sendRequest(request)
  }
  
  public func requestAccountAddPlace(_  model: AccountModel, place: Any, population: String, serviceLevel: String, addons: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountAddPlaceRequest = AccountAddPlaceRequest()
    request.source = model.address
    
    
    
    request.setPlace(place)
    
    request.setPopulation(population)
    
    request.setServiceLevel(serviceLevel)
    
    request.setAddons(addons)
    
    return try sendRequest(request)
  }
  
  public func requestAccountDelete(_  model: AccountModel, deleteOwnerLogin: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountDeleteRequest = AccountDeleteRequest()
    request.source = model.address
    
    
    
    request.setDeleteOwnerLogin(deleteOwnerLogin)
    
    return try sendRequest(request)
  }
  
  public func requestAccountDelinquentAccountEvent(_  model: AccountModel, accountId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountDelinquentAccountEventRequest = AccountDelinquentAccountEventRequest()
    request.source = model.address
    
    
    
    request.setAccountId(accountId)
    
    return try sendRequest(request)
  }
  
  public func requestAccountIssueCredit(_  model: AccountModel, amountInCents: String, description: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountIssueCreditRequest = AccountIssueCreditRequest()
    request.source = model.address
    
    
    
    request.setAmountInCents(amountInCents)
    
    request.setDescription(description)
    
    return try sendRequest(request)
  }
  
  public func requestAccountIssueInvoiceRefund(_  model: AccountModel, invoiceNumber: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountIssueInvoiceRefundRequest = AccountIssueInvoiceRefundRequest()
    request.source = model.address
    
    
    
    request.setInvoiceNumber(invoiceNumber)
    
    return try sendRequest(request)
  }
  
  public func requestAccountActivate(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountActivateRequest = AccountActivateRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestAccountApplyMyArcusDiscount(_  model: AccountModel, myArcusEmail: String, myArcusPassword: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: AccountApplyMyArcusDiscountRequest = AccountApplyMyArcusDiscountRequest()
    request.source = model.address
    request.isRequest = true
    
    
    request.setMyArcusEmail(myArcusEmail)
    
    request.setMyArcusPassword(myArcusPassword)
    
    return try sendRequest(request)
  }
  
  public func requestAccountRemoveMyArcusDiscount(_ model: AccountModel) throws -> Observable<ArcusSessionEvent> {
    let request: AccountRemoveMyArcusDiscountRequest = AccountRemoveMyArcusDiscountRequest()
    request.source = model.address
    request.isRequest = true
    
    return try sendRequest(request)
  }
  
}
