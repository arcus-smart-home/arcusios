
//
// SupportAgentCapabilityLegacy.swift
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

public class SupportAgentCapabilityLegacy: NSObject, ArcusSupportAgentCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SupportAgentCapabilityLegacy  = SupportAgentCapabilityLegacy()
  

  
  public static func getCreated(_ model: SupportAgentModel) -> Date? {
    guard let created: Date = capability.getSupportAgentCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getModified(_ model: SupportAgentModel) -> Date? {
    guard let modified: Date = capability.getSupportAgentModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func setModified(_ modified: Double, model: SupportAgentModel) {
    
    let modified: Date = Date(milliseconds: modified)
    capability.setSupportAgentModified(modified, model: model)
  }
  
  public static func getState(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentState(model)
  }
  
  public static func setState(_ state: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentState(state, model: model)
  }
  
  public static func getFirstName(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentFirstName(model)
  }
  
  public static func setFirstName(_ firstName: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentFirstName(firstName, model: model)
  }
  
  public static func getLastName(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentLastName(model)
  }
  
  public static func setLastName(_ lastName: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentLastName(lastName, model: model)
  }
  
  public static func getEmail(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentEmail(model)
  }
  
  public static func setEmail(_ email: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentEmail(email, model: model)
  }
  
  public static func getEmailVerified(_ model: SupportAgentModel) -> Date? {
    guard let emailVerified: Date = capability.getSupportAgentEmailVerified(model) else {
      return nil
    }
    return emailVerified
  }
  
  public static func setEmailVerified(_ emailVerified: Double, model: SupportAgentModel) {
    
    let emailVerified: Date = Date(milliseconds: emailVerified)
    capability.setSupportAgentEmailVerified(emailVerified, model: model)
  }
  
  public static func getMobileNumber(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentMobileNumber(model)
  }
  
  public static func setMobileNumber(_ mobileNumber: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentMobileNumber(mobileNumber, model: model)
  }
  
  public static func getMobileVerified(_ model: SupportAgentModel) -> Date? {
    guard let mobileVerified: Date = capability.getSupportAgentMobileVerified(model) else {
      return nil
    }
    return mobileVerified
  }
  
  public static func setMobileVerified(_ mobileVerified: Double, model: SupportAgentModel) {
    
    let mobileVerified: Date = Date(milliseconds: mobileVerified)
    capability.setSupportAgentMobileVerified(mobileVerified, model: model)
  }
  
  public static func getSupportTier(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentSupportTier(model)
  }
  
  public static func setSupportTier(_ supportTier: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentSupportTier(supportTier, model: model)
  }
  
  public static func getCurrLocation(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentCurrLocation(model)
  }
  
  public static func setCurrLocation(_ currLocation: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentCurrLocation(currLocation, model: model)
  }
  
  public static func getCurrLocationTimeZone(_ model: SupportAgentModel) -> String? {
    return capability.getSupportAgentCurrLocationTimeZone(model)
  }
  
  public static func setCurrLocationTimeZone(_ currLocationTimeZone: String, model: SupportAgentModel) {
    
    
    capability.setSupportAgentCurrLocationTimeZone(currLocationTimeZone, model: model)
  }
  
  public static func getMobileNotificationEndpoints(_ model: SupportAgentModel) -> [String]? {
    return capability.getSupportAgentMobileNotificationEndpoints(model)
  }
  
  public static func setMobileNotificationEndpoints(_ mobileNotificationEndpoints: [String], model: SupportAgentModel) {
    
    
    capability.setSupportAgentMobileNotificationEndpoints(mobileNotificationEndpoints, model: model)
  }
  
  public static func getPreferences(_ model: SupportAgentModel) -> [String: String]? {
    return capability.getSupportAgentPreferences(model)
  }
  
  public static func getNumFailedAttempts(_ model: SupportAgentModel) -> NSNumber? {
    guard let numFailedAttempts: Int = capability.getSupportAgentNumFailedAttempts(model) else {
      return nil
    }
    return NSNumber(value: numFailedAttempts)
  }
  
  public static func getLastFailedLoginTs(_ model: SupportAgentModel) -> Date? {
    guard let lastFailedLoginTs: Date = capability.getSupportAgentLastFailedLoginTs(model) else {
      return nil
    }
    return lastFailedLoginTs
  }
  
  public static func getLocked(_ model: SupportAgentModel) -> NSNumber? {
    guard let locked: Bool = capability.getSupportAgentLocked(model) else {
      return nil
    }
    return NSNumber(value: locked)
  }
  
  public static func listAgents(_ model: SupportAgentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSupportAgentListAgents(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func createSupportAgent(_  model: SupportAgentModel, email: String, firstName: String, lastName: String, supportTier: String, password: String, mobileNumber: String, currLocation: String, currLocationTimeZone: String) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportAgentCreateSupportAgent(model, email: email, firstName: firstName, lastName: lastName, supportTier: supportTier, password: password, mobileNumber: mobileNumber, currLocation: currLocation, currLocationTimeZone: currLocationTimeZone))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func findAgentById(_ model: SupportAgentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSupportAgentFindAgentById(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func findAgentByEmail(_  model: SupportAgentModel, email: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportAgentFindAgentByEmail(model, email: email))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func deleteAgent(_ model: SupportAgentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSupportAgentDeleteAgent(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func lockAgent(_ model: SupportAgentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSupportAgentLockAgent(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func unlockAgent(_ model: SupportAgentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSupportAgentUnlockAgent(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func resetAgentPassword(_  model: SupportAgentModel, email: String, newPassword: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportAgentResetAgentPassword(model, email: email, newPassword: newPassword))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func editPreferences(_  model: SupportAgentModel, email: String, prefValues: [String: String]) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportAgentEditPreferences(model, email: email, prefValues: prefValues))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
