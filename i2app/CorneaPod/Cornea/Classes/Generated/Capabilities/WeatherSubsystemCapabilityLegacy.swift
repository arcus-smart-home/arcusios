
//
// WeatherSubsystemCapabilityLegacy.swift
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

public class WeatherSubsystemCapabilityLegacy: NSObject, ArcusWeatherSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: WeatherSubsystemCapabilityLegacy  = WeatherSubsystemCapabilityLegacy()
  
  static let WeatherSubsystemWeatherAlertREADY: String = WeatherSubsystemWeatherAlert.ready.rawValue
  static let WeatherSubsystemWeatherAlertALERT: String = WeatherSubsystemWeatherAlert.alert.rawValue
  

  
  public static func getWeatherRadios(_ model: SubsystemModel) -> [String]? {
    return capability.getWeatherSubsystemWeatherRadios(model)
  }
  
  public static func getWeatherAlert(_ model: SubsystemModel) -> String? {
    return capability.getWeatherSubsystemWeatherAlert(model)?.rawValue
  }
  
  public static func getAlertingRadios(_ model: SubsystemModel) -> [String: [String]]? {
    return capability.getWeatherSubsystemAlertingRadios(model)
  }
  
  public static func getLastWeatherAlertTime(_ model: SubsystemModel) -> Date? {
    guard let lastWeatherAlertTime: Date = capability.getWeatherSubsystemLastWeatherAlertTime(model) else {
      return nil
    }
    return lastWeatherAlertTime
  }
  
  public static func snoozeAllAlerts(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestWeatherSubsystemSnoozeAllAlerts(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
