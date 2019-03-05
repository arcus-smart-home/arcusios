
//
// HubPowerCapabilityLegacy.swift
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

public class HubPowerCapabilityLegacy: NSObject, ArcusHubPowerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubPowerCapabilityLegacy  = HubPowerCapabilityLegacy()
  
  static let HubPowerSourceMAINS: String = HubPowerSource.mains.rawValue
  static let HubPowerSourceBATTERY: String = HubPowerSource.battery.rawValue
  

  
  public static func getSource(_ model: HubModel) -> String? {
    return capability.getHubPowerSource(model)?.rawValue
  }
  
  public static func getMainscpable(_ model: HubModel) -> NSNumber? {
    guard let mainscpable: Bool = capability.getHubPowerMainscpable(model) else {
      return nil
    }
    return NSNumber(value: mainscpable)
  }
  
  public static func getBattery(_ model: HubModel) -> NSNumber? {
    guard let Battery: Int = capability.getHubPowerBattery(model) else {
      return nil
    }
    return NSNumber(value: Battery)
  }
  
}
