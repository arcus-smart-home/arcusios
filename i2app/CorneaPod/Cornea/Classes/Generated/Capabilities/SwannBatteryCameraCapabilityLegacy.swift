
//
// SwannBatteryCameraCapabilityLegacy.swift
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

public class SwannBatteryCameraCapabilityLegacy: NSObject, ArcusSwannBatteryCameraCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SwannBatteryCameraCapabilityLegacy  = SwannBatteryCameraCapabilityLegacy()
  
  static let SwannBatteryCameraModeWLAN_CONFIGURE: String = SwannBatteryCameraMode.wlan_configure.rawValue
  static let SwannBatteryCameraModeWLAN_RECONNECT: String = SwannBatteryCameraMode.wlan_reconnect.rawValue
  static let SwannBatteryCameraModeNOTIFY: String = SwannBatteryCameraMode.notify.rawValue
  static let SwannBatteryCameraModeSOFTAP: String = SwannBatteryCameraMode.softap.rawValue
  static let SwannBatteryCameraModeRECORDING: String = SwannBatteryCameraMode.recording.rawValue
  static let SwannBatteryCameraModeSTREAMING: String = SwannBatteryCameraMode.streaming.rawValue
  static let SwannBatteryCameraModeUPGRADE: String = SwannBatteryCameraMode.upgrade.rawValue
  static let SwannBatteryCameraModeRESET: String = SwannBatteryCameraMode.reset.rawValue
  static let SwannBatteryCameraModeUNCONFIG: String = SwannBatteryCameraMode.unconfig.rawValue
  static let SwannBatteryCameraModeASLEEP: String = SwannBatteryCameraMode.asleep.rawValue
  static let SwannBatteryCameraModeUNKNOWN: String = SwannBatteryCameraMode.unknown.rawValue
  
  static let SwannBatteryCameraMotionDetectSleepMIN: String = SwannBatteryCameraMotionDetectSleep.min.rawValue
  static let SwannBatteryCameraMotionDetectSleep30S: String = SwannBatteryCameraMotionDetectSleep._30s.rawValue
  static let SwannBatteryCameraMotionDetectSleep1M: String = SwannBatteryCameraMotionDetectSleep._1m.rawValue
  static let SwannBatteryCameraMotionDetectSleep3M: String = SwannBatteryCameraMotionDetectSleep._3m.rawValue
  static let SwannBatteryCameraMotionDetectSleep5M: String = SwannBatteryCameraMotionDetectSleep._5m.rawValue
  

  
  public static func getSn(_ model: DeviceModel) -> String? {
    return capability.getSwannBatteryCameraSn(model)
  }
  
  public static func getMode(_ model: DeviceModel) -> String? {
    return capability.getSwannBatteryCameraMode(model)?.rawValue
  }
  
  public static func getTimeZone(_ model: DeviceModel) -> NSNumber? {
    guard let timeZone: Int = capability.getSwannBatteryCameraTimeZone(model) else {
      return nil
    }
    return NSNumber(value: timeZone)
  }
  
  public static func setTimeZone(_ timeZone: Int, model: DeviceModel) {
    
    
    capability.setSwannBatteryCameraTimeZone(timeZone, model: model)
  }
  
  public static func getMotionDetectSleep(_ model: DeviceModel) -> String? {
    return capability.getSwannBatteryCameraMotionDetectSleep(model)?.rawValue
  }
  
  public static func setMotionDetectSleep(_ motionDetectSleep: String, model: DeviceModel) {
    guard let motionDetectSleep: SwannBatteryCameraMotionDetectSleep = SwannBatteryCameraMotionDetectSleep(rawValue: motionDetectSleep) else { return }
    
    capability.setSwannBatteryCameraMotionDetectSleep(motionDetectSleep, model: model)
  }
  
  public static func getStopUpload(_ model: DeviceModel) -> NSNumber? {
    guard let stopUpload: Bool = capability.getSwannBatteryCameraStopUpload(model) else {
      return nil
    }
    return NSNumber(value: stopUpload)
  }
  
  public static func setStopUpload(_ stopUpload: Bool, model: DeviceModel) {
    
    
    capability.setSwannBatteryCameraStopUpload(stopUpload, model: model)
  }
  
  public static func keepAwake(_  model: DeviceModel, seconds: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSwannBatteryCameraKeepAwake(model, seconds: seconds))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
