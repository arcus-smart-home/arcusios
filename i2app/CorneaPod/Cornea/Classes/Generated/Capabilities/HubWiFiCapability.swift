
//
// HubWiFiCap.swift
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
  public static var hubWiFiNamespace: String = "hubwifi"
  public static var hubWiFiName: String = "HubWiFi"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubWiFiWifiEnabled: String = "hubwifi:wifiEnabled"
  static let hubWiFiWifiState: String = "hubwifi:wifiState"
  static let hubWiFiWifiSsid: String = "hubwifi:wifiSsid"
  static let hubWiFiWifiBssid: String = "hubwifi:wifiBssid"
  static let hubWiFiWifiSecurity: String = "hubwifi:wifiSecurity"
  static let hubWiFiWifiChannel: String = "hubwifi:wifiChannel"
  static let hubWiFiWifiNoise: String = "hubwifi:wifiNoise"
  static let hubWiFiWifiRssi: String = "hubwifi:wifiRssi"
  
}

public protocol ArcusHubWiFiCapability: class, RxArcusService {
  /** When true, wireless interface is enabled. */
  func getHubWiFiWifiEnabled(_ model: HubModel) -> Bool?
  /** When true, wireless interface is enabled. */
  func setHubWiFiWifiEnabled(_ wifiEnabled: Bool, model: HubModel)
/** Indicates whether or not this device has a WiFi connection to an access point. */
  func getHubWiFiWifiState(_ model: HubModel) -> HubWiFiWifiState?
  /** SSID of base station connected to. */
  func getHubWiFiWifiSsid(_ model: HubModel) -> String?
  /** BSSID of base station connected to. */
  func getHubWiFiWifiBssid(_ model: HubModel) -> String?
  /** Security of connection. */
  func getHubWiFiWifiSecurity(_ model: HubModel) -> HubWiFiWifiSecurity?
  /** Channel in use. */
  func getHubWiFiWifiChannel(_ model: HubModel) -> Int?
  /** Noise level in dBm */
  func getHubWiFiWifiNoise(_ model: HubModel) -> Int?
  /** Received signal stength indicator in dB. */
  func getHubWiFiWifiRssi(_ model: HubModel) -> Int?
  
  /** Attempts to connect to the access point with the given properties. */
  func requestHubWiFiWiFiConnect(_  model: HubModel, ssid: String, bssid: String, security: String, key: String)
   throws -> Observable<ArcusSessionEvent>/** Disconnects from current access point. USE WITH CAUTION. */
  func requestHubWiFiWiFiDisconnect(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
  func requestHubWiFiWiFiStartScan(_  model: HubModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent>/** Ends any active WiFiScan. If no scan is active, this is a no-op. */
  func requestHubWiFiWiFiEndScan(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubWiFiCapability {
  public func getHubWiFiWifiEnabled(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubWiFiWifiEnabled] as? Bool
  }
  
  public func setHubWiFiWifiEnabled(_ wifiEnabled: Bool, model: HubModel) {
    model.set([Attributes.hubWiFiWifiEnabled: wifiEnabled as AnyObject])
  }
  public func getHubWiFiWifiState(_ model: HubModel) -> HubWiFiWifiState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubWiFiWifiState] as? String,
      let enumAttr: HubWiFiWifiState = HubWiFiWifiState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubWiFiWifiSsid(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubWiFiWifiSsid] as? String
  }
  
  public func getHubWiFiWifiBssid(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubWiFiWifiBssid] as? String
  }
  
  public func getHubWiFiWifiSecurity(_ model: HubModel) -> HubWiFiWifiSecurity? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubWiFiWifiSecurity] as? String,
      let enumAttr: HubWiFiWifiSecurity = HubWiFiWifiSecurity(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubWiFiWifiChannel(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubWiFiWifiChannel] as? Int
  }
  
  public func getHubWiFiWifiNoise(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubWiFiWifiNoise] as? Int
  }
  
  public func getHubWiFiWifiRssi(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubWiFiWifiRssi] as? Int
  }
  
  
  public func requestHubWiFiWiFiConnect(_  model: HubModel, ssid: String, bssid: String, security: String, key: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubWiFiWiFiConnectRequest = HubWiFiWiFiConnectRequest()
    request.source = model.address
    
    
    
    request.setSsid(ssid)
    
    request.setBssid(bssid)
    
    request.setSecurity(security)
    
    request.setKey(key)
    
    return try sendRequest(request)
  }
  
  public func requestHubWiFiWiFiDisconnect(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubWiFiWiFiDisconnectRequest = HubWiFiWiFiDisconnectRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubWiFiWiFiStartScan(_  model: HubModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubWiFiWiFiStartScanRequest = HubWiFiWiFiStartScanRequest()
    request.source = model.address
    
    
    
    request.setTimeout(timeout)
    
    return try sendRequest(request)
  }
  
  public func requestHubWiFiWiFiEndScan(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubWiFiWiFiEndScanRequest = HubWiFiWiFiEndScanRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
