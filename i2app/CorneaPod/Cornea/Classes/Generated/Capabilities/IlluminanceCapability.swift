
//
// IlluminanceCap.swift
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
  public static var illuminanceNamespace: String = "ill"
  public static var illuminanceName: String = "Illuminance"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let illuminanceIlluminance: String = "ill:illuminance"
  static let illuminanceSensorType: String = "ill:sensorType"
  
}

public protocol ArcusIlluminanceCapability: class, RxArcusService {
  /** Reflects the current illuminance measured by the device. */
  func getIlluminanceIlluminance(_ model: DeviceModel) -> Double?
  /** Reflects the type of illuminance sensor included in the device. */
  func getIlluminanceSensorType(_ model: DeviceModel) -> IlluminanceSensorType?
  
  
}

extension ArcusIlluminanceCapability {
  public func getIlluminanceIlluminance(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.illuminanceIlluminance] as? Double
  }
  
  public func getIlluminanceSensorType(_ model: DeviceModel) -> IlluminanceSensorType? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.illuminanceSensorType] as? String,
      let enumAttr: IlluminanceSensorType = IlluminanceSensorType(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
}
