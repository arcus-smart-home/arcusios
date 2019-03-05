
//
// BridgeCap.swift
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
  public static var bridgeNamespace: String = "bridge"
  public static var bridgeName: String = "Bridge"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let bridgePairedDevices: String = "bridge:pairedDevices"
  static let bridgeUnpairedDevices: String = "bridge:unpairedDevices"
  static let bridgePairingState: String = "bridge:pairingState"
  static let bridgeNumDevicesSupported: String = "bridge:numDevicesSupported"
  
}

public protocol ArcusBridgeCapability: class, RxArcusService {
  /** Map from bridge-owned device identifier to the protocol address of paired children devices */
  func getBridgePairedDevices(_ model: DeviceModel) -> [String: String]?
  /** Set of bridge-owned device identifiers that have been seen but not paired. */
  func getBridgeUnpairedDevices(_ model: DeviceModel) -> [String]?
  /** The current pairing state of the bridge device.  PAIRING indicates that any new devices seen will be paired, UNPAIRING that devices are being removed and IDLE means neither */
  func getBridgePairingState(_ model: DeviceModel) -> BridgePairingState?
  /** Total number of devices this bridge can support. */
  func getBridgeNumDevicesSupported(_ model: DeviceModel) -> Int?
  
  /** Puts bridge into pairing mode for timeout seconds.  Any devices seen while not in pairing mode will be immediately paired as well as any new devices discovered within the timeout period */
  func requestBridgeStartPairing(_  model: DeviceModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent>/** Removes the bridge from pairing mode. */
  func requestBridgeStopPairing(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusBridgeCapability {
  public func getBridgePairedDevices(_ model: DeviceModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.bridgePairedDevices] as? [String: String]
  }
  
  public func getBridgeUnpairedDevices(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.bridgeUnpairedDevices] as? [String]
  }
  
  public func getBridgePairingState(_ model: DeviceModel) -> BridgePairingState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.bridgePairingState] as? String,
      let enumAttr: BridgePairingState = BridgePairingState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getBridgeNumDevicesSupported(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.bridgeNumDevicesSupported] as? Int
  }
  
  
  public func requestBridgeStartPairing(_  model: DeviceModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: BridgeStartPairingRequest = BridgeStartPairingRequest()
    request.source = model.address
    
    
    
    request.setTimeout(timeout)
    
    return try sendRequest(request)
  }
  
  public func requestBridgeStopPairing(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: BridgeStopPairingRequest = BridgeStopPairingRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
