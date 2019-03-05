
//
// HubZwaveCap.swift
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
  public static var hubZwaveNamespace: String = "hubzwave"
  public static var hubZwaveName: String = "HubZwave"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubZwaveHardware: String = "hubzwave:hardware"
  static let hubZwaveFirmware: String = "hubzwave:firmware"
  static let hubZwaveProtocol: String = "hubzwave:protocol"
  static let hubZwaveHomeId: String = "hubzwave:homeId"
  static let hubZwaveNumDevices: String = "hubzwave:numDevices"
  static let hubZwaveIsSecondary: String = "hubzwave:isSecondary"
  static let hubZwaveIsOnOtherNetwork: String = "hubzwave:isOnOtherNetwork"
  static let hubZwaveIsSUC: String = "hubzwave:isSUC"
  static let hubZwaveState: String = "hubzwave:state"
  static let hubZwaveUptime: String = "hubzwave:uptime"
  static let hubZwaveHealInProgress: String = "hubzwave:healInProgress"
  static let hubZwaveHealLastStart: String = "hubzwave:healLastStart"
  static let hubZwaveHealLastFinish: String = "hubzwave:healLastFinish"
  static let hubZwaveHealFinishReason: String = "hubzwave:healFinishReason"
  static let hubZwaveHealTotal: String = "hubzwave:healTotal"
  static let hubZwaveHealCompleted: String = "hubzwave:healCompleted"
  static let hubZwaveHealSuccessful: String = "hubzwave:healSuccessful"
  static let hubZwaveHealBlockingControl: String = "hubzwave:healBlockingControl"
  static let hubZwaveHealEstimatedFinish: String = "hubzwave:healEstimatedFinish"
  static let hubZwaveHealPercent: String = "hubzwave:healPercent"
  static let hubZwaveHealNextScheduled: String = "hubzwave:healNextScheduled"
  static let hubZwaveHealRecommended: String = "hubzwave:healRecommended"
  
}

public protocol ArcusHubZwaveCapability: class, RxArcusService {
  /** hardware version of the chip */
  func getHubZwaveHardware(_ model: HubZwaveModel) -> String?
  /** Current firmware version loaded on the chip. */
  func getHubZwaveFirmware(_ model: HubZwaveModel) -> String?
  /** Version of the ZDK protocol used. */
  func getHubZwaveProtocol(_ model: HubZwaveModel) -> String?
  /** Home Id of the Z-wave controller. */
  func getHubZwaveHomeId(_ model: HubZwaveModel) -> String?
  /** Number of devices currently paired to the z-wave chip. */
  func getHubZwaveNumDevices(_ model: HubZwaveModel) -> Int?
  /** If this is a secondary controller. */
  func getHubZwaveIsSecondary(_ model: HubZwaveModel) -> Bool?
  /** If this is on another network. */
  func getHubZwaveIsOnOtherNetwork(_ model: HubZwaveModel) -> Bool?
  /** If this is a SUC. */
  func getHubZwaveIsSUC(_ model: HubZwaveModel) -> Bool?
  /** Current state of the network. */
  func getHubZwaveState(_ model: HubZwaveModel) -> HubZwaveState?
  /** The amount of time since the last Z-Wave chip reset */
  func getHubZwaveUptime(_ model: HubZwaveModel) -> Int?
  /** True if the Z-Wave controller is in the process of healing the network. */
  func getHubZwaveHealInProgress(_ model: HubZwaveModel) -> Bool?
  /** Timestamp for the last time a Z-Wave network heal was started. */
  func getHubZwaveHealLastStart(_ model: HubZwaveModel) -> Date?
  /** Timestamp for the last time a Z-Wave network heal was finished. */
  func getHubZwaveHealLastFinish(_ model: HubZwaveModel) -> Date?
  /** An indication of the reason the last Z-Wave network heal was finished. */
  func getHubZwaveHealFinishReason(_ model: HubZwaveModel) -> HubZwaveHealFinishReason?
  /** The total number of nodes that an in-progress Z-Wave network heal is optimizing. */
  func getHubZwaveHealTotal(_ model: HubZwaveModel) -> Int?
  /** The number of nodes that the Z-Wave network heal has completed optimizing. */
  func getHubZwaveHealCompleted(_ model: HubZwaveModel) -> Int?
  /** The number of nodes that the Z-Wave network heal has successfully optimized. */
  func getHubZwaveHealSuccessful(_ model: HubZwaveModel) -> Int?
  /** True if the Z-Wave network heal process is currently blocking control of Z-Wave devices. */
  func getHubZwaveHealBlockingControl(_ model: HubZwaveModel) -> Bool?
  /** The estimated time that the heal will finish. */
  func getHubZwaveHealEstimatedFinish(_ model: HubZwaveModel) -> Date?
  /** The percentage complete of the Z-Wave network heal. */
  func getHubZwaveHealPercent(_ model: HubZwaveModel) -> Double?
  /** The next scheduled execution for a network heal (Java epoch mean no scheduled heal). */
  func getHubZwaveHealNextScheduled(_ model: HubZwaveModel) -> Date?
  /** True if a heal should be run on the network to restore proper operation. */
  func getHubZwaveHealRecommended(_ model: HubZwaveModel) -> Bool?
  /** True if a heal should be run on the network to restore proper operation. */
  func setHubZwaveHealRecommended(_ healRecommended: Bool, model: HubZwaveModel)

