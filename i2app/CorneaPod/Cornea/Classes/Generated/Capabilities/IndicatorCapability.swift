
//
// IndicatorCap.swift
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
  public static var indicatorNamespace: String = "indicator"
  public static var indicatorName: String = "Indicator"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let indicatorIndicator: String = "indicator:indicator"
  static let indicatorEnabled: String = "indicator:enabled"
  static let indicatorEnableSupported: String = "indicator:enableSupported"
  static let indicatorInverted: String = "indicator:inverted"
  
}

public protocol ArcusIndicatorCapability: class, RxArcusService {
  /** Reflects the state of the indicator on the device.  ON means the indicator is currently active, OFF means the indicators is inactive, and DISABLED means the indicator has been disabled. */
  func getIndicatorIndicator(_ model: DeviceModel) -> IndicatorIndicator?
  /** Allows the indicator to be enabled or disabled.  Not all devices will support this attribute. */
  func getIndicatorEnabled(_ model: DeviceModel) -> Bool?
  /** Allows the indicator to be enabled or disabled.  Not all devices will support this attribute. */
  func setIndicatorEnabled(_ enabled: Bool, model: DeviceModel)
/** Indicates whether or not the enabled attribute is supported. */
  func getIndicatorEnableSupported(_ model: DeviceModel) -> Bool?
  /** Indicates whether operation of the indicator should be inverted, if supported by the device. For example, turn indicator OFF when switch is ON, etc. */
  func getIndicatorInverted(_ model: DeviceModel) -> Bool?
  /** Indicates whether operation of the indicator should be inverted, if supported by the device. For example, turn indicator OFF when switch is ON, etc. */
  func setIndicatorInverted(_ inverted: Bool, model: DeviceModel)

  
}

extension ArcusIndicatorCapability {
  public func getIndicatorIndicator(_ model: DeviceModel) -> IndicatorIndicator? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.indicatorIndicator] as? String,
      let enumAttr: IndicatorIndicator = IndicatorIndicator(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getIndicatorEnabled(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.indicatorEnabled] as? Bool
  }
  
  public func setIndicatorEnabled(_ enabled: Bool, model: DeviceModel) {
    model.set([Attributes.indicatorEnabled: enabled as AnyObject])
  }
  public func getIndicatorEnableSupported(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.indicatorEnableSupported] as? Bool
  }
  
  public func getIndicatorInverted(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.indicatorInverted] as? Bool
  }
  
  public func setIndicatorInverted(_ inverted: Bool, model: DeviceModel) {
    model.set([Attributes.indicatorInverted: inverted as AnyObject])
  }
  
}
