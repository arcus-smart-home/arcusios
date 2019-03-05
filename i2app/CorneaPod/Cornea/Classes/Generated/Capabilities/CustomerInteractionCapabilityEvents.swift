
//
// CustomerInteractionCapEvents.swift
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

// MARK: Commands
fileprivate struct Commands {
  /** Add an interaction */
  static let customerInteractionCreateInteraction: String = "suppcustinteraction:CreateInteraction"
  /** update an interaction */
  static let customerInteractionUpdateInteraction: String = "suppcustinteraction:UpdateInteraction"
  /** Lists interactions within a time range */
  static let customerInteractionListInteractions: String = "suppcustinteraction:ListInteractions"
  /** Lists interactions within a time range across accounts and places */
  static let customerInteractionListInteractionsForTimeframe: String = "suppcustinteraction:ListInteractionsForTimeframe"
  
}

// MARK: Enumerations

// MARK: Requests

/** Add an interaction */
public class CustomerInteractionCreateInteractionRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CustomerInteractionCreateInteractionRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.customerInteractionCreateInteraction
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return CustomerInteractionCreateInteractionResponse(message)
  }

  // MARK: CreateInteractionRequest Attributes
  struct Attributes {
    /** unique id */
    static let id: String = "id"
/** ID of account */
    static let account: String = "account"
/** ID of place */
    static let place: String = "place"
/** ID of customer */
    static let customer: String = "customer"
/** ID of agent */
    static let agent: String = "agent"
/** what occurred */
    static let action: String = "action"
/** agent comment */
    static let comment: String = "comment"
/** agent concessions */
    static let concessions: String = "concessions"
/** incident number */
    static let incidentNumber: String = "incidentNumber"
/** list of problem devices */
    static let problemDevices: String = "problemDevices"
 }
  
  /** unique id */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
  /** ID of account */
  public func setAccount(_ account: String) {
    attributes[Attributes.account] = account as AnyObject
  }

  
  /** ID of place */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /** ID of customer */
  public func setCustomer(_ customer: String) {
    attributes[Attributes.customer] = customer as AnyObject
  }

  
  /** ID of agent */
  public func setAgent(_ agent: String) {
    attributes[Attributes.agent] = agent as AnyObject
  }

  
  /** what occurred */
  public func setAction(_ action: String) {
    attributes[Attributes.action] = action as AnyObject
  }

  
  /** agent comment */
  public func setComment(_ comment: String) {
    attributes[Attributes.comment] = comment as AnyObject
  }

  
  /** agent concessions */
  public func setConcessions(_ concessions: String) {
    attributes[Attributes.concessions] = concessions as AnyObject
  }

  
  /** incident number */
  public func setIncidentNumber(_ incidentNumber: String) {
    attributes[Attributes.incidentNumber] = incidentNumber as AnyObject
  }

  
  /** list of problem devices */
  public func setProblemDevices(_ problemDevices: [Any]) {
    attributes[Attributes.problemDevices] = problemDevices as AnyObject
  }

  
}

public class CustomerInteractionCreateInteractionResponse: SessionEvent {
  
}

