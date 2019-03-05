
//
// LeakGasCap.swift
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
  public static var leakGasNamespace: String = "gas"
  public static var leakGasName: String = "LeakGas"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let leakGasState: String = "gas:state"
  static let leakGasStatechanged: String = "gas:statechanged"
  
}

public protocol ArcusLeakGasCapability: class, RxArcusService {
  /** Reflects whether or not a natural gas leak has been detected by the sensor. */
  func getLeakGasState(_ model: DeviceModel) -> LeakGasState?
  /** UTC date time of last state change */
  func getLeakGasStatechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusLeakGasCapability {
  public func getLeakGasState(_ model: DeviceModel) -> LeakGasState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.leakGasState] as? String,
      let enumAttr: LeakGasState = LeakGasState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getLeakGasStatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.leakGasStatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
