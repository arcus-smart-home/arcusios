
//
// WeatherSubsystemCap.swift
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
  public static var weatherSubsystemNamespace: String = "subweather"
  public static var weatherSubsystemName: String = "WeatherSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let weatherSubsystemWeatherRadios: String = "subweather:weatherRadios"
  static let weatherSubsystemWeatherAlert: String = "subweather:weatherAlert"
  static let weatherSubsystemAlertingRadios: String = "subweather:alertingRadios"
  static let weatherSubsystemLastWeatherAlertTime: String = "subweather:lastWeatherAlertTime"
  
}

public protocol ArcusWeatherSubsystemCapability: class, RxArcusService {
  /** The set of weather radio devices in the place */
  func getWeatherSubsystemWeatherRadios(_ model: SubsystemModel) -> [String]?
  /** Indicates the whether any weather radios are currently alerting         - READY - No weather radios are alerting         - ALERT - One or more weather radios are alerting */
  func getWeatherSubsystemWeatherAlert(_ model: SubsystemModel) -> WeatherSubsystemWeatherAlert?
  /** A map of NWS EAS event codes for the current alert to the devices that are reporting that alert */
  func getWeatherSubsystemAlertingRadios(_ model: SubsystemModel) -> [String: [String]]?
  /** The last time a weather alert was raised */
  func getWeatherSubsystemLastWeatherAlertTime(_ model: SubsystemModel) -> Date?
  
  /** Send a stopplaying request to each station that is playing a weather alert. */
  func requestWeatherSubsystemSnoozeAllAlerts(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusWeatherSubsystemCapability {
  public func getWeatherSubsystemWeatherRadios(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weatherSubsystemWeatherRadios] as? [String]
  }
  
  public func getWeatherSubsystemWeatherAlert(_ model: SubsystemModel) -> WeatherSubsystemWeatherAlert? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.weatherSubsystemWeatherAlert] as? String,
      let enumAttr: WeatherSubsystemWeatherAlert = WeatherSubsystemWeatherAlert(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getWeatherSubsystemAlertingRadios(_ model: SubsystemModel) -> [String: [String]]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weatherSubsystemAlertingRadios] as? [String: [String]]
  }
  
  public func getWeatherSubsystemLastWeatherAlertTime(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.weatherSubsystemLastWeatherAlertTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestWeatherSubsystemSnoozeAllAlerts(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: WeatherSubsystemSnoozeAllAlertsRequest = WeatherSubsystemSnoozeAllAlertsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
