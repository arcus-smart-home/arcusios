
//
// SwitchCapabilityLegacy.swift
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

public class SwitchCapabilityLegacy: NSObject, ArcusSwitchCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SwitchCapabilityLegacy  = SwitchCapabilityLegacy()
  
  static let SwitchStateON: String = SwitchState.on.rawValue
  static let SwitchStateOFF: String = SwitchState.off.rawValue
  

  
  public static func getState(_ model: DeviceModel) -> String? {
    return capability.getSwitchState(model)?.rawValue
  }
  
  public static func setState(_ state: String, model: DeviceModel) {
    guard let state: SwitchState = SwitchState(rawValue: state) else { return }
    
    capability.setSwitchState(state, model: model)
  }
  
  public static func getInverted(_ model: DeviceModel) -> NSNumber? {
    guard let inverted: Bool = capability.getSwitchInverted(model) else {
      return nil
    }
    return NSNumber(value: inverted)
  }
  
  public static func setInverted(_ inverted: Bool, model: DeviceModel) {
    
    
    capability.setSwitchInverted(inverted, model: model)
  }
  
  public static func getStatechanged(_ model: DeviceModel) -> Date? {
    guard let statechanged: Date = capability.getSwitchStatechanged(model) else {
      return nil
    }
    return statechanged
  }
  
}
