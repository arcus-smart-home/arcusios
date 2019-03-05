
//
// DeviceOtaCapabilityLegacy.swift
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

public class DeviceOtaCapabilityLegacy: NSObject, ArcusDeviceOtaCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DeviceOtaCapabilityLegacy  = DeviceOtaCapabilityLegacy()
  
  static let DeviceOtaStatusIDLE: String = DeviceOtaStatus.idle.rawValue
  static let DeviceOtaStatusINPROGRESS: String = DeviceOtaStatus.inprogress.rawValue
  static let DeviceOtaStatusCOMPLETED: String = DeviceOtaStatus.completed.rawValue
  static let DeviceOtaStatusFAILED: String = DeviceOtaStatus.failed.rawValue
  

  
  public static func getCurrentVersion(_ model: DeviceModel) -> String? {
    return capability.getDeviceOtaCurrentVersion(model)
  }
  
  public static func getTargetVersion(_ model: DeviceModel) -> String? {
    return capability.getDeviceOtaTargetVersion(model)
  }
  
  public static func getStatus(_ model: DeviceModel) -> String? {
    return capability.getDeviceOtaStatus(model)?.rawValue
  }
  
  public static func getRetryCount(_ model: DeviceModel) -> NSNumber? {
    guard let retryCount: Int = capability.getDeviceOtaRetryCount(model) else {
      return nil
    }
    return NSNumber(value: retryCount)
  }
  
  public static func getLastAttempt(_ model: DeviceModel) -> Date? {
    guard let lastAttempt: Date = capability.getDeviceOtaLastAttempt(model) else {
      return nil
    }
    return lastAttempt
  }
  
  public static func getProgressPercent(_ model: DeviceModel) -> NSNumber? {
    guard let progressPercent: Double = capability.getDeviceOtaProgressPercent(model) else {
      return nil
    }
    return NSNumber(value: progressPercent)
  }
  
  public static func getLastFailReason(_ model: DeviceModel) -> String? {
    return capability.getDeviceOtaLastFailReason(model)
  }
  
  public static func firmwareUpdate(_  model: DeviceModel, url: String, priority: String, md5: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestDeviceOtaFirmwareUpdate(model, url: url, priority: priority, md5: md5))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func firmwareUpdateCancel(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestDeviceOtaFirmwareUpdateCancel(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
