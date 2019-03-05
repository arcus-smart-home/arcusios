
//
// Somfyv1Cap.swift
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
  public static var somfyv1Namespace: String = "somfyv1"
  public static var somfyv1Name: String = "Somfyv1"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let somfyv1Type: String = "somfyv1:type"
  static let somfyv1Reversed: String = "somfyv1:reversed"
  static let somfyv1Channel: String = "somfyv1:channel"
  static let somfyv1Currentstate: String = "somfyv1:currentstate"
  static let somfyv1Statechanged: String = "somfyv1:statechanged"
  
}

public protocol ArcusSomfyv1Capability: class, RxArcusService {
  /** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
  func getSomfyv1Type(_ model: DeviceModel) -> Somfyv1Type?
  /** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
  func setSomfyv1Type(_ type: Somfyv1Type, model: DeviceModel)
/** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
  func getSomfyv1Reversed(_ model: DeviceModel) -> Somfyv1Reversed?
  /** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
  func setSomfyv1Reversed(_ reversed: Somfyv1Reversed, model: DeviceModel)
/** The channel of the Blinds or Shade on the Bridge. */
  func getSomfyv1Channel(_ model: DeviceModel) -> Int?
  /** The current state (position) of the Blinds or Shade reported by the bridge. */
  func getSomfyv1Currentstate(_ model: DeviceModel) -> Somfyv1Currentstate?
  /** UTC time of last state (OPEN/CLOSED/FAVORITE) change. */
  func getSomfyv1Statechanged(_ model: DeviceModel) -> Date?
  
  /** Move the Blinds or Shade to a pre-programmed OPEN position. */
  func requestSomfyv1GoToOpen(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Move the Blinds or Shade to a pre-programmed CLOSED position. */
  func requestSomfyv1GoToClosed(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Move the Blinds or Shade to a pre-programmed FAVORITE position. */
  func requestSomfyv1GoToFavorite(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSomfyv1Capability {
  public func getSomfyv1Type(_ model: DeviceModel) -> Somfyv1Type? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.somfyv1Type] as? String,
      let enumAttr: Somfyv1Type = Somfyv1Type(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSomfyv1Type(_ type: Somfyv1Type, model: DeviceModel) {
    model.set([Attributes.somfyv1Type: type.rawValue as AnyObject])
  }
  public func getSomfyv1Reversed(_ model: DeviceModel) -> Somfyv1Reversed? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.somfyv1Reversed] as? String,
      let enumAttr: Somfyv1Reversed = Somfyv1Reversed(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSomfyv1Reversed(_ reversed: Somfyv1Reversed, model: DeviceModel) {
    model.set([Attributes.somfyv1Reversed: reversed.rawValue as AnyObject])
  }
  public func getSomfyv1Channel(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.somfyv1Channel] as? Int
  }
  
  public func getSomfyv1Currentstate(_ model: DeviceModel) -> Somfyv1Currentstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.somfyv1Currentstate] as? String,
      let enumAttr: Somfyv1Currentstate = Somfyv1Currentstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSomfyv1Statechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.somfyv1Statechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestSomfyv1GoToOpen(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: Somfyv1GoToOpenRequest = Somfyv1GoToOpenRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSomfyv1GoToClosed(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: Somfyv1GoToClosedRequest = Somfyv1GoToClosedRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSomfyv1GoToFavorite(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: Somfyv1GoToFavoriteRequest = Somfyv1GoToFavoriteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
