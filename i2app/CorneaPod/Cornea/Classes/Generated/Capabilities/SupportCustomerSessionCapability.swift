
//
// SupportCustomerSessionCap.swift
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
  public static var supportCustomerSessionNamespace: String = "suppcustsession"
  public static var supportCustomerSessionName: String = "SupportCustomerSession"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let supportCustomerSessionCreated: String = "suppcustsession:created"
  static let supportCustomerSessionModified: String = "suppcustsession:modified"
  static let supportCustomerSessionEnd: String = "suppcustsession:end"
  static let supportCustomerSessionAgent: String = "suppcustsession:agent"
  static let supportCustomerSessionAccount: String = "suppcustsession:account"
  static let supportCustomerSessionCaller: String = "suppcustsession:caller"
  static let supportCustomerSessionOrigin: String = "suppcustsession:origin"
  static let supportCustomerSessionUrl: String = "suppcustsession:url"
  static let supportCustomerSessionPlace: String = "suppcustsession:place"
  static let supportCustomerSessionNotes: String = "suppcustsession:notes"
  
}

public protocol ArcusSupportCustomerSessionCapability: class, RxArcusService {
  /** The date the session was started */
  func getSupportCustomerSessionCreated(_ model: SupportCustomerSessionModel) -> Date?
  /** The date the session was last updated */
  func getSupportCustomerSessionModified(_ model: SupportCustomerSessionModel) -> Date?
  /** The date the session was closed */
  func getSupportCustomerSessionEnd(_ model: SupportCustomerSessionModel) -> Date?
  /** The id of the agent */
  func getSupportCustomerSessionAgent(_ model: SupportCustomerSessionModel) -> String?
  /** The id of the account */
  func getSupportCustomerSessionAccount(_ model: SupportCustomerSessionModel) -> String?
  /** The id of the caller */
  func getSupportCustomerSessionCaller(_ model: SupportCustomerSessionModel) -> String?
  /** What started this session */
  func getSupportCustomerSessionOrigin(_ model: SupportCustomerSessionModel) -> String?
  /** The last known URL for the session. */
  func getSupportCustomerSessionUrl(_ model: SupportCustomerSessionModel) -> String?
  /** The last known URL for the session. */
  func setSupportCustomerSessionUrl(_ url: String, model: SupportCustomerSessionModel)
/** The current place in the session */
  func getSupportCustomerSessionPlace(_ model: SupportCustomerSessionModel) -> String?
  /** The current place in the session */
  func setSupportCustomerSessionPlace(_ place: String, model: SupportCustomerSessionModel)
/** Notes taken by the agent during the session */
  func getSupportCustomerSessionNotes(_ model: SupportCustomerSessionModel) -> [String]?
  /** Notes taken by the agent during the session */
  func setSupportCustomerSessionNotes(_ notes: [String], model: SupportCustomerSessionModel)

  /** Create a support customer session */
  func requestSupportCustomerSessionStartSession(_  model: SupportCustomerSessionModel, agent: String, account: String, caller: String, origin: String)
   throws -> Observable<ArcusSessionEvent>/** Find the active support customer session (if any) by account id and agent id */
  func requestSupportCustomerSessionFindActiveSession(_  model: SupportCustomerSessionModel, agent: String, account: String)
   throws -> Observable<ArcusSessionEvent>/** Find all support customer sessions for an account (active and closed) by account id */
  func requestSupportCustomerSessionListSessions(_  model: SupportCustomerSessionModel, account: String)
   throws -> Observable<ArcusSessionEvent>/** Closes a session */
  func requestSupportCustomerSessionCloseSession(_ model: SupportCustomerSessionModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSupportCustomerSessionCapability {
  public func getSupportCustomerSessionCreated(_ model: SupportCustomerSessionModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportCustomerSessionCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSupportCustomerSessionModified(_ model: SupportCustomerSessionModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportCustomerSessionModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSupportCustomerSessionEnd(_ model: SupportCustomerSessionModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportCustomerSessionEnd] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSupportCustomerSessionAgent(_ model: SupportCustomerSessionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportCustomerSessionAgent] as? String
  }
  
  public func getSupportCustomerSessionAccount(_ model: SupportCustomerSessionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportCustomerSessionAccount] as? String
  }
  
  public func getSupportCustomerSessionCaller(_ model: SupportCustomerSessionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportCustomerSessionCaller] as? String
  }
  
  public func getSupportCustomerSessionOrigin(_ model: SupportCustomerSessionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportCustomerSessionOrigin] as? String
  }
  
  public func getSupportCustomerSessionUrl(_ model: SupportCustomerSessionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportCustomerSessionUrl] as? String
  }
  
  public func setSupportCustomerSessionUrl(_ url: String, model: SupportCustomerSessionModel) {
    model.set([Attributes.supportCustomerSessionUrl: url as AnyObject])
  }
  public func getSupportCustomerSessionPlace(_ model: SupportCustomerSessionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportCustomerSessionPlace] as? String
  }
  
  public func setSupportCustomerSessionPlace(_ place: String, model: SupportCustomerSessionModel) {
    model.set([Attributes.supportCustomerSessionPlace: place as AnyObject])
  }
  public func getSupportCustomerSessionNotes(_ model: SupportCustomerSessionModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportCustomerSessionNotes] as? [String]
  }
  
  public func setSupportCustomerSessionNotes(_ notes: [String], model: SupportCustomerSessionModel) {
    model.set([Attributes.supportCustomerSessionNotes: notes as AnyObject])
  }
  
  public func requestSupportCustomerSessionStartSession(_  model: SupportCustomerSessionModel, agent: String, account: String, caller: String, origin: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportCustomerSessionStartSessionRequest = SupportCustomerSessionStartSessionRequest()
    request.source = model.address
    
    
    
    request.setAgent(agent)
    
    request.setAccount(account)
    
    request.setCaller(caller)
    
    request.setOrigin(origin)
    
    return try sendRequest(request)
  }
  
  public func requestSupportCustomerSessionFindActiveSession(_  model: SupportCustomerSessionModel, agent: String, account: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportCustomerSessionFindActiveSessionRequest = SupportCustomerSessionFindActiveSessionRequest()
    request.source = model.address
    
    
    
    request.setAgent(agent)
    
    request.setAccount(account)
    
    return try sendRequest(request)
  }
  
  public func requestSupportCustomerSessionListSessions(_  model: SupportCustomerSessionModel, account: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportCustomerSessionListSessionsRequest = SupportCustomerSessionListSessionsRequest()
    request.source = model.address
    
    
    
    request.setAccount(account)
    
    return try sendRequest(request)
  }
  
  public func requestSupportCustomerSessionCloseSession(_ model: SupportCustomerSessionModel) throws -> Observable<ArcusSessionEvent> {
    let request: SupportCustomerSessionCloseSessionRequest = SupportCustomerSessionCloseSessionRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
