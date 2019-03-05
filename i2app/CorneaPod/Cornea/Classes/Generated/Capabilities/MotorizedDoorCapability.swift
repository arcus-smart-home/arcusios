
//
// MotorizedDoorCap.swift
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
  public static var motorizedDoorNamespace: String = "motdoor"
  public static var motorizedDoorName: String = "MotorizedDoor"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let motorizedDoorDoorstate: String = "motdoor:doorstate"
  static let motorizedDoorDoorlevel: String = "motdoor:doorlevel"
  static let motorizedDoorDoorstatechanged: String = "motdoor:doorstatechanged"
  
}

public protocol ArcusMotorizedDoorCapability: class, RxArcusService {
  /** Current door state, and if written, desired door state. */
  func getMotorizedDoorDoorstate(_ model: DeviceModel) -> MotorizedDoorDoorstate?
  /** Current door state, and if written, desired door state. */
  func setMotorizedDoorDoorstate(_ doorstate: MotorizedDoorDoorstate, model: DeviceModel)
/** % open. 0 is closed, 100 is open.  Some doors do support reporting what level they are currently at, and some support a requested door level to leave a garage door at partial open. */
  func getMotorizedDoorDoorlevel(_ model: DeviceModel) -> Int?
  /** % open. 0 is closed, 100 is open.  Some doors do support reporting what level they are currently at, and some support a requested door level to leave a garage door at partial open. */
  func setMotorizedDoorDoorlevel(_ doorlevel: Int, model: DeviceModel)
/** UTC date time of last doorstate change */
  func getMotorizedDoorDoorstatechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusMotorizedDoorCapability {
  public func getMotorizedDoorDoorstate(_ model: DeviceModel) -> MotorizedDoorDoorstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.motorizedDoorDoorstate] as? String,
      let enumAttr: MotorizedDoorDoorstate = MotorizedDoorDoorstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setMotorizedDoorDoorstate(_ doorstate: MotorizedDoorDoorstate, model: DeviceModel) {
    model.set([Attributes.motorizedDoorDoorstate: doorstate.rawValue as AnyObject])
  }
  public func getMotorizedDoorDoorlevel(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.motorizedDoorDoorlevel] as? Int
  }
  
  public func setMotorizedDoorDoorlevel(_ doorlevel: Int, model: DeviceModel) {
    model.set([Attributes.motorizedDoorDoorlevel: doorlevel as AnyObject])
  }
  public func getMotorizedDoorDoorstatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.motorizedDoorDoorstatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
