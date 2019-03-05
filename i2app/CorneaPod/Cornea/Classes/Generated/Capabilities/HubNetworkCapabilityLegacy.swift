
//
// HubNetworkCapabilityLegacy.swift
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

public class HubNetworkCapabilityLegacy: NSObject, ArcusHubNetworkCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubNetworkCapabilityLegacy  = HubNetworkCapabilityLegacy()
  
  static let HubNetworkTypeETH: String = HubNetworkType.eth.rawValue
  static let HubNetworkType3G: String = HubNetworkType._3g.rawValue
  static let HubNetworkTypeWIFI: String = HubNetworkType.wifi.rawValue
  

  
  public static func getType(_ model: HubModel) -> String? {
    return capability.getHubNetworkType(model)?.rawValue
  }
  
  public static func getUptime(_ model: HubModel) -> NSNumber? {
    guard let uptime: Int = capability.getHubNetworkUptime(model) else {
      return nil
    }
    return NSNumber(value: uptime)
  }
  
  public static func getIp(_ model: HubModel) -> String? {
    return capability.getHubNetworkIp(model)
  }
  
  public static func getExternalip(_ model: HubModel) -> String? {
    return capability.getHubNetworkExternalip(model)
  }
  
  public static func getNetmask(_ model: HubModel) -> String? {
    return capability.getHubNetworkNetmask(model)
  }
  
  public static func getGateway(_ model: HubModel) -> String? {
    return capability.getHubNetworkGateway(model)
  }
  
  public static func getDns(_ model: HubModel) -> String? {
    return capability.getHubNetworkDns(model)
  }
  
  public static func getInterfaces(_ model: HubModel) -> [String]? {
    return capability.getHubNetworkInterfaces(model)
  }
  
  public static func getRoutingTable(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubNetworkGetRoutingTable(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
