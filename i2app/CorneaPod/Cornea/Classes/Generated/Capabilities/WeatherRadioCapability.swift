
//
// WeatherRadioCap.swift
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
  public static var weatherRadioNamespace: String = "noaa"
  public static var weatherRadioName: String = "WeatherRadio"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let weatherRadioAlertstate: String = "noaa:alertstate"
  static let weatherRadioPlayingstate: String = "noaa:playingstate"
  static let weatherRadioCurrentalert: String = "noaa:currentalert"
  static let weatherRadioLastalerttime: String = "noaa:lastalerttime"
  static let weatherRadioAlertsofinterest: String = "noaa:alertsofinterest"
  static let weatherRadioLocation: String = "noaa:location"
  static let weatherRadioStationselected: String = "noaa:stationselected"
  static let weatherRadioFrequency: String = "noaa:frequency"
  
}

public protocol ArcusWeatherRadioCapability: class, RxArcusService {
  /** Reflects the current state of the weather radio (alerting, no existing alert, or an existing hushed alert). */
  func getWeatherRadioAlertstate(_ model: DeviceModel) -> WeatherRadioAlertstate?
  /** Reflects whether the weather radio is currently playing or is quiet. */
  func getWeatherRadioPlayingstate(_ model: DeviceModel) -> WeatherRadioPlayingstate?
  /** EAS code for current alert (three letter strings). Set to NONE when no alert is active. Set to UNKNOWN when a code not currently known is sent. */
  func getWeatherRadioCurrentalert(_ model: DeviceModel) -> String?
  /** UTC date time of last alert start time. Note if alert changes (county list or duration), timestamp will be updated. */
  func getWeatherRadioLastalerttime(_ model: DeviceModel) -> Date?
  /** List of EAS alert codes the user wishes to be notifed of (three letter strings). */
  func getWeatherRadioAlertsofinterest(_ model: DeviceModel) -> [String]?
  /** List of EAS alert codes the user wishes to be notifed of (three letter strings). */
  func setWeatherRadioAlertsofinterest(_ alertsofinterest: [String], model: DeviceModel)
/** Six digit S.A.M.E. code for locations published by NOAA. */
  func getWeatherRadioLocation(_ model: DeviceModel) -> String?
  /** Six digit S.A.M.E. code for locations published by NOAA. */
  func setWeatherRadioLocation(_ location: String, model: DeviceModel)
/** station ID of selected station. */
  func getWeatherRadioStationselected(_ model: DeviceModel) -> Int?
  /** station ID of selected station. */
  func setWeatherRadioStationselected(_ stationselected: Int, model: DeviceModel)
/** Broadcast frequency of selected station. */
  func getWeatherRadioFrequency(_ model: DeviceModel) -> String?
  
  /** Scans all stations to determine which can be heard. */
  func requestWeatherRadioScanStations(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Play selected station to allow user to select amongst the options. */
  func requestWeatherRadioPlayStation(_  model: DeviceModel, station: Int, time: Int)
   throws -> Observable<ArcusSessionEvent>/** Stop playing current station. */
  func requestWeatherRadioStopPlayingStation(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Select station as the one Halo will use. */
  func requestWeatherRadioSelectStation(_  model: DeviceModel, station: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusWeatherRadioCapability {
  public func getWeatherRadioAlertstate(_ model: DeviceModel) -> WeatherRadioAlertstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.weatherRadioAlertstate] as? String,
      let enumAttr: WeatherRadioAlertstate = WeatherRadioAlertstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getWeatherRadioPlayingstate(_ model: DeviceModel) -> WeatherRadioPlayingstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.weatherRadioPlayingstate] as? String,
      let enumAttr: WeatherRadioPlayingstate = WeatherRadioPlayingstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getWeatherRadioCurrentalert(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weatherRadioCurrentalert] as? String
  }
  
  public func getWeatherRadioLastalerttime(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.weatherRadioLastalerttime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getWeatherRadioAlertsofinterest(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weatherRadioAlertsofinterest] as? [String]
  }
  
  public func setWeatherRadioAlertsofinterest(_ alertsofinterest: [String], model: DeviceModel) {
    model.set([Attributes.weatherRadioAlertsofinterest: alertsofinterest as AnyObject])
  }
  public func getWeatherRadioLocation(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weatherRadioLocation] as? String
  }
  
  public func setWeatherRadioLocation(_ location: String, model: DeviceModel) {
    model.set([Attributes.weatherRadioLocation: location as AnyObject])
  }
  public func getWeatherRadioStationselected(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weatherRadioStationselected] as? Int
  }
  
  public func setWeatherRadioStationselected(_ stationselected: Int, model: DeviceModel) {
    model.set([Attributes.weatherRadioStationselected: stationselected as AnyObject])
  }
  public func getWeatherRadioFrequency(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.weatherRadioFrequency] as? String
  }
  
  
  public func requestWeatherRadioScanStations(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: WeatherRadioScanStationsRequest = WeatherRadioScanStationsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestWeatherRadioPlayStation(_  model: DeviceModel, station: Int, time: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: WeatherRadioPlayStationRequest = WeatherRadioPlayStationRequest()
    request.source = model.address
    
    
    
    request.setStation(station)
    
    request.setTime(time)
    
    return try sendRequest(request)
  }
  
  public func requestWeatherRadioStopPlayingStation(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: WeatherRadioStopPlayingStationRequest = WeatherRadioStopPlayingStationRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestWeatherRadioSelectStation(_  model: DeviceModel, station: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: WeatherRadioSelectStationRequest = WeatherRadioSelectStationRequest()
    request.source = model.address
    
    
    
    request.setStation(station)
    
    return try sendRequest(request)
  }
  
}
