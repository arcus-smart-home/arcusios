
//
// HueBridgeCap.swift
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
  public static var hueBridgeNamespace: String = "huebridge"
  public static var hueBridgeName: String = "HueBridge"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hueBridgeIpaddress: String = "huebridge:ipaddress"
  static let hueBridgeMac: String = "huebridge:mac"
  static let hueBridgeApiversion: String = "huebridge:apiversion"
  static let hueBridgeSwversion: String = "huebridge:swversion"
  static let hueBridgeZigbeechannel: String = "huebridge:zigbeechannel"
  static let hueBridgeModel: String = "huebridge:model"
  static let hueBridgeBridgeid: String = "huebridge:bridgeid"
  
}

public protocol ArcusHueBridgeCapability: class, RxArcusService {
  /** Ip address of the hue bridge */
  func getHueBridgeIpaddress(_ model: DeviceModel) -> String?
  /** Mac address of the hue bridge ethernet port */
  func getHueBridgeMac(_ model: DeviceModel) -> String?
  /** Api version of the hue bridge */
  func getHueBridgeApiversion(_ model: DeviceModel) -> String?
  /** Software version of the hue bridge */
  func getHueBridgeSwversion(_ model: DeviceModel) -> String?
  /** Zigbee channel of hte hue bridge */
  func getHueBridgeZigbeechannel(_ model: DeviceModel) -> String?
  /** Model id of the hue bridge */
  func getHueBridgeModel(_ model: DeviceModel) -> String?
  /** Id of the hue bridge */
  func getHueBridgeBridgeid(_ model: DeviceModel) -> String?
  
  
}

extension ArcusHueBridgeCapability {
  public func getHueBridgeIpaddress(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hueBridgeIpaddress] as? String
  }
  
  public func getHueBridgeMac(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hueBridgeMac] as? String
  }
  
  public func getHueBridgeApiversion(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hueBridgeApiversion] as? String
  }
  
  public func getHueBridgeSwversion(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hueBridgeSwversion] as? String
  }
  
  public func getHueBridgeZigbeechannel(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hueBridgeZigbeechannel] as? String
  }
  
  public func getHueBridgeModel(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hueBridgeModel] as? String
  }
  
  public func getHueBridgeBridgeid(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hueBridgeBridgeid] as? String
  }
  
  
}
