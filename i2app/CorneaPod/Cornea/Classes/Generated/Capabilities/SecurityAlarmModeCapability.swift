
//
// SecurityAlarmModeCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var securityAlarmModeNamespace: String = "subsecuritymode"
  public static var securityAlarmModeName: String = "SecurityAlarmMode"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let securityAlarmModeDevices: String = "subsecuritymode:devices"
  static let securityAlarmModeEntranceDelaySec: String = "subsecuritymode:entranceDelaySec"
  static let securityAlarmModeExitDelaySec: String = "subsecuritymode:exitDelaySec"
  static let securityAlarmModeAlarmSensitivityDeviceCount: String = "subsecuritymode:alarmSensitivityDeviceCount"
  static let securityAlarmModeSilent: String = "subsecuritymode:silent"
  static let securityAlarmModeSoundsEnabled: String = "subsecuritymode:soundsEnabled"
  static let securityAlarmModeMotionSensorCount: String = "subsecuritymode:motionSensorCount"
  
}

public protocol ArcusSecurityAlarmModeCapability: class, RxArcusService {
  /** The addresses of all the security devices that participate in this mode. */
  func getSecurityAlarmModeDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of all the security devices that participate in this mode. */
  func setSecurityAlarmModeDevices(_ devices: [String], model: SubsystemModel)
/** The amount of time an alarm device must be triggering for before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
  func getSecurityAlarmModeEntranceDelaySec(_ model: SubsystemModel) -> Int?
  /** The amount of time an alarm device must be triggering for before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
  func setSecurityAlarmModeEntranceDelaySec(_ entranceDelaySec: Int, model: SubsystemModel)
/** The amount of time before the alarm is fully armed.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
  func getSecurityAlarmModeExitDelaySec(_ model: SubsystemModel) -> Int?
  /** The amount of time before the alarm is fully armed.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
  func setSecurityAlarmModeExitDelaySec(_ exitDelaySec: Int, model: SubsystemModel)
/** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
  func getSecurityAlarmModeAlarmSensitivityDeviceCount(_ model: SubsystemModel) -> Int?
  /** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
  func setSecurityAlarmModeAlarmSensitivityDeviceCount(_ alarmSensitivityDeviceCount: Int, model: SubsystemModel)
/** When true only notifications will be sent, alert devices will not be triggered. */
  func getSecurityAlarmModeSilent(_ model: SubsystemModel) -> Bool?
  /** When true only notifications will be sent, alert devices will not be triggered. */
  func setSecurityAlarmModeSilent(_ silent: Bool, model: SubsystemModel)
/** Hub and keypad make sounds when arming.&lt;br/&gt;&lt;b&gt;Default: true&lt;/b&gt; */
  func getSecurityAlarmModeSoundsEnabled(_ model: SubsystemModel) -> Bool?
  /** Hub and keypad make sounds when arming.&lt;br/&gt;&lt;b&gt;Default: true&lt;/b&gt; */
  func setSecurityAlarmModeSoundsEnabled(_ soundsEnabled: Bool, model: SubsystemModel)
/** The number of the number of motion sensors associated with this mode */
  func getSecurityAlarmModeMotionSensorCount(_ model: SubsystemModel) -> Int?
  /** The number of the number of motion sensors associated with this mode */
  func setSecurityAlarmModeMotionSensorCount(_ motionSensorCount: Int, model: SubsystemModel)

  
}

extension ArcusSecurityAlarmModeCapability {
  public func getSecurityAlarmModeDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securityAlarmModeDevices] as? [String]
  }
  
  public func setSecurityAlarmModeDevices(_ devices: [String], model: SubsystemModel) {
    model.set([Attributes.securityAlarmModeDevices: devices as AnyObject])
  }
  public func getSecurityAlarmModeEntranceDelaySec(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securityAlarmModeEntranceDelaySec] as? Int
  }
  
  public func setSecurityAlarmModeEntranceDelaySec(_ entranceDelaySec: Int, model: SubsystemModel) {
    model.set([Attributes.securityAlarmModeEntranceDelaySec: entranceDelaySec as AnyObject])
  }
  public func getSecurityAlarmModeExitDelaySec(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securityAlarmModeExitDelaySec] as? Int
  }
  
  public func setSecurityAlarmModeExitDelaySec(_ exitDelaySec: Int, model: SubsystemModel) {
    model.set([Attributes.securityAlarmModeExitDelaySec: exitDelaySec as AnyObject])
  }
  public func getSecurityAlarmModeAlarmSensitivityDeviceCount(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securityAlarmModeAlarmSensitivityDeviceCount] as? Int
  }
  
  public func setSecurityAlarmModeAlarmSensitivityDeviceCount(_ alarmSensitivityDeviceCount: Int, model: SubsystemModel) {
    model.set([Attributes.securityAlarmModeAlarmSensitivityDeviceCount: alarmSensitivityDeviceCount as AnyObject])
  }
  public func getSecurityAlarmModeSilent(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securityAlarmModeSilent] as? Bool
  }
  
  public func setSecurityAlarmModeSilent(_ silent: Bool, model: SubsystemModel) {
    model.set([Attributes.securityAlarmModeSilent: silent as AnyObject])
  }
  public func getSecurityAlarmModeSoundsEnabled(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securityAlarmModeSoundsEnabled] as? Bool
  }
  
  public func setSecurityAlarmModeSoundsEnabled(_ soundsEnabled: Bool, model: SubsystemModel) {
    model.set([Attributes.securityAlarmModeSoundsEnabled: soundsEnabled as AnyObject])
  }
  public func getSecurityAlarmModeMotionSensorCount(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.securityAlarmModeMotionSensorCount] as? Int
  }
  
  public func setSecurityAlarmModeMotionSensorCount(_ motionSensorCount: Int, model: SubsystemModel) {
    model.set([Attributes.securityAlarmModeMotionSensorCount: motionSensorCount as AnyObject])
  }
  
}
