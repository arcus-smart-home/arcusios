
//
// HubAlarmCapabilityLegacy.swift
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

public class HubAlarmCapabilityLegacy: NSObject, ArcusHubAlarmCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubAlarmCapabilityLegacy  = HubAlarmCapabilityLegacy()
  
  static let HubAlarmStateSUSPENDED: String = HubAlarmState.suspended.rawValue
  static let HubAlarmStateACTIVE: String = HubAlarmState.active.rawValue
  
  static let HubAlarmAlarmStateINACTIVE: String = HubAlarmAlarmState.inactive.rawValue
  static let HubAlarmAlarmStateREADY: String = HubAlarmAlarmState.ready.rawValue
  static let HubAlarmAlarmStatePREALERT: String = HubAlarmAlarmState.prealert.rawValue
  static let HubAlarmAlarmStateALERTING: String = HubAlarmAlarmState.alerting.rawValue
  static let HubAlarmAlarmStateCLEARING: String = HubAlarmAlarmState.clearing.rawValue
  
  static let HubAlarmSecurityModeINACTIVE: String = HubAlarmSecurityMode.inactive.rawValue
  static let HubAlarmSecurityModeDISARMED: String = HubAlarmSecurityMode.disarmed.rawValue
  static let HubAlarmSecurityModeON: String = HubAlarmSecurityMode.on.rawValue
  static let HubAlarmSecurityModePARTIAL: String = HubAlarmSecurityMode.partial.rawValue
  
  static let HubAlarmSecurityAlertStateINACTIVE: String = HubAlarmSecurityAlertState.inactive.rawValue
  static let HubAlarmSecurityAlertStatePENDING_CLEAR: String = HubAlarmSecurityAlertState.pending_clear.rawValue
  static let HubAlarmSecurityAlertStateDISARMED: String = HubAlarmSecurityAlertState.disarmed.rawValue
  static let HubAlarmSecurityAlertStateARMING: String = HubAlarmSecurityAlertState.arming.rawValue
  static let HubAlarmSecurityAlertStateREADY: String = HubAlarmSecurityAlertState.ready.rawValue
  static let HubAlarmSecurityAlertStatePREALERT: String = HubAlarmSecurityAlertState.prealert.rawValue
  static let HubAlarmSecurityAlertStateALERT: String = HubAlarmSecurityAlertState.alert.rawValue
  static let HubAlarmSecurityAlertStateCLEARING: String = HubAlarmSecurityAlertState.clearing.rawValue
  
  static let HubAlarmPanicAlertStateINACTIVE: String = HubAlarmPanicAlertState.inactive.rawValue
  static let HubAlarmPanicAlertStatePENDING_CLEAR: String = HubAlarmPanicAlertState.pending_clear.rawValue
  static let HubAlarmPanicAlertStateDISARMED: String = HubAlarmPanicAlertState.disarmed.rawValue
  static let HubAlarmPanicAlertStateARMING: String = HubAlarmPanicAlertState.arming.rawValue
  static let HubAlarmPanicAlertStateREADY: String = HubAlarmPanicAlertState.ready.rawValue
  static let HubAlarmPanicAlertStatePREALERT: String = HubAlarmPanicAlertState.prealert.rawValue
  static let HubAlarmPanicAlertStateALERT: String = HubAlarmPanicAlertState.alert.rawValue
  static let HubAlarmPanicAlertStateCLEARING: String = HubAlarmPanicAlertState.clearing.rawValue
  
  static let HubAlarmSmokeAlertStateINACTIVE: String = HubAlarmSmokeAlertState.inactive.rawValue
  static let HubAlarmSmokeAlertStatePENDING_CLEAR: String = HubAlarmSmokeAlertState.pending_clear.rawValue
  static let HubAlarmSmokeAlertStateDISARMED: String = HubAlarmSmokeAlertState.disarmed.rawValue
  static let HubAlarmSmokeAlertStateARMING: String = HubAlarmSmokeAlertState.arming.rawValue
  static let HubAlarmSmokeAlertStateREADY: String = HubAlarmSmokeAlertState.ready.rawValue
  static let HubAlarmSmokeAlertStatePREALERT: String = HubAlarmSmokeAlertState.prealert.rawValue
  static let HubAlarmSmokeAlertStateALERT: String = HubAlarmSmokeAlertState.alert.rawValue
  static let HubAlarmSmokeAlertStateCLEARING: String = HubAlarmSmokeAlertState.clearing.rawValue
  
  static let HubAlarmCoAlertStateINACTIVE: String = HubAlarmCoAlertState.inactive.rawValue
  static let HubAlarmCoAlertStatePENDING_CLEAR: String = HubAlarmCoAlertState.pending_clear.rawValue
  static let HubAlarmCoAlertStateDISARMED: String = HubAlarmCoAlertState.disarmed.rawValue
  static let HubAlarmCoAlertStateARMING: String = HubAlarmCoAlertState.arming.rawValue
  static let HubAlarmCoAlertStateREADY: String = HubAlarmCoAlertState.ready.rawValue
  static let HubAlarmCoAlertStatePREALERT: String = HubAlarmCoAlertState.prealert.rawValue
  static let HubAlarmCoAlertStateALERT: String = HubAlarmCoAlertState.alert.rawValue
  static let HubAlarmCoAlertStateCLEARING: String = HubAlarmCoAlertState.clearing.rawValue
  
  static let HubAlarmWaterAlertStateINACTIVE: String = HubAlarmWaterAlertState.inactive.rawValue
  static let HubAlarmWaterAlertStatePENDING_CLEAR: String = HubAlarmWaterAlertState.pending_clear.rawValue
  static let HubAlarmWaterAlertStateDISARMED: String = HubAlarmWaterAlertState.disarmed.rawValue
  static let HubAlarmWaterAlertStateARMING: String = HubAlarmWaterAlertState.arming.rawValue
  static let HubAlarmWaterAlertStateREADY: String = HubAlarmWaterAlertState.ready.rawValue
  static let HubAlarmWaterAlertStatePREALERT: String = HubAlarmWaterAlertState.prealert.rawValue
  static let HubAlarmWaterAlertStateALERT: String = HubAlarmWaterAlertState.alert.rawValue
  static let HubAlarmWaterAlertStateCLEARING: String = HubAlarmWaterAlertState.clearing.rawValue
  

  
  public static func getState(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmState(model)?.rawValue
  }
  
  public static func getAlarmState(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmAlarmState(model)?.rawValue
  }
  
  public static func getSecurityMode(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmSecurityMode(model)?.rawValue
  }
  
  public static func getSecurityArmTime(_ model: HubAlarmModel) -> Date? {
    guard let securityArmTime: Date = capability.getHubAlarmSecurityArmTime(model) else {
      return nil
    }
    return securityArmTime
  }
  
  public static func getLastArmedTime(_ model: HubAlarmModel) -> Date? {
    guard let lastArmedTime: Date = capability.getHubAlarmLastArmedTime(model) else {
      return nil
    }
    return lastArmedTime
  }
  
  public static func getLastArmedBy(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmLastArmedBy(model)
  }
  
  public static func getLastArmedFrom(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmLastArmedFrom(model)
  }
  
  public static func getLastDisarmedTime(_ model: HubAlarmModel) -> Date? {
    guard let lastDisarmedTime: Date = capability.getHubAlarmLastDisarmedTime(model) else {
      return nil
    }
    return lastDisarmedTime
  }
  
  public static func getLastDisarmedBy(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmLastDisarmedBy(model)
  }
  
  public static func getLastDisarmedFrom(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmLastDisarmedFrom(model)
  }
  
  public static func getActiveAlerts(_ model: HubAlarmModel) -> [Any]? {
    return capability.getHubAlarmActiveAlerts(model)
  }
  
  public static func getAvailableAlerts(_ model: HubAlarmModel) -> [Any]? {
    return capability.getHubAlarmAvailableAlerts(model)
  }
  
  public static func getCurrentIncident(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmCurrentIncident(model)
  }
  
  public static func getReconnectReport(_ model: HubAlarmModel) -> NSNumber? {
    guard let reconnectReport: Bool = capability.getHubAlarmReconnectReport(model) else {
      return nil
    }
    return NSNumber(value: reconnectReport)
  }
  
  public static func getSecurityAlertState(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmSecurityAlertState(model)?.rawValue
  }
  
  public static func getSecurityDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSecurityDevices(model)
  }
  
  public static func getSecurityExcludedDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSecurityExcludedDevices(model)
  }
  
  public static func getSecurityActiveDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSecurityActiveDevices(model)
  }
  
  public static func getSecurityCurrentActive(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSecurityCurrentActive(model)
  }
  
  public static func getSecurityOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSecurityOfflineDevices(model)
  }
  
  public static func getSecurityTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSecurityTriggeredDevices(model)
  }
  
  public static func getSecurityTriggers(_ model: HubAlarmModel) -> [Any]? {
    return capability.getHubAlarmSecurityTriggers(model)
  }
  
  public static func getSecurityPreAlertEndTime(_ model: HubAlarmModel) -> Date? {
    guard let securityPreAlertEndTime: Date = capability.getHubAlarmSecurityPreAlertEndTime(model) else {
      return nil
    }
    return securityPreAlertEndTime
  }
  
  public static func getSecuritySilent(_ model: HubAlarmModel) -> NSNumber? {
    guard let securitySilent: Bool = capability.getHubAlarmSecuritySilent(model) else {
      return nil
    }
    return NSNumber(value: securitySilent)
  }
  
  public static func getSecurityEntranceDelay(_ model: HubAlarmModel) -> NSNumber? {
    guard let securityEntranceDelay: Int = capability.getHubAlarmSecurityEntranceDelay(model) else {
      return nil
    }
    return NSNumber(value: securityEntranceDelay)
  }
  
  public static func getSecuritySensitivity(_ model: HubAlarmModel) -> NSNumber? {
    guard let securitySensitivity: Int = capability.getHubAlarmSecuritySensitivity(model) else {
      return nil
    }
    return NSNumber(value: securitySensitivity)
  }
  
  public static func getPanicAlertState(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmPanicAlertState(model)?.rawValue
  }
  
  public static func getPanicActiveDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmPanicActiveDevices(model)
  }
  
  public static func getPanicOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmPanicOfflineDevices(model)
  }
  
  public static func getPanicTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmPanicTriggeredDevices(model)
  }
  
  public static func getPanicTriggers(_ model: HubAlarmModel) -> [Any]? {
    return capability.getHubAlarmPanicTriggers(model)
  }
  
  public static func getPanicSilent(_ model: HubAlarmModel) -> NSNumber? {
    guard let panicSilent: Bool = capability.getHubAlarmPanicSilent(model) else {
      return nil
    }
    return NSNumber(value: panicSilent)
  }
  
  public static func setPanicSilent(_ panicSilent: Bool, model: HubAlarmModel) {
    
    
    capability.setHubAlarmPanicSilent(panicSilent, model: model)
  }
  
  public static func getSmokeAlertState(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmSmokeAlertState(model)?.rawValue
  }
  
  public static func getSmokeActiveDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSmokeActiveDevices(model)
  }
  
  public static func getSmokeOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSmokeOfflineDevices(model)
  }
  
  public static func getSmokeTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmSmokeTriggeredDevices(model)
  }
  
  public static func getSmokeTriggers(_ model: HubAlarmModel) -> [Any]? {
    return capability.getHubAlarmSmokeTriggers(model)
  }
  
  public static func getSmokeSilent(_ model: HubAlarmModel) -> NSNumber? {
    guard let smokeSilent: Bool = capability.getHubAlarmSmokeSilent(model) else {
      return nil
    }
    return NSNumber(value: smokeSilent)
  }
  
  public static func setSmokeSilent(_ smokeSilent: Bool, model: HubAlarmModel) {
    
    
    capability.setHubAlarmSmokeSilent(smokeSilent, model: model)
  }
  
  public static func getCoAlertState(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmCoAlertState(model)?.rawValue
  }
  
  public static func getCoActiveDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmCoActiveDevices(model)
  }
  
  public static func getCoOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmCoOfflineDevices(model)
  }
  
  public static func getCoTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmCoTriggeredDevices(model)
  }
  
  public static func getCoTriggers(_ model: HubAlarmModel) -> [Any]? {
    return capability.getHubAlarmCoTriggers(model)
  }
  
  public static func getCoSilent(_ model: HubAlarmModel) -> NSNumber? {
    guard let coSilent: Bool = capability.getHubAlarmCoSilent(model) else {
      return nil
    }
    return NSNumber(value: coSilent)
  }
  
  public static func setCoSilent(_ coSilent: Bool, model: HubAlarmModel) {
    
    
    capability.setHubAlarmCoSilent(coSilent, model: model)
  }
  
  public static func getWaterAlertState(_ model: HubAlarmModel) -> String? {
    return capability.getHubAlarmWaterAlertState(model)?.rawValue
  }
  
  public static func getWaterActiveDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmWaterActiveDevices(model)
  }
  
  public static func getWaterOfflineDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmWaterOfflineDevices(model)
  }
  
  public static func getWaterTriggeredDevices(_ model: HubAlarmModel) -> [String]? {
    return capability.getHubAlarmWaterTriggeredDevices(model)
  }
  
  public static func getWaterTriggers(_ model: HubAlarmModel) -> [Any]? {
    return capability.getHubAlarmWaterTriggers(model)
  }
  
  public static func getWaterSilent(_ model: HubAlarmModel) -> NSNumber? {
    guard let waterSilent: Bool = capability.getHubAlarmWaterSilent(model) else {
      return nil
    }
    return NSNumber(value: waterSilent)
  }
  
  public static func setWaterSilent(_ waterSilent: Bool, model: HubAlarmModel) {
    
    
    capability.setHubAlarmWaterSilent(waterSilent, model: model)
  }
  
  public static func activate(_ model: HubAlarmModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubAlarmActivate(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func suspend(_ model: HubAlarmModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubAlarmSuspend(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func arm(_  model: HubAlarmModel, mode: String, bypassed: Bool, entranceDelaySecs: Int, exitDelaySecs: Int, alarmSensitivityDeviceCount: Int, silent: Bool, soundsEnabled: Bool, activeDevices: [String], armedBy: String, armedFrom: String) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAlarmArm(model, mode: mode, bypassed: bypassed, entranceDelaySecs: entranceDelaySecs, exitDelaySecs: exitDelaySecs, alarmSensitivityDeviceCount: alarmSensitivityDeviceCount, silent: silent, soundsEnabled: soundsEnabled, activeDevices: activeDevices, armedBy: armedBy, armedFrom: armedFrom))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disarm(_  model: HubAlarmModel, disarmedBy: String, disarmedFrom: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAlarmDisarm(model, disarmedBy: disarmedBy, disarmedFrom: disarmedFrom))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func panic(_  model: HubAlarmModel, source: String, event: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAlarmPanic(model, source: source, event: event))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func clearIncident(_ model: HubAlarmModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubAlarmClearIncident(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
