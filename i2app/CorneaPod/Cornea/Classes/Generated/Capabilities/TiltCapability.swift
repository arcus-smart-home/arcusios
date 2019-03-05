
//
// TiltCap.swift
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
  public static var tiltNamespace: String = "tilt"
  public static var tiltName: String = "Tilt"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let tiltTiltstate: String = "tilt:tiltstate"
  static let tiltTiltstatechanged: String = "tilt:tiltstatechanged"
  
}

public protocol ArcusTiltCapability: class, RxArcusService {
  /** Reflects the current state of the tilt sensor. */
  func getTiltTiltstate(_ model: DeviceModel) -> TiltTiltstate?
  /** Reflects the current state of the tilt sensor. */
  func setTiltTiltstate(_ tiltstate: TiltTiltstate, model: DeviceModel)
/** UTC date time of last tilt state change */
  func getTiltTiltstatechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusTiltCapability {
  public func getTiltTiltstate(_ model: DeviceModel) -> TiltTiltstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.tiltTiltstate] as? String,
      let enumAttr: TiltTiltstate = TiltTiltstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setTiltTiltstate(_ tiltstate: TiltTiltstate, model: DeviceModel) {
    model.set([Attributes.tiltTiltstate: tiltstate.rawValue as AnyObject])
  }
  public func getTiltTiltstatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.tiltTiltstatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
