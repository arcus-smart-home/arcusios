
//
// CustomerInteractionCap.swift
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
  public static var customerInteractionNamespace: String = "suppcustinteraction"
  public static var customerInteractionName: String = "CustomerInteraction"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let customerInteractionCreated: String = "suppcustinteraction:created"
  static let customerInteractionId: String = "suppcustinteraction:id"
  static let customerInteractionAccount: String = "suppcustinteraction:account"
  static let customerInteractionPlace: String = "suppcustinteraction:place"
  static let customerInteractionCustomer: String = "suppcustinteraction:customer"
  static let customerInteractionAgent: String = "suppcustinteraction:agent"
  static let customerInteractionAction: String = "suppcustinteraction:action"
  static let customerInteractionComment: String = "suppcustinteraction:comment"
  static let customerInteractionConcessions: String = "suppcustinteraction:concessions"
  static let customerInteractionIncidentNumber: String = "suppcustinteraction:incidentNumber"
  static let customerInteractionModified: String = "suppcustinteraction:modified"
  
}

public protocol ArcusCustomerInteractionCapability: class, RxArcusService {
  /** The date the interaction was created */
  func getCustomerInteractionCreated(_ model: CustomerInteractionModel) -> Date?
  /** unique id */
  func getCustomerInteractionId(_ model: CustomerInteractionModel) -> String?
  /** Account id of the interaction */
  func getCustomerInteractionAccount(_ model: CustomerInteractionModel) -> String?
  /** The place id of the interaction */
  func getCustomerInteractionPlace(_ model: CustomerInteractionModel) -> String?
  /** The customer of in the interaction */
  func getCustomerInteractionCustomer(_ model: CustomerInteractionModel) -> String?
  /** Id of the agent that created the interaction */
  func getCustomerInteractionAgent(_ model: CustomerInteractionModel) -> String?
  /** The action that happened */
  func getCustomerInteractionAction(_ model: CustomerInteractionModel) -> String?
  /** The action that happened */
  func setCustomerInteractionAction(_ action: String, model: CustomerInteractionModel)
/** The comment entered about the interaction */
  func getCustomerInteractionComment(_ model: CustomerInteractionModel) -> String?
  /** The comment entered about the interaction */
  func setCustomerInteractionComment(_ comment: String, model: CustomerInteractionModel)
/** The concessions that were given */
  func getCustomerInteractionConcessions(_ model: CustomerInteractionModel) -> String?
  /** The concessions that were given */
  func setCustomerInteractionConcessions(_ concessions: String, model: CustomerInteractionModel)
/** The incident number entered about the interaction */
  func getCustomerInteractionIncidentNumber(_ model: CustomerInteractionModel) -> String?
  /** The incident number entered about the interaction */
  func setCustomerInteractionIncidentNumber(_ incidentNumber: String, model: CustomerInteractionModel)
/** The last date the interaction was modified */
  func getCustomerInteractionModified(_ model: CustomerInteractionModel) -> Date?
  
  /** Add an interaction */
  func requestCustomerInteractionCreateInteraction(_  model: CustomerInteractionModel, id: String, account: String, place: String, customer: String, agent: String, action: String, comment: String, concessions: String, incidentNumber: String, problemDevices: [Any])
   throws -> Observable<ArcusSessionEvent>/** update an interaction */
  func requestCustomerInteractionUpdateInteraction(_  model: CustomerInteractionModel, id: String, account: String, place: String, customer: String, agent: String, action: String, comment: String, concessions: String, incidentNumber: String, created: Date)
   throws -> Observable<ArcusSessionEvent>/** Lists interactions within a time range */
  func requestCustomerInteractionListInteractions(_  model: CustomerInteractionModel, account: String, place: String, startDate: String, endDate: String)
   throws -> Observable<ArcusSessionEvent>/** Lists interactions within a time range across accounts and places */
  func requestCustomerInteractionListInteractionsForTimeframe(_  model: CustomerInteractionModel, filter: [String], startDate: String, endDate: String, token: String, limit: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusCustomerInteractionCapability {
  public func getCustomerInteractionCreated(_ model: CustomerInteractionModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.customerInteractionCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getCustomerInteractionId(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionId] as? String
  }
  
  public func getCustomerInteractionAccount(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionAccount] as? String
  }
  
  public func getCustomerInteractionPlace(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionPlace] as? String
  }
  
