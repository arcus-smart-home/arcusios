
//
// HubZwaveCapabilityLegacy.swift
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

public class HubZwaveCapabilityLegacy: NSObject, ArcusHubZwaveCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubZwaveCapabilityLegacy  = HubZwaveCapabilityLegacy()
  
  static let HubZwaveStateINIT: String = HubZwaveState.hubZwaveInit.rawValue
  static let HubZwaveStateNORMAL: String = HubZwaveState.normal.rawValue
  static let HubZwaveStatePAIRING: String = HubZwaveState.pairing.rawValue
  static let HubZwaveStateUNPAIRING: String = HubZwaveState.unpairing.rawValue
  
  static let HubZwaveHealFinishReasonSUCCESS: String = HubZwaveHealFinishReason.success.rawValue
  static let HubZwaveHealFinishReasonCANCEL: String = HubZwaveHealFinishReason.cancel.rawValue
  static let HubZwaveHealFinishReasonTERMINATED: String = HubZwaveHealFinishReason.terminated.rawValue
  

  
  public static func getHardware(_ model: HubZwaveModel) -> String? {
    return capability.getHubZwaveHardware(model)
  }
  
  public static func getFirmware(_ model: HubZwaveModel) -> String? {
    return capability.getHubZwaveFirmware(model)
  }
  
  public static func getProtocol(_ model: HubZwaveModel) -> String? {
    return capability.getHubZwaveProtocol(model)
  }
  
  public static func getHomeId(_ model: HubZwaveModel) -> String? {
    return capability.getHubZwaveHomeId(model)
  }
  
  public static func getNumDevices(_ model: HubZwaveModel) -> NSNumber? {
    guard let numDevices: Int = capability.getHubZwaveNumDevices(model) else {
      return nil
    }
    return NSNumber(value: numDevices)
  }
  
  public static func getIsSecondary(_ model: HubZwaveModel) -> NSNumber? {
    guard let isSecondary: Bool = capability.getHubZwaveIsSecondary(model) else {
      return nil
    }
    return NSNumber(value: isSecondary)
  }
  
  public static func getIsOnOtherNetwork(_ model: HubZwaveModel) -> NSNumber? {
    guard let isOnOtherNetwork: Bool = capability.getHubZwaveIsOnOtherNetwork(model) else {
      return nil
    }
    return NSNumber(value: isOnOtherNetwork)
  }
  
  public static func getIsSUC(_ model: HubZwaveModel) -> NSNumber? {
    guard let isSUC: Bool = capability.getHubZwaveIsSUC(model) else {
      return nil
    }
    return NSNumber(value: isSUC)
  }
  
  public static func getState(_ model: HubZwaveModel) -> String? {
    return capability.getHubZwaveState(model)?.rawValue
  }
  
  public static func getUptime(_ model: HubZwaveModel) -> NSNumber? {
    guard let uptime: Int = capability.getHubZwaveUptime(model) else {
      return nil
    }
    return NSNumber(value: uptime)
  }
  
  public static func getHealInProgress(_ model: HubZwaveModel) -> NSNumber? {
    guard let healInProgress: Bool = capability.getHubZwaveHealInProgress(model) else {
      return nil
    }
    return NSNumber(value: healInProgress)
  }
  
  public static func getHealLastStart(_ model: HubZwaveModel) -> Date? {
    guard let healLastStart: Date = capability.getHubZwaveHealLastStart(model) else {
      return nil
    }
    return healLastStart
  }
  
  public static func getHealLastFinish(_ model: HubZwaveModel) -> Date? {
    guard let healLastFinish: Date = capability.getHubZwaveHealLastFinish(model) else {
      return nil
    }
    return healLastFinish
  }
  
  public static func getHealFinishReason(_ model: HubZwaveModel) -> String? {
    return capability.getHubZwaveHealFinishReason(model)?.rawValue
  }
  
  public static func getHealTotal(_ model: HubZwaveModel) -> NSNumber? {
    guard let healTotal: Int = capability.getHubZwaveHealTotal(model) else {
      return nil
    }
    return NSNumber(value: healTotal)
  }
  
  public static func getHealCompleted(_ model: HubZwaveModel) -> NSNumber? {
    guard let healCompleted: Int = capability.getHubZwaveHealCompleted(model) else {
      return nil
    }
    return NSNumber(value: healCompleted)
  }
  
  public static func getHealSuccessful(_ model: HubZwaveModel) -> NSNumber? {
    guard let healSuccessful: Int = capability.getHubZwaveHealSuccessful(model) else {
      return nil
    }
    return NSNumber(value: healSuccessful)
  }
  
  public static func getHealBlockingControl(_ model: HubZwaveModel) -> NSNumber? {
    guard let healBlockingControl: Bool = capability.getHubZwaveHealBlockingControl(model) else {
      return nil
    }
    return NSNumber(value: healBlockingControl)
  }
  
  public static func getHealEstimatedFinish(_ model: HubZwaveModel) -> Date? {
    guard let healEstimatedFinish: Date = capability.getHubZwaveHealEstimatedFinish(model) else {
      return nil
    }
    return healEstimatedFinish
  }
  
  public static func getHealPercent(_ model: HubZwaveModel) -> NSNumber? {
    guard let healPercent: Double = capability.getHubZwaveHealPercent(model) else {
      return nil
    }
    return NSNumber(value: healPercent)
  }
  
  public static func getHealNextScheduled(_ model: HubZwaveModel) -> Date? {
    guard let healNextScheduled: Date = capability.getHubZwaveHealNextScheduled(model) else {
      return nil
    }
    return healNextScheduled
  }
  
  public static func getHealRecommended(_ model: HubZwaveModel) -> NSNumber? {
    guard let healRecommended: Bool = capability.getHubZwaveHealRecommended(model) else {
      return nil
    }
    return NSNumber(value: healRecommended)
  }
  
  public static func setHealRecommended(_ healRecommended: Bool, model: HubZwaveModel) {
    
    
    capability.setHubZwaveHealRecommended(healRecommended, model: model)
  }
  
  public static func factoryReset(_ model: HubZwaveModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZwaveFactoryReset(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func reset(_  model: HubZwaveModel, type: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZwaveReset(model, type: type))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func forcePrimary(_ model: HubZwaveModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZwaveForcePrimary(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func forceSecondary(_ model: HubZwaveModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZwaveForceSecondary(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func networkInformation(_ model: HubZwaveModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZwaveNetworkInformation(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func heal(_  model: HubZwaveModel, block: Bool, time: Double) -> PMKPromise {
  
    
    let time: Date = Date(milliseconds: time)
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZwaveHeal(model, block: block, time: time))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func cancelHeal(_ model: HubZwaveModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZwaveCancelHeal(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func removeZombie(_  model: HubZwaveModel, node: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZwaveRemoveZombie(model, node: node))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func associate(_  model: HubZwaveModel, node: Int, groups: [Int]) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZwaveAssociate(model, node: node, groups: groups))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func assignReturnRoutes(_  model: HubZwaveModel, node: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZwaveAssignReturnRoutes(model, node: node))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
