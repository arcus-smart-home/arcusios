
//
// MotionCapabilityLegacy.swift
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

public class MotionCapabilityLegacy: NSObject, ArcusMotionCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: MotionCapabilityLegacy  = MotionCapabilityLegacy()
  
  static let MotionMotionNONE: String = MotionMotion.none.rawValue
  static let MotionMotionDETECTED: String = MotionMotion.detected.rawValue
  
  static let MotionSensitivityOFF: String = MotionSensitivity.off.rawValue
  static let MotionSensitivityLOW: String = MotionSensitivity.low.rawValue
  static let MotionSensitivityMED: String = MotionSensitivity.med.rawValue
  static let MotionSensitivityHIGH: String = MotionSensitivity.high.rawValue
  static let MotionSensitivityMAX: String = MotionSensitivity.max.rawValue
  

  
  public static func getMotion(_ model: DeviceModel) -> String? {
    return capability.getMotionMotion(model)?.rawValue
  }
  
  public static func getMotionchanged(_ model: DeviceModel) -> Date? {
    guard let motionchanged: Date = capability.getMotionMotionchanged(model) else {
      return nil
    }
    return motionchanged
  }
  
  public static func getSensitivitiesSupported(_ model: DeviceModel) -> [String]? {
    return capability.getMotionSensitivitiesSupported(model)
  }
  
  public static func getSensitivity(_ model: DeviceModel) -> String? {
    return capability.getMotionSensitivity(model)?.rawValue
  }
  
  public static func setSensitivity(_ sensitivity: String, model: DeviceModel) {
    guard let sensitivity: MotionSensitivity = MotionSensitivity(rawValue: sensitivity) else { return }
    
    capability.setMotionSensitivity(sensitivity, model: model)
  }
  
}
