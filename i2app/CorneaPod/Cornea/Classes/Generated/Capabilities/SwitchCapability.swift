
//
// SwitchCap.swift
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
  public static var switchNamespace: String = "swit"
  public static var switchName: String = "Switch"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let switchState: String = "swit:state"
  static let switchInverted: String = "swit:inverted"
  static let switchStatechanged: String = "swit:statechanged"
  
}

public protocol ArcusSwitchCapability: class, RxArcusService {
  /** Reflects the state of the switch. Also used to set the state of the switch. */
  func getSwitchState(_ model: DeviceModel) -> SwitchState?
  /** Reflects the state of the switch. Also used to set the state of the switch. */
  func setSwitchState(_ state: SwitchState, model: DeviceModel)
/** Indicates whether operation of the physical switch toggle should be inverted, if supported. */
  func getSwitchInverted(_ model: DeviceModel) -> Bool?
  /** Indicates whether operation of the physical switch toggle should be inverted, if supported. */
  func setSwitchInverted(_ inverted: Bool, model: DeviceModel)
/** UTC date time of last state change */
  func getSwitchStatechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusSwitchCapability {
  public func getSwitchState(_ model: DeviceModel) -> SwitchState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.switchState] as? String,
      let enumAttr: SwitchState = SwitchState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSwitchState(_ state: SwitchState, model: DeviceModel) {
    model.set([Attributes.switchState: state.rawValue as AnyObject])
  }
  public func getSwitchInverted(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.switchInverted] as? Bool
  }
  
  public func setSwitchInverted(_ inverted: Bool, model: DeviceModel) {
    model.set([Attributes.switchInverted: inverted as AnyObject])
  }
  public func getSwitchStatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.switchStatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
