
//
// AlarmIncidentCapabilityLegacy.swift
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

public class AlarmIncidentCapabilityLegacy: NSObject, ArcusAlarmIncidentCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: AlarmIncidentCapabilityLegacy  = AlarmIncidentCapabilityLegacy()
  
  static let AlarmIncidentAlertStatePREALERT: String = AlarmIncidentAlertState.prealert.rawValue
  static let AlarmIncidentAlertStateALERT: String = AlarmIncidentAlertState.alert.rawValue
  static let AlarmIncidentAlertStateCANCELLING: String = AlarmIncidentAlertState.cancelling.rawValue
  static let AlarmIncidentAlertStateCOMPLETE: String = AlarmIncidentAlertState.complete.rawValue
  
  static let AlarmIncidentMonitoringStateNONE: String = AlarmIncidentMonitoringState.none.rawValue
  static let AlarmIncidentMonitoringStatePENDING: String = AlarmIncidentMonitoringState.pending.rawValue
  static let AlarmIncidentMonitoringStateDISPATCHING: String = AlarmIncidentMonitoringState.dispatching.rawValue
  static let AlarmIncidentMonitoringStateDISPATCHED: String = AlarmIncidentMonitoringState.dispatched.rawValue
  static let AlarmIncidentMonitoringStateREFUSED: String = AlarmIncidentMonitoringState.refused.rawValue
  static let AlarmIncidentMonitoringStateCANCELLED: String = AlarmIncidentMonitoringState.cancelled.rawValue
  static let AlarmIncidentMonitoringStateFAILED: String = AlarmIncidentMonitoringState.failed.rawValue
  
  static let AlarmIncidentPlatformStatePREALERT: String = AlarmIncidentPlatformState.prealert.rawValue
  static let AlarmIncidentPlatformStateALERT: String = AlarmIncidentPlatformState.alert.rawValue
  static let AlarmIncidentPlatformStateCANCELLING: String = AlarmIncidentPlatformState.cancelling.rawValue
  static let AlarmIncidentPlatformStateCOMPLETE: String = AlarmIncidentPlatformState.complete.rawValue
  
  static let AlarmIncidentHubStatePREALERT: String = AlarmIncidentHubState.prealert.rawValue
  static let AlarmIncidentHubStateALERT: String = AlarmIncidentHubState.alert.rawValue
  static let AlarmIncidentHubStateCANCELLING: String = AlarmIncidentHubState.cancelling.rawValue
  static let AlarmIncidentHubStateCOMPLETE: String = AlarmIncidentHubState.complete.rawValue
  
  static let AlarmIncidentAlertSECURITY: String = AlarmIncidentAlert.security.rawValue
  static let AlarmIncidentAlertPANIC: String = AlarmIncidentAlert.panic.rawValue
  static let AlarmIncidentAlertSMOKE: String = AlarmIncidentAlert.smoke.rawValue
  static let AlarmIncidentAlertCO: String = AlarmIncidentAlert.co.rawValue
  static let AlarmIncidentAlertWATER: String = AlarmIncidentAlert.water.rawValue
  static let AlarmIncidentAlertCARE: String = AlarmIncidentAlert.care.rawValue
  static let AlarmIncidentAlertWEATHER: String = AlarmIncidentAlert.weather.rawValue
  

  
  public static func getPlaceId(_ model: AlarmIncidentModel) -> String? {
    return capability.getAlarmIncidentPlaceId(model)
  }
  
  public static func getStartTime(_ model: AlarmIncidentModel) -> Date? {
    guard let startTime: Date = capability.getAlarmIncidentStartTime(model) else {
      return nil
    }
    return startTime
  }
  
  public static func getPrealertEndtime(_ model: AlarmIncidentModel) -> Date? {
    guard let prealertEndtime: Date = capability.getAlarmIncidentPrealertEndtime(model) else {
      return nil
    }
    return prealertEndtime
  }
  
  public static func getEndTime(_ model: AlarmIncidentModel) -> Date? {
    guard let endTime: Date = capability.getAlarmIncidentEndTime(model) else {
      return nil
    }
    return endTime
  }
  
  public static func getAlertState(_ model: AlarmIncidentModel) -> String? {
    return capability.getAlarmIncidentAlertState(model)?.rawValue
  }
  
  public static func getConfirmed(_ model: AlarmIncidentModel) -> NSNumber? {
    guard let confirmed: Bool = capability.getAlarmIncidentConfirmed(model) else {
      return nil
    }
    return NSNumber(value: confirmed)
  }
  
  public static func getMonitoringState(_ model: AlarmIncidentModel) -> String? {
    return capability.getAlarmIncidentMonitoringState(model)?.rawValue
  }
  
  public static func getPlatformState(_ model: AlarmIncidentModel) -> String? {
    return capability.getAlarmIncidentPlatformState(model)?.rawValue
  }
  
  public static func getHubState(_ model: AlarmIncidentModel) -> String? {
    return capability.getAlarmIncidentHubState(model)?.rawValue
  }
  
  public static func getAlert(_ model: AlarmIncidentModel) -> String? {
    return capability.getAlarmIncidentAlert(model)?.rawValue
  }
  
  public static func getAdditionalAlerts(_ model: AlarmIncidentModel) -> [String]? {
    return capability.getAlarmIncidentAdditionalAlerts(model)
  }
  
  public static func getTracker(_ model: AlarmIncidentModel) -> [Any]? {
    return capability.getAlarmIncidentTracker(model)
  }
  
  public static func getCancelled(_ model: AlarmIncidentModel) -> NSNumber? {
    guard let cancelled: Bool = capability.getAlarmIncidentCancelled(model) else {
      return nil
    }
    return NSNumber(value: cancelled)
  }
  
  public static func getCancelledBy(_ model: AlarmIncidentModel) -> String? {
    return capability.getAlarmIncidentCancelledBy(model)
  }
  
  public static func getMonitored(_ model: AlarmIncidentModel) -> NSNumber? {
    guard let monitored: Bool = capability.getAlarmIncidentMonitored(model) else {
      return nil
    }
    return NSNumber(value: monitored)
  }
  
  public static func verify(_ model: AlarmIncidentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAlarmIncidentVerify(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func cancel(_ model: AlarmIncidentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestAlarmIncidentCancel(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHistoryEntries(_  model: AlarmIncidentModel, limit: Int, token: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestAlarmIncidentListHistoryEntries(model, limit: limit, token: token))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
