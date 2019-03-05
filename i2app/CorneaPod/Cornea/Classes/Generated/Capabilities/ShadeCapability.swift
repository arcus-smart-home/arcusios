
//
// ShadeCap.swift
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
  public static var shadeNamespace: String = "shade"
  public static var shadeName: String = "Shade"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let shadeLevel: String = "shade:level"
  static let shadeShadestate: String = "shade:shadestate"
  static let shadeLevelchanged: String = "shade:levelchanged"
  
}

public protocol ArcusShadeCapability: class, RxArcusService {
  /** The percentage that the shades are open (raised/lowered). May also be used to set how closed (lowered) or open (raised) the shade is where 100% is fully open and 0% is fully closed. For devices that only support being set fully Open (Raised) or Closed (Lowered), use 0% for Closed (Lowered) and 100% for Open (Raised). */
  func getShadeLevel(_ model: DeviceModel) -> Int?
  /** The percentage that the shades are open (raised/lowered). May also be used to set how closed (lowered) or open (raised) the shade is where 100% is fully open and 0% is fully closed. For devices that only support being set fully Open (Raised) or Closed (Lowered), use 0% for Closed (Lowered) and 100% for Open (Raised). */
  func setShadeLevel(_ level: Int, model: DeviceModel)
/** Reflects the current state of the shade.  Obstruction implying that something is preventing the opening or closing of the shade. */
  func getShadeShadestate(_ model: DeviceModel) -> ShadeShadestate?
  /** UTC time of last level change. */
  func getShadeLevelchanged(_ model: DeviceModel) -> Date?
  
  /** Move the shade to a pre-programmed OPEN position. */
  func requestShadeGoToOpen(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Move the shade to a pre-programmed CLOSED position. */
  func requestShadeGoToClosed(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Move the shade to a pre-programmed FAVORITE position. */
  func requestShadeGoToFavorite(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusShadeCapability {
  public func getShadeLevel(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.shadeLevel] as? Int
  }
  
  public func setShadeLevel(_ level: Int, model: DeviceModel) {
    model.set([Attributes.shadeLevel: level as AnyObject])
  }
  public func getShadeShadestate(_ model: DeviceModel) -> ShadeShadestate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.shadeShadestate] as? String,
      let enumAttr: ShadeShadestate = ShadeShadestate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getShadeLevelchanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.shadeLevelchanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestShadeGoToOpen(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: ShadeGoToOpenRequest = ShadeGoToOpenRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestShadeGoToClosed(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: ShadeGoToClosedRequest = ShadeGoToClosedRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestShadeGoToFavorite(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: ShadeGoToFavoriteRequest = ShadeGoToFavoriteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
