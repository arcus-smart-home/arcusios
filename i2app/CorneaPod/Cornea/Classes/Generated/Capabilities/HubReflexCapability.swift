
//
// HubReflexCap.swift
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
  public static var hubReflexNamespace: String = "hubrflx"
  public static var hubReflexName: String = "HubReflex"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubReflexNumDrivers: String = "hubrflx:numDrivers"
  static let hubReflexDbHash: String = "hubrflx:dbHash"
  static let hubReflexNumDevices: String = "hubrflx:numDevices"
  static let hubReflexNumPins: String = "hubrflx:numPins"
  static let hubReflexVersionSupported: String = "hubrflx:versionSupported"
  
}

public protocol ArcusHubReflexCapability: class, RxArcusService {
  /** The number of drivers present in the hub&#x27;s current driver database. */
  func getHubReflexNumDrivers(_ model: HubModel) -> Int?
  /** A hash value over the contents of the hub&#x27;s current driver database. */
  func getHubReflexDbHash(_ model: HubModel) -> String?
  /** The number of devices on the hub that are running reflexes. */
  func getHubReflexNumDevices(_ model: HubModel) -> Int?
  /** The number of user pins on the hub that are running reflexes. */
  func getHubReflexNumPins(_ model: HubModel) -> Int?
  /** The version of hub local reflexes currently supported by the hub. */
  func getHubReflexVersionSupported(_ model: HubModel) -> Int?
  
  
}

extension ArcusHubReflexCapability {
  public func getHubReflexNumDrivers(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubReflexNumDrivers] as? Int
  }
  
  public func getHubReflexDbHash(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubReflexDbHash] as? String
  }
  
  public func getHubReflexNumDevices(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubReflexNumDevices] as? Int
  }
  
  public func getHubReflexNumPins(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubReflexNumPins] as? Int
  }
  
  public func getHubReflexVersionSupported(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubReflexVersionSupported] as? Int
  }
  
  
}
