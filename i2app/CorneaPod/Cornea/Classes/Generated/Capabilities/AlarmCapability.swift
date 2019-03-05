
//
// AlarmCap.swift
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
  public static var alarmNamespace: String = "alarm"
  public static var alarmName: String = "Alarm"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let alarmAlertState: String = "alarm:alertState"
  static let alarmDevices: String = "alarm:devices"
  static let alarmExcludedDevices: String = "alarm:excludedDevices"
  static let alarmActiveDevices: String = "alarm:activeDevices"
  static let alarmOfflineDevices: String = "alarm:offlineDevices"
  static let alarmTriggeredDevices: String = "alarm:triggeredDevices"
  static let alarmTriggers: String = "alarm:triggers"
  static let alarmMonitored: String = "alarm:monitored"
  static let alarmSilent: String = "alarm:silent"
  
}

public protocol ArcusAlarmCapability: class, RxArcusService {
  /** The current state of this alert. */
  func getAlarmAlertState(_ model: AlarmModel) -> AlarmAlertState?
  /** The addresses of all the devices that are able to participate in this alarm. */
  func getAlarmDevices(_ model: AlarmModel) -> [String]?
  /** The addresses of the devices that are excluded from participating in this alarm. */
  func getAlarmExcludedDevices(_ model: AlarmModel) -> [String]?
  /** The addresses of the devices that are participating in this alarm. */
  func getAlarmActiveDevices(_ model: AlarmModel) -> [String]?
  /** The addresses of the devices would be active except they have fallen offline. */
  func getAlarmOfflineDevices(_ model: AlarmModel) -> [String]?
  /** The addresses of the devices which are currently triggered. */
  func getAlarmTriggeredDevices(_ model: AlarmModel) -> [String]?
  /** The triggers associated with the current alert. */
  func getAlarmTriggers(_ model: AlarmModel) -> [Any]?
  /** True if this alarm is professionally monitored. */
  func getAlarmMonitored(_ model: AlarmModel) -> Bool?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func getAlarmSilent(_ model: AlarmModel) -> Bool?
  /** When true only notifications will be sent, alert devices / keypads will not sound. */
  func setAlarmSilent(_ silent: Bool, model: AlarmModel)

  
}

extension ArcusAlarmCapability {
  public func getAlarmAlertState(_ model: AlarmModel) -> AlarmAlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alarmAlertState] as? String,
      let enumAttr: AlarmAlertState = AlarmAlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAlarmDevices(_ model: AlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmDevices] as? [String]
  }
  
  public func getAlarmExcludedDevices(_ model: AlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmExcludedDevices] as? [String]
  }
  
  public func getAlarmActiveDevices(_ model: AlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmActiveDevices] as? [String]
  }
  
  public func getAlarmOfflineDevices(_ model: AlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmOfflineDevices] as? [String]
  }
  
  public func getAlarmTriggeredDevices(_ model: AlarmModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmTriggeredDevices] as? [String]
  }
  
  public func getAlarmTriggers(_ model: AlarmModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmTriggers] as? [Any]
  }
  
  public func getAlarmMonitored(_ model: AlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmMonitored] as? Bool
  }
  
  public func getAlarmSilent(_ model: AlarmModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alarmSilent] as? Bool
  }
  
  public func setAlarmSilent(_ silent: Bool, model: AlarmModel) {
    model.set([Attributes.alarmSilent: silent as AnyObject])
  }
  
}
