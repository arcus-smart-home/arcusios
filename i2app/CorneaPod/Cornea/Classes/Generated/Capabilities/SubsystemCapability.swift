
//
// SubsystemCap.swift
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
  public static var subsystemNamespace: String = "subs"
  public static var subsystemName: String = "Subsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let subsystemName: String = "subs:name"
  static let subsystemVersion: String = "subs:version"
  static let subsystemHash: String = "subs:hash"
  static let subsystemAccount: String = "subs:account"
  static let subsystemPlace: String = "subs:place"
  static let subsystemAvailable: String = "subs:available"
  static let subsystemState: String = "subs:state"
  
}

public protocol ArcusSubsystemCapability: class, RxArcusService {
  /** A display name for the subsystem, generally not shown to end-users */
  func getSubsystemName(_ model: SubsystemModel) -> String?
  /** The published version of the subsystem */
  func getSubsystemVersion(_ model: SubsystemModel) -> String?
  /** A hash of the subsystem may be used to ensure the exact version that is being run */
  func getSubsystemHash(_ model: SubsystemModel) -> String?
  /** The account associated with the this subsystem. */
  func getSubsystemAccount(_ model: SubsystemModel) -> String?
  /** The place the subsystem is associated with, there may be only one instance of each subsystem per place. */
  func getSubsystemPlace(_ model: SubsystemModel) -> String?
  /** Indicates whether the subsystem is available on the current place or not. When this is false it generally means there need to be more devices added to the place. */
  func getSubsystemAvailable(_ model: SubsystemModel) -> Bool?
  /** Indicates the current state of a subsystem.  A SUSPENDED subsystem will not collect any new data or enable associated rules, but may still allow previously collected data to be viewed. */
  func getSubsystemState(_ model: SubsystemModel) -> SubsystemState?
  
  /** Puts the subsystem into an &#x27;active&#x27; state, this only applies to previously suspended subsystems, see Place#AddSubsystem(subsystemType: String) for adding new subsystems to a place. */
  func requestSubsystemActivate(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Puts the subsystem into a &#x27;suspended&#x27; state. */
  func requestSubsystemSuspend(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Removes the subsystem and all data from the associated place. */
  func requestSubsystemDelete(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the history log entries associated with this subsystem */
  func requestSubsystemListHistoryEntries(_  model: SubsystemModel, limit: Int, token: String, includeIncidents: Bool)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusSubsystemCapability {
  public func getSubsystemName(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.subsystemName] as? String
  }
  
  public func getSubsystemVersion(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.subsystemVersion] as? String
  }
  
  public func getSubsystemHash(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.subsystemHash] as? String
  }
  
  public func getSubsystemAccount(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.subsystemAccount] as? String
  }
  
  public func getSubsystemPlace(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.subsystemPlace] as? String
  }
  
  public func getSubsystemAvailable(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.subsystemAvailable] as? Bool
  }
  
  public func getSubsystemState(_ model: SubsystemModel) -> SubsystemState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.subsystemState] as? String,
      let enumAttr: SubsystemState = SubsystemState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
  public func requestSubsystemActivate(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: SubsystemActivateRequest = SubsystemActivateRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSubsystemSuspend(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: SubsystemSuspendRequest = SubsystemSuspendRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSubsystemDelete(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: SubsystemDeleteRequest = SubsystemDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSubsystemListHistoryEntries(_  model: SubsystemModel, limit: Int, token: String, includeIncidents: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: SubsystemListHistoryEntriesRequest = SubsystemListHistoryEntriesRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    request.setIncludeIncidents(includeIncidents)
    
    return try sendRequest(request)
  }
  
}
