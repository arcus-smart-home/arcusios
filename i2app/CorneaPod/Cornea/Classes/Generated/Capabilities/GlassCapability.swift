
//
// GlassCap.swift
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
  public static var glassNamespace: String = "glass"
  public static var glassName: String = "Glass"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let glassBreak: String = "glass:break"
  static let glassBreakchanged: String = "glass:breakchanged"
  
}

public protocol ArcusGlassCapability: class, RxArcusService {
  /** Reflects the current state of the glass break sensor. */
  func getGlassBreak(_ model: DeviceModel) -> GlassBreak?
  /** UTC date time of last break change */
  func getGlassBreakchanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusGlassCapability {
  public func getGlassBreak(_ model: DeviceModel) -> GlassBreak? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.glassBreak] as? String,
      let enumAttr: GlassBreak = GlassBreak(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getGlassBreakchanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.glassBreakchanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
