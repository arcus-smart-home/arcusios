
//
// SmokeCap.swift
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
  public static var smokeNamespace: String = "smoke"
  public static var smokeName: String = "Smoke"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let smokeSmoke: String = "smoke:smoke"
  static let smokeSmokechanged: String = "smoke:smokechanged"
  
}

public protocol ArcusSmokeCapability: class, RxArcusService {
  /** Reflects the current state of the smoke detector (safe,detected). */
  func getSmokeSmoke(_ model: DeviceModel) -> SmokeSmoke?
  /** UTC date time of last smoke change */
  func getSmokeSmokechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusSmokeCapability {
  public func getSmokeSmoke(_ model: DeviceModel) -> SmokeSmoke? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.smokeSmoke] as? String,
      let enumAttr: SmokeSmoke = SmokeSmoke(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSmokeSmokechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.smokeSmokechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
