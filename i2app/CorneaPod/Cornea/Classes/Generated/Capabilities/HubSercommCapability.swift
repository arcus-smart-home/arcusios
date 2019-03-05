
//
// HubSercommCap.swift
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
  public static var hubSercommNamespace: String = "hubsercomm"
  public static var hubSercommName: String = "HubSercomm"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubSercommNumAvailable: String = "hubsercomm:numAvailable"
  static let hubSercommNumPaired: String = "hubsercomm:numPaired"
  static let hubSercommNumNotOwned: String = "hubsercomm:numNotOwned"
  static let hubSercommNumDisconnected: String = "hubsercomm:numDisconnected"
  static let hubSercommCameras: String = "hubsercomm:cameras"
  static let hubSercommUsername: String = "hubsercomm:username"
  static let hubSercommCertHash: String = "hubsercomm:certHash"
  
}

public protocol ArcusHubSercommCapability: class, RxArcusService {
  /** Number of cameras available for pairing */
  func getHubSercommNumAvailable(_ model: HubModel) -> Int?
  /** Number of cameras paired to the hub */
  func getHubSercommNumPaired(_ model: HubModel) -> Int?
  /** Number of cameras paired to other hubs */
  func getHubSercommNumNotOwned(_ model: HubModel) -> Int?
  /** Number of cameras that are no longer connected */
  func getHubSercommNumDisconnected(_ model: HubModel) -> Int?
  /** List of cameras (by MAC address) with current mode */
  func getHubSercommCameras(_ model: HubModel) -> [String: String]?
  /** Per-hub camera username */
  func getHubSercommUsername(_ model: HubModel) -> String?
  /** Per-hub camera certificate hash value */
  func getHubSercommCertHash(_ model: HubModel) -> String?
  
