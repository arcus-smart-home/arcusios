
//
// HubNetworkCap.swift
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
  public static var hubNetworkNamespace: String = "hubnet"
  public static var hubNetworkName: String = "HubNetwork"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubNetworkType: String = "hubnet:type"
  static let hubNetworkUptime: String = "hubnet:uptime"
  static let hubNetworkIp: String = "hubnet:ip"
  static let hubNetworkExternalip: String = "hubnet:externalip"
  static let hubNetworkNetmask: String = "hubnet:netmask"
  static let hubNetworkGateway: String = "hubnet:gateway"
  static let hubNetworkDns: String = "hubnet:dns"
  static let hubNetworkInterfaces: String = "hubnet:interfaces"
  
}

public protocol ArcusHubNetworkCapability: class, RxArcusService {
  /** Name of the primary network interface. */
  func getHubNetworkType(_ model: HubModel) -> HubNetworkType?
  /** Elapsed second since last change of the active interface type. */
  func getHubNetworkUptime(_ model: HubModel) -> Int?
  /** ip address of the active interface */
  func getHubNetworkIp(_ model: HubModel) -> String?
  /** External ip address of the active interface as detected by the hub bridge. */
  func getHubNetworkExternalip(_ model: HubModel) -> String?
  /** netmask of the gateway */
  func getHubNetworkNetmask(_ model: HubModel) -> String?
  /** IP Address gateway */
  func getHubNetworkGateway(_ model: HubModel) -> String?
  /** CSV of the DNS server IP Addresses. */
  func getHubNetworkDns(_ model: HubModel) -> String?
  /** ip address of the active interface */
  func getHubNetworkInterfaces(_ model: HubModel) -> [String]?
  
  /** Gets the routing table for the active netowrk interface. */
  func requestHubNetworkGetRoutingTable(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubNetworkCapability {
  public func getHubNetworkType(_ model: HubModel) -> HubNetworkType? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubNetworkType] as? String,
      let enumAttr: HubNetworkType = HubNetworkType(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubNetworkUptime(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubNetworkUptime] as? Int
  }
  
  public func getHubNetworkIp(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubNetworkIp] as? String
  }
  
  public func getHubNetworkExternalip(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubNetworkExternalip] as? String
  }
  
  public func getHubNetworkNetmask(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubNetworkNetmask] as? String
  }
  
  public func getHubNetworkGateway(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubNetworkGateway] as? String
  }
  
  public func getHubNetworkDns(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubNetworkDns] as? String
  }
  
  public func getHubNetworkInterfaces(_ model: HubModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubNetworkInterfaces] as? [String]
  }
  
  
  public func requestHubNetworkGetRoutingTable(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubNetworkGetRoutingTableRequest = HubNetworkGetRoutingTableRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
