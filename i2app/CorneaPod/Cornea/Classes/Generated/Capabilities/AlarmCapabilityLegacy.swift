
//
// AlarmCapabilityLegacy.swift
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

public class AlarmCapabilityLegacy: NSObject, ArcusAlarmCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: AlarmCapabilityLegacy  = AlarmCapabilityLegacy()
  
  static let AlarmAlertStateINACTIVE: String = AlarmAlertState.inactive.rawValue
  static let AlarmAlertStateDISARMED: String = AlarmAlertState.disarmed.rawValue
  static let AlarmAlertStateARMING: String = AlarmAlertState.arming.rawValue
  static let AlarmAlertStateREADY: String = AlarmAlertState.ready.rawValue
  static let AlarmAlertStatePREALERT: String = AlarmAlertState.prealert.rawValue
  static let AlarmAlertStateALERT: String = AlarmAlertState.alert.rawValue
  static let AlarmAlertStateCLEARING: String = AlarmAlertState.clearing.rawValue
  

  
  public static func getAlertState(_ model: AlarmModel) -> String? {
    return capability.getAlarmAlertState(model)?.rawValue
  }
  
  public static func getDevices(_ model: AlarmModel) -> [String]? {
    return capability.getAlarmDevices(model)
  }
  
  public static func getExcludedDevices(_ model: AlarmModel) -> [String]? {
    return capability.getAlarmExcludedDevices(model)
  }
  
  public static func getActiveDevices(_ model: AlarmModel) -> [String]? {
    return capability.getAlarmActiveDevices(model)
  }
  
  public static func getOfflineDevices(_ model: AlarmModel) -> [String]? {
    return capability.getAlarmOfflineDevices(model)
  }
  
  public static func getTriggeredDevices(_ model: AlarmModel) -> [String]? {
    return capability.getAlarmTriggeredDevices(model)
  }
  
  public static func getTriggers(_ model: AlarmModel) -> [Any]? {
    return capability.getAlarmTriggers(model)
  }
  
  public static func getMonitored(_ model: AlarmModel) -> NSNumber? {
    guard let monitored: Bool = capability.getAlarmMonitored(model) else {
      return nil
    }
    return NSNumber(value: monitored)
  }
  
  public static func getSilent(_ model: AlarmModel) -> NSNumber? {
    guard let silent: Bool = capability.getAlarmSilent(model) else {
      return nil
    }
    return NSNumber(value: silent)
  }
  
  public static func setSilent(_ silent: Bool, model: AlarmModel) {
    
    
    capability.setAlarmSilent(silent, model: model)
  }
  
}
