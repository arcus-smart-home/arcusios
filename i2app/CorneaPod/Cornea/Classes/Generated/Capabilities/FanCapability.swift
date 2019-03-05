
//
// FanCap.swift
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
  public static var fanNamespace: String = "fan"
  public static var fanName: String = "Fan"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let fanSpeed: String = "fan:speed"
  static let fanMaxSpeed: String = "fan:maxSpeed"
  static let fanDirection: String = "fan:direction"
  
}

public protocol ArcusFanCapability: class, RxArcusService {
  /** Reflects the speed of the device. Also used to set the speed of the device. */
  func getFanSpeed(_ model: DeviceModel) -> Int?
  /** Reflects the speed of the device. Also used to set the speed of the device. */
  func setFanSpeed(_ speed: Int, model: DeviceModel)
/** Determine the max speed as reported by the fan. */
  func getFanMaxSpeed(_ model: DeviceModel) -> Int?
  /** Reflects the direction of air flow through the fan. */
  func getFanDirection(_ model: DeviceModel) -> FanDirection?
  /** Reflects the direction of air flow through the fan. */
  func setFanDirection(_ direction: FanDirection, model: DeviceModel)

  
}

extension ArcusFanCapability {
  public func getFanSpeed(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.fanSpeed] as? Int
  }
  
  public func setFanSpeed(_ speed: Int, model: DeviceModel) {
    model.set([Attributes.fanSpeed: speed as AnyObject])
  }
  public func getFanMaxSpeed(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.fanMaxSpeed] as? Int
  }
  
  public func getFanDirection(_ model: DeviceModel) -> FanDirection? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.fanDirection] as? String,
      let enumAttr: FanDirection = FanDirection(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setFanDirection(_ direction: FanDirection, model: DeviceModel) {
    model.set([Attributes.fanDirection: direction.rawValue as AnyObject])
  }
  
}
