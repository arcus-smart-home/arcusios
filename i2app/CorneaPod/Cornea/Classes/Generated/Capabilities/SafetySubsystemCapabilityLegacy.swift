
//
// SafetySubsystemCapabilityLegacy.swift
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

public class SafetySubsystemCapabilityLegacy: NSObject, ArcusSafetySubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SafetySubsystemCapabilityLegacy  = SafetySubsystemCapabilityLegacy()
  
  static let SafetySubsystemAlarmREADY: String = SafetySubsystemAlarm.ready.rawValue
  static let SafetySubsystemAlarmWARN: String = SafetySubsystemAlarm.warn.rawValue
  static let SafetySubsystemAlarmSOAKING: String = SafetySubsystemAlarm.soaking.rawValue
  static let SafetySubsystemAlarmALERT: String = SafetySubsystemAlarm.alert.rawValue
  static let SafetySubsystemAlarmCLEARING: String = SafetySubsystemAlarm.clearing.rawValue
  
  static let SafetySubsystemSmokePreAlertREADY: String = SafetySubsystemSmokePreAlert.ready.rawValue
  static let SafetySubsystemSmokePreAlertALERT: String = SafetySubsystemSmokePreAlert.alert.rawValue
  

  
  public static func getTotalDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSafetySubsystemTotalDevices(model)
  }
  
  public static func getActiveDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSafetySubsystemActiveDevices(model)
  }
  
  public static func getIgnoredDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSafetySubsystemIgnoredDevices(model)
  }
  
  public static func setIgnoredDevices(_ ignoredDevices: [String], model: SubsystemModel) {
    
    
    capability.setSafetySubsystemIgnoredDevices(ignoredDevices, model: model)
  }
  
  public static func getWaterShutoffValves(_ model: SubsystemModel) -> [String]? {
    return capability.getSafetySubsystemWaterShutoffValves(model)
  }
  
  public static func getAlarm(_ model: SubsystemModel) -> String? {
    return capability.getSafetySubsystemAlarm(model)?.rawValue
  }
  
  public static func getTriggers(_ model: SubsystemModel) -> [Any]? {
    return capability.getSafetySubsystemTriggers(model)
  }
  
  public static func getPendingClear(_ model: SubsystemModel) -> [Any]? {
    return capability.getSafetySubsystemPendingClear(model)
  }
  
  public static func getWarnings(_ model: SubsystemModel) -> [String: String]? {
    return capability.getSafetySubsystemWarnings(model)
  }
  
  public static func getCallTreeEnabled(_ model: SubsystemModel) -> NSNumber? {
    guard let callTreeEnabled: Bool = capability.getSafetySubsystemCallTreeEnabled(model) else {
      return nil
    }
    return NSNumber(value: callTreeEnabled)
  }
  
  public static func getCallTree(_ model: SubsystemModel) -> [Any]? {
    return capability.getSafetySubsystemCallTree(model)
  }
  
  public static func setCallTree(_ callTree: [Any], model: SubsystemModel) {
    
    
    capability.setSafetySubsystemCallTree(callTree, model: model)
  }
  
  public static func getSensorState(_ model: SubsystemModel) -> [String: String]? {
    return capability.getSafetySubsystemSensorState(model)
  }
  
  public static func getLastAlertTime(_ model: SubsystemModel) -> Date? {
    guard let lastAlertTime: Date = capability.getSafetySubsystemLastAlertTime(model) else {
      return nil
    }
    return lastAlertTime
  }
  
  public static func getLastAlertCause(_ model: SubsystemModel) -> String? {
    return capability.getSafetySubsystemLastAlertCause(model)
  }
  
  public static func getLastClearTime(_ model: SubsystemModel) -> Date? {
    guard let lastClearTime: Date = capability.getSafetySubsystemLastClearTime(model) else {
      return nil
    }
    return lastClearTime
  }
  
  public static func getLastClearedBy(_ model: SubsystemModel) -> String? {
    return capability.getSafetySubsystemLastClearedBy(model)
  }
  
  public static func getAlarmSensitivitySec(_ model: SubsystemModel) -> NSNumber? {
    guard let alarmSensitivitySec: Int = capability.getSafetySubsystemAlarmSensitivitySec(model) else {
      return nil
    }
    return NSNumber(value: alarmSensitivitySec)
  }
  
  public static func getAlarmSensitivityDeviceCount(_ model: SubsystemModel) -> NSNumber? {
    guard let alarmSensitivityDeviceCount: Int = capability.getSafetySubsystemAlarmSensitivityDeviceCount(model) else {
      return nil
    }
    return NSNumber(value: alarmSensitivityDeviceCount)
  }
  
  public static func setAlarmSensitivityDeviceCount(_ alarmSensitivityDeviceCount: Int, model: SubsystemModel) {
    
    
    capability.setSafetySubsystemAlarmSensitivityDeviceCount(alarmSensitivityDeviceCount, model: model)
  }
  
  public static func getQuietPeriodSec(_ model: SubsystemModel) -> NSNumber? {
    guard let quietPeriodSec: Int = capability.getSafetySubsystemQuietPeriodSec(model) else {
      return nil
    }
    return NSNumber(value: quietPeriodSec)
  }
  
  public static func setQuietPeriodSec(_ quietPeriodSec: Int, model: SubsystemModel) {
    
    
    capability.setSafetySubsystemQuietPeriodSec(quietPeriodSec, model: model)
  }
  
  public static func getSilentAlarm(_ model: SubsystemModel) -> NSNumber? {
    guard let silentAlarm: Bool = capability.getSafetySubsystemSilentAlarm(model) else {
      return nil
    }
    return NSNumber(value: silentAlarm)
  }
  
  public static func setSilentAlarm(_ silentAlarm: Bool, model: SubsystemModel) {
    
    
    capability.setSafetySubsystemSilentAlarm(silentAlarm, model: model)
  }
  
  public static func getWaterShutOff(_ model: SubsystemModel) -> NSNumber? {
    guard let waterShutOff: Bool = capability.getSafetySubsystemWaterShutOff(model) else {
      return nil
    }
    return NSNumber(value: waterShutOff)
  }
  
  public static func setWaterShutOff(_ waterShutOff: Bool, model: SubsystemModel) {
    
    
    capability.setSafetySubsystemWaterShutOff(waterShutOff, model: model)
  }
  
  public static func getSmokePreAlertDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSafetySubsystemSmokePreAlertDevices(model)
  }
  
  public static func getSmokePreAlert(_ model: SubsystemModel) -> String? {
    return capability.getSafetySubsystemSmokePreAlert(model)?.rawValue
  }
  
  public static func getLastSmokePreAlertTime(_ model: SubsystemModel) -> Date? {
    guard let lastSmokePreAlertTime: Date = capability.getSafetySubsystemLastSmokePreAlertTime(model) else {
      return nil
    }
    return lastSmokePreAlertTime
  }
  
  public static func trigger(_  model: SubsystemModel, cause: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSafetySubsystemTrigger(model, cause: cause))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func clear(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSafetySubsystemClear(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
