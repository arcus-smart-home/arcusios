
//
// SupportAgentLogEntryCap.swift
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
  public static var supportAgentLogEntryNamespace: String = "salogentry"
  public static var supportAgentLogEntryName: String = "SupportAgentLogEntry"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let supportAgentLogEntryCreated: String = "salogentry:created"
  static let supportAgentLogEntryAgentId: String = "salogentry:agentId"
  static let supportAgentLogEntryAccountId: String = "salogentry:accountId"
  static let supportAgentLogEntryAction: String = "salogentry:action"
  static let supportAgentLogEntryParameters: String = "salogentry:parameters"
  static let supportAgentLogEntryUserId: String = "salogentry:userId"
  static let supportAgentLogEntryPlaceId: String = "salogentry:placeId"
  static let supportAgentLogEntryDeviceId: String = "salogentry:deviceId"
  
}

public protocol ArcusSupportAgentLogEntryCapability: class, RxArcusService {
  /** The date the entry was created */
  func getSupportAgentLogEntryCreated(_ model: SupportAgentLogEntryModel) -> Date?
  /** Id of the agent */
  func getSupportAgentLogEntryAgentId(_ model: SupportAgentLogEntryModel) -> String?
  /** Account id in the log entry */
  func getSupportAgentLogEntryAccountId(_ model: SupportAgentLogEntryModel) -> String?
  /** The action that happened */
  func getSupportAgentLogEntryAction(_ model: SupportAgentLogEntryModel) -> String?
  /** The parameters used in the action */
  func getSupportAgentLogEntryParameters(_ model: SupportAgentLogEntryModel) -> [String]?
  /** Id of the user this log is associated with (if any) */
  func getSupportAgentLogEntryUserId(_ model: SupportAgentLogEntryModel) -> String?
  /** The place id in the log entry, if any */
  func getSupportAgentLogEntryPlaceId(_ model: SupportAgentLogEntryModel) -> String?
  /** The device id in the log entry, if any */
  func getSupportAgentLogEntryDeviceId(_ model: SupportAgentLogEntryModel) -> String?
  
  /** Log something an agent did */
  func requestSupportAgentLogEntryCreateAgentLogEntry(_  model: SupportAgentLogEntryModel, agentId: String, accountId: String, action: String, parameters: [String], userId: String, deviceId: String, placeId: String)
   throws -> Observable<ArcusSessionEvent>/** Lists audit logs within a time range */
  func requestSupportAgentLogEntryListAgentLogEntries(_  model: SupportAgentLogEntryModel, agentId: String, startDate: String, endDate: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusSupportAgentLogEntryCapability {
  public func getSupportAgentLogEntryCreated(_ model: SupportAgentLogEntryModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.supportAgentLogEntryCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSupportAgentLogEntryAgentId(_ model: SupportAgentLogEntryModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLogEntryAgentId] as? String
  }
  
  public func getSupportAgentLogEntryAccountId(_ model: SupportAgentLogEntryModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLogEntryAccountId] as? String
  }
  
  public func getSupportAgentLogEntryAction(_ model: SupportAgentLogEntryModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLogEntryAction] as? String
  }
  
  public func getSupportAgentLogEntryParameters(_ model: SupportAgentLogEntryModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLogEntryParameters] as? [String]
  }
  
  public func getSupportAgentLogEntryUserId(_ model: SupportAgentLogEntryModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLogEntryUserId] as? String
  }
  
  public func getSupportAgentLogEntryPlaceId(_ model: SupportAgentLogEntryModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLogEntryPlaceId] as? String
  }
  
  public func getSupportAgentLogEntryDeviceId(_ model: SupportAgentLogEntryModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.supportAgentLogEntryDeviceId] as? String
  }
  
  
  public func requestSupportAgentLogEntryCreateAgentLogEntry(_  model: SupportAgentLogEntryModel, agentId: String, accountId: String, action: String, parameters: [String], userId: String, deviceId: String, placeId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentLogEntryCreateAgentLogEntryRequest = SupportAgentLogEntryCreateAgentLogEntryRequest()
    request.source = model.address
    
    
    
    request.setAgentId(agentId)
    
    request.setAccountId(accountId)
    
    request.setAction(action)
    
    request.setParameters(parameters)
    
    request.setUserId(userId)
    
    request.setDeviceId(deviceId)
    
    request.setPlaceId(placeId)
    
    return try sendRequest(request)
  }
  
  public func requestSupportAgentLogEntryListAgentLogEntries(_  model: SupportAgentLogEntryModel, agentId: String, startDate: String, endDate: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SupportAgentLogEntryListAgentLogEntriesRequest = SupportAgentLogEntryListAgentLogEntriesRequest()
    request.source = model.address
    
    
    
    request.setAgentId(agentId)
    
    request.setStartDate(startDate)
    
    request.setEndDate(endDate)
    
    return try sendRequest(request)
  }
  
}
