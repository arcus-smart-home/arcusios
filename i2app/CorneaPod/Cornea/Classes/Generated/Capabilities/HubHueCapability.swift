
//
// HubHueCap.swift
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
  public static var hubHueNamespace: String = "hubhue"
  public static var hubHueName: String = "HubHue"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubHueBridgesAvailable: String = "hubhue:bridgesAvailable"
  static let hubHueBridgesPaired: String = "hubhue:bridgesPaired"
  static let hubHueLightsAvailable: String = "hubhue:lightsAvailable"
  static let hubHueLightsPaired: String = "hubhue:lightsPaired"
  
}

public protocol ArcusHubHueCapability: class, RxArcusService {
  /** Mapping of UUIDs to models of bridges that have been seen and are online but not paired */
  func getHubHueBridgesAvailable(_ model: HubModel) -> [String: String]?
  /** Mapping of UUIDs to models of birdges that have been paired */
  func getHubHueBridgesPaired(_ model: HubModel) -> [String: String]?
  /** The lights available for pairing where the key is the light&#x27;s identifier and the value is the uuid of bridge the light is behind */
  func getHubHueLightsAvailable(_ model: HubModel) -> [String: String]?
  /** The lights paired where the key is the light&#x27;s identifier and the value is the bridge the uuid of the bridge the light is behind */
  func getHubHueLightsPaired(_ model: HubModel) -> [String: String]?
  
  /** Clears the hue devices from the local memory and database on the hub. */
  func requestHubHueReset(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubHueCapability {
  public func getHubHueBridgesAvailable(_ model: HubModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubHueBridgesAvailable] as? [String: String]
  }
  
  public func getHubHueBridgesPaired(_ model: HubModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubHueBridgesPaired] as? [String: String]
  }
  
  public func getHubHueLightsAvailable(_ model: HubModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubHueLightsAvailable] as? [String: String]
  }
  
  public func getHubHueLightsPaired(_ model: HubModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubHueLightsPaired] as? [String: String]
  }
  
  
  public func requestHubHueReset(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubHueResetRequest = HubHueResetRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
