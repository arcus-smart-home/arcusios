
//
// Hub4gCapabilityLegacy.swift
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

public class Hub4gCapabilityLegacy: NSObject, ArcusHub4gCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: Hub4gCapabilityLegacy  = Hub4gCapabilityLegacy()
  
  static let Hub4gConnectionStateCONNECTING: String = Hub4gConnectionState.connecting.rawValue
  static let Hub4gConnectionStateCONNECTED: String = Hub4gConnectionState.connected.rawValue
  static let Hub4gConnectionStateDISCONNECTING: String = Hub4gConnectionState.disconnecting.rawValue
  static let Hub4gConnectionStateDISCONNECTED: String = Hub4gConnectionState.disconnected.rawValue
  

  
  public static func getPresent(_ model: HubModel) -> NSNumber? {
    guard let present: Bool = capability.getHub4gPresent(model) else {
      return nil
    }
    return NSNumber(value: present)
  }
  
  public static func getSimPresent(_ model: HubModel) -> NSNumber? {
    guard let simPresent: Bool = capability.getHub4gSimPresent(model) else {
      return nil
    }
    return NSNumber(value: simPresent)
  }
  
  public static func getSimProvisioned(_ model: HubModel) -> NSNumber? {
    guard let simProvisioned: Bool = capability.getHub4gSimProvisioned(model) else {
      return nil
    }
    return NSNumber(value: simProvisioned)
  }
  
  public static func getSimDisabled(_ model: HubModel) -> NSNumber? {
    guard let simDisabled: Bool = capability.getHub4gSimDisabled(model) else {
      return nil
    }
    return NSNumber(value: simDisabled)
  }
  
  public static func getSimDisabledDate(_ model: HubModel) -> Date? {
    guard let simDisabledDate: Date = capability.getHub4gSimDisabledDate(model) else {
      return nil
    }
    return simDisabledDate
  }
  
  public static func getConnectionState(_ model: HubModel) -> String? {
    return capability.getHub4gConnectionState(model)?.rawValue
  }
  
  public static func getVendor(_ model: HubModel) -> String? {
    return capability.getHub4gVendor(model)
  }
  
  public static func getModel(_ model: HubModel) -> String? {
    return capability.getHub4gModel(model)
  }
  
  public static func getSerialNumber(_ model: HubModel) -> String? {
    return capability.getHub4gSerialNumber(model)
  }
  
  public static func getImei(_ model: HubModel) -> String? {
    return capability.getHub4gImei(model)
  }
  
  public static func getImsi(_ model: HubModel) -> String? {
    return capability.getHub4gImsi(model)
  }
  
  public static func getIccid(_ model: HubModel) -> String? {
    return capability.getHub4gIccid(model)
  }
  
  public static func getPhoneNumber(_ model: HubModel) -> String? {
    return capability.getHub4gPhoneNumber(model)
  }
  
  public static func getMode(_ model: HubModel) -> String? {
    return capability.getHub4gMode(model)
  }
  
  public static func getSignalBars(_ model: HubModel) -> NSNumber? {
    guard let signalBars: Int = capability.getHub4gSignalBars(model) else {
      return nil
    }
    return NSNumber(value: signalBars)
  }
  
  public static func getConnectionStatus(_ model: HubModel) -> String? {
    return capability.getHub4gConnectionStatus(model)
  }
  
  public static func getInfo(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHub4gGetInfo(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func resetStatistics(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHub4gResetStatistics(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getStatistics(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHub4gGetStatistics(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
