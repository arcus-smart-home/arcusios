
//
// IpInfoCap.swift
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
  public static var ipInfoNamespace: String = "ipinfo"
  public static var ipInfoName: String = "IpInfo"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let ipInfoIp: String = "ipinfo:ip"
  static let ipInfoMac: String = "ipinfo:mac"
  static let ipInfoNetmask: String = "ipinfo:netmask"
  static let ipInfoGateway: String = "ipinfo:gateway"
  
}

public protocol ArcusIpInfoCapability: class, RxArcusService {
  /** Current local IP address */
  func getIpInfoIp(_ model: DeviceModel) -> String?
  /** MAC Address */
  func getIpInfoMac(_ model: DeviceModel) -> String?
  /** Current network mask */
  func getIpInfoNetmask(_ model: DeviceModel) -> String?
  /** Current gateway IP address */
  func getIpInfoGateway(_ model: DeviceModel) -> String?
  
  
}

extension ArcusIpInfoCapability {
  public func getIpInfoIp(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ipInfoIp] as? String
  }
  
  public func getIpInfoMac(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ipInfoMac] as? String
  }
  
  public func getIpInfoNetmask(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ipInfoNetmask] as? String
  }
  
  public func getIpInfoGateway(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ipInfoGateway] as? String
  }
  
  
}
