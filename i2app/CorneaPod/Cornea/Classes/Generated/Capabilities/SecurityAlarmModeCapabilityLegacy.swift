
//
// SecurityAlarmModeCapabilityLegacy.swift
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

public class SecurityAlarmModeCapabilityLegacy: NSObject, ArcusSecurityAlarmModeCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SecurityAlarmModeCapabilityLegacy  = SecurityAlarmModeCapabilityLegacy()
  

  
  public static func getDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getSecurityAlarmModeDevices(model)
  }
  
  public static func setDevices(_ devices: [String], model: SubsystemModel) {
    
    
    capability.setSecurityAlarmModeDevices(devices, model: model)
  }
  
  public static func getEntranceDelaySec(_ model: SubsystemModel) -> NSNumber? {
    guard let entranceDelaySec: Int = capability.getSecurityAlarmModeEntranceDelaySec(model) else {
      return nil
    }
    return NSNumber(value: entranceDelaySec)
  }
  
  public static func setEntranceDelaySec(_ entranceDelaySec: Int, model: SubsystemModel) {
    
    
    capability.setSecurityAlarmModeEntranceDelaySec(entranceDelaySec, model: model)
  }
  
  public static func getExitDelaySec(_ model: SubsystemModel) -> NSNumber? {
    guard let exitDelaySec: Int = capability.getSecurityAlarmModeExitDelaySec(model) else {
      return nil
    }
    return NSNumber(value: exitDelaySec)
  }
  
  public static func setExitDelaySec(_ exitDelaySec: Int, model: SubsystemModel) {
    
    
    capability.setSecurityAlarmModeExitDelaySec(exitDelaySec, model: model)
  }
  
  public static func getAlarmSensitivityDeviceCount(_ model: SubsystemModel) -> NSNumber? {
    guard let alarmSensitivityDeviceCount: Int = capability.getSecurityAlarmModeAlarmSensitivityDeviceCount(model) else {
      return nil
    }
    return NSNumber(value: alarmSensitivityDeviceCount)
  }
  
  public static func setAlarmSensitivityDeviceCount(_ alarmSensitivityDeviceCount: Int, model: SubsystemModel) {
    
    
    capability.setSecurityAlarmModeAlarmSensitivityDeviceCount(alarmSensitivityDeviceCount, model: model)
  }
  
  public static func getSilent(_ model: SubsystemModel) -> NSNumber? {
    guard let silent: Bool = capability.getSecurityAlarmModeSilent(model) else {
      return nil
    }
    return NSNumber(value: silent)
  }
  
  public static func setSilent(_ silent: Bool, model: SubsystemModel) {
    
    
    capability.setSecurityAlarmModeSilent(silent, model: model)
  }
  
  public static func getSoundsEnabled(_ model: SubsystemModel) -> NSNumber? {
    guard let soundsEnabled: Bool = capability.getSecurityAlarmModeSoundsEnabled(model) else {
      return nil
    }
    return NSNumber(value: soundsEnabled)
  }
  
  public static func setSoundsEnabled(_ soundsEnabled: Bool, model: SubsystemModel) {
    
    
    capability.setSecurityAlarmModeSoundsEnabled(soundsEnabled, model: model)
  }
  
  public static func getMotionSensorCount(_ model: SubsystemModel) -> NSNumber? {
    guard let motionSensorCount: Int = capability.getSecurityAlarmModeMotionSensorCount(model) else {
      return nil
    }
    return NSNumber(value: motionSensorCount)
  }
  
  public static func setMotionSensorCount(_ motionSensorCount: Int, model: SubsystemModel) {
    
    
    capability.setSecurityAlarmModeMotionSensorCount(motionSensorCount, model: model)
  }
  
}
