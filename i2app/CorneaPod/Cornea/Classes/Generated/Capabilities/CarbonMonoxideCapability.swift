
//
// CarbonMonoxideCap.swift
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
  public static var carbonMonoxideNamespace: String = "co"
  public static var carbonMonoxideName: String = "CarbonMonoxide"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let carbonMonoxideCo: String = "co:co"
  static let carbonMonoxideEol: String = "co:eol"
  static let carbonMonoxideCochanged: String = "co:cochanged"
  static let carbonMonoxideCoppm: String = "co:coppm"
  
}

public protocol ArcusCarbonMonoxideCapability: class, RxArcusService {
  /** Reflects the state of the carbon monoxide presence. When &#x27;DETECTED&#x27; the sensor has detected CO, when &#x27;SAFE&#x27; no CO has been detected. */
  func getCarbonMonoxideCo(_ model: DeviceModel) -> CarbonMonoxideCo?
  /** Reflects the state of the carbon monoxide sensor itself. When &#x27;OK&#x27; the sensor is operational, when &#x27;EOL&#x27; the sensor has reached its &#x27;end-of-life&#x27; and should be replaced. */
  func getCarbonMonoxideEol(_ model: DeviceModel) -> CarbonMonoxideEol?
  /** UTC date time of last co change */
  func getCarbonMonoxideCochanged(_ model: DeviceModel) -> Date?
  /** Measured value of the Carbon Monoxide in the room in parts per million */
  func getCarbonMonoxideCoppm(_ model: DeviceModel) -> Int?
  
  
}

extension ArcusCarbonMonoxideCapability {
  public func getCarbonMonoxideCo(_ model: DeviceModel) -> CarbonMonoxideCo? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.carbonMonoxideCo] as? String,
      let enumAttr: CarbonMonoxideCo = CarbonMonoxideCo(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getCarbonMonoxideEol(_ model: DeviceModel) -> CarbonMonoxideEol? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.carbonMonoxideEol] as? String,
      let enumAttr: CarbonMonoxideEol = CarbonMonoxideEol(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getCarbonMonoxideCochanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.carbonMonoxideCochanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getCarbonMonoxideCoppm(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.carbonMonoxideCoppm] as? Int
  }
  
  
}
