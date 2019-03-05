
//
// RelativeHumidityCap.swift
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
  public static var relativeHumidityNamespace: String = "humid"
  public static var relativeHumidityName: String = "RelativeHumidity"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let relativeHumidityHumidity: String = "humid:humidity"
  
}

public protocol ArcusRelativeHumidityCapability: class, RxArcusService {
  /** Reflects the relative humidity */
  func getRelativeHumidityHumidity(_ model: DeviceModel) -> Double?
  
  
}

extension ArcusRelativeHumidityCapability {
  public func getRelativeHumidityHumidity(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.relativeHumidityHumidity] as? Double
  }
  
  
}
