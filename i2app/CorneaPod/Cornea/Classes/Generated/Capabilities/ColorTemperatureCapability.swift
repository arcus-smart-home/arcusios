
//
// ColorTemperatureCap.swift
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
  public static var colorTemperatureNamespace: String = "colortemp"
  public static var colorTemperatureName: String = "ColorTemperature"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let colorTemperatureColortemp: String = "colortemp:colortemp"
  static let colorTemperatureMincolortemp: String = "colortemp:mincolortemp"
  static let colorTemperatureMaxcolortemp: String = "colortemp:maxcolortemp"
  
}

public protocol ArcusColorTemperatureCapability: class, RxArcusService {
  /** Current color temperature in degrees Kelvin. */
  func getColorTemperatureColortemp(_ model: DeviceModel) -> Int?
  /** Current color temperature in degrees Kelvin. */
  func setColorTemperatureColortemp(_ colortemp: Int, model: DeviceModel)
/** Warmest color temperature supported. */
  func getColorTemperatureMincolortemp(_ model: DeviceModel) -> Int?
  /** Coolest color temperature supported. */
  func getColorTemperatureMaxcolortemp(_ model: DeviceModel) -> Int?
  
  
}

extension ArcusColorTemperatureCapability {
  public func getColorTemperatureColortemp(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.colorTemperatureColortemp] as? Int
  }
  
  public func setColorTemperatureColortemp(_ colortemp: Int, model: DeviceModel) {
    model.set([Attributes.colorTemperatureColortemp: colortemp as AnyObject])
  }
  public func getColorTemperatureMincolortemp(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.colorTemperatureMincolortemp] as? Int
  }
  
  public func getColorTemperatureMaxcolortemp(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.colorTemperatureMaxcolortemp] as? Int
  }
  
  
}