/** update an interaction */
public class CustomerInteractionUpdateInteractionRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CustomerInteractionUpdateInteractionRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.customerInteractionUpdateInteraction
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return CustomerInteractionUpdateInteractionResponse(message)
  }

  // MARK: UpdateInteractionRequest Attributes
  struct Attributes {
    /** unique id */
    static let id: String = "id"
/** ID of account */
    static let account: String = "account"
/** ID of place */
    static let place: String = "place"
/** ID of customer */
    static let customer: String = "customer"
/** ID of agent */
    static let agent: String = "agent"
/** what occurred */
    static let action: String = "action"
/** agent comment */
    static let comment: String = "comment"
/** agent concessions */
    static let concessions: String = "concessions"
/** incident number */
    static let incidentNumber: String = "incidentNumber"
/** created */
    static let created: String = "created"
 }
  
  /** unique id */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
  /** ID of account */
  public func setAccount(_ account: String) {
    attributes[Attributes.account] = account as AnyObject
  }

  
  /** ID of place */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /** ID of customer */
  public func setCustomer(_ customer: String) {
    attributes[Attributes.customer] = customer as AnyObject
  }

  
  /** ID of agent */
  public func setAgent(_ agent: String) {
    attributes[Attributes.agent] = agent as AnyObject
  }

  
  /** what occurred */
  public func setAction(_ action: String) {
    attributes[Attributes.action] = action as AnyObject
  }

  
  /** agent comment */
  public func setComment(_ comment: String) {
    attributes[Attributes.comment] = comment as AnyObject
  }

  
  /** agent concessions */
  public func setConcessions(_ concessions: String) {
    attributes[Attributes.concessions] = concessions as AnyObject
  }

  
  /** incident number */
  public func setIncidentNumber(_ incidentNumber: String) {
    attributes[Attributes.incidentNumber] = incidentNumber as AnyObject
  }

  
  /** created */
  public func setCreated(_ created: Date) {
    let created: Double = created.millisecondsSince1970
    attributes[Attributes.created] = created as AnyObject
  }

  
}

public class CustomerInteractionUpdateInteractionResponse: SessionEvent {
  
}

/** Lists interactions within a time range */
public class CustomerInteractionListInteractionsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CustomerInteractionListInteractionsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.customerInteractionListInteractions
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return CustomerInteractionListInteractionsResponse(message)
  }

  // MARK: ListInteractionsRequest Attributes
  struct Attributes {
    /** ID of account */
    static let account: String = "account"
/** ID of place */
    static let place: String = "place"
/** Earliest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
    static let startDate: String = "startDate"
/** Latest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
    static let endDate: String = "endDate"
 }
  
  /** ID of account */
  public func setAccount(_ account: String) {
    attributes[Attributes.account] = account as AnyObject
  }

  
  /** ID of place */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /** Earliest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
  public func setStartDate(_ startDate: String) {
    attributes[Attributes.startDate] = startDate as AnyObject
  }

  
  /** Latest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
  public func setEndDate(_ endDate: String) {
    attributes[Attributes.endDate] = endDate as AnyObject
  }

  
}

public class CustomerInteractionListInteractionsResponse: SessionEvent {
  
  
  /** The list of customer interactions */
  public func getInteractions() -> [Any]? {
    return self.attributes["interactions"] as? [Any]
  }
}

/** Lists interactions within a time range across accounts and places */
public class CustomerInteractionListInteractionsForTimeframeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CustomerInteractionListInteractionsForTimeframeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.customerInteractionListInteractionsForTimeframe
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return CustomerInteractionListInteractionsForTimeframeResponse(message)
  }

  // MARK: ListInteractionsForTimeframeRequest Attributes
  struct Attributes {
    /** array of actions to retrieve interactions for */
    static let filter: String = "filter"
/** Earliest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
    static let startDate: String = "startDate"
/** Latest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
    static let endDate: String = "endDate"
/** token for paging results */
    static let token: String = "token"
/** max 1000, default 50 */
    static let limit: String = "limit"
 }
  
  /** array of actions to retrieve interactions for */
  public func setFilter(_ filter: [String]) {
    attributes[Attributes.filter] = filter as AnyObject
  }

  
  /** Earliest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
  public func setStartDate(_ startDate: String) {
    attributes[Attributes.startDate] = startDate as AnyObject
  }

  
  /** Latest date for interactions. Format is yyyy-MM-dd HH:mm:ss */
  public func setEndDate(_ endDate: String) {
    attributes[Attributes.endDate] = endDate as AnyObject
  }

  
  /** token for paging results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
  /** max 1000, default 50 */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
}

public class CustomerInteractionListInteractionsForTimeframeResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The list of customer interactions */
  public func getInteractions() -> [Any]? {
    return self.attributes["interactions"] as? [Any]
  }
}

