
//
// DeviceCap.swift
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
  public static var deviceNamespace: String = "dev"
  public static var deviceName: String = "Device"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let deviceAccount: String = "dev:account"
  static let devicePlace: String = "dev:place"
  static let deviceDevtypehint: String = "dev:devtypehint"
  static let deviceName: String = "dev:name"
  static let deviceVendor: String = "dev:vendor"
  static let deviceModel: String = "dev:model"
  static let deviceProductId: String = "dev:productId"
  
}

public protocol ArcusDeviceCapability: class, RxArcusService {
  /** Driver-owned account associated with the device */
  func getDeviceAccount(_ model: DeviceModel) -> String?
  /** Driver-owned place where the device is currently located */
  func getDevicePlace(_ model: DeviceModel) -> String?
  /** Device Details screen that should be used to view this device */
  func getDeviceDevtypehint(_ model: DeviceModel) -> String?
  /** Human readable name for the device */
  func getDeviceName(_ model: DeviceModel) -> String?
  /** Human readable name for the device */
  func setDeviceName(_ name: String, model: DeviceModel)
/** Vendor name */
  func getDeviceVendor(_ model: DeviceModel) -> String?
  /** Model name */
  func getDeviceModel(_ model: DeviceModel) -> String?
  /** ID of the product catalog that describes this device */
  func getDeviceProductId(_ model: DeviceModel) -> String?
  
  /** Returns a list of all the history log entries associated with this device */
  func requestDeviceListHistoryEntries(_  model: DeviceModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent>/**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the Device. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This may put the hub in unpairing mode depending on the device being removed.           */
  func requestDeviceRemove(_  model: DeviceModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent>/** Sent to request that a device be removed. */
  func requestDeviceForceRemove(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusDeviceCapability {
  public func getDeviceAccount(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAccount] as? String
  }
  
  public func getDevicePlace(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.devicePlace] as? String
  }
  
  public func getDeviceDevtypehint(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceDevtypehint] as? String
  }
  
  public func getDeviceName(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceName] as? String
  }
  
  public func setDeviceName(_ name: String, model: DeviceModel) {
    model.set([Attributes.deviceName: name as AnyObject])
  }
  public func getDeviceVendor(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceVendor] as? String
  }
  
  public func getDeviceModel(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceModel] as? String
  }
  
  public func getDeviceProductId(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceProductId] as? String
  }
  
  
  public func requestDeviceListHistoryEntries(_  model: DeviceModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: DeviceListHistoryEntriesRequest = DeviceListHistoryEntriesRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    return try sendRequest(request)
  }
  
  public func requestDeviceRemove(_  model: DeviceModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: DeviceRemoveRequest = DeviceRemoveRequest()
    request.source = model.address
    
    
    
    request.setTimeout(timeout)
    
    return try sendRequest(request)
  }
  
  public func requestDeviceForceRemove(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceForceRemoveRequest = DeviceForceRemoveRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
