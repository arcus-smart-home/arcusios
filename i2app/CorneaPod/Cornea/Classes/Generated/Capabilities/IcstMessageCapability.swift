
//
// IcstMessageCap.swift
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
  public static var icstMessageNamespace: String = "icstmsg"
  public static var icstMessageName: String = "IcstMessage"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let icstMessageCreated: String = "icstmsg:created"
  static let icstMessageId: String = "icstmsg:id"
  static let icstMessageMessageType: String = "icstmsg:messageType"
  static let icstMessageAgent: String = "icstmsg:agent"
  static let icstMessageMessage: String = "icstmsg:message"
  static let icstMessageRecipients: String = "icstmsg:recipients"
  static let icstMessageExpiration: String = "icstmsg:expiration"
  static let icstMessageModified: String = "icstmsg:modified"
  
}

public protocol ArcusIcstMessageCapability: class, RxArcusService {
  /** The date the message was created */
  func getIcstMessageCreated(_ model: IcstMessageModel) -> Date?
  /** unique id */
  func getIcstMessageId(_ model: IcstMessageModel) -> String?
  /** The type of message (MOTD, URGENT) */
  func getIcstMessageMessageType(_ model: IcstMessageModel) -> String?
  /** The type of message (MOTD, URGENT) */
  func setIcstMessageMessageType(_ messageType: String, model: IcstMessageModel)
/** agent id that created the message */
  func getIcstMessageAgent(_ model: IcstMessageModel) -> String?
  /** The message to be shared */
  func getIcstMessageMessage(_ model: IcstMessageModel) -> String?
  /** The message to be shared */
  func setIcstMessageMessage(_ message: String, model: IcstMessageModel)
/** The set of recipients, or empty if all should see it */
  func getIcstMessageRecipients(_ model: IcstMessageModel) -> [String]?
  /** The set of recipients, or empty if all should see it */
  func setIcstMessageRecipients(_ recipients: [String], model: IcstMessageModel)
/** The date the message expires (end-of-day), empty if URGENT or MOTD expires same day it was created */
  func getIcstMessageExpiration(_ model: IcstMessageModel) -> Date?
  /** The date the message expires (end-of-day), empty if URGENT or MOTD expires same day it was created */
  func setIcstMessageExpiration(_ expiration: Date, model: IcstMessageModel)
/** The last date the interaction was modified */
  func getIcstMessageModified(_ model: IcstMessageModel) -> Date?
  
  /** Add a message */
  func requestIcstMessageCreateMessage(_  model: IcstMessageModel, id: String, messageType: String, agent: String, message: String, recipients: [String], expiration: Date)
   throws -> Observable<ArcusSessionEvent>/** Lists messages within a time range */
  func requestIcstMessageListMessagesForTimeframe(_  model: IcstMessageModel, messageType: String, agent: String, startDate: String, endDate: String, token: String, limit: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusIcstMessageCapability {
  public func getIcstMessageCreated(_ model: IcstMessageModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.icstMessageCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getIcstMessageId(_ model: IcstMessageModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstMessageId] as? String
  }
  
  public func getIcstMessageMessageType(_ model: IcstMessageModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstMessageMessageType] as? String
  }
  
  public func setIcstMessageMessageType(_ messageType: String, model: IcstMessageModel) {
    model.set([Attributes.icstMessageMessageType: messageType as AnyObject])
  }
  public func getIcstMessageAgent(_ model: IcstMessageModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstMessageAgent] as? String
  }
  
  public func getIcstMessageMessage(_ model: IcstMessageModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstMessageMessage] as? String
  }
  
  public func setIcstMessageMessage(_ message: String, model: IcstMessageModel) {
    model.set([Attributes.icstMessageMessage: message as AnyObject])
  }
  public func getIcstMessageRecipients(_ model: IcstMessageModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstMessageRecipients] as? [String]
  }
  
  public func setIcstMessageRecipients(_ recipients: [String], model: IcstMessageModel) {
    model.set([Attributes.icstMessageRecipients: recipients as AnyObject])
  }
  public func getIcstMessageExpiration(_ model: IcstMessageModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.icstMessageExpiration] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func setIcstMessageExpiration(_ expiration: Date, model: IcstMessageModel) {
    model.set([Attributes.icstMessageExpiration: expiration.millisecondsSince1970 as AnyObject])
  }
  public func getIcstMessageModified(_ model: IcstMessageModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.icstMessageModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestIcstMessageCreateMessage(_  model: IcstMessageModel, id: String, messageType: String, agent: String, message: String, recipients: [String], expiration: Date)
   throws -> Observable<ArcusSessionEvent> {
    let request: IcstMessageCreateMessageRequest = IcstMessageCreateMessageRequest()
    request.source = model.address
    
    
    
    request.setId(id)
    
    request.setMessageType(messageType)
    
    request.setAgent(agent)
    
    request.setMessage(message)
    
    request.setRecipients(recipients)
    
    request.setExpiration(expiration)
    
    return try sendRequest(request)
  }
  
  public func requestIcstMessageListMessagesForTimeframe(_  model: IcstMessageModel, messageType: String, agent: String, startDate: String, endDate: String, token: String, limit: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: IcstMessageListMessagesForTimeframeRequest = IcstMessageListMessagesForTimeframeRequest()
    request.source = model.address
    
    
    
    request.setMessageType(messageType)
    
    request.setAgent(agent)
    
    request.setStartDate(startDate)
    
    request.setEndDate(endDate)
    
    request.setToken(token)
    
    request.setLimit(limit)
    
    return try sendRequest(request)
  }
  
}
