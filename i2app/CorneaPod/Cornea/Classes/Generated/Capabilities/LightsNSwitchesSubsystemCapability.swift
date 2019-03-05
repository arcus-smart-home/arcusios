
//
// LightsNSwitchesSubsystemCap.swift
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
  public static var lightsNSwitchesSubsystemNamespace: String = "sublightsnswitches"
  public static var lightsNSwitchesSubsystemName: String = "LightsNSwitchesSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let lightsNSwitchesSubsystemSwitchDevices: String = "sublightsnswitches:switchDevices"
  static let lightsNSwitchesSubsystemDeviceGroups: String = "sublightsnswitches:deviceGroups"
  static let lightsNSwitchesSubsystemOnDeviceCounts: String = "sublightsnswitches:onDeviceCounts"
  
}

public protocol ArcusLightsNSwitchesSubsystemCapability: class, RxArcusService {
  /** The set of switch devices in the place */
  func getLightsNSwitchesSubsystemSwitchDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of LIGHTS device groups defined at this place */
  func getLightsNSwitchesSubsystemDeviceGroups(_ model: SubsystemModel) -> [String]?
  /** A map of deviceTypeHint to count of devices that are currently on. */
  func getLightsNSwitchesSubsystemOnDeviceCounts(_ model: SubsystemModel) -> [String: Int]?
  
  
}

extension ArcusLightsNSwitchesSubsystemCapability {
  public func getLightsNSwitchesSubsystemSwitchDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lightsNSwitchesSubsystemSwitchDevices] as? [String]
  }
  
  public func getLightsNSwitchesSubsystemDeviceGroups(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lightsNSwitchesSubsystemDeviceGroups] as? [String]
  }
  
  public func getLightsNSwitchesSubsystemOnDeviceCounts(_ model: SubsystemModel) -> [String: Int]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.lightsNSwitchesSubsystemOnDeviceCounts] as? [String: Int]
  }
  
  
}
