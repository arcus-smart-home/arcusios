
//
// DeviceConnectionCapabilityLegacy.swift
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

public class DeviceConnectionCapabilityLegacy: NSObject, ArcusDeviceConnectionCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DeviceConnectionCapabilityLegacy  = DeviceConnectionCapabilityLegacy()
  
  static let DeviceConnectionStateONLINE: String = DeviceConnectionState.online.rawValue
  static let DeviceConnectionStateOFFLINE: String = DeviceConnectionState.offline.rawValue
  
  static let DeviceConnectionStatusONLINE: String = DeviceConnectionStatus.online.rawValue
  static let DeviceConnectionStatusFLAPPING: String = DeviceConnectionStatus.flapping.rawValue
  static let DeviceConnectionStatusLOST: String = DeviceConnectionStatus.lost.rawValue
  

  
  public static func getState(_ model: DeviceModel) -> String? {
    return capability.getDeviceConnectionState(model)?.rawValue
  }
  
  public static func getStatus(_ model: DeviceModel) -> String? {
    return capability.getDeviceConnectionStatus(model)?.rawValue
  }
  
  public static func getLastchange(_ model: DeviceModel) -> Date? {
    guard let lastchange: Date = capability.getDeviceConnectionLastchange(model) else {
      return nil
    }
    return lastchange
  }
  
  public static func getSignal(_ model: DeviceModel) -> NSNumber? {
    guard let signal: Int = capability.getDeviceConnectionSignal(model) else {
      return nil
    }
    return NSNumber(value: signal)
  }
  
  public static func lostDevice(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestDeviceConnectionLostDevice(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
