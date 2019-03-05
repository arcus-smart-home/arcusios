
//
// ClockCapabilityLegacy.swift
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
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class ClockCapabilityLegacy: NSObject, ArcusClockCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ClockCapabilityLegacy  = ClockCapabilityLegacy()
  

  
  public static func getYear(_ model: DeviceModel) -> NSNumber? {
    guard let year: Int = capability.getClockYear(model) else {
      return nil
    }
    return NSNumber(value: year)
  }
  
  public static func getMonth(_ model: DeviceModel) -> NSNumber? {
    guard let month: Int = capability.getClockMonth(model) else {
      return nil
    }
    return NSNumber(value: month)
  }
  
  public static func getDay(_ model: DeviceModel) -> NSNumber? {
    guard let day: Int = capability.getClockDay(model) else {
      return nil
    }
    return NSNumber(value: day)
  }
  
  public static func getHour(_ model: DeviceModel) -> NSNumber? {
    guard let hour: Int = capability.getClockHour(model) else {
      return nil
    }
    return NSNumber(value: hour)
  }
  
  public static func getMinute(_ model: DeviceModel) -> NSNumber? {
    guard let minute: Int = capability.getClockMinute(model) else {
      return nil
    }
    return NSNumber(value: minute)
  }
  
  public static func getSecond(_ model: DeviceModel) -> NSNumber? {
    guard let second: Int = capability.getClockSecond(model) else {
      return nil
    }
    return NSNumber(value: second)
  }
  
  public static func getDay_of_week(_ model: DeviceModel) -> NSNumber? {
    guard let day_of_week: Int = capability.getClockDay_of_week(model) else {
      return nil
    }
    return NSNumber(value: day_of_week)
  }
  
}
