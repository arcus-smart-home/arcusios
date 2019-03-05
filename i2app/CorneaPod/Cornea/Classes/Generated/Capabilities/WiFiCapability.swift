
//
// WiFiCap.swift
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
  public static var wiFiNamespace: String = "wifi"
  public static var wiFiName: String = "WiFi"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let wiFiEnabled: String = "wifi:enabled"
  static let wiFiState: String = "wifi:state"
  static let wiFiSsid: String = "wifi:ssid"
  static let wiFiBssid: String = "wifi:bssid"
  static let wiFiSecurity: String = "wifi:security"
  static let wiFiChannel: String = "wifi:channel"
  static let wiFiNoise: String = "wifi:noise"
  static let wiFiRssi: String = "wifi:rssi"
  
}

public protocol ArcusWiFiCapability: class, RxArcusService {
  /** When true, wireless interface is enabled. */
  func getWiFiEnabled(_ model: DeviceModel) -> Bool?
  /** When true, wireless interface is enabled. */
  func setWiFiEnabled(_ enabled: Bool, model: DeviceModel)
/** Indicates whether or not this device has a WiFi connection to an access point. */
  func getWiFiState(_ model: DeviceModel) -> WiFiState?
  /** SSID of base station connected to. */
  func getWiFiSsid(_ model: DeviceModel) -> String?
  /** BSSID of base station connected to. */
  func getWiFiBssid(_ model: DeviceModel) -> String?
  /** Security of connection. */
  func getWiFiSecurity(_ model: DeviceModel) -> WiFiSecurity?
  /** Channel in use. */
  func getWiFiChannel(_ model: DeviceModel) -> Int?
  /** Noise level in dBm */
  func getWiFiNoise(_ model: DeviceModel) -> Int?
  /** Received signal stength indicator in dB. */
  func getWiFiRssi(_ model: DeviceModel) -> Int?
  
  /** Attempts to connect to the access point with the given properties. */
  func requestWiFiConnect(_  model: DeviceModel, ssid: String, bssid: String, security: String, key: String)
   throws -> Observable<ArcusSessionEvent>/** Disconnects from current access point. USE WITH CAUTION. */
  func requestWiFiDisconnect(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusWiFiCapability {
  public func getWiFiEnabled(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.wiFiEnabled] as? Bool
  }
  
  public func setWiFiEnabled(_ enabled: Bool, model: DeviceModel) {
    model.set([Attributes.wiFiEnabled: enabled as AnyObject])
  }
  public func getWiFiState(_ model: DeviceModel) -> WiFiState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.wiFiState] as? String,
      let enumAttr: WiFiState = WiFiState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getWiFiSsid(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.wiFiSsid] as? String
  }
  
  public func getWiFiBssid(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.wiFiBssid] as? String
  }
  
  public func getWiFiSecurity(_ model: DeviceModel) -> WiFiSecurity? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.wiFiSecurity] as? String,
      let enumAttr: WiFiSecurity = WiFiSecurity(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getWiFiChannel(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.wiFiChannel] as? Int
  }
  
  public func getWiFiNoise(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.wiFiNoise] as? Int
  }
  
  public func getWiFiRssi(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.wiFiRssi] as? Int
  }
  
  
  public func requestWiFiConnect(_  model: DeviceModel, ssid: String, bssid: String, security: String, key: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: WiFiConnectRequest = WiFiConnectRequest()
    request.source = model.address
    
    
    
    request.setSsid(ssid)
    
    request.setBssid(bssid)
    
    request.setSecurity(security)
    
    request.setKey(key)
    
    return try sendRequest(request)
  }
  
  public func requestWiFiDisconnect(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: WiFiDisconnectRequest = WiFiDisconnectRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
