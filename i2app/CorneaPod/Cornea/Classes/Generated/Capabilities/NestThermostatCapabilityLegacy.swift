
//
// NestThermostatCapabilityLegacy.swift
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

public class NestThermostatCapabilityLegacy: NSObject, ArcusNestThermostatCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: NestThermostatCapabilityLegacy  = NestThermostatCapabilityLegacy()
  

  
  public static func getHasleaf(_ model: DeviceModel) -> NSNumber? {
    guard let hasleaf: Bool = capability.getNestThermostatHasleaf(model) else {
      return nil
    }
    return NSNumber(value: hasleaf)
  }
  
  public static func getRoomname(_ model: DeviceModel) -> String? {
    return capability.getNestThermostatRoomname(model)
  }
  
  public static func getLocked(_ model: DeviceModel) -> NSNumber? {
    guard let locked: Bool = capability.getNestThermostatLocked(model) else {
      return nil
    }
    return NSNumber(value: locked)
  }
  
  public static func getLockedtempmin(_ model: DeviceModel) -> NSNumber? {
    guard let lockedtempmin: Double = capability.getNestThermostatLockedtempmin(model) else {
      return nil
    }
    return NSNumber(value: lockedtempmin)
  }
  
  public static func getLockedtempmax(_ model: DeviceModel) -> NSNumber? {
    guard let lockedtempmax: Double = capability.getNestThermostatLockedtempmax(model) else {
      return nil
    }
    return NSNumber(value: lockedtempmax)
  }
  
}
