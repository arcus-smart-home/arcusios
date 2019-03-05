
//
// EcowaterWaterSoftenerCap.swift
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
  public static var ecowaterWaterSoftenerNamespace: String = "ecowater"
  public static var ecowaterWaterSoftenerName: String = "EcowaterWaterSoftener"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let ecowaterWaterSoftenerExcessiveUse: String = "ecowater:excessiveUse"
  static let ecowaterWaterSoftenerContinuousUse: String = "ecowater:continuousUse"
  static let ecowaterWaterSoftenerContinuousDuration: String = "ecowater:continuousDuration"
  static let ecowaterWaterSoftenerContinuousRate: String = "ecowater:continuousRate"
  static let ecowaterWaterSoftenerAlertOnContinuousUse: String = "ecowater:alertOnContinuousUse"
  static let ecowaterWaterSoftenerAlertOnExcessiveUse: String = "ecowater:alertOnExcessiveUse"
  
}

public protocol ArcusEcowaterWaterSoftenerCapability: class, RxArcusService {
  /** Indicates whether or not the device is experiencing excessive water flow */
  func getEcowaterWaterSoftenerExcessiveUse(_ model: DeviceModel) -> Bool?
  /** Indicates whether or not the device is experiencing continuous water flow */
  func getEcowaterWaterSoftenerContinuousUse(_ model: DeviceModel) -> Bool?
  /** Number of seconds where flow must meet or exceed continuousRate before continuousUse will be marked true */
  func getEcowaterWaterSoftenerContinuousDuration(_ model: DeviceModel) -> Int?
  /** Number of seconds where flow must meet or exceed continuousRate before continuousUse will be marked true */
  func setEcowaterWaterSoftenerContinuousDuration(_ continuousDuration: Int, model: DeviceModel)
/** Flow threshold in gallons per minute used to determine continuousUse */
  func getEcowaterWaterSoftenerContinuousRate(_ model: DeviceModel) -> Double?
  /** Flow threshold in gallons per minute used to determine continuousUse */
  func setEcowaterWaterSoftenerContinuousRate(_ continuousRate: Double, model: DeviceModel)
/** Indicates whether the user wants to receive continuous use notifications */
  func getEcowaterWaterSoftenerAlertOnContinuousUse(_ model: DeviceModel) -> Bool?
  /** Indicates whether the user wants to receive continuous use notifications */
  func setEcowaterWaterSoftenerAlertOnContinuousUse(_ alertOnContinuousUse: Bool, model: DeviceModel)
/** Indicates whether the user wants to receive excessive use notifications */
  func getEcowaterWaterSoftenerAlertOnExcessiveUse(_ model: DeviceModel) -> Bool?
  /** Indicates whether the user wants to receive excessive use notifications */
  func setEcowaterWaterSoftenerAlertOnExcessiveUse(_ alertOnExcessiveUse: Bool, model: DeviceModel)

  
}

extension ArcusEcowaterWaterSoftenerCapability {
  public func getEcowaterWaterSoftenerExcessiveUse(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ecowaterWaterSoftenerExcessiveUse] as? Bool
  }
  
  public func getEcowaterWaterSoftenerContinuousUse(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ecowaterWaterSoftenerContinuousUse] as? Bool
  }
  
  public func getEcowaterWaterSoftenerContinuousDuration(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ecowaterWaterSoftenerContinuousDuration] as? Int
  }
  
  public func setEcowaterWaterSoftenerContinuousDuration(_ continuousDuration: Int, model: DeviceModel) {
    model.set([Attributes.ecowaterWaterSoftenerContinuousDuration: continuousDuration as AnyObject])
  }
  public func getEcowaterWaterSoftenerContinuousRate(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ecowaterWaterSoftenerContinuousRate] as? Double
  }
  
  public func setEcowaterWaterSoftenerContinuousRate(_ continuousRate: Double, model: DeviceModel) {
    model.set([Attributes.ecowaterWaterSoftenerContinuousRate: continuousRate as AnyObject])
  }
  public func getEcowaterWaterSoftenerAlertOnContinuousUse(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ecowaterWaterSoftenerAlertOnContinuousUse] as? Bool
  }
  
  public func setEcowaterWaterSoftenerAlertOnContinuousUse(_ alertOnContinuousUse: Bool, model: DeviceModel) {
    model.set([Attributes.ecowaterWaterSoftenerAlertOnContinuousUse: alertOnContinuousUse as AnyObject])
  }
  public func getEcowaterWaterSoftenerAlertOnExcessiveUse(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ecowaterWaterSoftenerAlertOnExcessiveUse] as? Bool
  }
  
  public func setEcowaterWaterSoftenerAlertOnExcessiveUse(_ alertOnExcessiveUse: Bool, model: DeviceModel) {
    model.set([Attributes.ecowaterWaterSoftenerAlertOnExcessiveUse: alertOnExcessiveUse as AnyObject])
  }
  
}
