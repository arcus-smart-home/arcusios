
//
// HubZigbeeCap.swift
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
  public static var hubZigbeeNamespace: String = "hubzigbee"
  public static var hubZigbeeName: String = "HubZigbee"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubZigbeePanid: String = "hubzigbee:panid"
  static let hubZigbeeExtid: String = "hubzigbee:extid"
  static let hubZigbeeChannel: String = "hubzigbee:channel"
  static let hubZigbeePower: String = "hubzigbee:power"
  static let hubZigbeePowermode: String = "hubzigbee:powermode"
  static let hubZigbeeProfile: String = "hubzigbee:profile"
  static let hubZigbeeSecurity: String = "hubzigbee:security"
  static let hubZigbeeSupportednwks: String = "hubzigbee:supportednwks"
  static let hubZigbeeJoining: String = "hubzigbee:joining"
  static let hubZigbeeUpdateid: String = "hubzigbee:updateid"
  static let hubZigbeeEui64: String = "hubzigbee:eui64"
  static let hubZigbeeTceui64: String = "hubzigbee:tceui64"
  static let hubZigbeeUptime: String = "hubzigbee:uptime"
  static let hubZigbeeVersion: String = "hubzigbee:version"
  static let hubZigbeeManufacturer: String = "hubzigbee:manufacturer"
  static let hubZigbeeState: String = "hubzigbee:state"
  static let hubZigbeePendingPairing: String = "hubzigbee:pendingPairing"
  
}

public protocol ArcusHubZigbeeCapability: class, RxArcusService {
  /** The PANID in use by the Zigbee network */
  func getHubZigbeePanid(_ model: HubModel) -> Int?
  /** The extended PANID in use by the Zigbee network */
  func getHubZigbeeExtid(_ model: HubModel) -> Int?
  /** The channel in use by the Zigbee network */
  func getHubZigbeeChannel(_ model: HubModel) -> Int?
  /** The transmit power in use by the Zigbee chip */
  func getHubZigbeePower(_ model: HubModel) -> Int?
  /** The power mode used by the Zigbee chip */
  func getHubZigbeePowermode(_ model: HubModel) -> HubZigbeePowermode?
  /** The stack profile in use by the Zigbee network */
  func getHubZigbeeProfile(_ model: HubModel) -> Int?
  /** The security level in use by the Zigbee network */
  func getHubZigbeeSecurity(_ model: HubModel) -> Int?
  /** The number of supported Zigbee networks */
  func getHubZigbeeSupportednwks(_ model: HubModel) -> Int?
  /** True if the Zigbee network is allowing joins, false otherwise */
  func getHubZigbeeJoining(_ model: HubModel) -> Bool?
  /** The NWK update id in use by the Zigbee network */
  func getHubZigbeeUpdateid(_ model: HubModel) -> Int?
  /** The EUI64 of the Zigbee chip */
  func getHubZigbeeEui64(_ model: HubModel) -> Int?
  /** The EUI64 of the Zigbee network&#x27;s trust center */
  func getHubZigbeeTceui64(_ model: HubModel) -> Int?
  /** The amount of time since the last Zigbee chip reset */
  func getHubZigbeeUptime(_ model: HubModel) -> Int?
  /** The EZSP version number */
  func getHubZigbeeVersion(_ model: HubModel) -> String?
  /** The Zigbee manufacturer code of the Zigbee chip */
  func getHubZigbeeManufacturer(_ model: HubModel) -> Int?
  /** The Zigbee network state */
  func getHubZigbeeState(_ model: HubModel) -> HubZigbeeState?
  /** Devices that use link-keys/install codes that have NOT joined the network.  This is a super-set of the hubkit:pendingPairing. */
  func getHubZigbeePendingPairing(_ model: HubModel) -> [Any]?
  
  /** Perform a reset of the Zigbee chip */
  func requestHubZigbeeReset(_  model: HubModel, type: String)
   throws -> Observable<ArcusSessionEvent>/** Perform an environment scan using the Zigbee chip */
  func requestHubZigbeeScan(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Get the Zigbee chip configuration information */
  func requestHubZigbeeGetConfig(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Get the current low-level statistics tracked by the Zigbee chip */
  func requestHubZigbeeGetStats(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Get the node descriptor of a node in the Zigbee network */
  func requestHubZigbeeGetNodeDesc(_  model: HubModel, nwk: Int)
   throws -> Observable<ArcusSessionEvent>/** Get the active endpoints of a node in the Zigbee network */
  func requestHubZigbeeGetActiveEp(_  model: HubModel, nwk: Int)
   throws -> Observable<ArcusSessionEvent>/** Get the simple descriptor of a node in the Zigbee network */
  func requestHubZigbeeGetSimpleDesc(_  model: HubModel, nwk: Int, ep: Int)
   throws -> Observable<ArcusSessionEvent>/** Get the power descriptor of a node in the Zigbee network */
  func requestHubZigbeeGetPowerDesc(_  model: HubModel, nwk: Int)
   throws -> Observable<ArcusSessionEvent>/** Identify a node in the Zigbee network */
  func requestHubZigbeeIdentify(_  model: HubModel, eui64: Int, duration: Int)
   throws -> Observable<ArcusSessionEvent>/** Remove a node from the Zigbee network */
  func requestHubZigbeeRemove(_  model: HubModel, eui64: Int)
   throws -> Observable<ArcusSessionEvent>/** Factory reset the Zigbee stack, removing all paired devices in the process. */
  func requestHubZigbeeFactoryReset(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Restore the Zigbee network to an exact state. */
  func requestHubZigbeeFormNetwork(_  model: HubModel, eui64: Int, panId: Int, extPanId: Int, channel: Int, nwkkey: String, nwkfc: Int, apsfc: Int, updateid: Int)
   throws -> Observable<ArcusSessionEvent>/** Run the migration fix proceedure */
  func requestHubZigbeeFixMigration(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Get information about the current state of the network. */
  func requestHubZigbeeNetworkInformation(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Pairs a device using a pre-shared link key. */
  func requestHubZigbeePairingLinkKey(_  model: HubModel, euid: String, linkkey: String, timeout: Int)
   throws -> Observable<ArcusSessionEvent>/** Pairs a device using a pre-shared install code. */
  func requestHubZigbeePairingInstallCode(_  model: HubModel, euid: String, installcode: String, timeout: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubZigbeeCapability {
  public func getHubZigbeePanid(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeePanid] as? Int
  }
  
  public func getHubZigbeeExtid(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeExtid] as? Int
  }
  
  public func getHubZigbeeChannel(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeChannel] as? Int
  }
  
  public func getHubZigbeePower(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeePower] as? Int
  }
  
  public func getHubZigbeePowermode(_ model: HubModel) -> HubZigbeePowermode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubZigbeePowermode] as? String,
      let enumAttr: HubZigbeePowermode = HubZigbeePowermode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubZigbeeProfile(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeProfile] as? Int
  }
  
  public func getHubZigbeeSecurity(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeSecurity] as? Int
  }
  
  public func getHubZigbeeSupportednwks(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeSupportednwks] as? Int
  }
  
