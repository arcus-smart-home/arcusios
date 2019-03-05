
//
// PairingSubsystemCapabilityLegacy.swift
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

public class PairingSubsystemCapabilityLegacy: NSObject, ArcusPairingSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PairingSubsystemCapabilityLegacy  = PairingSubsystemCapabilityLegacy()
  
  static let PairingSubsystemPairingModeIDLE: String = PairingSubsystemPairingMode.idle.rawValue
  static let PairingSubsystemPairingModeHUB: String = PairingSubsystemPairingMode.hub.rawValue
  static let PairingSubsystemPairingModeCLOUD: String = PairingSubsystemPairingMode.cloud.rawValue
  static let PairingSubsystemPairingModeOAUTH: String = PairingSubsystemPairingMode.oauth.rawValue
  static let PairingSubsystemPairingModeHUB_UNPAIRING: String = PairingSubsystemPairingMode.hub_unpairing.rawValue
  

  
  public static func getPairingMode(_ model: SubsystemModel) -> String? {
    return capability.getPairingSubsystemPairingMode(model)?.rawValue
  }
  
  public static func getPairingModeChanged(_ model: SubsystemModel) -> Date? {
    guard let pairingModeChanged: Date = capability.getPairingSubsystemPairingModeChanged(model) else {
      return nil
    }
    return pairingModeChanged
  }
  
  public static func getPairingDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getPairingSubsystemPairingDevices(model)
  }
  
  public static func getSearchProductAddress(_ model: SubsystemModel) -> String? {
    return capability.getPairingSubsystemSearchProductAddress(model)
  }
  
  public static func getSearchDeviceFound(_ model: SubsystemModel) -> NSNumber? {
    guard let searchDeviceFound: Bool = capability.getPairingSubsystemSearchDeviceFound(model) else {
      return nil
    }
    return NSNumber(value: searchDeviceFound)
  }
  
  public static func getSearchIdle(_ model: SubsystemModel) -> NSNumber? {
    guard let searchIdle: Bool = capability.getPairingSubsystemSearchIdle(model) else {
      return nil
    }
    return NSNumber(value: searchIdle)
  }
  
  public static func getSearchIdleTimeout(_ model: SubsystemModel) -> Date? {
    guard let searchIdleTimeout: Date = capability.getPairingSubsystemSearchIdleTimeout(model) else {
      return nil
    }
    return searchIdleTimeout
  }
  
  public static func getSearchTimeout(_ model: SubsystemModel) -> Date? {
    guard let searchTimeout: Date = capability.getPairingSubsystemSearchTimeout(model) else {
      return nil
    }
    return searchTimeout
  }
  
  public static func listPairingDevices(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingSubsystemListPairingDevices(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func startPairing(_  model: SubsystemModel, productAddress: String, mock: Bool) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPairingSubsystemStartPairing(model, productAddress: productAddress, mock: mock))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func search(_  model: SubsystemModel, productAddress: String, form: [String: String]) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPairingSubsystemSearch(model, productAddress: productAddress, form: form))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHelpSteps(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingSubsystemListHelpSteps(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func dismissAll(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingSubsystemDismissAll(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func stopSearching(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingSubsystemStopSearching(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func factoryReset(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingSubsystemFactoryReset(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getKitInformation(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPairingSubsystemGetKitInformation(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
