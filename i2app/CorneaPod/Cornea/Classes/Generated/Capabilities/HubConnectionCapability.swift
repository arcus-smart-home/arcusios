
//
// HubConnectionCap.swift
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
  public static var hubConnectionNamespace: String = "hubconn"
  public static var hubConnectionName: String = "HubConnection"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubConnectionState: String = "hubconn:state"
  static let hubConnectionLastchange: String = "hubconn:lastchange"
  static let hubConnectionConnQuality: String = "hubconn:connQuality"
  static let hubConnectionPingTime: String = "hubconn:pingTime"
  static let hubConnectionPingResponse: String = "hubconn:pingResponse"
  
}

public protocol ArcusHubConnectionCapability: class, RxArcusService {
  /** Determines if the connected state of the hub, if it is online or offline. */
  func getHubConnectionState(_ model: HubModel) -> HubConnectionState?
  /** Time of the last change in connect.state. */
  func getHubConnectionLastchange(_ model: HubModel) -> Date?
  /** Determines if the connected state of the hub, if it is online or offline. */
  func getHubConnectionConnQuality(_ model: HubModel) -> Int?
  /** A measure of the hub to hub bridge ping time. */
  func getHubConnectionPingTime(_ model: HubModel) -> Int?
  /** Percent number of pongs recevied for pongs sent over X period of time. */
  func getHubConnectionPingResponse(_ model: HubModel) -> Int?
  
  
}

extension ArcusHubConnectionCapability {
  public func getHubConnectionState(_ model: HubModel) -> HubConnectionState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubConnectionState] as? String,
      let enumAttr: HubConnectionState = HubConnectionState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubConnectionLastchange(_ model: HubModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubConnectionLastchange] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubConnectionConnQuality(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubConnectionConnQuality] as? Int
  }
  
  public func getHubConnectionPingTime(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubConnectionPingTime] as? Int
  }
  
  public func getHubConnectionPingResponse(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubConnectionPingResponse] as? Int
  }
  
  
}
