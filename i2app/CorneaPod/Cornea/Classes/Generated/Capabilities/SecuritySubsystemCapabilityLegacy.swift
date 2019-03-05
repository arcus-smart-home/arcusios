
//
// SecuritySubsystemCapabilityLegacy.swift
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

public class SecuritySubsystemCapabilityLegacy: NSObject, ArcusSecuritySubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SecuritySubsystemCapabilityLegacy  = SecuritySubsystemCapabilityLegacy()
  
  static let SecuritySubsystemAlarmStateDISARMED: String = SecuritySubsystemAlarmState.disarmed.rawValue
  static let SecuritySubsystemAlarmStateARMING: String = SecuritySubsystemAlarmState.arming.rawValue
  static let SecuritySubsystemAlarmStateARMED: String = SecuritySubsystemAlarmState.armed.rawValue
  static let SecuritySubsystemAlarmStateALERT: String = SecuritySubsystemAlarmState.alert.rawValue
  static let SecuritySubsystemAlarmStateCLEARING: String = SecuritySubsystemAlarmState.clearing.rawValue
  static let SecuritySubsystemAlarmStateSOAKING: String = SecuritySubsystemAlarmState.soaking.rawValue
  
  static let SecuritySubsystemAlarmModeOFF: String = SecuritySubsystemAlarmMode.off.rawValue
  static let SecuritySubsystemAlarmModeON: String = SecuritySubsystemAlarmMode.on.rawValue
  static let SecuritySubsystemAlarmModePARTIAL: String = SecuritySubsystemAlarmMode.partial.rawValue
  
  static let SecuritySubsystemCurrentAlertCauseALARM: String = SecuritySubsystemCurrentAlertCause.alarm.rawValue
  static let SecuritySubsystemCurrentAlertCausePANIC: String = SecuritySubsystemCurrentAlertCause.panic.rawValue
  static let SecuritySubsystemCurrentAlertCauseNONE: String = SecuritySubsystemCurrentAlertCause.none.rawValue
  
  static let SecuritySubsystemLastAcknowledgementNEVER: String = SecuritySubsystemLastAcknowledgement.never.rawValue
  static let SecuritySubsystemLastAcknowledgementPENDING: String = SecuritySubsystemLastAcknowledgement.pending.rawValue
  static let SecuritySubsystemLastAcknowledgementACKNOWLEDGED: String = SecuritySubsystemLastAcknowledgement.acknowledged.rawValue
  static let SecuritySubsystemLastAcknowledgementFAILED: String = SecuritySubsystemLastAcknowledgement.failed.rawValue
  

  
  public static func getSecurityDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemSecurityDevices(model)
  }
  
  public static func getTriggeredDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemTriggeredDevices(model)
  }
  
  public static func getReadyDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemReadyDevices(model)
  }
  
  public static func getArmedDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemArmedDevices(model)
  }
  
  public static func getBypassedDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemBypassedDevices(model)
  }
  
  public static func getOfflineDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemOfflineDevices(model)
  }
  
  public static func getKeypads(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemKeypads(model)
  }
  
  public static func getAlarmState(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemAlarmState(model)?.rawValue
  }
  
  public static func getAlarmMode(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemAlarmMode(model)?.rawValue
  }
  
  public static func getLastAlertTime(_ model: SubsystemModel) -> Date? {
    guard let lastAlertTime: Date = capability.getSecuritySubsystemLastAlertTime(model) else {
      return nil
    }
    return lastAlertTime
  }
  
  public static func getLastAlertCause(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemLastAlertCause(model)
  }
  
  public static func getCurrentAlertTriggers(_ model: SubsystemModel) -> [String: Double]? {
    return capability.getSecuritySubsystemCurrentAlertTriggers(model)
  }
  
  public static func getCurrentAlertCause(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemCurrentAlertCause(model)?.rawValue
  }
  
  public static func getLastAlertTriggers(_ model: SubsystemModel) -> [String: Double]? {
    return capability.getSecuritySubsystemLastAlertTriggers(model)
  }
  
  public static func getLastAcknowledgement(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemLastAcknowledgement(model)?.rawValue
  }
  
  public static func getLastAcknowledgementTime(_ model: SubsystemModel) -> Date? {
    guard let lastAcknowledgementTime: Date = capability.getSecuritySubsystemLastAcknowledgementTime(model) else {
      return nil
    }
    return lastAcknowledgementTime
  }
  
  public static func getLastAcknowledgedBy(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemLastAcknowledgedBy(model)
  }
  
  public static func getLastArmedTime(_ model: SubsystemModel) -> Date? {
    guard let lastArmedTime: Date = capability.getSecuritySubsystemLastArmedTime(model) else {
      return nil
    }
    return lastArmedTime
  }
  
  public static func getLastArmedBy(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemLastArmedBy(model)
  }
  
  public static func getLastDisarmedTime(_ model: SubsystemModel) -> Date? {
    guard let lastDisarmedTime: Date = capability.getSecuritySubsystemLastDisarmedTime(model) else {
      return nil
    }
    return lastDisarmedTime
  }
  
  public static func getLastDisarmedBy(_ model: SubsystemModel) -> String? {
    return capability.getSecuritySubsystemLastDisarmedBy(model)
  }
  
  public static func getCallTreeEnabled(_ model: SubsystemModel) -> NSNumber? {
    guard let callTreeEnabled: Bool = capability.getSecuritySubsystemCallTreeEnabled(model) else {
      return nil
    }
    return NSNumber(value: callTreeEnabled)
  }
  
  public static func getCallTree(_ model: SubsystemModel) -> [Any]? {
    return capability.getSecuritySubsystemCallTree(model)
  }
  
  public static func setCallTree(_ callTree: [Any], model: SubsystemModel) {
    
    
    capability.setSecuritySubsystemCallTree(callTree, model: model)
  }
  
  public static func getKeypadArmBypassedTimeOutSec(_ model: SubsystemModel) -> NSNumber? {
    guard let keypadArmBypassedTimeOutSec: Int = capability.getSecuritySubsystemKeypadArmBypassedTimeOutSec(model) else {
      return nil
    }
    return NSNumber(value: keypadArmBypassedTimeOutSec)
  }
  
  public static func setKeypadArmBypassedTimeOutSec(_ keypadArmBypassedTimeOutSec: Int, model: SubsystemModel) {
    
    
    capability.setSecuritySubsystemKeypadArmBypassedTimeOutSec(keypadArmBypassedTimeOutSec, model: model)
  }
  
  public static func getBlacklistedSecurityDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecuritySubsystemBlacklistedSecurityDevices(model)
  }
  
  public static func panic(_  model: SubsystemModel, silent: Bool) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSecuritySubsystemPanic(model, silent: silent))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func arm(_  model: SubsystemModel, mode: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSecuritySubsystemArm(model, mode: mode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func armBypassed(_  model: SubsystemModel, mode: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSecuritySubsystemArmBypassed(model, mode: mode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func acknowledge(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSecuritySubsystemAcknowledge(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disarm(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSecuritySubsystemDisarm(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