  public func getCustomerInteractionCustomer(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionCustomer] as? String
  }
  
  public func getCustomerInteractionAgent(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionAgent] as? String
  }
  
  public func getCustomerInteractionAction(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionAction] as? String
  }
  
  public func setCustomerInteractionAction(_ action: String, model: CustomerInteractionModel) {
    model.set([Attributes.customerInteractionAction: action as AnyObject])
  }
  public func getCustomerInteractionComment(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionComment] as? String
  }
  
  public func setCustomerInteractionComment(_ comment: String, model: CustomerInteractionModel) {
    model.set([Attributes.customerInteractionComment: comment as AnyObject])
  }
  public func getCustomerInteractionConcessions(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionConcessions] as? String
  }
  
  public func setCustomerInteractionConcessions(_ concessions: String, model: CustomerInteractionModel) {
    model.set([Attributes.customerInteractionConcessions: concessions as AnyObject])
  }
  public func getCustomerInteractionIncidentNumber(_ model: CustomerInteractionModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.customerInteractionIncidentNumber] as? String
  }
  
  public func setCustomerInteractionIncidentNumber(_ incidentNumber: String, model: CustomerInteractionModel) {
    model.set([Attributes.customerInteractionIncidentNumber: incidentNumber as AnyObject])
  }
  public func getCustomerInteractionModified(_ model: CustomerInteractionModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.customerInteractionModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestCustomerInteractionCreateInteraction(_  model: CustomerInteractionModel, id: String, account: String, place: String, customer: String, agent: String, action: String, comment: String, concessions: String, incidentNumber: String, problemDevices: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: CustomerInteractionCreateInteractionRequest = CustomerInteractionCreateInteractionRequest()
    request.source = model.address
    
    
    
    request.setId(id)
    
    request.setAccount(account)
    
    request.setPlace(place)
    
    request.setCustomer(customer)
    
    request.setAgent(agent)
    
    request.setAction(action)
    
    request.setComment(comment)
    
    request.setConcessions(concessions)
    
    request.setIncidentNumber(incidentNumber)
    
    request.setProblemDevices(problemDevices)
    
    return try sendRequest(request)
  }
  
  public func requestCustomerInteractionUpdateInteraction(_  model: CustomerInteractionModel, id: String, account: String, place: String, customer: String, agent: String, action: String, comment: String, concessions: String, incidentNumber: String, created: Date)
   throws -> Observable<ArcusSessionEvent> {
    let request: CustomerInteractionUpdateInteractionRequest = CustomerInteractionUpdateInteractionRequest()
    request.source = model.address
    
    
    
    request.setId(id)
    
    request.setAccount(account)
    
    request.setPlace(place)
    
    request.setCustomer(customer)
    
    request.setAgent(agent)
    
    request.setAction(action)
    
    request.setComment(comment)
    
    request.setConcessions(concessions)
    
    request.setIncidentNumber(incidentNumber)
    
    request.setCreated(created)
    
    return try sendRequest(request)
  }
  
  public func requestCustomerInteractionListInteractions(_  model: CustomerInteractionModel, account: String, place: String, startDate: String, endDate: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: CustomerInteractionListInteractionsRequest = CustomerInteractionListInteractionsRequest()
    request.source = model.address
    
    
    
    request.setAccount(account)
    
    request.setPlace(place)
    
    request.setStartDate(startDate)
    
    request.setEndDate(endDate)
    
    return try sendRequest(request)
  }
  
  public func requestCustomerInteractionListInteractionsForTimeframe(_  model: CustomerInteractionModel, filter: [String], startDate: String, endDate: String, token: String, limit: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: CustomerInteractionListInteractionsForTimeframeRequest = CustomerInteractionListInteractionsForTimeframeRequest()
    request.source = model.address
    
    
    
    request.setFilter(filter)
    
    request.setStartDate(startDate)
    
    request.setEndDate(endDate)
    
    request.setToken(token)
    
    request.setLimit(limit)
    
    return try sendRequest(request)
  }
  
}
