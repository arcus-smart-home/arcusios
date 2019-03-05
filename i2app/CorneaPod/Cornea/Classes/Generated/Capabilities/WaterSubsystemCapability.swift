
//
// WaterSubsystemCap.swift
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
  public static var waterSubsystemNamespace: String = "subwater"
  public static var waterSubsystemName: String = "WaterSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let waterSubsystemPrimaryWaterHeater: String = "subwater:primaryWaterHeater"
  static let waterSubsystemPrimaryWaterSoftener: String = "subwater:primaryWaterSoftener"
  static let waterSubsystemClosedWaterValves: String = "subwater:closedWaterValves"
  static let waterSubsystemWaterDevices: String = "subwater:waterDevices"
  static let waterSubsystemContinuousWaterUseDevices: String = "subwater:continuousWaterUseDevices"
  static let waterSubsystemExcessiveWaterUseDevices: String = "subwater:excessiveWaterUseDevices"
  static let waterSubsystemLowSaltDevices: String = "subwater:lowSaltDevices"
  
}

public protocol ArcusWaterSubsystemCapability: class, RxArcusService {
  /** When the first water heater is added it will be populated with that value.  This will be null if no water heater devices exist in the system. */
  func getWaterSubsystemPrimaryWaterHeater(_ model: SubsystemModel) -> String?
  /** When the first water heater is added it will be populated with that value.  This will be null if no water heater devices exist in the system. */
  func setWaterSubsystemPrimaryWaterHeater(_ primaryWaterHeater: String, model: SubsystemModel)
/** When the first water softener is added it will be populated with that value. This will be null if no water softener devices exist in the system. */
  func getWaterSubsystemPrimaryWaterSoftener(_ model: SubsystemModel) -> String?
  /** When the first water softener is added it will be populated with that value. This will be null if no water softener devices exist in the system. */
  func setWaterSubsystemPrimaryWaterSoftener(_ primaryWaterSoftener: String, model: SubsystemModel)
/** The set of water shutoff valves that are currently closed. */
  func getWaterSubsystemClosedWaterValves(_ model: SubsystemModel) -> [String]?
  /** The set of devices that participate in the water service. */
  func getWaterSubsystemWaterDevices(_ model: SubsystemModel) -> [String]?
  /** The set of devices that have a continuous water use alert enabled and active. */
  func getWaterSubsystemContinuousWaterUseDevices(_ model: SubsystemModel) -> [String]?
  /** The set of devices that have an excessive water use alert enabled and active. */
  func getWaterSubsystemExcessiveWaterUseDevices(_ model: SubsystemModel) -> [String]?
  /** The set of water softeners that have a low salt level. */
  func getWaterSubsystemLowSaltDevices(_ model: SubsystemModel) -> [String]?
  
  
}

extension ArcusWaterSubsystemCapability {
  public func getWaterSubsystemPrimaryWaterHeater(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSubsystemPrimaryWaterHeater] as? String
  }
  
  public func setWaterSubsystemPrimaryWaterHeater(_ primaryWaterHeater: String, model: SubsystemModel) {
    model.set([Attributes.waterSubsystemPrimaryWaterHeater: primaryWaterHeater as AnyObject])
  }
  public func getWaterSubsystemPrimaryWaterSoftener(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSubsystemPrimaryWaterSoftener] as? String
  }
  
  public func setWaterSubsystemPrimaryWaterSoftener(_ primaryWaterSoftener: String, model: SubsystemModel) {
    model.set([Attributes.waterSubsystemPrimaryWaterSoftener: primaryWaterSoftener as AnyObject])
  }
  public func getWaterSubsystemClosedWaterValves(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSubsystemClosedWaterValves] as? [String]
  }
  
  public func getWaterSubsystemWaterDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSubsystemWaterDevices] as? [String]
  }
  
  public func getWaterSubsystemContinuousWaterUseDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSubsystemContinuousWaterUseDevices] as? [String]
  }
  
  public func getWaterSubsystemExcessiveWaterUseDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSubsystemExcessiveWaterUseDevices] as? [String]
  }
  
  public func getWaterSubsystemLowSaltDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.waterSubsystemLowSaltDevices] as? [String]
  }
  
  
}
