
//
// Somfy1Cap.swift
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
  public static var somfy1Namespace: String = "somfy1"
  public static var somfy1Name: String = "Somfy1"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let somfy1Mode: String = "somfy1:mode"
  static let somfy1Reversed: String = "somfy1:reversed"
  
}

public protocol ArcusSomfy1Capability: class, RxArcusService {
  /** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
  func getSomfy1Mode(_ model: DeviceModel) -> Somfy1Mode?
  /** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
  func setSomfy1Mode(_ mode: Somfy1Mode, model: DeviceModel)
/** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
  func getSomfy1Reversed(_ model: DeviceModel) -> Somfy1Reversed?
  /** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
  func setSomfy1Reversed(_ reversed: Somfy1Reversed, model: DeviceModel)

  
}

extension ArcusSomfy1Capability {
  public func getSomfy1Mode(_ model: DeviceModel) -> Somfy1Mode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.somfy1Mode] as? String,
      let enumAttr: Somfy1Mode = Somfy1Mode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSomfy1Mode(_ mode: Somfy1Mode, model: DeviceModel) {
    model.set([Attributes.somfy1Mode: mode.rawValue as AnyObject])
  }
  public func getSomfy1Reversed(_ model: DeviceModel) -> Somfy1Reversed? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.somfy1Reversed] as? String,
      let enumAttr: Somfy1Reversed = Somfy1Reversed(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSomfy1Reversed(_ reversed: Somfy1Reversed, model: DeviceModel) {
    model.set([Attributes.somfy1Reversed: reversed.rawValue as AnyObject])
  }
  
}
