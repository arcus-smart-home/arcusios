
//
// SupportAgentCap.swift
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
  public static var supportAgentNamespace: String = "supportagent"
  public static var supportAgentName: String = "SupportAgent"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let supportAgentCreated: String = "supportagent:created"
  static let supportAgentModified: String = "supportagent:modified"
  static let supportAgentState: String = "supportagent:state"
  static let supportAgentFirstName: String = "supportagent:firstName"
  static let supportAgentLastName: String = "supportagent:lastName"
  static let supportAgentEmail: String = "supportagent:email"
  static let supportAgentEmailVerified: String = "supportagent:emailVerified"
  static let supportAgentMobileNumber: String = "supportagent:mobileNumber"
  static let supportAgentMobileVerified: String = "supportagent:mobileVerified"
  static let supportAgentSupportTier: String = "supportagent:supportTier"
  static let supportAgentCurrLocation: String = "supportagent:currLocation"
  static let supportAgentCurrLocationTimeZone: String = "supportagent:currLocationTimeZone"
  static let supportAgentMobileNotificationEndpoints: String = "supportagent:mobileNotificationEndpoints"
  static let supportAgentPreferences: String = "supportagent:preferences"
  static let supportAgentNumFailedAttempts: String = "supportagent:numFailedAttempts"
  static let supportAgentLastFailedLoginTs: String = "supportagent:lastFailedLoginTs"
  static let supportAgentLocked: String = "supportagent:locked"
  
}

public protocol ArcusSupportAgentCapability: class, RxArcusService {
  /** The date the agent was created */
  func getSupportAgentCreated(_ model: SupportAgentModel) -> Date?
  /** The date the agent was last modified */
  func getSupportAgentModified(_ model: SupportAgentModel) -> Date?
  /** The date the agent was last modified */
  func setSupportAgentModified(_ modified: Date, model: SupportAgentModel)
/** The state of the agent */
  func getSupportAgentState(_ model: SupportAgentModel) -> String?
  /** The state of the agent */
  func setSupportAgentState(_ state: String, model: SupportAgentModel)
/** First name of the agent */
  func getSupportAgentFirstName(_ model: SupportAgentModel) -> String?
  /** First name of the agent */
  func setSupportAgentFirstName(_ firstName: String, model: SupportAgentModel)
/** Last name of the agent */
  func getSupportAgentLastName(_ model: SupportAgentModel) -> String?
  /** Last name of the agent */
  func setSupportAgentLastName(_ lastName: String, model: SupportAgentModel)
/** The email address for the agent */
  func getSupportAgentEmail(_ model: SupportAgentModel) -> String?
  /** The email address for the agent */
  func setSupportAgentEmail(_ email: String, model: SupportAgentModel)
/** The date the email was verified */
  func getSupportAgentEmailVerified(_ model: SupportAgentModel) -> Date?
  /** The date the email was verified */
  func setSupportAgentEmailVerified(_ emailVerified: Date, model: SupportAgentModel)
/** The mobile phone number for the agent */
  func getSupportAgentMobileNumber(_ model: SupportAgentModel) -> String?
  /** The mobile phone number for the agent */
  func setSupportAgentMobileNumber(_ mobileNumber: String, model: SupportAgentModel)
/** The date the mobile phone number was verified */
  func getSupportAgentMobileVerified(_ model: SupportAgentModel) -> Date?
  /** The date the mobile phone number was verified */
  func setSupportAgentMobileVerified(_ mobileVerified: Date, model: SupportAgentModel)
/** The support tier for the agent */
  func getSupportAgentSupportTier(_ model: SupportAgentModel) -> String?
  /** The support tier for the agent */
  func setSupportAgentSupportTier(_ supportTier: String, model: SupportAgentModel)
/** The support center the agent belongs to */
  func getSupportAgentCurrLocation(_ model: SupportAgentModel) -> String?
  /** The support center the agent belongs to */
  func setSupportAgentCurrLocation(_ currLocation: String, model: SupportAgentModel)
/** The time zone the support center is located in */
  func getSupportAgentCurrLocationTimeZone(_ model: SupportAgentModel) -> String?
  /** The time zone the support center is located in */
  func setSupportAgentCurrLocationTimeZone(_ currLocationTimeZone: String, model: SupportAgentModel)
/** The list of mobile endpoints where notifications may be sent */
  func getSupportAgentMobileNotificationEndpoints(_ model: SupportAgentModel) -> [String]?
  /** The list of mobile endpoints where notifications may be sent */
  func setSupportAgentMobileNotificationEndpoints(_ mobileNotificationEndpoints: [String], model: SupportAgentModel)
/** maps preferences by name to value  */
  func getSupportAgentPreferences(_ model: SupportAgentModel) -> [String: String]?
  /** The number of consecutive failed login attempts. Zero after agent is unlocked. Cannot be changed by setattributes */
  func getSupportAgentNumFailedAttempts(_ model: SupportAgentModel) -> Int?
  /** The date the agent last had a failed login. Null after agent is unlocked. Cannot be changed by setattributes */
  func getSupportAgentLastFailedLoginTs(_ model: SupportAgentModel) -> Date?
  /** True if the agent is locked out from logging in. False after agent is unlocked. Cannot be changed by setattributes */
  func getSupportAgentLocked(_ model: SupportAgentModel) -> Bool?
  
