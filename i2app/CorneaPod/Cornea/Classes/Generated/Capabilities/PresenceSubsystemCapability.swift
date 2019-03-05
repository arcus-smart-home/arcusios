
//
// PresenceSubsystemCap.swift
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
  public static var presenceSubsystemNamespace: String = "subspres"
  public static var presenceSubsystemName: String = "PresenceSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let presenceSubsystemOccupied: String = "subspres:occupied"
  static let presenceSubsystemOccupiedConf: String = "subspres:occupiedConf"
  static let presenceSubsystemPeopleAtHome: String = "subspres:peopleAtHome"
  static let presenceSubsystemPeopleAway: String = "subspres:peopleAway"
  static let presenceSubsystemDevicesAtHome: String = "subspres:devicesAtHome"
  static let presenceSubsystemDevicesAway: String = "subspres:devicesAway"
  static let presenceSubsystemAllDevices: String = "subspres:allDevices"
  
}

public protocol ArcusPresenceSubsystemCapability: class, RxArcusService {
  /** Estimate as to whether the home is occupied */
  func getPresenceSubsystemOccupied(_ model: SubsystemModel) -> Bool?
  /** Confidence in occupied estimate */
  func getPresenceSubsystemOccupiedConf(_ model: SubsystemModel) -> Any?
  /** Set of the addresses of people who are in this place */
  func getPresenceSubsystemPeopleAtHome(_ model: SubsystemModel) -> [String]?
  /** Set of address of people that are away from this place */
  func getPresenceSubsystemPeopleAway(_ model: SubsystemModel) -> [String]?
  /** Set of addresses of presence capable devices not associated with people in this place */
  func getPresenceSubsystemDevicesAtHome(_ model: SubsystemModel) -> [String]?
  /** Set of addresses of presence capable devices not associated with people that are away from this place */
  func getPresenceSubsystemDevicesAway(_ model: SubsystemModel) -> [String]?
  /** Set of addresses of all presence capable devices */
  func getPresenceSubsystemAllDevices(_ model: SubsystemModel) -> [String]?
  
  /** Presence analysis describes, for each person, whether the subsystem thinks the person is at home or not and how it came to that conclusion. */
  func requestPresenceSubsystemGetPresenceAnalysis(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusPresenceSubsystemCapability {
  public func getPresenceSubsystemOccupied(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presenceSubsystemOccupied] as? Bool
  }
  
  public func getPresenceSubsystemOccupiedConf(_ model: SubsystemModel) -> Any? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presenceSubsystemOccupiedConf] as? Any
  }
  
  public func getPresenceSubsystemPeopleAtHome(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presenceSubsystemPeopleAtHome] as? [String]
  }
  
  public func getPresenceSubsystemPeopleAway(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presenceSubsystemPeopleAway] as? [String]
  }
  
  public func getPresenceSubsystemDevicesAtHome(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presenceSubsystemDevicesAtHome] as? [String]
  }
  
  public func getPresenceSubsystemDevicesAway(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presenceSubsystemDevicesAway] as? [String]
  }
  
  public func getPresenceSubsystemAllDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presenceSubsystemAllDevices] as? [String]
  }
  
  
  public func requestPresenceSubsystemGetPresenceAnalysis(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PresenceSubsystemGetPresenceAnalysisRequest = PresenceSubsystemGetPresenceAnalysisRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
