
//
// HubReflexCapabilityLegacy.swift
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

public class HubReflexCapabilityLegacy: NSObject, ArcusHubReflexCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubReflexCapabilityLegacy  = HubReflexCapabilityLegacy()
  

  
  public static func getNumDrivers(_ model: HubModel) -> NSNumber? {
    guard let numDrivers: Int = capability.getHubReflexNumDrivers(model) else {
      return nil
    }
    return NSNumber(value: numDrivers)
  }
  
  public static func getDbHash(_ model: HubModel) -> String? {
    return capability.getHubReflexDbHash(model)
  }
  
  public static func getNumDevices(_ model: HubModel) -> NSNumber? {
    guard let numDevices: Int = capability.getHubReflexNumDevices(model) else {
      return nil
    }
    return NSNumber(value: numDevices)
  }
  
  public static func getNumPins(_ model: HubModel) -> NSNumber? {
    guard let numPins: Int = capability.getHubReflexNumPins(model) else {
      return nil
    }
    return NSNumber(value: numPins)
  }
  
  public static func getVersionSupported(_ model: HubModel) -> NSNumber? {
    guard let versionSupported: Int = capability.getHubReflexVersionSupported(model) else {
      return nil
    }
    return NSNumber(value: versionSupported)
  }
  
}
