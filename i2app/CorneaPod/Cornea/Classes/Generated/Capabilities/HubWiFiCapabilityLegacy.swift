
//
// HubWiFiCapabilityLegacy.swift
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
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class HubWiFiCapabilityLegacy: NSObject, ArcusHubWiFiCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubWiFiCapabilityLegacy  = HubWiFiCapabilityLegacy()
  
  static let HubWiFiWifiStateCONNECTED: String = HubWiFiWifiState.connected.rawValue
  static let HubWiFiWifiStateDISCONNECTED: String = HubWiFiWifiState.disconnected.rawValue
  
  static let HubWiFiWifiSecurityNONE: String = HubWiFiWifiSecurity.none.rawValue
  static let HubWiFiWifiSecurityWEP: String = HubWiFiWifiSecurity.wep.rawValue
  static let HubWiFiWifiSecurityWPA_PSK: String = HubWiFiWifiSecurity.wpa_psk.rawValue
  static let HubWiFiWifiSecurityWPA2_PSK: String = HubWiFiWifiSecurity.wpa2_psk.rawValue
  static let HubWiFiWifiSecurityWPA_ENTERPRISE: String = HubWiFiWifiSecurity.wpa_enterprise.rawValue
  static let HubWiFiWifiSecurityWPA2_ENTERPRISE: String = HubWiFiWifiSecurity.wpa2_enterprise.rawValue
  

  
  public static func getWifiEnabled(_ model: HubModel) -> NSNumber? {
    guard let wifiEnabled: Bool = capability.getHubWiFiWifiEnabled(model) else {
      return nil
    }
    return NSNumber(value: wifiEnabled)
  }
  
  public static func setWifiEnabled(_ wifiEnabled: Bool, model: HubModel) {
    
    
    capability.setHubWiFiWifiEnabled(wifiEnabled, model: model)
  }
  
  public static func getWifiState(_ model: HubModel) -> String? {
    return capability.getHubWiFiWifiState(model)?.rawValue
  }
  
  public static func getWifiSsid(_ model: HubModel) -> String? {
    return capability.getHubWiFiWifiSsid(model)
  }
  
  public static func getWifiBssid(_ model: HubModel) -> String? {
    return capability.getHubWiFiWifiBssid(model)
  }
  
  public static func getWifiSecurity(_ model: HubModel) -> String? {
    return capability.getHubWiFiWifiSecurity(model)?.rawValue
  }
  
  public static func getWifiChannel(_ model: HubModel) -> NSNumber? {
    guard let wifiChannel: Int = capability.getHubWiFiWifiChannel(model) else {
      return nil
    }
    return NSNumber(value: wifiChannel)
  }
  
  public static func getWifiNoise(_ model: HubModel) -> NSNumber? {
    guard let wifiNoise: Int = capability.getHubWiFiWifiNoise(model) else {
      return nil
    }
    return NSNumber(value: wifiNoise)
  }
  
  public static func getWifiRssi(_ model: HubModel) -> NSNumber? {
    guard let wifiRssi: Int = capability.getHubWiFiWifiRssi(model) else {
      return nil
    }
    return NSNumber(value: wifiRssi)
  }
  
  public static func wiFiConnect(_  model: HubModel, ssid: String, bssid: String, security: String, key: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubWiFiWiFiConnect(model, ssid: ssid, bssid: bssid, security: security, key: key))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wiFiDisconnect(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubWiFiWiFiDisconnect(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wiFiStartScan(_  model: HubModel, timeout: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubWiFiWiFiStartScan(model, timeout: timeout))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wiFiEndScan(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubWiFiWiFiEndScan(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
