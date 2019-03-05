
//
// HubCapabilityLegacy.swift
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

public class HubCapabilityLegacy: NSObject, ArcusHubCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubCapabilityLegacy  = HubCapabilityLegacy()
  
  static let HubStateNORMAL: String = HubState.normal.rawValue
  static let HubStatePAIRING: String = HubState.pairing.rawValue
  static let HubStateUNPAIRING: String = HubState.unpairing.rawValue
  static let HubStateDOWN: String = HubState.down.rawValue
  
  static let HubRegistrationStateREGISTERED: String = HubRegistrationState.registered.rawValue
  static let HubRegistrationStateUNREGISTERED: String = HubRegistrationState.unregistered.rawValue
  static let HubRegistrationStateORPHANED: String = HubRegistrationState.orphaned.rawValue
  

  
  public static func getId(_ model: HubModel) -> String? {
    return capability.getHubId(model)
  }
  
  public static func getAccount(_ model: HubModel) -> String? {
    return capability.getHubAccount(model)
  }
  
  public static func getPlace(_ model: HubModel) -> String? {
    return capability.getHubPlace(model)
  }
  
  public static func getName(_ model: HubModel) -> String? {
    return capability.getHubName(model)
  }
  
  public static func setName(_ name: String, model: HubModel) {
    
    
    capability.setHubName(name, model: model)
  }
  
  public static func getImage(_ model: HubModel) -> String? {
    return capability.getHubImage(model)
  }
  
  public static func setImage(_ image: String, model: HubModel) {
    
    
    capability.setHubImage(image, model: model)
  }
  
  public static func getVendor(_ model: HubModel) -> String? {
    return capability.getHubVendor(model)
  }
  
  public static func getModel(_ model: HubModel) -> String? {
    return capability.getHubModel(model)
  }
  
  public static func getState(_ model: HubModel) -> String? {
    return capability.getHubState(model)?.rawValue
  }
  
  public static func getRegistrationState(_ model: HubModel) -> String? {
    return capability.getHubRegistrationState(model)?.rawValue
  }
  
  public static func getTime(_ model: HubModel) -> NSNumber? {
    guard let time: Int = capability.getHubTime(model) else {
      return nil
    }
    return NSNumber(value: time)
  }
  
  public static func getTz(_ model: HubModel) -> String? {
    return capability.getHubTz(model)
  }
  
  public static func setTz(_ tz: String, model: HubModel) {
    
    
    capability.setHubTz(tz, model: model)
  }
  
  public static func pairingRequest(_  model: HubModel, actionType: String, timeout: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubPairingRequest(model, actionType: actionType, timeout: timeout))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func unpairingRequest(_  model: HubModel, actionType: String, timeout: Int, hubProtocol: String, protocolId: String, force: Bool) -> PMKPromise {
  
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubUnpairingRequest(model, actionType: actionType, timeout: timeout, hubProtocol: hubProtocol, protocolId: protocolId, force: force))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHubs(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubListHubs(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func resetLogLevels(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubResetLogLevels(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setLogLevel(_  model: HubModel, level: String, scope: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSetLogLevel(model, level: level, scope: scope))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getLogs(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubGetLogs(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func streamLogs(_  model: HubModel, duration: Int, severity: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubStreamLogs(model, duration: duration, severity: severity))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getConfig(_  model: HubModel, defaults: Bool, matching: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubGetConfig(model, defaults: defaults, matching: matching))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setConfig(_  model: HubModel, config: [String: String]) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSetConfig(model, config: config))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
