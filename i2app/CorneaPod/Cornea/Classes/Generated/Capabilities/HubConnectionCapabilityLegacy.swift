
//
// HubConnectionCapabilityLegacy.swift
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

public class HubConnectionCapabilityLegacy: NSObject, ArcusHubConnectionCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubConnectionCapabilityLegacy  = HubConnectionCapabilityLegacy()
  
  static let HubConnectionStateONLINE: String = HubConnectionState.online.rawValue
  static let HubConnectionStateHANDSHAKE: String = HubConnectionState.handshake.rawValue
  static let HubConnectionStateOFFLINE: String = HubConnectionState.offline.rawValue
  

  
  public static func getState(_ model: HubModel) -> String? {
    return capability.getHubConnectionState(model)?.rawValue
  }
  
  public static func getLastchange(_ model: HubModel) -> Date? {
    guard let lastchange: Date = capability.getHubConnectionLastchange(model) else {
      return nil
    }
    return lastchange
  }
  
  public static func getConnQuality(_ model: HubModel) -> NSNumber? {
    guard let connQuality: Int = capability.getHubConnectionConnQuality(model) else {
      return nil
    }
    return NSNumber(value: connQuality)
  }
  
  public static func getPingTime(_ model: HubModel) -> NSNumber? {
    guard let pingTime: Int = capability.getHubConnectionPingTime(model) else {
      return nil
    }
    return NSNumber(value: pingTime)
  }
  
  public static func getPingResponse(_ model: HubModel) -> NSNumber? {
    guard let pingResponse: Int = capability.getHubConnectionPingResponse(model) else {
      return nil
    }
    return NSNumber(value: pingResponse)
  }
  
}
