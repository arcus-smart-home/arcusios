
//
// EcowaterWaterSoftenerCapabilityLegacy.swift
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

public class EcowaterWaterSoftenerCapabilityLegacy: NSObject, ArcusEcowaterWaterSoftenerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: EcowaterWaterSoftenerCapabilityLegacy  = EcowaterWaterSoftenerCapabilityLegacy()
  

  
  public static func getExcessiveUse(_ model: DeviceModel) -> NSNumber? {
    guard let excessiveUse: Bool = capability.getEcowaterWaterSoftenerExcessiveUse(model) else {
      return nil
    }
    return NSNumber(value: excessiveUse)
  }
  
  public static func getContinuousUse(_ model: DeviceModel) -> NSNumber? {
    guard let continuousUse: Bool = capability.getEcowaterWaterSoftenerContinuousUse(model) else {
      return nil
    }
    return NSNumber(value: continuousUse)
  }
  
  public static func getContinuousDuration(_ model: DeviceModel) -> NSNumber? {
    guard let continuousDuration: Int = capability.getEcowaterWaterSoftenerContinuousDuration(model) else {
      return nil
    }
    return NSNumber(value: continuousDuration)
  }
  
  public static func setContinuousDuration(_ continuousDuration: Int, model: DeviceModel) {
    
    
    capability.setEcowaterWaterSoftenerContinuousDuration(continuousDuration, model: model)
  }
  
  public static func getContinuousRate(_ model: DeviceModel) -> NSNumber? {
    guard let continuousRate: Double = capability.getEcowaterWaterSoftenerContinuousRate(model) else {
      return nil
    }
    return NSNumber(value: continuousRate)
  }
  
  public static func setContinuousRate(_ continuousRate: Double, model: DeviceModel) {
    
    
    capability.setEcowaterWaterSoftenerContinuousRate(continuousRate, model: model)
  }
  
  public static func getAlertOnContinuousUse(_ model: DeviceModel) -> NSNumber? {
    guard let alertOnContinuousUse: Bool = capability.getEcowaterWaterSoftenerAlertOnContinuousUse(model) else {
      return nil
    }
    return NSNumber(value: alertOnContinuousUse)
  }
  
  public static func setAlertOnContinuousUse(_ alertOnContinuousUse: Bool, model: DeviceModel) {
    
    
    capability.setEcowaterWaterSoftenerAlertOnContinuousUse(alertOnContinuousUse, model: model)
  }
  
  public static func getAlertOnExcessiveUse(_ model: DeviceModel) -> NSNumber? {
    guard let alertOnExcessiveUse: Bool = capability.getEcowaterWaterSoftenerAlertOnExcessiveUse(model) else {
      return nil
    }
    return NSNumber(value: alertOnExcessiveUse)
  }
  
  public static func setAlertOnExcessiveUse(_ alertOnExcessiveUse: Bool, model: DeviceModel) {
    
    
    capability.setEcowaterWaterSoftenerAlertOnExcessiveUse(alertOnExcessiveUse, model: model)
  }
  
}
