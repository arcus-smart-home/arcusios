
//
// WeatherRadioCapabilityLegacy.swift
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

public class WeatherRadioCapabilityLegacy: NSObject, ArcusWeatherRadioCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: WeatherRadioCapabilityLegacy  = WeatherRadioCapabilityLegacy()
  
  static let WeatherRadioAlertstateALERT: String = WeatherRadioAlertstate.alert.rawValue
  static let WeatherRadioAlertstateNO_ALERT: String = WeatherRadioAlertstate.no_alert.rawValue
  static let WeatherRadioAlertstateHUSHED: String = WeatherRadioAlertstate.hushed.rawValue
  
  static let WeatherRadioPlayingstatePLAYING: String = WeatherRadioPlayingstate.playing.rawValue
  static let WeatherRadioPlayingstateQUIET: String = WeatherRadioPlayingstate.quiet.rawValue
  

  
  public static func getAlertstate(_ model: DeviceModel) -> String? {
    return capability.getWeatherRadioAlertstate(model)?.rawValue
  }
  
  public static func getPlayingstate(_ model: DeviceModel) -> String? {
    return capability.getWeatherRadioPlayingstate(model)?.rawValue
  }
  
  public static func getCurrentalert(_ model: DeviceModel) -> String? {
    return capability.getWeatherRadioCurrentalert(model)
  }
  
  public static func getLastalerttime(_ model: DeviceModel) -> Date? {
    guard let lastalerttime: Date = capability.getWeatherRadioLastalerttime(model) else {
      return nil
    }
    return lastalerttime
  }
  
  public static func getAlertsofinterest(_ model: DeviceModel) -> [String]? {
    return capability.getWeatherRadioAlertsofinterest(model)
  }
  
  public static func setAlertsofinterest(_ alertsofinterest: [String], model: DeviceModel) {
    
    
    capability.setWeatherRadioAlertsofinterest(alertsofinterest, model: model)
  }
  
  public static func getLocation(_ model: DeviceModel) -> String? {
    return capability.getWeatherRadioLocation(model)
  }
  
  public static func setLocation(_ location: String, model: DeviceModel) {
    
    
    capability.setWeatherRadioLocation(location, model: model)
  }
  
  public static func getStationselected(_ model: DeviceModel) -> NSNumber? {
    guard let stationselected: Int = capability.getWeatherRadioStationselected(model) else {
      return nil
    }
    return NSNumber(value: stationselected)
  }
  
  public static func setStationselected(_ stationselected: Int, model: DeviceModel) {
    
    
    capability.setWeatherRadioStationselected(stationselected, model: model)
  }
  
  public static func getFrequency(_ model: DeviceModel) -> String? {
    return capability.getWeatherRadioFrequency(model)
  }
  
  public static func scanStations(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestWeatherRadioScanStations(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func playStation(_  model: DeviceModel, station: Int, time: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestWeatherRadioPlayStation(model, station: station, time: time))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func stopPlayingStation(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestWeatherRadioStopPlayingStation(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func selectStation(_  model: DeviceModel, station: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestWeatherRadioSelectStation(model, station: station))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
