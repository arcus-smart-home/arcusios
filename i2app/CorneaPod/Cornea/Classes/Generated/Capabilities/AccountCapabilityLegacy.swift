
//
// AccountCapabilityLegacy.swift
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

public class AccountCapabilityLegacy: NSObject, ArcusAccountCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: AccountCapabilityLegacy  = AccountCapabilityLegacy()
  

  
  public static func getState(_ model: AccountModel) -> String? {
    return capability.getAccountState(model)
  }
  
  public static func setState(_ state: String, model: AccountModel) {
    
    
    capability.setAccountState(state, model: model)
  }
  
  public static func getTaxExempt(_ model: AccountModel) -> NSNumber? {
    guard let taxExempt: Bool = capability.getAccountTaxExempt(model) else {
      return nil
    }
    return NSNumber(value: taxExempt)
  }
  
  public static func getBillingFirstName(_ model: AccountModel) -> String? {
    return capability.getAccountBillingFirstName(model)
  }
  
  public static func getBillingLastName(_ model: AccountModel) -> String? {
    return capability.getAccountBillingLastName(model)
  }
  
  public static func getBillingCCType(_ model: AccountModel) -> String? {
    return capability.getAccountBillingCCType(model)
  }
  
  public static func getBillingCCLast4(_ model: AccountModel) -> String? {
    return capability.getAccountBillingCCLast4(model)
  }
  
  public static func getBillingStreet1(_ model: AccountModel) -> String? {
    return capability.getAccountBillingStreet1(model)
  }
  
  public static func getBillingStreet2(_ model: AccountModel) -> String? {
    return capability.getAccountBillingStreet2(model)
  }
  
  public static func getBillingCity(_ model: AccountModel) -> String? {
    return capability.getAccountBillingCity(model)
  }
  
  public static func getBillingState(_ model: AccountModel) -> String? {
    return capability.getAccountBillingState(model)
  }
  
  public static func getBillingZip(_ model: AccountModel) -> String? {
    return capability.getAccountBillingZip(model)
  }
  
  public static func getBillingZipPlusFour(_ model: AccountModel) -> String? {
    return capability.getAccountBillingZipPlusFour(model)
  }
  
  public static func getOwner(_ model: AccountModel) -> String? {
    return capability.getAccountOwner(model)
  }
  
  public static func getMyArcusEmail(_ model: AccountModel) -> String? {
    return capability.getAccountMyArcusEmail(model)
  }
  
  public static func getCreated(_ model: AccountModel) -> Date? {
    guard let created: Date = capability.getAccountCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getModified(_ model: AccountModel) -> Date? {
    guard let modified: Date = capability.getAccountModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func listDevices(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountListDevices(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHubs(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountListHubs(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listPlaces(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountListPlaces(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listInvoices(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountListInvoices(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listAdjustments(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountListAdjustments(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func signupTransition(_  model: AccountModel, stepcompleted: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountSignupTransition(model, stepcompleted: stepcompleted))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateBillingInfoCC(_  model: AccountModel, billingToken: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountUpdateBillingInfoCC(model, billingToken: billingToken))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func skipPremiumTrial(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountSkipPremiumTrial(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func createBillingAccount(_  model: AccountModel, billingToken: String, placeID: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountCreateBillingAccount(model, billingToken: billingToken, placeID: placeID))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateServicePlan(_  model: AccountModel, placeID: String, serviceLevel: String, addons: Any) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountUpdateServicePlan(model, placeID: placeID, serviceLevel: serviceLevel, addons: addons))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func addPlace(_  model: AccountModel, place: Any, population: String, serviceLevel: String, addons: Any) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountAddPlace(model, place: place, population: population, serviceLevel: serviceLevel, addons: addons))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_  model: AccountModel, deleteOwnerLogin: Bool) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountDelete(model, deleteOwnerLogin: deleteOwnerLogin))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delinquentAccountEvent(_  model: AccountModel, accountId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountDelinquentAccountEvent(model, accountId: accountId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func issueCredit(_  model: AccountModel, amountInCents: String, description: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountIssueCredit(model, amountInCents: amountInCents, description: description))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func issueInvoiceRefund(_  model: AccountModel, invoiceNumber: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountIssueInvoiceRefund(model, invoiceNumber: invoiceNumber))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func activate(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountActivate(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func applyMyArcusDiscount(_  model: AccountModel, myArcusEmail: String, myArcusPassword: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAccountApplyMyArcusDiscount(model, myArcusEmail: myArcusEmail, myArcusPassword: myArcusPassword))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func removeMyArcusDiscount(_ model: AccountModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAccountRemoveMyArcusDiscount(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