  /** Clears out the ZWave controller, effectively unpairing all devices.  Will also change the zwave chip&#x27;s home id. */
  func requestHubZwaveFactoryReset(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent>/** Perform a reset of the Z-Wave chip */
  func requestHubZwaveReset(_  model: HubZwaveModel, type: String)
   throws -> Observable<ArcusSessionEvent>/** Forces the Z-Wave chip into the primary controller role. */
  func requestHubZwaveForcePrimary(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent>/** Forces the Z-Wave chip into the secondary controller role. */
  func requestHubZwaveForceSecondary(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent>/** Get information about the current state of the network. */
  func requestHubZwaveNetworkInformation(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent>/** Performs a network wide heal of the Z-Wave network. WARNING: This interferes with normal operation of the Z-Wave controller for the duration of the healing process. */
  func requestHubZwaveHeal(_  model: HubZwaveModel, block: Bool, time: Date)
   throws -> Observable<ArcusSessionEvent>/** Cancels any Z-Wave network heal that might be in progress. */
  func requestHubZwaveCancelHeal(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent>/** Attempts to remove a zombie node from the Z-Wave chip&#x27;s node list. */
  func requestHubZwaveRemoveZombie(_  model: HubZwaveModel, node: Int)
   throws -> Observable<ArcusSessionEvent>/** Attempts to associate with a node using the given groups. */
  func requestHubZwaveAssociate(_  model: HubZwaveModel, node: Int, groups: [Int])
   throws -> Observable<ArcusSessionEvent>/** Attempts to re-assign return routes to a node. */
  func requestHubZwaveAssignReturnRoutes(_  model: HubZwaveModel, node: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubZwaveCapability {
  public func getHubZwaveHardware(_ model: HubZwaveModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHardware] as? String
  }
  
  public func getHubZwaveFirmware(_ model: HubZwaveModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveFirmware] as? String
  }
  
  public func getHubZwaveProtocol(_ model: HubZwaveModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveProtocol] as? String
  }
  
  public func getHubZwaveHomeId(_ model: HubZwaveModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHomeId] as? String
  }
  
  public func getHubZwaveNumDevices(_ model: HubZwaveModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveNumDevices] as? Int
  }
  
  public func getHubZwaveIsSecondary(_ model: HubZwaveModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveIsSecondary] as? Bool
  }
  
  public func getHubZwaveIsOnOtherNetwork(_ model: HubZwaveModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveIsOnOtherNetwork] as? Bool
  }
  
