
//
// SafetySubsystemCap.swift
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
  public static var safetySubsystemNamespace: String = "subsafety"
  public static var safetySubsystemName: String = "SafetySubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let safetySubsystemTotalDevices: String = "subsafety:totalDevices"
  static let safetySubsystemActiveDevices: String = "subsafety:activeDevices"
  static let safetySubsystemIgnoredDevices: String = "subsafety:ignoredDevices"
  static let safetySubsystemWaterShutoffValves: String = "subsafety:waterShutoffValves"
  static let safetySubsystemAlarm: String = "subsafety:alarm"
  static let safetySubsystemTriggers: String = "subsafety:triggers"
  static let safetySubsystemPendingClear: String = "subsafety:pendingClear"
  static let safetySubsystemWarnings: String = "subsafety:warnings"
  static let safetySubsystemCallTreeEnabled: String = "subsafety:callTreeEnabled"
  static let safetySubsystemCallTree: String = "subsafety:callTree"
  static let safetySubsystemSensorState: String = "subsafety:sensorState"
  static let safetySubsystemLastAlertTime: String = "subsafety:lastAlertTime"
  static let safetySubsystemLastAlertCause: String = "subsafety:lastAlertCause"
  static let safetySubsystemLastClearTime: String = "subsafety:lastClearTime"
  static let safetySubsystemLastClearedBy: String = "subsafety:lastClearedBy"
  static let safetySubsystemAlarmSensitivitySec: String = "subsafety:alarmSensitivitySec"
  static let safetySubsystemAlarmSensitivityDeviceCount: String = "subsafety:alarmSensitivityDeviceCount"
  static let safetySubsystemQuietPeriodSec: String = "subsafety:quietPeriodSec"
  static let safetySubsystemSilentAlarm: String = "subsafety:silentAlarm"
  static let safetySubsystemWaterShutOff: String = "subsafety:waterShutOff"
  static let safetySubsystemSmokePreAlertDevices: String = "subsafety:smokePreAlertDevices"
  static let safetySubsystemSmokePreAlert: String = "subsafety:smokePreAlert"
  static let safetySubsystemLastSmokePreAlertTime: String = "subsafety:lastSmokePreAlertTime"
  
}

