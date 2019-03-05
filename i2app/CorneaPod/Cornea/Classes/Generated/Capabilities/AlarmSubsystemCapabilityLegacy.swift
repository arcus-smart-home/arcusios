
//
// AlarmSubsystemCapabilityLegacy.swift
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

public class AlarmSubsystemCapabilityLegacy: NSObject, ArcusAlarmSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: AlarmSubsystemCapabilityLegacy  = AlarmSubsystemCapabilityLegacy()
  
  static let AlarmSubsystemAlarmStateINACTIVE: String = AlarmSubsystemAlarmState.inactive.rawValue
  static let AlarmSubsystemAlarmStateREADY: String = AlarmSubsystemAlarmState.ready.rawValue
  static let AlarmSubsystemAlarmStatePREALERT: String = AlarmSubsystemAlarmState.prealert.rawValue
  static let AlarmSubsystemAlarmStateALERTING: String = AlarmSubsystemAlarmState.alerting.rawValue
  static let AlarmSubsystemAlarmStateCLEARING: String = AlarmSubsystemAlarmState.clearing.rawValue
  
  static let AlarmSubsystemSecurityModeINACTIVE: String = AlarmSubsystemSecurityMode.inactive.rawValue
  static let AlarmSubsystemSecurityModeDISARMED: String = AlarmSubsystemSecurityMode.disarmed.rawValue
  static let AlarmSubsystemSecurityModeON: String = AlarmSubsystemSecurityMode.on.rawValue
  static let AlarmSubsystemSecurityModePARTIAL: String = AlarmSubsystemSecurityMode.partial.rawValue
  
  static let AlarmSubsystemAlarmProviderPLATFORM: String = AlarmSubsystemAlarmProvider.platform.rawValue
  static let AlarmSubsystemAlarmProviderHUB: String = AlarmSubsystemAlarmProvider.hub.rawValue
  
  static let AlarmSubsystemRequestedAlarmProviderPLATFORM: String = AlarmSubsystemRequestedAlarmProvider.platform.rawValue
  static let AlarmSubsystemRequestedAlarmProviderHUB: String = AlarmSubsystemRequestedAlarmProvider.hub.rawValue
  

  
  public static func getAlarmState(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemAlarmState(model)?.rawValue
  }
  
  public static func getSecurityMode(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemSecurityMode(model)?.rawValue
  }
  
  public static func getSecurityArmTime(_ model: SubsystemModel) -> Date? {
    guard let securityArmTime: Date = capability.getAlarmSubsystemSecurityArmTime(model) else {
      return nil
    }
    return securityArmTime
  }
  
  public static func getLastArmedTime(_ model: SubsystemModel) -> Date? {
    guard let lastArmedTime: Date = capability.getAlarmSubsystemLastArmedTime(model) else {
      return nil
    }
    return lastArmedTime
  }
  
  public static func getLastArmedBy(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemLastArmedBy(model)
  }
  
  public static func getLastArmedFrom(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemLastArmedFrom(model)
  }
  
  public static func getLastDisarmedTime(_ model: SubsystemModel) -> Date? {
    guard let lastDisarmedTime: Date = capability.getAlarmSubsystemLastDisarmedTime(model) else {
      return nil
    }
    return lastDisarmedTime
  }
  
  public static func getLastDisarmedBy(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemLastDisarmedBy(model)
  }
  
  public static func getLastDisarmedFrom(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemLastDisarmedFrom(model)
  }
  
  public static func getActiveAlerts(_ model: SubsystemModel) -> [Any]? {
    return capability.getAlarmSubsystemActiveAlerts(model)
  }
  
  public static func getAvailableAlerts(_ model: SubsystemModel) -> [Any]? {
    return capability.getAlarmSubsystemAvailableAlerts(model)
  }
  
  public static func getMonitoredAlerts(_ model: SubsystemModel) -> [Any]? {
    return capability.getAlarmSubsystemMonitoredAlerts(model)
  }
  
  public static func setMonitoredAlerts(_ monitoredAlerts: [Any], model: SubsystemModel) {
    
    
    capability.setAlarmSubsystemMonitoredAlerts(monitoredAlerts, model: model)
  }
  
  public static func getCurrentIncident(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemCurrentIncident(model)
  }
  
  public static func getCallTree(_ model: SubsystemModel) -> [Any]? {
    return capability.getAlarmSubsystemCallTree(model)
  }
  
  public static func setCallTree(_ callTree: [Any], model: SubsystemModel) {
    
    
    capability.setAlarmSubsystemCallTree(callTree, model: model)
  }
  
  public static func getTestModeEnabled(_ model: SubsystemModel) -> NSNumber? {
    guard let testModeEnabled: Bool = capability.getAlarmSubsystemTestModeEnabled(model) else {
      return nil
    }
    return NSNumber(value: testModeEnabled)
  }
  
  public static func setTestModeEnabled(_ testModeEnabled: Bool, model: SubsystemModel) {
    
    
    capability.setAlarmSubsystemTestModeEnabled(testModeEnabled, model: model)
  }
  
  public static func getFanShutoffSupported(_ model: SubsystemModel) -> NSNumber? {
    guard let fanShutoffSupported: Bool = capability.getAlarmSubsystemFanShutoffSupported(model) else {
      return nil
    }
    return NSNumber(value: fanShutoffSupported)
  }
  
  public static func getFanShutoffOnSmoke(_ model: SubsystemModel) -> NSNumber? {
    guard let fanShutoffOnSmoke: Bool = capability.getAlarmSubsystemFanShutoffOnSmoke(model) else {
      return nil
    }
    return NSNumber(value: fanShutoffOnSmoke)
  }
  
  public static func setFanShutoffOnSmoke(_ fanShutoffOnSmoke: Bool, model: SubsystemModel) {
    
    
    capability.setAlarmSubsystemFanShutoffOnSmoke(fanShutoffOnSmoke, model: model)
  }
  
  public static func getFanShutoffOnCO(_ model: SubsystemModel) -> NSNumber? {
    guard let fanShutoffOnCO: Bool = capability.getAlarmSubsystemFanShutoffOnCO(model) else {
      return nil
    }
    return NSNumber(value: fanShutoffOnCO)
  }
  
  public static func setFanShutoffOnCO(_ fanShutoffOnCO: Bool, model: SubsystemModel) {
    
    
    capability.setAlarmSubsystemFanShutoffOnCO(fanShutoffOnCO, model: model)
  }
  
  public static func getRecordingSupported(_ model: SubsystemModel) -> NSNumber? {
    guard let recordingSupported: Bool = capability.getAlarmSubsystemRecordingSupported(model) else {
      return nil
    }
    return NSNumber(value: recordingSupported)
  }
  
  public static func getRecordOnSecurity(_ model: SubsystemModel) -> NSNumber? {
    guard let recordOnSecurity: Bool = capability.getAlarmSubsystemRecordOnSecurity(model) else {
      return nil
    }
    return NSNumber(value: recordOnSecurity)
  }
  
  public static func setRecordOnSecurity(_ recordOnSecurity: Bool, model: SubsystemModel) {
    
    
    capability.setAlarmSubsystemRecordOnSecurity(recordOnSecurity, model: model)
  }
  
  public static func getRecordingDurationSec(_ model: SubsystemModel) -> NSNumber? {
    guard let recordingDurationSec: Int = capability.getAlarmSubsystemRecordingDurationSec(model) else {
      return nil
    }
    return NSNumber(value: recordingDurationSec)
  }
  
  public static func setRecordingDurationSec(_ recordingDurationSec: Int, model: SubsystemModel) {
    
    
    capability.setAlarmSubsystemRecordingDurationSec(recordingDurationSec, model: model)
  }
  
  public static func getAlarmProvider(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemAlarmProvider(model)?.rawValue
  }
  
  public static func getRequestedAlarmProvider(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemRequestedAlarmProvider(model)?.rawValue
  }
  
  public static func getLastAlarmProviderAttempt(_ model: SubsystemModel) -> Date? {
    guard let lastAlarmProviderAttempt: Date = capability.getAlarmSubsystemLastAlarmProviderAttempt(model) else {
      return nil
    }
    return lastAlarmProviderAttempt
  }
  
  public static func getLastAlarmProviderError(_ model: SubsystemModel) -> String? {
    return capability.getAlarmSubsystemLastAlarmProviderError(model)
  }
  
  public static func listIncidents(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAlarmSubsystemListIncidents(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func arm(_  model: SubsystemModel, mode: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAlarmSubsystemArm(model, mode: mode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func armBypassed(_  model: SubsystemModel, mode: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAlarmSubsystemArmBypassed(model, mode: mode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disarm(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAlarmSubsystemDisarm(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func panic(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAlarmSubsystemPanic(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setProvider(_  model: SubsystemModel, provider: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAlarmSubsystemSetProvider(model, provider: provider))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