  public func getHubZwaveIsSUC(_ model: HubZwaveModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveIsSUC] as? Bool
  }
  
  public func getHubZwaveState(_ model: HubZwaveModel) -> HubZwaveState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubZwaveState] as? String,
      let enumAttr: HubZwaveState = HubZwaveState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubZwaveUptime(_ model: HubZwaveModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveUptime] as? Int
  }
  
  public func getHubZwaveHealInProgress(_ model: HubZwaveModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHealInProgress] as? Bool
  }
  
  public func getHubZwaveHealLastStart(_ model: HubZwaveModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubZwaveHealLastStart] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubZwaveHealLastFinish(_ model: HubZwaveModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubZwaveHealLastFinish] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubZwaveHealFinishReason(_ model: HubZwaveModel) -> HubZwaveHealFinishReason? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubZwaveHealFinishReason] as? String,
      let enumAttr: HubZwaveHealFinishReason = HubZwaveHealFinishReason(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubZwaveHealTotal(_ model: HubZwaveModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHealTotal] as? Int
  }
  
  public func getHubZwaveHealCompleted(_ model: HubZwaveModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHealCompleted] as? Int
  }
  
  public func getHubZwaveHealSuccessful(_ model: HubZwaveModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHealSuccessful] as? Int
  }
  
  public func getHubZwaveHealBlockingControl(_ model: HubZwaveModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHealBlockingControl] as? Bool
  }
  
  public func getHubZwaveHealEstimatedFinish(_ model: HubZwaveModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubZwaveHealEstimatedFinish] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubZwaveHealPercent(_ model: HubZwaveModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHealPercent] as? Double
  }
  
  public func getHubZwaveHealNextScheduled(_ model: HubZwaveModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubZwaveHealNextScheduled] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubZwaveHealRecommended(_ model: HubZwaveModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZwaveHealRecommended] as? Bool
  }
  
  public func setHubZwaveHealRecommended(_ healRecommended: Bool, model: HubZwaveModel) {
    model.set([Attributes.hubZwaveHealRecommended: healRecommended as AnyObject])
  }
  
  public func requestHubZwaveFactoryReset(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveFactoryResetRequest = HubZwaveFactoryResetRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveReset(_  model: HubZwaveModel, type: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveResetRequest = HubZwaveResetRequest()
    request.source = model.address
    
    
    
    request.setType(type)
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveForcePrimary(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveForcePrimaryRequest = HubZwaveForcePrimaryRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveForceSecondary(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveForceSecondaryRequest = HubZwaveForceSecondaryRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveNetworkInformation(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveNetworkInformationRequest = HubZwaveNetworkInformationRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveHeal(_  model: HubZwaveModel, block: Bool, time: Date)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveHealRequest = HubZwaveHealRequest()
    request.source = model.address
    
    
    
    request.setBlock(block)
    
    request.setTime(time)
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveCancelHeal(_ model: HubZwaveModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveCancelHealRequest = HubZwaveCancelHealRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveRemoveZombie(_  model: HubZwaveModel, node: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveRemoveZombieRequest = HubZwaveRemoveZombieRequest()
    request.source = model.address
    
    
    
    request.setNode(node)
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveAssociate(_  model: HubZwaveModel, node: Int, groups: [Int])
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveAssociateRequest = HubZwaveAssociateRequest()
    request.source = model.address
    
    
    
    request.setNode(node)
    
    request.setGroups(groups)
    
    return try sendRequest(request)
  }
  
  public func requestHubZwaveAssignReturnRoutes(_  model: HubZwaveModel, node: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZwaveAssignReturnRoutesRequest = HubZwaveAssignReturnRoutesRequest()
    request.source = model.address
    
    
    
    request.setNode(node)
    
    return try sendRequest(request)
  }
  
}