  public func getHubZigbeeJoining(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeJoining] as? Bool
  }
  
  public func getHubZigbeeUpdateid(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeUpdateid] as? Int
  }
  
  public func getHubZigbeeEui64(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeEui64] as? Int
  }
  
  public func getHubZigbeeTceui64(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeTceui64] as? Int
  }
  
  public func getHubZigbeeUptime(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeUptime] as? Int
  }
  
  public func getHubZigbeeVersion(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeVersion] as? String
  }
  
  public func getHubZigbeeManufacturer(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeeManufacturer] as? Int
  }
  
  public func getHubZigbeeState(_ model: HubModel) -> HubZigbeeState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubZigbeeState] as? String,
      let enumAttr: HubZigbeeState = HubZigbeeState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubZigbeePendingPairing(_ model: HubModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubZigbeePendingPairing] as? [Any]
  }
  
  
  public func requestHubZigbeeReset(_  model: HubModel, type: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeResetRequest = HubZigbeeResetRequest()
    request.source = model.address
    
    
    
    request.setType(type)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeScan(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeScanRequest = HubZigbeeScanRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeGetConfig(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeGetConfigRequest = HubZigbeeGetConfigRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeGetStats(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeGetStatsRequest = HubZigbeeGetStatsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeGetNodeDesc(_  model: HubModel, nwk: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeGetNodeDescRequest = HubZigbeeGetNodeDescRequest()
    request.source = model.address
    
    
    
    request.setNwk(nwk)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeGetActiveEp(_  model: HubModel, nwk: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeGetActiveEpRequest = HubZigbeeGetActiveEpRequest()
    request.source = model.address
    
    
    
    request.setNwk(nwk)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeGetSimpleDesc(_  model: HubModel, nwk: Int, ep: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeGetSimpleDescRequest = HubZigbeeGetSimpleDescRequest()
    request.source = model.address
    
    
    
    request.setNwk(nwk)
    
    request.setEp(ep)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeGetPowerDesc(_  model: HubModel, nwk: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeGetPowerDescRequest = HubZigbeeGetPowerDescRequest()
    request.source = model.address
    
    
    
    request.setNwk(nwk)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeIdentify(_  model: HubModel, eui64: Int, duration: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeIdentifyRequest = HubZigbeeIdentifyRequest()
    request.source = model.address
    
    
    
    request.setEui64(eui64)
    
    request.setDuration(duration)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeRemove(_  model: HubModel, eui64: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeRemoveRequest = HubZigbeeRemoveRequest()
    request.source = model.address
    
    
    
    request.setEui64(eui64)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeFactoryReset(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeFactoryResetRequest = HubZigbeeFactoryResetRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeFormNetwork(_  model: HubModel, eui64: Int, panId: Int, extPanId: Int, channel: Int, nwkkey: String, nwkfc: Int, apsfc: Int, updateid: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeFormNetworkRequest = HubZigbeeFormNetworkRequest()
    request.source = model.address
    
    
    
    request.setEui64(eui64)
    
    request.setPanId(panId)
    
    request.setExtPanId(extPanId)
    
    request.setChannel(channel)
    
    request.setNwkkey(nwkkey)
    
    request.setNwkfc(nwkfc)
    
    request.setApsfc(apsfc)
    
    request.setUpdateid(updateid)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeFixMigration(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeFixMigrationRequest = HubZigbeeFixMigrationRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeeNetworkInformation(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeeNetworkInformationRequest = HubZigbeeNetworkInformationRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeePairingLinkKey(_  model: HubModel, euid: String, linkkey: String, timeout: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeePairingLinkKeyRequest = HubZigbeePairingLinkKeyRequest()
    request.source = model.address
    
    
    
    request.setEuid(euid)
    
    request.setLinkkey(linkkey)
    
    request.setTimeout(timeout)
    
    return try sendRequest(request)
  }
  
  public func requestHubZigbeePairingInstallCode(_  model: HubModel, euid: String, installcode: String, timeout: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubZigbeePairingInstallCodeRequest = HubZigbeePairingInstallCodeRequest()
    request.source = model.address
    
    
    
    request.setEuid(euid)
    
    request.setInstallcode(installcode)
    
    request.setTimeout(timeout)
    
    return try sendRequest(request)
  }
  
}