  /** Lists all agents */
  func requestSupportAgentListAgents(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent>/** Create a support agent */
  func requestSupportAgentCreateSupportAgent(_  model: SupportAgentModel, email: String, firstName: String, lastName: String, supportTier: String, password: String, mobileNumber: String, currLocation: String, currLocationTimeZone: String)
   throws -> Observable<ArcusSessionEvent>/** Find a support agent by their id */
  func requestSupportAgentFindAgentById(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent>/** Find a support agent by their email address */
  func requestSupportAgentFindAgentByEmail(_  model: SupportAgentModel, email: String)
   throws -> Observable<ArcusSessionEvent>/** Removes an agent */
  func requestSupportAgentDeleteAgent(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent>/** Manually locks an agent, keeping them from logging in */
  func requestSupportAgentLockAgent(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent>/** Unlocks an agent, allowing them to login */
  func requestSupportAgentUnlockAgent(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent>/** Resets an agent&#x27;s password */
  func requestSupportAgentResetAgentPassword(_  model: SupportAgentModel, email: String, newPassword: String)
   throws -> Observable<ArcusSessionEvent>/** allows inserts and updates of user preferences */
  func requestSupportAgentEditPreferences(_  model: SupportAgentModel, email: String, prefValues: [String: String])
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusSupportAgentCapability {
  public func getSupportAgentCreated(_ model: SupportAgentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportAgentCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSupportAgentModified(_ model: SupportAgentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportAgentModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func setSupportAgentModified(_ modified: Date, model: SupportAgentModel) {
    model.set([Attributes.supportAgentModified: modified.millisecondsSince1970 as AnyObject])
  }
  public func getSupportAgentState(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentState] as? String
  }
  
  public func setSupportAgentState(_ state: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentState: state as AnyObject])
  }
  public func getSupportAgentFirstName(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentFirstName] as? String
  }
  
  public func setSupportAgentFirstName(_ firstName: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentFirstName: firstName as AnyObject])
  }
  public func getSupportAgentLastName(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLastName] as? String
  }
  
  public func setSupportAgentLastName(_ lastName: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentLastName: lastName as AnyObject])
  }
  public func getSupportAgentEmail(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentEmail] as? String
  }
  
  public func setSupportAgentEmail(_ email: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentEmail: email as AnyObject])
  }
  public func getSupportAgentEmailVerified(_ model: SupportAgentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportAgentEmailVerified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func setSupportAgentEmailVerified(_ emailVerified: Date, model: SupportAgentModel) {
    model.set([Attributes.supportAgentEmailVerified: emailVerified.millisecondsSince1970 as AnyObject])
  }
  public func getSupportAgentMobileNumber(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentMobileNumber] as? String
  }
  
  public func setSupportAgentMobileNumber(_ mobileNumber: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentMobileNumber: mobileNumber as AnyObject])
  }
  public func getSupportAgentMobileVerified(_ model: SupportAgentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportAgentMobileVerified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func setSupportAgentMobileVerified(_ mobileVerified: Date, model: SupportAgentModel) {
    model.set([Attributes.supportAgentMobileVerified: mobileVerified.millisecondsSince1970 as AnyObject])
  }
  public func getSupportAgentSupportTier(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentSupportTier] as? String
  }
  
  public func setSupportAgentSupportTier(_ supportTier: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentSupportTier: supportTier as AnyObject])
  }
  public func getSupportAgentCurrLocation(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentCurrLocation] as? String
  }
  
  public func setSupportAgentCurrLocation(_ currLocation: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentCurrLocation: currLocation as AnyObject])
  }
  public func getSupportAgentCurrLocationTimeZone(_ model: SupportAgentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentCurrLocationTimeZone] as? String
  }
  
  public func setSupportAgentCurrLocationTimeZone(_ currLocationTimeZone: String, model: SupportAgentModel) {
    model.set([Attributes.supportAgentCurrLocationTimeZone: currLocationTimeZone as AnyObject])
  }
  public func getSupportAgentMobileNotificationEndpoints(_ model: SupportAgentModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentMobileNotificationEndpoints] as? [String]
  }
  
  public func setSupportAgentMobileNotificationEndpoints(_ mobileNotificationEndpoints: [String], model: SupportAgentModel) {
    model.set([Attributes.supportAgentMobileNotificationEndpoints: mobileNotificationEndpoints as AnyObject])
  }
  public func getSupportAgentPreferences(_ model: SupportAgentModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentPreferences] as? [String: String]
  }
  
  public func getSupportAgentNumFailedAttempts(_ model: SupportAgentModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentNumFailedAttempts] as? Int
  }
  
  public func getSupportAgentLastFailedLoginTs(_ model: SupportAgentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportAgentLastFailedLoginTs] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSupportAgentLocked(_ model: SupportAgentModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLocked] as? Bool
  }
  
  
  public func requestSupportAgentListAgents(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentListAgentsRequest = SupportAgentListAgentsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentCreateSupportAgent(_  model: SupportAgentModel, email: String, firstName: String, lastName: String, supportTier: String, password: String, mobileNumber: String, currLocation: String, currLocationTimeZone: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentCreateSupportAgentRequest = SupportAgentCreateSupportAgentRequest()
    request.source = model.address
    
    
    
    request.setEmail(email)
    
    request.setFirstName(firstName)
    
    request.setLastName(lastName)
    
    request.setSupportTier(supportTier)
    
    request.setPassword(password)
    
    request.setMobileNumber(mobileNumber)
    
    request.setCurrLocation(currLocation)
    
    request.setCurrLocationTimeZone(currLocationTimeZone)
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentFindAgentById(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentFindAgentByIdRequest = SupportAgentFindAgentByIdRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentFindAgentByEmail(_  model: SupportAgentModel, email: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentFindAgentByEmailRequest = SupportAgentFindAgentByEmailRequest()
    request.source = model.address
    
    
    
    request.setEmail(email)
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentDeleteAgent(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentDeleteAgentRequest = SupportAgentDeleteAgentRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentLockAgent(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentLockAgentRequest = SupportAgentLockAgentRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentUnlockAgent(_ model: SupportAgentModel) throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentUnlockAgentRequest = SupportAgentUnlockAgentRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentResetAgentPassword(_  model: SupportAgentModel, email: String, newPassword: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentResetAgentPasswordRequest = SupportAgentResetAgentPasswordRequest()
    request.source = model.address
    
    
    
    request.setEmail(email)
    
    request.setNewPassword(newPassword)
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentEditPreferences(_  model: SupportAgentModel, email: String, prefValues: [String: String])
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentEditPreferencesRequest = SupportAgentEditPreferencesRequest()
    request.source = model.address
    
    
    
    request.setEmail(email)
    
    request.setPrefValues(prefValues)
    
    return try sendRequest(request)
  }
  
}
