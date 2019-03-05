
//
// CareSubsystemCapabilityLegacy.swift
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

public class CareSubsystemCapabilityLegacy: NSObject, ArcusCareSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: CareSubsystemCapabilityLegacy  = CareSubsystemCapabilityLegacy()
  
  static let CareSubsystemAlarmModeON: String = CareSubsystemAlarmMode.on.rawValue
  static let CareSubsystemAlarmModeVISIT: String = CareSubsystemAlarmMode.visit.rawValue
  
  static let CareSubsystemAlarmStateREADY: String = CareSubsystemAlarmState.ready.rawValue
  static let CareSubsystemAlarmStateALERT: String = CareSubsystemAlarmState.alert.rawValue
  
  static let CareSubsystemLastAcknowledgementPENDING: String = CareSubsystemLastAcknowledgement.pending.rawValue
  static let CareSubsystemLastAcknowledgementACKNOWLEDGED: String = CareSubsystemLastAcknowledgement.acknowledged.rawValue
  static let CareSubsystemLastAcknowledgementFAILED: String = CareSubsystemLastAcknowledgement.failed.rawValue
  

  
  public static func getTriggeredDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getCareSubsystemTriggeredDevices(model)
  }
  
  public static func getInactiveDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getCareSubsystemInactiveDevices(model)
  }
  
  public static func getCareDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getCareSubsystemCareDevices(model)
  }
  
  public static func setCareDevices(_ careDevices: [String], model: SubsystemModel) {
    
    
    capability.setCareSubsystemCareDevices(careDevices, model: model)
  }
  
  public static func getCareCapableDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getCareSubsystemCareCapableDevices(model)
  }
  
  public static func getPresenceDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getCareSubsystemPresenceDevices(model)
  }
  
  public static func getBehaviors(_ model: SubsystemModel) -> [String]? {
    return capability.getCareSubsystemBehaviors(model)
  }
  
  public static func getActiveBehaviors(_ model: SubsystemModel) -> [String]? {
    return capability.getCareSubsystemActiveBehaviors(model)
  }
  
  public static func getAlarmMode(_ model: SubsystemModel) -> String? {
    return capability.getCareSubsystemAlarmMode(model)?.rawValue
  }
  
  public static func setAlarmMode(_ alarmMode: String, model: SubsystemModel) {
    guard let alarmMode: CareSubsystemAlarmMode = CareSubsystemAlarmMode(rawValue: alarmMode) else { return }
    
    capability.setCareSubsystemAlarmMode(alarmMode, model: model)
  }
  
  public static func getAlarmState(_ model: SubsystemModel) -> String? {
    return capability.getCareSubsystemAlarmState(model)?.rawValue
  }
  
  public static func getLastAlertTime(_ model: SubsystemModel) -> Date? {
    guard let lastAlertTime: Date = capability.getCareSubsystemLastAlertTime(model) else {
      return nil
    }
    return lastAlertTime
  }
  
  public static func getLastAlertCause(_ model: SubsystemModel) -> String? {
    return capability.getCareSubsystemLastAlertCause(model)
  }
  
  public static func getLastAlertTriggers(_ model: SubsystemModel) -> [String: Double]? {
    return capability.getCareSubsystemLastAlertTriggers(model)
  }
  
  public static func getLastAcknowledgement(_ model: SubsystemModel) -> String? {
    return capability.getCareSubsystemLastAcknowledgement(model)?.rawValue
  }
  
  public static func getLastAcknowledgementTime(_ model: SubsystemModel) -> Date? {
    guard let lastAcknowledgementTime: Date = capability.getCareSubsystemLastAcknowledgementTime(model) else {
      return nil
    }
    return lastAcknowledgementTime
  }
  
  public static func getLastAcknowledgedBy(_ model: SubsystemModel) -> String? {
    return capability.getCareSubsystemLastAcknowledgedBy(model)
  }
  
  public static func getLastClearTime(_ model: SubsystemModel) -> Date? {
    guard let lastClearTime: Date = capability.getCareSubsystemLastClearTime(model) else {
      return nil
    }
    return lastClearTime
  }
  
  public static func getLastClearedBy(_ model: SubsystemModel) -> String? {
    return capability.getCareSubsystemLastClearedBy(model)
  }
  
  public static func getCallTreeEnabled(_ model: SubsystemModel) -> NSNumber? {
    guard let callTreeEnabled: Bool = capability.getCareSubsystemCallTreeEnabled(model) else {
      return nil
    }
    return NSNumber(value: callTreeEnabled)
  }
  
  public static func getCallTree(_ model: SubsystemModel) -> [Any]? {
    return capability.getCareSubsystemCallTree(model)
  }
  
  public static func setCallTree(_ callTree: [Any], model: SubsystemModel) {
    
    
    capability.setCareSubsystemCallTree(callTree, model: model)
  }
  
  public static func getSilent(_ model: SubsystemModel) -> NSNumber? {
    guard let silent: Bool = capability.getCareSubsystemSilent(model) else {
      return nil
    }
    return NSNumber(value: silent)
  }
  
  public static func setSilent(_ silent: Bool, model: SubsystemModel) {
    
    
    capability.setCareSubsystemSilent(silent, model: model)
  }
  
  public static func getCareDevicesPopulated(_ model: SubsystemModel) -> NSNumber? {
    guard let careDevicesPopulated: Bool = capability.getCareSubsystemCareDevicesPopulated(model) else {
      return nil
    }
    return NSNumber(value: careDevicesPopulated)
  }
  
  public static func panic(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCareSubsystemPanic(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func acknowledge(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCareSubsystemAcknowledge(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func clear(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCareSubsystemClear(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listActivity(_  model: SubsystemModel, start: Double, end: Double, bucket: Int, devices: [String]) -> PMKPromise {
  
    let start: Date = Date(milliseconds: start)
    let end: Date = Date(milliseconds: end)
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCareSubsystemListActivity(model, start: start, end: end, bucket: bucket, devices: devices))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listDetailedActivity(_  model: SubsystemModel, limit: Int, token: String, devices: [String]) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCareSubsystemListDetailedActivity(model, limit: limit, token: token, devices: devices))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listBehaviors(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCareSubsystemListBehaviors(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listBehaviorTemplates(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCareSubsystemListBehaviorTemplates(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func addBehavior(_  model: SubsystemModel, behavior: Any) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCareSubsystemAddBehavior(model, behavior: behavior))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateBehavior(_  model: SubsystemModel, behavior: Any) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCareSubsystemUpdateBehavior(model, behavior: behavior))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func removeBehavior(_  model: SubsystemModel, id: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCareSubsystemRemoveBehavior(model, id: id))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
