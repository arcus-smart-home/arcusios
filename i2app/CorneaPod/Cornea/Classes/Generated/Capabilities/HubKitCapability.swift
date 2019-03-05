
//
// HubKitCap.swift
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
  public static var hubKitNamespace: String = "hubkit"
  public static var hubKitName: String = "HubKit"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubKitType: String = "hubkit:type"
  static let hubKitKit: String = "hubkit:kit"
  static let hubKitPendingPairing: String = "hubkit:pendingPairing"
  
}

public protocol ArcusHubKitCapability: class, RxArcusService {
  /** Type of kit that this hub is a part of. */
  func getHubKitType(_ model: HubModel) -> HubKitType?
  /** List of devices in the kit with the hub. */
  func getHubKitKit(_ model: HubModel) -> [Any]?
  /** Devices that have NOT successfully paired that are part of the kit.  This is a sub-set of the hubzigbee:pendingPairing list. */
  func getHubKitPendingPairing(_ model: HubModel) -> [Any]?
  
  /** Set the kit items for the hub. */
  func requestHubKitSetKit(_  model: HubModel, type: String, devices: [Any])
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubKitCapability {
  public func getHubKitType(_ model: HubModel) -> HubKitType? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubKitType] as? String,
      let enumAttr: HubKitType = HubKitType(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubKitKit(_ model: HubModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubKitKit] as? [Any]
  }
  
  public func getHubKitPendingPairing(_ model: HubModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubKitPendingPairing] as? [Any]
  }
  
  
  public func requestHubKitSetKit(_  model: HubModel, type: String, devices: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: HubKitSetKitRequest = HubKitSetKitRequest()
    request.source = model.address
    
    
    
    request.setType(type)
    
    request.setDevices(devices)
    
    return try sendRequest(request)
  }
  
}
