
//
// DevicePowerCap.swift
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
  public static var devicePowerNamespace: String = "devpow"
  public static var devicePowerName: String = "DevicePower"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let devicePowerSource: String = "devpow:source"
  static let devicePowerLinecapable: String = "devpow:linecapable"
  static let devicePowerBackupbatterycapable: String = "devpow:backupbatterycapable"
  static let devicePowerBattery: String = "devpow:battery"
  static let devicePowerBackupbattery: String = "devpow:backupbattery"
  static let devicePowerSourcechanged: String = "devpow:sourcechanged"
  static let devicePowerRechargeable: String = "devpow:rechargeable"
  
}

public protocol ArcusDevicePowerCapability: class, RxArcusService {
  /** Indicates that this device is currently line-powered */
  func getDevicePowerSource(_ model: DeviceModel) -> DevicePowerSource?
  /** When true, indicates that it is possible to line-power this device from the mains. */
  func getDevicePowerLinecapable(_ model: DeviceModel) -> Bool?
  /** When true, indicates the device can support a back-up battery. */
  func getDevicePowerBackupbatterycapable(_ model: DeviceModel) -> Bool?
  /** Level of primary battery. 0 = battery not present. */
  func getDevicePowerBattery(_ model: DeviceModel) -> Int?
  /** Level of primary battery. 0 = battery not present. */
  func getDevicePowerBackupbattery(_ model: DeviceModel) -> Int?
  /** UTC date time of last source change */
  func getDevicePowerSourcechanged(_ model: DeviceModel) -> Date?
  /** When true, indicates that the battery will recharge while the device is on LINE power.  Unset or null indicated that this is NOT rechargable */
  func getDevicePowerRechargeable(_ model: DeviceModel) -> Bool?
  
  
}

extension ArcusDevicePowerCapability {
  public func getDevicePowerSource(_ model: DeviceModel) -> DevicePowerSource? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.devicePowerSource] as? String,
      let enumAttr: DevicePowerSource = DevicePowerSource(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getDevicePowerLinecapable(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.devicePowerLinecapable] as? Bool
  }
  
  public func getDevicePowerBackupbatterycapable(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.devicePowerBackupbatterycapable] as? Bool
  }
  
  public func getDevicePowerBattery(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.devicePowerBattery] as? Int
  }
  
  public func getDevicePowerBackupbattery(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.devicePowerBackupbattery] as? Int
  }
  
  public func getDevicePowerSourcechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.devicePowerSourcechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getDevicePowerRechargeable(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.devicePowerRechargeable] as? Bool
  }
  
  
}
