
//
// WiFiCapabilityLegacy.swift
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

public class WiFiCapabilityLegacy: NSObject, ArcusWiFiCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: WiFiCapabilityLegacy  = WiFiCapabilityLegacy()
  
  static let WiFiStateCONNECTED: String = WiFiState.connected.rawValue
  static let WiFiStateDISCONNECTED: String = WiFiState.disconnected.rawValue
  
  static let WiFiSecurityNONE: String = WiFiSecurity.none.rawValue
  static let WiFiSecurityWEP: String = WiFiSecurity.wep.rawValue
  static let WiFiSecurityWPA_PSK: String = WiFiSecurity.wpa_psk.rawValue
  static let WiFiSecurityWPA2_PSK: String = WiFiSecurity.wpa2_psk.rawValue
  static let WiFiSecurityWPA_ENTERPRISE: String = WiFiSecurity.wpa_enterprise.rawValue
  static let WiFiSecurityWPA2_ENTERPRISE: String = WiFiSecurity.wpa2_enterprise.rawValue
  

  
  public static func getEnabled(_ model: DeviceModel) -> NSNumber? {
    guard let enabled: Bool = capability.getWiFiEnabled(model) else {
      return nil
    }
    return NSNumber(value: enabled)
  }
  
  public static func setEnabled(_ enabled: Bool, model: DeviceModel) {
    
    
    capability.setWiFiEnabled(enabled, model: model)
  }
  
  public static func getState(_ model: DeviceModel) -> String? {
    return capability.getWiFiState(model)?.rawValue
  }
  
  public static func getSsid(_ model: DeviceModel) -> String? {
    return capability.getWiFiSsid(model)
  }
  
  public static func getBssid(_ model: DeviceModel) -> String? {
    return capability.getWiFiBssid(model)
  }
  
  public static func getSecurity(_ model: DeviceModel) -> String? {
    return capability.getWiFiSecurity(model)?.rawValue
  }
  
  public static func getChannel(_ model: DeviceModel) -> NSNumber? {
    guard let channel: Int = capability.getWiFiChannel(model) else {
      return nil
    }
    return NSNumber(value: channel)
  }
  
  public static func getNoise(_ model: DeviceModel) -> NSNumber? {
    guard let noise: Int = capability.getWiFiNoise(model) else {
      return nil
    }
    return NSNumber(value: noise)
  }
  
  public static func getRssi(_ model: DeviceModel) -> NSNumber? {
    guard let rssi: Int = capability.getWiFiRssi(model) else {
      return nil
    }
    return NSNumber(value: rssi)
  }
  
  public static func connect(_  model: DeviceModel, ssid: String, bssid: String, security: String, key: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestWiFiConnect(model, ssid: ssid, bssid: bssid, security: security, key: key))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disconnect(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestWiFiDisconnect(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
