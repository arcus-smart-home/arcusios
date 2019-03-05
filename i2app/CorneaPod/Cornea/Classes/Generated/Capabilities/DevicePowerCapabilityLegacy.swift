
//
// DevicePowerCapabilityLegacy.swift
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

public class DevicePowerCapabilityLegacy: NSObject, ArcusDevicePowerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DevicePowerCapabilityLegacy  = DevicePowerCapabilityLegacy()
  
  static let DevicePowerSourceLINE: String = DevicePowerSource.line.rawValue
  static let DevicePowerSourceBATTERY: String = DevicePowerSource.battery.rawValue
  static let DevicePowerSourceBACKUPBATTERY: String = DevicePowerSource.backupbattery.rawValue
  

  
  public static func getSource(_ model: DeviceModel) -> String? {
    return capability.getDevicePowerSource(model)?.rawValue
  }
  
  public static func getLinecapable(_ model: DeviceModel) -> NSNumber? {
    guard let linecapable: Bool = capability.getDevicePowerLinecapable(model) else {
      return nil
    }
    return NSNumber(value: linecapable)
  }
  
  public static func getBackupbatterycapable(_ model: DeviceModel) -> NSNumber? {
    guard let backupbatterycapable: Bool = capability.getDevicePowerBackupbatterycapable(model) else {
      return nil
    }
    return NSNumber(value: backupbatterycapable)
  }
  
  public static func getBattery(_ model: DeviceModel) -> NSNumber? {
    guard let battery: Int = capability.getDevicePowerBattery(model) else {
      return nil
    }
    return NSNumber(value: battery)
  }
  
  public static func getBackupbattery(_ model: DeviceModel) -> NSNumber? {
    guard let backupbattery: Int = capability.getDevicePowerBackupbattery(model) else {
      return nil
    }
    return NSNumber(value: backupbattery)
  }
  
  public static func getSourcechanged(_ model: DeviceModel) -> Date? {
    guard let sourcechanged: Date = capability.getDevicePowerSourcechanged(model) else {
      return nil
    }
    return sourcechanged
  }
  
  public static func getRechargeable(_ model: DeviceModel) -> NSNumber? {
    guard let rechargeable: Bool = capability.getDevicePowerRechargeable(model) else {
      return nil
    }
    return NSNumber(value: rechargeable)
  }
  
}
