
//
// HueBridgeCapabilityLegacy.swift
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

public class HueBridgeCapabilityLegacy: NSObject, ArcusHueBridgeCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HueBridgeCapabilityLegacy  = HueBridgeCapabilityLegacy()
  

  
  public static func getIpaddress(_ model: DeviceModel) -> String? {
    return capability.getHueBridgeIpaddress(model)
  }
  
  public static func getMac(_ model: DeviceModel) -> String? {
    return capability.getHueBridgeMac(model)
  }
  
  public static func getApiversion(_ model: DeviceModel) -> String? {
    return capability.getHueBridgeApiversion(model)
  }
  
  public static func getSwversion(_ model: DeviceModel) -> String? {
    return capability.getHueBridgeSwversion(model)
  }
  
  public static func getZigbeechannel(_ model: DeviceModel) -> String? {
    return capability.getHueBridgeZigbeechannel(model)
  }
  
  public static func getModel(_ model: DeviceModel) -> String? {
    return capability.getHueBridgeModel(model)
  }
  
  public static func getBridgeid(_ model: DeviceModel) -> String? {
    return capability.getHueBridgeBridgeid(model)
  }
  
}
