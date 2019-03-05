
//
// HubPowerCap.swift
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
  public static var hubPowerNamespace: String = "hubpow"
  public static var hubPowerName: String = "HubPower"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubPowerSource: String = "hubpow:source"
  static let hubPowerMainscpable: String = "hubpow:mainscpable"
  static let hubPowerBattery: String = "hubpow:Battery"
  
}

public protocol ArcusHubPowerCapability: class, RxArcusService {
  /** Indicates where the power from the hub is coming from. */
  func getHubPowerSource(_ model: HubModel) -> HubPowerSource?
  /** If the hub can be plugged in or not. */
  func getHubPowerMainscpable(_ model: HubModel) -> Bool?
  /** Current battery remaining, in percent */
  func getHubPowerBattery(_ model: HubModel) -> Int?
  
  
}

extension ArcusHubPowerCapability {
  public func getHubPowerSource(_ model: HubModel) -> HubPowerSource? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubPowerSource] as? String,
      let enumAttr: HubPowerSource = HubPowerSource(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubPowerMainscpable(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubPowerMainscpable] as? Bool
  }
  
  public func getHubPowerBattery(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubPowerBattery] as? Int
  }
  
  
}
