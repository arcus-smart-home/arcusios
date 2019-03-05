
//
// PowerUseCap.swift
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
  public static var powerUseNamespace: String = "pow"
  public static var powerUseName: String = "PowerUse"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let powerUseInstantaneous: String = "pow:instantaneous"
  static let powerUseCumulative: String = "pow:cumulative"
  static let powerUseWholehome: String = "pow:wholehome"
  
}

public protocol ArcusPowerUseCapability: class, RxArcusService {
  /** Reflects an instantaneous power reading from the device. */
  func getPowerUseInstantaneous(_ model: DeviceModel) -> Double?
  /** Reflects the cumulative power reading from the device if possible. */
  func getPowerUseCumulative(_ model: DeviceModel) -> Double?
  /** If true, this represents a whole-home meter. */
  func getPowerUseWholehome(_ model: DeviceModel) -> Bool?
  
  
}

extension ArcusPowerUseCapability {
  public func getPowerUseInstantaneous(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.powerUseInstantaneous] as? Double
  }
  
  public func getPowerUseCumulative(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.powerUseCumulative] as? Double
  }
  
  public func getPowerUseWholehome(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.powerUseWholehome] as? Bool
  }
  
  
}
