
//
// MotionCap.swift
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
  public static var motionNamespace: String = "mot"
  public static var motionName: String = "Motion"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let motionMotion: String = "mot:motion"
  static let motionMotionchanged: String = "mot:motionchanged"
  static let motionSensitivitiesSupported: String = "mot:sensitivitiesSupported"
  static let motionSensitivity: String = "mot:sensitivity"
  
}

public protocol ArcusMotionCapability: class, RxArcusService {
  /** Reflects the state of the motion sensor. When detected the motion sensor has detected motion, when none no motion has been detected. */
  func getMotionMotion(_ model: DeviceModel) -> MotionMotion?
  /** UTC date time of last motion change */
  func getMotionMotionchanged(_ model: DeviceModel) -> Date?
  /** A set of sensitivities that are supported by this motion sensor.  If the set is null or empty modification of the sensitivity is not supported. */
  func getMotionSensitivitiesSupported(_ model: DeviceModel) -> [String]?
  /** The sensitivity of the motion sensor where:  OFF:   Implies that the motion sensor is disabled and will not detect motion LOW:   Arcust possible detection sensitivity MED:   Moderate detection sensitivity HIGH:  High detection sensitivity MAX:   Maximum sensitivity the device can be set to.  This will be null for motion sensors that do not support modification of sensitivity.  */
  func getMotionSensitivity(_ model: DeviceModel) -> MotionSensitivity?
  /** The sensitivity of the motion sensor where:  OFF:   Implies that the motion sensor is disabled and will not detect motion LOW:   Arcust possible detection sensitivity MED:   Moderate detection sensitivity HIGH:  High detection sensitivity MAX:   Maximum sensitivity the device can be set to.  This will be null for motion sensors that do not support modification of sensitivity.  */
  func setMotionSensitivity(_ sensitivity: MotionSensitivity, model: DeviceModel)

  
}

extension ArcusMotionCapability {
  public func getMotionMotion(_ model: DeviceModel) -> MotionMotion? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.motionMotion] as? String,
      let enumAttr: MotionMotion = MotionMotion(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getMotionMotionchanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.motionMotionchanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getMotionSensitivitiesSupported(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.motionSensitivitiesSupported] as? [String]
  }
  
  public func getMotionSensitivity(_ model: DeviceModel) -> MotionSensitivity? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.motionSensitivity] as? String,
      let enumAttr: MotionSensitivity = MotionSensitivity(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setMotionSensitivity(_ sensitivity: MotionSensitivity, model: DeviceModel) {
    model.set([Attributes.motionSensitivity: sensitivity.rawValue as AnyObject])
  }
  
}
