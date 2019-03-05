
//
// ValveCap.swift
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
  public static var valveNamespace: String = "valv"
  public static var valveName: String = "Valve"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let valveValvestate: String = "valv:valvestate"
  static let valveValvestatechanged: String = "valv:valvestatechanged"
  
}

public protocol ArcusValveCapability: class, RxArcusService {
  /** Reflects the current state of the valve. Obstruction implying that something is preventing the opening or closing of the valve. May also be used to set the state of the valve. */
  func getValveValvestate(_ model: DeviceModel) -> ValveValvestate?
  /** Reflects the current state of the valve. Obstruction implying that something is preventing the opening or closing of the valve. May also be used to set the state of the valve. */
  func setValveValvestate(_ valvestate: ValveValvestate, model: DeviceModel)
/** UTC date time of last valve state change */
  func getValveValvestatechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusValveCapability {
  public func getValveValvestate(_ model: DeviceModel) -> ValveValvestate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.valveValvestate] as? String,
      let enumAttr: ValveValvestate = ValveValvestate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setValveValvestate(_ valvestate: ValveValvestate, model: DeviceModel) {
    model.set([Attributes.valveValvestate: valvestate.rawValue as AnyObject])
  }
  public func getValveValvestatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.valveValvestatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