public protocol ArcusSafetySubsystemCapability: class, RxArcusService {
  /** The addresses of all the safety devices in this place. */
  func getSafetySubsystemTotalDevices(_ model: SubsystemModel) -> [String]?
  /** the addresses of all the currently active (online) safety devices in this place. */
  func getSafetySubsystemActiveDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of the devices which should not be used to trigger safety alarms. */
  func getSafetySubsystemIgnoredDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of the devices which should not be used to trigger safety alarms. */
  func setSafetySubsystemIgnoredDevices(_ ignoredDevices: [String], model: SubsystemModel)
/** The addresses of the devices that are water shutoff valves. */
  func getSafetySubsystemWaterShutoffValves(_ model: SubsystemModel) -> [String]?
  /** Indicates the current state of the alarm:         - READY - The alarm is active and watching for safety alerts         - WARN - The alarm is active, but one or more of the safety sensors has low battery or connectivity issues that could potentially cause an alarm to be missed         - SOAKING - One or more safety devices have triggered, but not a sufficient amount of time or devices to set off the whole system.         - ALERT - A safety device has triggered an alarm         - CLEARING - A request has been made to CLEAR the alarm, but there are still devices triggering an alarm. */
  func getSafetySubsystemAlarm(_ model: SubsystemModel) -> SafetySubsystemAlarm?
  /** The addresses of all devices which currently have their alarm triggered.  If this is non-empty the alarm will be either ALERT, SOAKING or CLEARING */
  func getSafetySubsystemTriggers(_ model: SubsystemModel) -> [Any]?
  /** The list of events that were outstanding at the time the user canceled the alarm still waiting for an all clear from the device. */
  func getSafetySubsystemPendingClear(_ model: SubsystemModel) -> [Any]?
  /** A set of warnings about devices which have potential issues that could cause an alarm to be missed.  The key is the address of the device with a warning and the value is an I18N code with the description of the problem. */
  func getSafetySubsystemWarnings(_ model: SubsystemModel) -> [String: String]?
  /** Set to true if the account is PREMIUM, indicating the callTree will be used for alerts. Set to false if the account is BASIC, indicating that only the account owner will be notified. */
  func getSafetySubsystemCallTreeEnabled(_ model: SubsystemModel) -> Bool?
  /** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
  func getSafetySubsystemCallTree(_ model: SubsystemModel) -> [Any]?
  /** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
  func setSafetySubsystemCallTree(_ callTree: [Any], model: SubsystemModel)
/** A map of types of safety sensors to the current status. Each value means:     NONE - There are no devices of the given type     SAFE - All devices of that type are on and haven&#x27;t detected a safety alarm     OFFLINE - At least one device of the given type is offline, but none have detected a safety alarm     DETECTED - At least one device of the given type has detected a safety alarm */
  func getSafetySubsystemSensorState(_ model: SubsystemModel) -> [String: String]?
  /** The last time the alarm was fired. */
  func getSafetySubsystemLastAlertTime(_ model: SubsystemModel) -> Date?
  /** The reason the alarm was fired. */
  func getSafetySubsystemLastAlertCause(_ model: SubsystemModel) -> String?
  /** The last time the alarm was cleared. */
  func getSafetySubsystemLastClearTime(_ model: SubsystemModel) -> Date?
  /** The actor that cleared the alarm. */
  func getSafetySubsystemLastClearedBy(_ model: SubsystemModel) -> String?
  /** The amount of time an alarm device must be triggering for before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 0&lt;/b&gt; */
  func getSafetySubsystemAlarmSensitivitySec(_ model: SubsystemModel) -> Int?
  /** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
  func getSafetySubsystemAlarmSensitivityDeviceCount(_ model: SubsystemModel) -> Int?
  /** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
  func setSafetySubsystemAlarmSensitivityDeviceCount(_ alarmSensitivityDeviceCount: Int, model: SubsystemModel)
/** The number of seconds after an alarm has been cleared before it can be fired again.&lt;br/&gt;&lt;b&gt;Default: 0&lt;/b&gt; */
  func getSafetySubsystemQuietPeriodSec(_ model: SubsystemModel) -> Int?
  /** The number of seconds after an alarm has been cleared before it can be fired again.&lt;br/&gt;&lt;b&gt;Default: 0&lt;/b&gt; */
  func setSafetySubsystemQuietPeriodSec(_ quietPeriodSec: Int, model: SubsystemModel)
/** When set to true &#x27;alert&#x27; devices will not be triggered when the alarm is raised. */
  func getSafetySubsystemSilentAlarm(_ model: SubsystemModel) -> Bool?
  /** When set to true &#x27;alert&#x27; devices will not be triggered when the alarm is raised. */
  func setSafetySubsystemSilentAlarm(_ silentAlarm: Bool, model: SubsystemModel)
/** When set to true &#x27;valve&#x27; devices will be turned off when a water leak is detected. */
  func getSafetySubsystemWaterShutOff(_ model: SubsystemModel) -> Bool?
  /** When set to true &#x27;valve&#x27; devices will be turned off when a water leak is detected. */
  func setSafetySubsystemWaterShutOff(_ waterShutOff: Bool, model: SubsystemModel)
/** The addresses of all the devices in this place that are in smoke pre-alert state. */
  func getSafetySubsystemSmokePreAlertDevices(_ model: SubsystemModel) -> [String]?
  /** Indicates the whether any devices that can provide a smoke pre-alert are alerting         - READY - The alarm is active and watching for safety alerts         - ALERT - A safety device has triggered a prealarm */
  func getSafetySubsystemSmokePreAlert(_ model: SubsystemModel) -> SafetySubsystemSmokePreAlert?
  /** The last time the alarm was fired. */
  func getSafetySubsystemLastSmokePreAlertTime(_ model: SubsystemModel) -> Date?
  
  /** Immediately puts the alarm into ALERT mode IF it is in READY.  The cause will be recorded as the lastAlertCause. */
  func requestSafetySubsystemTrigger(_  model: SubsystemModel, cause: String)
   throws -> Observable<ArcusSessionEvent>/** Immediately clear and cancel the active alarm. */
  func requestSafetySubsystemClear(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSafetySubsystemCapability {
  public func getSafetySubsystemTotalDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemTotalDevices] as? [String]
  }
  
  public func getSafetySubsystemActiveDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemActiveDevices] as? [String]
  }
  
  public func getSafetySubsystemIgnoredDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemIgnoredDevices] as? [String]
  }
  
  public func setSafetySubsystemIgnoredDevices(_ ignoredDevices: [String], model: SubsystemModel) {
    model.set([Attributes.safetySubsystemIgnoredDevices: ignoredDevices as AnyObject])
  }
  public func getSafetySubsystemWaterShutoffValves(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemWaterShutoffValves] as? [String]
  }
  
  public func getSafetySubsystemAlarm(_ model: SubsystemModel) -> SafetySubsystemAlarm? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.safetySubsystemAlarm] as? String,
      let enumAttr: SafetySubsystemAlarm = SafetySubsystemAlarm(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSafetySubsystemTriggers(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemTriggers] as? [Any]
  }
  
  public func getSafetySubsystemPendingClear(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemPendingClear] as? [Any]
  }
  
  public func getSafetySubsystemWarnings(_ model: SubsystemModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemWarnings] as? [String: String]
  }
  
  public func getSafetySubsystemCallTreeEnabled(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemCallTreeEnabled] as? Bool
  }
  
  public func getSafetySubsystemCallTree(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemCallTree] as? [Any]
  }
  
  public func setSafetySubsystemCallTree(_ callTree: [Any], model: SubsystemModel) {
    model.set([Attributes.safetySubsystemCallTree: callTree as AnyObject])
  }
  public func getSafetySubsystemSensorState(_ model: SubsystemModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemSensorState] as? [String: String]
  }
  
  public func getSafetySubsystemLastAlertTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.safetySubsystemLastAlertTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSafetySubsystemLastAlertCause(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemLastAlertCause] as? String
  }
  
  public func getSafetySubsystemLastClearTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.safetySubsystemLastClearTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSafetySubsystemLastClearedBy(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemLastClearedBy] as? String
  }
  
  public func getSafetySubsystemAlarmSensitivitySec(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemAlarmSensitivitySec] as? Int
  }
  
  public func getSafetySubsystemAlarmSensitivityDeviceCount(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemAlarmSensitivityDeviceCount] as? Int
  }
  
  public func setSafetySubsystemAlarmSensitivityDeviceCount(_ alarmSensitivityDeviceCount: Int, model: SubsystemModel) {
    model.set([Attributes.safetySubsystemAlarmSensitivityDeviceCount: alarmSensitivityDeviceCount as AnyObject])
  }
  public func getSafetySubsystemQuietPeriodSec(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemQuietPeriodSec] as? Int
  }
  
  public func setSafetySubsystemQuietPeriodSec(_ quietPeriodSec: Int, model: SubsystemModel) {
    model.set([Attributes.safetySubsystemQuietPeriodSec: quietPeriodSec as AnyObject])
  }
  public func getSafetySubsystemSilentAlarm(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemSilentAlarm] as? Bool
  }
  
  public func setSafetySubsystemSilentAlarm(_ silentAlarm: Bool, model: SubsystemModel) {
    model.set([Attributes.safetySubsystemSilentAlarm: silentAlarm as AnyObject])
  }
  public func getSafetySubsystemWaterShutOff(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemWaterShutOff] as? Bool
  }
  
  public func setSafetySubsystemWaterShutOff(_ waterShutOff: Bool, model: SubsystemModel) {
    model.set([Attributes.safetySubsystemWaterShutOff: waterShutOff as AnyObject])
  }
  public func getSafetySubsystemSmokePreAlertDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.safetySubsystemSmokePreAlertDevices] as? [String]
  }
  
  public func getSafetySubsystemSmokePreAlert(_ model: SubsystemModel) -> SafetySubsystemSmokePreAlert? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.safetySubsystemSmokePreAlert] as? String,
      let enumAttr: SafetySubsystemSmokePreAlert = SafetySubsystemSmokePreAlert(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSafetySubsystemLastSmokePreAlertTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.safetySubsystemLastSmokePreAlertTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestSafetySubsystemTrigger(_  model: SubsystemModel, cause: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SafetySubsystemTriggerRequest = SafetySubsystemTriggerRequest()
    request.source = model.address
    
    
    
    request.setCause(cause)
    
    return try sendRequest(request)
  }
  
  public func requestSafetySubsystemClear(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: SafetySubsystemClearRequest = SafetySubsystemClearRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
