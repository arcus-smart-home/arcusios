
//
// HubCap.swift
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
  public static var hubNamespace: String = "hub"
  public static var hubName: String = "Hub"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubId: String = "hub:id"
  static let hubAccount: String = "hub:account"
  static let hubPlace: String = "hub:place"
  static let hubName: String = "hub:name"
  static let hubImage: String = "hub:image"
  static let hubVendor: String = "hub:vendor"
  static let hubModel: String = "hub:model"
  static let hubState: String = "hub:state"
  static let hubRegistrationState: String = "hub:registrationState"
  static let hubTime: String = "hub:time"
  static let hubTz: String = "hub:tz"
  
}

public protocol ArcusHubCapability: class, RxArcusService {
  /** Driver-owned globally unique identifier for the hub */
  func getHubId(_ model: HubModel) -> String?
  /** Driver-owned account associated with the hub */
  func getHubAccount(_ model: HubModel) -> String?
  /** Driver-owned place where the device is currently located */
  func getHubPlace(_ model: HubModel) -> String?
  /** Human readable name for the hub */
  func getHubName(_ model: HubModel) -> String?
  /** Human readable name for the hub */
  func setHubName(_ name: String, model: HubModel)
/** Media URL to image that represents the hub */
  func getHubImage(_ model: HubModel) -> String?
  /** Media URL to image that represents the hub */
  func setHubImage(_ image: String, model: HubModel)
/** Vendor name */
  func getHubVendor(_ model: HubModel) -> String?
  /** Model name */
  func getHubModel(_ model: HubModel) -> String?
  /** State of the hub */
  func getHubState(_ model: HubModel) -> HubState?
  /** The registration state of the hub */
  func getHubRegistrationState(_ model: HubModel) -> HubRegistrationState?
  /** The current time on the hub. Milliseconds since Jan 1, 1970 (UTC). */
  func getHubTime(_ model: HubModel) -> Int?
  /** The timezone for the hub. */
  func getHubTz(_ model: HubModel) -> String?
  /** The timezone for the hub. */
  func setHubTz(_ tz: String, model: HubModel)

  /** Lists all devices associated with this account */
  func requestHubPairingRequest(_  model: HubModel, actionType: String, timeout: Int)
   throws -> Observable<ArcusSessionEvent>/** Lists all devices associated with this account */
  func requestHubUnpairingRequest(_  model: HubModel, actionType: String, timeout: Int, hubProtocol: String, protocolId: String, force: Bool)
   throws -> Observable<ArcusSessionEvent>/** Lists all hubs associated with this account */
  func requestHubListHubs(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Resets all log levels to their normal values. */
  func requestHubResetLogLevels(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Sets the log level of for the specified scope, or the root log level if no scope is specified. */
  func requestHubSetLogLevel(_  model: HubModel, level: String, scope: String)
   throws -> Observable<ArcusSessionEvent>/** Gets recent logs from the hub. */
  func requestHubGetLogs(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Starts streaming logs to the platform for the specified amount of time. */
  func requestHubStreamLogs(_  model: HubModel, duration: Int, severity: String)
   throws -> Observable<ArcusSessionEvent>/** Gets all key/value pairs describing the hub&#x27;s configuration. */
  func requestHubGetConfig(_  model: HubModel, defaults: Bool, matching: String)
   throws -> Observable<ArcusSessionEvent>/** Gets all key/value pairs describing the hub&#x27;s configuration. */
  func requestHubSetConfig(_  model: HubModel, config: [String: String])
   throws -> Observable<ArcusSessionEvent>/** Remove/Deactivate the hub. */
  func requestHubDelete(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubCapability {
  public func getHubId(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubId] as? String
  }
  
  public func getHubAccount(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAccount] as? String
  }
  
  public func getHubPlace(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubPlace] as? String
  }
  
  public func getHubName(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubName] as? String
  }
  
  public func setHubName(_ name: String, model: HubModel) {
    model.set([Attributes.hubName: name as AnyObject])
  }
  public func getHubImage(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubImage] as? String
  }
  
  public func setHubImage(_ image: String, model: HubModel) {
    model.set([Attributes.hubImage: image as AnyObject])
  }
  public func getHubVendor(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubVendor] as? String
  }
  
  public func getHubModel(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubModel] as? String
  }
  
  public func getHubState(_ model: HubModel) -> HubState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubState] as? String,
      let enumAttr: HubState = HubState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubRegistrationState(_ model: HubModel) -> HubRegistrationState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubRegistrationState] as? String,
      let enumAttr: HubRegistrationState = HubRegistrationState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubTime(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubTime] as? Int
  }
  
  public func getHubTz(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubTz] as? String
  }
  
  public func setHubTz(_ tz: String, model: HubModel) {
    model.set([Attributes.hubTz: tz as AnyObject])
  }
  
  public func requestHubPairingRequest(_  model: HubModel, actionType: String, timeout: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubPairingRequestRequest = HubPairingRequestRequest()
    request.source = model.address
    
    
    
    request.setActionType(actionType)
    
    request.setTimeout(timeout)
    
    return try sendRequest(request)
  }
  
  public func requestHubUnpairingRequest(_  model: HubModel, actionType: String, timeout: Int, hubProtocol: String, protocolId: String, force: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubUnpairingRequestRequest = HubUnpairingRequestRequest()
    request.source = model.address
    
    
    
    request.setActionType(actionType)
    
    request.setTimeout(timeout)
    
    request.setProtocol(hubProtocol)
    
    request.setProtocolId(protocolId)
    
    request.setForce(force)
    
    return try sendRequest(request)
  }
  
  public func requestHubListHubs(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubListHubsRequest = HubListHubsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubResetLogLevels(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubResetLogLevelsRequest = HubResetLogLevelsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubSetLogLevel(_  model: HubModel, level: String, scope: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSetLogLevelRequest = HubSetLogLevelRequest()
    request.source = model.address
    
    
    
    request.setLevel(level)
    
    request.setScope(scope)
    
    return try sendRequest(request)
  }
  
  public func requestHubGetLogs(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubGetLogsRequest = HubGetLogsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubStreamLogs(_  model: HubModel, duration: Int, severity: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubStreamLogsRequest = HubStreamLogsRequest()
    request.source = model.address
    
    
    
    request.setDuration(duration)
    
    request.setSeverity(severity)
    
    return try sendRequest(request)
  }
  
  public func requestHubGetConfig(_  model: HubModel, defaults: Bool, matching: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubGetConfigRequest = HubGetConfigRequest()
    request.source = model.address
    
    
    
    request.setDefaults(defaults)
    
    request.setMatching(matching)
    
    return try sendRequest(request)
  }
  
  public func requestHubSetConfig(_  model: HubModel, config: [String: String])
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSetConfigRequest = HubSetConfigRequest()
    request.source = model.address
    
    
    
    request.setConfig(config)
    
    return try sendRequest(request)
  }
  
  public func requestHubDelete(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubDeleteRequest = HubDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
