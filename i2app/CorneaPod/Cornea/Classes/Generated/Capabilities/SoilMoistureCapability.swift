
//
// SoilMoistureCap.swift
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
  public static var soilMoistureNamespace: String = "soilmoisture"
  public static var soilMoistureName: String = "SoilMoisture"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let soilMoistureWatercontent: String = "soilmoisture:watercontent"
  static let soilMoistureSoiltype: String = "soilmoisture:soiltype"
  static let soilMoistureWatercontentupdated: String = "soilmoisture:watercontentupdated"
  
}

public protocol ArcusSoilMoistureCapability: class, RxArcusService {
  /** Reflects the ratio of volume of water per volume of soil (0.0 = No Moisture, 0.5 = Completely Saturated). */
  func getSoilMoistureWatercontent(_ model: DeviceModel) -> Double?
  /** Reflects the type of soil in which the water content is being measured. Defaults to NORMAL. */
  func getSoilMoistureSoiltype(_ model: DeviceModel) -> SoilMoistureSoiltype?
  /** Reflects the type of soil in which the water content is being measured. Defaults to NORMAL. */
  func setSoilMoistureSoiltype(_ soiltype: SoilMoistureSoiltype, model: DeviceModel)
/** UTC date time of when Water Content value was reported by sensor. */
  func getSoilMoistureWatercontentupdated(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusSoilMoistureCapability {
  public func getSoilMoistureWatercontent(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.soilMoistureWatercontent] as? Double
  }
  
  public func getSoilMoistureSoiltype(_ model: DeviceModel) -> SoilMoistureSoiltype? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.soilMoistureSoiltype] as? String,
      let enumAttr: SoilMoistureSoiltype = SoilMoistureSoiltype(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSoilMoistureSoiltype(_ soiltype: SoilMoistureSoiltype, model: DeviceModel) {
    model.set([Attributes.soilMoistureSoiltype: soiltype.rawValue as AnyObject])
  }
  public func getSoilMoistureWatercontentupdated(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.soilMoistureWatercontentupdated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
