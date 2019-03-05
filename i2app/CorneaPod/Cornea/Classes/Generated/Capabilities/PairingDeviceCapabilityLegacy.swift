
//
// PairingDeviceCapabilityLegacy.swift
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

public class PairingDeviceCapabilityLegacy: NSObject, ArcusPairingDeviceCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PairingDeviceCapabilityLegacy  = PairingDeviceCapabilityLegacy()
  
  static let PairingDevicePairingStatePAIRING: String = PairingDevicePairingState.pairing.rawValue
  static let PairingDevicePairingStateMISPAIRED: String = PairingDevicePairingState.mispaired.rawValue
  static let PairingDevicePairingStateMISCONFIGURED: String = PairingDevicePairingState.misconfigured.rawValue
  static let PairingDevicePairingStatePAIRED: String = PairingDevicePairingState.paired.rawValue
  
  static let PairingDevicePairingPhaseJOIN: String = PairingDevicePairingPhase.join.rawValue
  static let PairingDevicePairingPhaseCONNECT: String = PairingDevicePairingPhase.connect.rawValue
  static let PairingDevicePairingPhaseIDENTIFY: String = PairingDevicePairingPhase.identify.rawValue
  static let PairingDevicePairingPhasePREPARE: String = PairingDevicePairingPhase.prepare.rawValue
  static let PairingDevicePairingPhaseCONFIGURE: String = PairingDevicePairingPhase.configure.rawValue
  static let PairingDevicePairingPhaseFAILED: String = PairingDevicePairingPhase.failed.rawValue
  static let PairingDevicePairingPhasePAIRED: String = PairingDevicePairingPhase.paired.rawValue
  
  static let PairingDeviceRemoveModeCLOUD: String = PairingDeviceRemoveMode.cloud.rawValue
  static let PairingDeviceRemoveModeHUB_AUTOMATIC: String = PairingDeviceRemoveMode.hub_automatic.rawValue
  static let PairingDeviceRemoveModeHUB_MANUAL: String = PairingDeviceRemoveMode.hub_manual.rawValue
  

  
  public static func getPairingState(_ model: PairingDeviceModel) -> String? {
    return capability.getPairingDevicePairingState(model)?.rawValue
  }
  
  public static func getPairingPhase(_ model: PairingDeviceModel) -> String? {
    return capability.getPairingDevicePairingPhase(model)?.rawValue
  }
  
  public static func getPairingProgress(_ model: PairingDeviceModel) -> NSNumber? {
    guard let pairingProgress: Int = capability.getPairingDevicePairingProgress(model) else {
      return nil
    }
    return NSNumber(value: pairingProgress)
  }
  
  public static func getCustomizations(_ model: PairingDeviceModel) -> [String]? {
    return capability.getPairingDeviceCustomizations(model)
  }
  
  public static func getDeviceAddress(_ model: PairingDeviceModel) -> String? {
    return capability.getPairingDeviceDeviceAddress(model)
  }
  
  public static func getProductAddress(_ model: PairingDeviceModel) -> String? {
    return capability.getPairingDeviceProductAddress(model)
  }
  
  public static func getRemoveMode(_ model: PairingDeviceModel) -> String? {
    return capability.getPairingDeviceRemoveMode(model)?.rawValue
  }
  
  public static func getProtocolAddress(_ model: PairingDeviceModel) -> String? {
    return capability.getPairingDeviceProtocolAddress(model)
  }
  
  public static func customize(_ model: PairingDeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingDeviceCustomize(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func addCustomization(_  model: PairingDeviceModel, customization: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPairingDeviceAddCustomization(model, customization: customization))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func dismiss(_ model: PairingDeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingDeviceDismiss(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func remove(_ model: PairingDeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingDeviceRemove(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func forceRemove(_ model: PairingDeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingDeviceForceRemove(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
