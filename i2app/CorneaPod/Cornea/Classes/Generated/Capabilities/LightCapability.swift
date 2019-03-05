
//
// LightCap.swift
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
  public static var lightNamespace: String = "light"
  public static var lightName: String = "Light"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let lightColormode: String = "light:colormode"
  
}

public protocol ArcusLightCapability: class, RxArcusService {
  /** Reflects the current color mode of the light (or Normal for non-color devices). */
  func getLightColormode(_ model: DeviceModel) -> LightColormode?
  /** Reflects the current color mode of the light (or Normal for non-color devices). */
  func setLightColormode(_ colormode: LightColormode, model: DeviceModel)

  
}

extension ArcusLightCapability {
  public func getLightColormode(_ model: DeviceModel) -> LightColormode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.lightColormode] as? String,
      let enumAttr: LightColormode = LightColormode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setLightColormode(_ colormode: LightColormode, model: DeviceModel) {
    model.set([Attributes.lightColormode: colormode.rawValue as AnyObject])
  }
  
}
