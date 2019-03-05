
//
// PlaceMonitorSubsystemCapabilityLegacy.swift
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

public class PlaceMonitorSubsystemCapabilityLegacy: NSObject, ArcusPlaceMonitorSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PlaceMonitorSubsystemCapabilityLegacy  = PlaceMonitorSubsystemCapabilityLegacy()
  
  static let PlaceMonitorSubsystemPairingStatePAIRING: String = PlaceMonitorSubsystemPairingState.pairing.rawValue
  static let PlaceMonitorSubsystemPairingStateUNPAIRING: String = PlaceMonitorSubsystemPairingState.unpairing.rawValue
  static let PlaceMonitorSubsystemPairingStateIDLE: String = PlaceMonitorSubsystemPairingState.idle.rawValue
  static let PlaceMonitorSubsystemPairingStatePARTIAL: String = PlaceMonitorSubsystemPairingState.partial.rawValue
  

  
  public static func getUpdatedDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getPlaceMonitorSubsystemUpdatedDevices(model)
  }
  
  public static func getDefaultRulesDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getPlaceMonitorSubsystemDefaultRulesDevices(model)
  }
  
  public static func getOfflineNotificationSent(_ model: SubsystemModel) -> [String: Double]? {
    return capability.getPlaceMonitorSubsystemOfflineNotificationSent(model)
  }
  
  public static func getLowBatteryNotificationSent(_ model: SubsystemModel) -> [String: Double]? {
    return capability.getPlaceMonitorSubsystemLowBatteryNotificationSent(model)
  }
  
  public static func getPairingState(_ model: SubsystemModel) -> String? {
    return capability.getPlaceMonitorSubsystemPairingState(model)?.rawValue
  }
  
  public static func getSmartHomeAlerts(_ model: SubsystemModel) -> [Any]? {
    return capability.getPlaceMonitorSubsystemSmartHomeAlerts(model)
  }
  
  public static func renderAlerts(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlaceMonitorSubsystemRenderAlerts(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
