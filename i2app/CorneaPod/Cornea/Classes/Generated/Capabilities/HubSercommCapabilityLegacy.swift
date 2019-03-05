
//
// HubSercommCapabilityLegacy.swift
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

public class HubSercommCapabilityLegacy: NSObject, ArcusHubSercommCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubSercommCapabilityLegacy  = HubSercommCapabilityLegacy()
  

  
  public static func getNumAvailable(_ model: HubModel) -> NSNumber? {
    guard let numAvailable: Int = capability.getHubSercommNumAvailable(model) else {
      return nil
    }
    return NSNumber(value: numAvailable)
  }
  
  public static func getNumPaired(_ model: HubModel) -> NSNumber? {
    guard let numPaired: Int = capability.getHubSercommNumPaired(model) else {
      return nil
    }
    return NSNumber(value: numPaired)
  }
  
  public static func getNumNotOwned(_ model: HubModel) -> NSNumber? {
    guard let numNotOwned: Int = capability.getHubSercommNumNotOwned(model) else {
      return nil
    }
    return NSNumber(value: numNotOwned)
  }
  
  public static func getNumDisconnected(_ model: HubModel) -> NSNumber? {
    guard let numDisconnected: Int = capability.getHubSercommNumDisconnected(model) else {
      return nil
    }
    return NSNumber(value: numDisconnected)
  }
  
  public static func getCameras(_ model: HubModel) -> [String: String]? {
    return capability.getHubSercommCameras(model)
  }
  
  public static func getUsername(_ model: HubModel) -> String? {
    return capability.getHubSercommUsername(model)
  }
  
  public static func getCertHash(_ model: HubModel) -> String? {
    return capability.getHubSercommCertHash(model)
  }
  
  public static func getCameraPassword(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubSercommGetCameraPassword(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func pair(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommPair(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func reset(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommReset(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func reboot(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommReboot(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func config(_  model: HubModel, mac: String, params: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommConfig(model, mac: mac, params: params))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func upgrade(_  model: HubModel, mac: String, url: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommUpgrade(model, mac: mac, url: url))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getState(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetState(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getVersion(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetVersion(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getDayNight(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetDayNight(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getIPAddress(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetIPAddress(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getModel(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetModel(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getInfo(_  model: HubModel, mac: String, group: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetInfo(model, mac: mac, group: group))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getAttrs(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetAttrs(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func motionDetectStart(_  model: HubModel, mac: String, url: String, username: String, password: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommMotionDetectStart(model, mac: mac, url: url, username: username, password: password))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func motionDetectStop(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommMotionDetectStop(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func videoStreamStart(_  model: HubModel, mac: String, hubSercommAddress: String, username: String, password: String, duration: Int, precapture: Int, format: Int, resolution: Int, quality_type: Int, bitrate: Int, quality: Int, framerate: Int) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommVideoStreamStart(model, mac: mac, hubSercommAddress: hubSercommAddress, username: username, password: password, duration: duration, precapture: precapture, format: format, resolution: resolution, quality_type: quality_type, bitrate: bitrate, quality: quality, framerate: framerate))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func videoStreamStop(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommVideoStreamStop(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wifiScanStart(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommWifiScanStart(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wifiScanEnd(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommWifiScanEnd(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wifiConnect(_  model: HubModel, mac: String, ssid: String, security: String, key: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommWifiConnect(model, mac: mac, ssid: ssid, security: security, key: key))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wifiDisconnect(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommWifiDisconnect(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func wifiGetAttrs(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommWifiGetAttrs(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getCustomAttrs(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommGetCustomAttrs(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setCustomAttrs(_  model: HubModel, mac: String, irLedMode: String, irLedLuminance: Int, mdMode: String, mdThreshold: Int, mdSensitivity: Int, mdWindowCoordinates: String) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommSetCustomAttrs(model, mac: mac, irLedMode: irLedMode, irLedLuminance: irLedLuminance, mdMode: mdMode, mdThreshold: mdThreshold, mdSensitivity: mdSensitivity, mdWindowCoordinates: mdWindowCoordinates))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func purgeCamera(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommPurgeCamera(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func ptzGetAttrs(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommPtzGetAttrs(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func ptzGotoHome(_  model: HubModel, mac: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommPtzGotoHome(model, mac: mac))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func ptzGotoAbsolute(_  model: HubModel, mac: String, pan: Int, tilt: Int, zoom: Int) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommPtzGotoAbsolute(model, mac: mac, pan: pan, tilt: tilt, zoom: zoom))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func ptzGotoRelative(_  model: HubModel, mac: String, deltaPan: Int, deltaTilt: Int, deltaZoom: Int) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSercommPtzGotoRelative(model, mac: mac, deltaPan: deltaPan, deltaTilt: deltaTilt, deltaZoom: deltaZoom))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