  /** Get camera password for hub */
  func requestHubSercommGetCameraPassword(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Pair a camera to the hub */
  func requestHubSercommPair(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Reset a camera back to factory defaults */
  func requestHubSercommReset(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Reboot a camera */
  func requestHubSercommReboot(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Configure a camera */
  func requestHubSercommConfig(_  model: HubModel, mac: String, params: String)
   throws -> Observable<ArcusSessionEvent>/** Upgrade firmware on camera */
  func requestHubSercommUpgrade(_  model: HubModel, mac: String, url: String)
   throws -> Observable<ArcusSessionEvent>/** Get current state of camera */
  func requestHubSercommGetState(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get current firmware version on camera */
  func requestHubSercommGetVersion(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get current day/night setting of camera */
  func requestHubSercommGetDayNight(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get IPv4 address of camera */
  func requestHubSercommGetIPAddress(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get model of camera */
  func requestHubSercommGetModel(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get camera information and configuration */
  func requestHubSercommGetInfo(_  model: HubModel, mac: String, group: String)
   throws -> Observable<ArcusSessionEvent>/** Get camera attributes */
  func requestHubSercommGetAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Start motion detection on camera. */
  func requestHubSercommMotionDetectStart(_  model: HubModel, mac: String, url: String, username: String, password: String)
   throws -> Observable<ArcusSessionEvent>/** Stop motion detection on a camera. */
  func requestHubSercommMotionDetectStop(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Start video streaming on camera. */
  func requestHubSercommVideoStreamStart(_  model: HubModel, mac: String, hubSercommAddress: String, username: String, password: String, duration: Int, precapture: Int, format: Int, resolution: Int, quality_type: Int, bitrate: Int, quality: Int, framerate: Int)
   throws -> Observable<ArcusSessionEvent>/** Stop video streaming on a camera. */
  func requestHubSercommVideoStreamStop(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Start scan for wireless access points */
  func requestHubSercommWifiScanStart(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** End scan for wireless access points */
  func requestHubSercommWifiScanEnd(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Connect to a wireless network */
  func requestHubSercommWifiConnect(_  model: HubModel, mac: String, ssid: String, security: String, key: String)
   throws -> Observable<ArcusSessionEvent>/** Disconnect from a wireless network. */
  func requestHubSercommWifiDisconnect(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get current wireless attributes */
  func requestHubSercommWifiGetAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get camera custom attributes */
  func requestHubSercommGetCustomAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Set camera custom attributes */
  func requestHubSercommSetCustomAttrs(_  model: HubModel, mac: String, irLedMode: String, irLedLuminance: Int, mdMode: String, mdThreshold: Int, mdSensitivity: Int, mdWindowCoordinates: String)
   throws -> Observable<ArcusSessionEvent>/** Remove camera from database, remove if necessary */
  func requestHubSercommPurgeCamera(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Get camera Pan/Tilt/Zoom attributes */
  func requestHubSercommPtzGetAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Move camera to home position */
  func requestHubSercommPtzGotoHome(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent>/** Move camera to absolute position */
  func requestHubSercommPtzGotoAbsolute(_  model: HubModel, mac: String, pan: Int, tilt: Int, zoom: Int)
   throws -> Observable<ArcusSessionEvent>/** Move camera to relative position */
  func requestHubSercommPtzGotoRelative(_  model: HubModel, mac: String, deltaPan: Int, deltaTilt: Int, deltaZoom: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubSercommCapability {
  public func getHubSercommNumAvailable(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSercommNumAvailable] as? Int
  }
  
  public func getHubSercommNumPaired(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSercommNumPaired] as? Int
  }
  
  public func getHubSercommNumNotOwned(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSercommNumNotOwned] as? Int
  }
  
  public func getHubSercommNumDisconnected(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSercommNumDisconnected] as? Int
  }
  
  public func getHubSercommCameras(_ model: HubModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSercommCameras] as? [String: String]
  }
  
  public func getHubSercommUsername(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSercommUsername] as? String
  }
  
  public func getHubSercommCertHash(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSercommCertHash] as? String
  }
  
  
  public func requestHubSercommGetCameraPassword(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetCameraPasswordRequest = HubSercommGetCameraPasswordRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommPair(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommPairRequest = HubSercommPairRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommReset(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommResetRequest = HubSercommResetRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommReboot(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommRebootRequest = HubSercommRebootRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommConfig(_  model: HubModel, mac: String, params: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommConfigRequest = HubSercommConfigRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setParams(params)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommUpgrade(_  model: HubModel, mac: String, url: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommUpgradeRequest = HubSercommUpgradeRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setUrl(url)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetState(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetStateRequest = HubSercommGetStateRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetVersion(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetVersionRequest = HubSercommGetVersionRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetDayNight(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetDayNightRequest = HubSercommGetDayNightRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetIPAddress(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetIPAddressRequest = HubSercommGetIPAddressRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetModel(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetModelRequest = HubSercommGetModelRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetInfo(_  model: HubModel, mac: String, group: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetInfoRequest = HubSercommGetInfoRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setGroup(group)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetAttrsRequest = HubSercommGetAttrsRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommMotionDetectStart(_  model: HubModel, mac: String, url: String, username: String, password: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommMotionDetectStartRequest = HubSercommMotionDetectStartRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setUrl(url)
    
    request.setUsername(username)
    
    request.setPassword(password)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommMotionDetectStop(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommMotionDetectStopRequest = HubSercommMotionDetectStopRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommVideoStreamStart(_  model: HubModel, mac: String, hubSercommAddress: String, username: String, password: String, duration: Int, precapture: Int, format: Int, resolution: Int, quality_type: Int, bitrate: Int, quality: Int, framerate: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommVideoStreamStartRequest = HubSercommVideoStreamStartRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setAddress(hubSercommAddress)
    
    request.setUsername(username)
    
    request.setPassword(password)
    
    request.setDuration(duration)
    
    request.setPrecapture(precapture)
    
    request.setFormat(format)
    
    request.setResolution(resolution)
    
    request.setQuality_type(quality_type)
    
    request.setBitrate(bitrate)
    
    request.setQuality(quality)
    
    request.setFramerate(framerate)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommVideoStreamStop(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommVideoStreamStopRequest = HubSercommVideoStreamStopRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommWifiScanStart(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommWifiScanStartRequest = HubSercommWifiScanStartRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommWifiScanEnd(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommWifiScanEndRequest = HubSercommWifiScanEndRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommWifiConnect(_  model: HubModel, mac: String, ssid: String, security: String, key: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommWifiConnectRequest = HubSercommWifiConnectRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setSsid(ssid)
    
    request.setSecurity(security)
    
    request.setKey(key)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommWifiDisconnect(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommWifiDisconnectRequest = HubSercommWifiDisconnectRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommWifiGetAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommWifiGetAttrsRequest = HubSercommWifiGetAttrsRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommGetCustomAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommGetCustomAttrsRequest = HubSercommGetCustomAttrsRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommSetCustomAttrs(_  model: HubModel, mac: String, irLedMode: String, irLedLuminance: Int, mdMode: String, mdThreshold: Int, mdSensitivity: Int, mdWindowCoordinates: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommSetCustomAttrsRequest = HubSercommSetCustomAttrsRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setIrLedMode(irLedMode)
    
    request.setIrLedLuminance(irLedLuminance)
    
    request.setMdMode(mdMode)
    
    request.setMdThreshold(mdThreshold)
    
    request.setMdSensitivity(mdSensitivity)
    
    request.setMdWindowCoordinates(mdWindowCoordinates)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommPurgeCamera(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommPurgeCameraRequest = HubSercommPurgeCameraRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommPtzGetAttrs(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommPtzGetAttrsRequest = HubSercommPtzGetAttrsRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommPtzGotoHome(_  model: HubModel, mac: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommPtzGotoHomeRequest = HubSercommPtzGotoHomeRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommPtzGotoAbsolute(_  model: HubModel, mac: String, pan: Int, tilt: Int, zoom: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommPtzGotoAbsoluteRequest = HubSercommPtzGotoAbsoluteRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setPan(pan)
    
    request.setTilt(tilt)
    
    request.setZoom(zoom)
    
    return try sendRequest(request)
  }
  
  public func requestHubSercommPtzGotoRelative(_  model: HubModel, mac: String, deltaPan: Int, deltaTilt: Int, deltaZoom: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSercommPtzGotoRelativeRequest = HubSercommPtzGotoRelativeRequest()
    request.source = model.address
    
    
    
    request.setMac(mac)
    
    request.setDeltaPan(deltaPan)
    
    request.setDeltaTilt(deltaTilt)
    
    request.setDeltaZoom(deltaZoom)
    
    return try sendRequest(request)
  }
  
}
