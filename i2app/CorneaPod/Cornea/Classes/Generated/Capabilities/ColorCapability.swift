
//
// ColorCap.swift
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
  public static var colorNamespace: String = "color"
  public static var colorName: String = "Color"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let colorHue: String = "color:hue"
  static let colorSaturation: String = "color:saturation"
  
}

public protocol ArcusColorCapability: class, RxArcusService {
  /** Reflects the current hue or for lack of a better word color. May also be used to set the hue. Range is 0-360 angular degrees. */
  func getColorHue(_ model: DeviceModel) -> Int?
  /** Reflects the current hue or for lack of a better word color. May also be used to set the hue. Range is 0-360 angular degrees. */
  func setColorHue(_ hue: Int, model: DeviceModel)
/** The saturation or intensity of the hue. Lower values result in less intensity (more gray) and higher values result in a more intense hue (less gray). May also be used to set the saturation. */
  func getColorSaturation(_ model: DeviceModel) -> Int?
  /** The saturation or intensity of the hue. Lower values result in less intensity (more gray) and higher values result in a more intense hue (less gray). May also be used to set the saturation. */
  func setColorSaturation(_ saturation: Int, model: DeviceModel)

  
}

extension ArcusColorCapability {
  public func getColorHue(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.colorHue] as? Int
  }
  
  public func setColorHue(_ hue: Int, model: DeviceModel) {
    model.set([Attributes.colorHue: hue as AnyObject])
  }
  public func getColorSaturation(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.colorSaturation] as? Int
  }
  
  public func setColorSaturation(_ saturation: Int, model: DeviceModel) {
    model.set([Attributes.colorSaturation: saturation as AnyObject])
  }
  
}
