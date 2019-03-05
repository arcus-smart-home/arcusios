
//
// TwinStarCap.swift
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
  public static var twinStarNamespace: String = "twinstar"
  public static var twinStarName: String = "TwinStar"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let twinStarEcomode: String = "twinstar:ecomode"
  
}

public protocol ArcusTwinStarCapability: class, RxArcusService {
  /** If enabled the heater will reduce power consumption to save energy. */
  func getTwinStarEcomode(_ model: DeviceModel) -> TwinStarEcomode?
  /** If enabled the heater will reduce power consumption to save energy. */
  func setTwinStarEcomode(_ ecomode: TwinStarEcomode, model: DeviceModel)

  
}

extension ArcusTwinStarCapability {
  public func getTwinStarEcomode(_ model: DeviceModel) -> TwinStarEcomode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.twinStarEcomode] as? String,
      let enumAttr: TwinStarEcomode = TwinStarEcomode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setTwinStarEcomode(_ ecomode: TwinStarEcomode, model: DeviceModel) {
    model.set([Attributes.twinStarEcomode: ecomode.rawValue as AnyObject])
  }
  
}
