
//
// BridgeCapabilityLegacy.swift
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

public class BridgeCapabilityLegacy: NSObject, ArcusBridgeCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: BridgeCapabilityLegacy  = BridgeCapabilityLegacy()
  
  static let BridgePairingStatePAIRING: String = BridgePairingState.pairing.rawValue
  static let BridgePairingStateUNPAIRING: String = BridgePairingState.unpairing.rawValue
  static let BridgePairingStateIDLE: String = BridgePairingState.idle.rawValue
  

  
  public static func getPairedDevices(_ model: DeviceModel) -> [String: String]? {
    return capability.getBridgePairedDevices(model)
  }
  
  public static func getUnpairedDevices(_ model: DeviceModel) -> [String]? {
    return capability.getBridgeUnpairedDevices(model)
  }
  
  public static func getPairingState(_ model: DeviceModel) -> String? {
    return capability.getBridgePairingState(model)?.rawValue
  }
  
  public static func getNumDevicesSupported(_ model: DeviceModel) -> NSNumber? {
    guard let numDevicesSupported: Int = capability.getBridgeNumDevicesSupported(model) else {
      return nil
    }
    return NSNumber(value: numDevicesSupported)
  }
  
  public static func startPairing(_  model: DeviceModel, timeout: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestBridgeStartPairing(model, timeout: timeout))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func stopPairing(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestBridgeStopPairing(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
