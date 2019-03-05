
//
// IndicatorCapabilityLegacy.swift
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

public class IndicatorCapabilityLegacy: NSObject, ArcusIndicatorCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: IndicatorCapabilityLegacy  = IndicatorCapabilityLegacy()
  
  static let IndicatorIndicatorON: String = IndicatorIndicator.on.rawValue
  static let IndicatorIndicatorOFF: String = IndicatorIndicator.off.rawValue
  static let IndicatorIndicatorDISABLED: String = IndicatorIndicator.disabled.rawValue
  

  
  public static func getIndicator(_ model: DeviceModel) -> String? {
    return capability.getIndicatorIndicator(model)?.rawValue
  }
  
  public static func getEnabled(_ model: DeviceModel) -> NSNumber? {
    guard let enabled: Bool = capability.getIndicatorEnabled(model) else {
      return nil
    }
    return NSNumber(value: enabled)
  }
  
  public static func setEnabled(_ enabled: Bool, model: DeviceModel) {
    
    
    capability.setIndicatorEnabled(enabled, model: model)
  }
  
  public static func getEnableSupported(_ model: DeviceModel) -> NSNumber? {
    guard let enableSupported: Bool = capability.getIndicatorEnableSupported(model) else {
      return nil
    }
    return NSNumber(value: enableSupported)
  }
  
  public static func getInverted(_ model: DeviceModel) -> NSNumber? {
    guard let inverted: Bool = capability.getIndicatorInverted(model) else {
      return nil
    }
    return NSNumber(value: inverted)
  }
  
  public static func setInverted(_ inverted: Bool, model: DeviceModel) {
    
    
    capability.setIndicatorInverted(inverted, model: model)
  }
  
}
