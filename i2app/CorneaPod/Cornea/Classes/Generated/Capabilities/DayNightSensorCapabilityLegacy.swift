
//
// DayNightSensorCapabilityLegacy.swift
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

public class DayNightSensorCapabilityLegacy: NSObject, ArcusDayNightSensorCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: DayNightSensorCapabilityLegacy  = DayNightSensorCapabilityLegacy()
  
  static let DayNightSensorModeDAY: String = DayNightSensorMode.day.rawValue
  static let DayNightSensorModeNIGHT: String = DayNightSensorMode.night.rawValue
  

  
  public static func getMode(_ model: DeviceModel) -> String? {
    return capability.getDayNightSensorMode(model)?.rawValue
  }
  
  public static func getModechanged(_ model: DeviceModel) -> Date? {
    guard let modechanged: Date = capability.getDayNightSensorModechanged(model) else {
      return nil
    }
    return modechanged
  }
  
}
