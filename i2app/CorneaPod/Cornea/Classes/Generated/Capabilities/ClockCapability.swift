
//
// ClockCap.swift
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
  public static var clockNamespace: String = "clock"
  public static var clockName: String = "Clock"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let clockYear: String = "clock:year"
  static let clockMonth: String = "clock:month"
  static let clockDay: String = "clock:day"
  static let clockHour: String = "clock:hour"
  static let clockMinute: String = "clock:minute"
  static let clockSecond: String = "clock:second"
  static let clockDay_of_week: String = "clock:day_of_week"
  
}

public protocol ArcusClockCapability: class, RxArcusService {
  /** Year gregorian calendar */
  func getClockYear(_ model: DeviceModel) -> Int?
  /** Month 1-12 (Jan - Dec) */
  func getClockMonth(_ model: DeviceModel) -> Int?
  /** Day of the month */
  func getClockDay(_ model: DeviceModel) -> Int?
  /** Hour of the day 0-23.  Midnight = 0 */
  func getClockHour(_ model: DeviceModel) -> Int?
  /** Minute of the hour */
  func getClockMinute(_ model: DeviceModel) -> Int?
  /** Second of the minute */
  func getClockSecond(_ model: DeviceModel) -> Int?
  /** Day of the week */
  func getClockDay_of_week(_ model: DeviceModel) -> Int?
  
  
}

extension ArcusClockCapability {
  public func getClockYear(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.clockYear] as? Int
  }
  
  public func getClockMonth(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.clockMonth] as? Int
  }
  
  public func getClockDay(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.clockDay] as? Int
  }
  
  public func getClockHour(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.clockHour] as? Int
  }
  
  public func getClockMinute(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.clockMinute] as? Int
  }
  
  public func getClockSecond(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.clockSecond] as? Int
  }
  
  public func getClockDay_of_week(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.clockDay_of_week] as? Int
  }
  
  
}
