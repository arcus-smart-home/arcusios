
//
// DeviceConnectionCap.swift
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
  public static var deviceConnectionNamespace: String = "devconn"
  public static var deviceConnectionName: String = "DeviceConnection"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let deviceConnectionState: String = "devconn:state"
  static let deviceConnectionStatus: String = "devconn:status"
  static let deviceConnectionLastchange: String = "devconn:lastchange"
  static let deviceConnectionSignal: String = "devconn:signal"
  
}

public protocol ArcusDeviceConnectionCapability: class, RxArcusService {
  /** Reflects the state of the connection to this device. If the device has intermediate connectivity states at the protocol level, it must be marked as offline until it can be fully controlled by the platform */
  func getDeviceConnectionState(_ model: DeviceModel) -> DeviceConnectionState?
  /** Reflects the status of the connection to this device. */
  func getDeviceConnectionStatus(_ model: DeviceModel) -> DeviceConnectionStatus?
  /** Time of the last change in connect.state */
  func getDeviceConnectionLastchange(_ model: DeviceModel) -> Date?
  /** A projection from a protocol transport specific measurement of signal strength. For zigbee or wifi this may be the RSSI normalized to percentage. */
  func getDeviceConnectionSignal(_ model: DeviceModel) -> Int?
  
  /** Sent when a device exists on the platform but is not reported by the hub. */
  func requestDeviceConnectionLostDevice(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusDeviceConnectionCapability {
  public func getDeviceConnectionState(_ model: DeviceModel) -> DeviceConnectionState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.deviceConnectionState] as? String,
      let enumAttr: DeviceConnectionState = DeviceConnectionState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getDeviceConnectionStatus(_ model: DeviceModel) -> DeviceConnectionStatus? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.deviceConnectionStatus] as? String,
      let enumAttr: DeviceConnectionStatus = DeviceConnectionStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getDeviceConnectionLastchange(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.deviceConnectionLastchange] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getDeviceConnectionSignal(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceConnectionSignal] as? Int
  }
  
  
  public func requestDeviceConnectionLostDevice(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceConnectionLostDeviceRequest = DeviceConnectionLostDeviceRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
