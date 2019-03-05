
//
// PlaceMonitorSubsystemCap.swift
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
  public static var placeMonitorSubsystemNamespace: String = "subplacemonitor"
  public static var placeMonitorSubsystemName: String = "PlaceMonitorSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let placeMonitorSubsystemUpdatedDevices: String = "subplacemonitor:updatedDevices"
  static let placeMonitorSubsystemDefaultRulesDevices: String = "subplacemonitor:defaultRulesDevices"
  static let placeMonitorSubsystemOfflineNotificationSent: String = "subplacemonitor:offlineNotificationSent"
  static let placeMonitorSubsystemLowBatteryNotificationSent: String = "subplacemonitor:lowBatteryNotificationSent"
  static let placeMonitorSubsystemPairingState: String = "subplacemonitor:pairingState"
  static let placeMonitorSubsystemSmartHomeAlerts: String = "subplacemonitor:smartHomeAlerts"
  
}

public protocol ArcusPlaceMonitorSubsystemCapability: class, RxArcusService {
  /** The addresses and version of all the devices that have OTA firmware upgrades requests issued. */
  func getPlaceMonitorSubsystemUpdatedDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of all the devices that have default rules and schedules . */
  func getPlaceMonitorSubsystemDefaultRulesDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of all the devices that have offline notifications sent . */
  func getPlaceMonitorSubsystemOfflineNotificationSent(_ model: SubsystemModel) -> [String: Double]?
  /** The addresses of all the devices that have a low battery notification sent. */
  func getPlaceMonitorSubsystemLowBatteryNotificationSent(_ model: SubsystemModel) -> [String: Double]?
  /** Pairing state of the place. */
  func getPlaceMonitorSubsystemPairingState(_ model: SubsystemModel) -> PlaceMonitorSubsystemPairingState?
  /** The list of current smart home alerts. */
  func getPlaceMonitorSubsystemSmartHomeAlerts(_ model: SubsystemModel) -> [Any]?
  
  /** Renders all alerts */
  func requestPlaceMonitorSubsystemRenderAlerts(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusPlaceMonitorSubsystemCapability {
  public func getPlaceMonitorSubsystemUpdatedDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeMonitorSubsystemUpdatedDevices] as? [String]
  }
  
  public func getPlaceMonitorSubsystemDefaultRulesDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeMonitorSubsystemDefaultRulesDevices] as? [String]
  }
  
  public func getPlaceMonitorSubsystemOfflineNotificationSent(_ model: SubsystemModel) -> [String: Double]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeMonitorSubsystemOfflineNotificationSent] as? [String: Double]
  }
  
  public func getPlaceMonitorSubsystemLowBatteryNotificationSent(_ model: SubsystemModel) -> [String: Double]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeMonitorSubsystemLowBatteryNotificationSent] as? [String: Double]
  }
  
  public func getPlaceMonitorSubsystemPairingState(_ model: SubsystemModel) -> PlaceMonitorSubsystemPairingState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.placeMonitorSubsystemPairingState] as? String,
      let enumAttr: PlaceMonitorSubsystemPairingState = PlaceMonitorSubsystemPairingState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPlaceMonitorSubsystemSmartHomeAlerts(_ model: SubsystemModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeMonitorSubsystemSmartHomeAlerts] as? [Any]
  }
  
  
  public func requestPlaceMonitorSubsystemRenderAlerts(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceMonitorSubsystemRenderAlertsRequest = PlaceMonitorSubsystemRenderAlertsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
