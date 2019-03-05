
//
// ClimateSubsystemCapabilityLegacy.swift
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

public class ClimateSubsystemCapabilityLegacy: NSObject, ArcusClimateSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ClimateSubsystemCapabilityLegacy  = ClimateSubsystemCapabilityLegacy()
  

  
  public static func getControlDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getClimateSubsystemControlDevices(model)
  }
  
  public static func getTemperatureDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getClimateSubsystemTemperatureDevices(model)
  }
  
  public static func getHumidityDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getClimateSubsystemHumidityDevices(model)
  }
  
  public static func getThermostats(_ model: SubsystemModel) -> [String]? {
    return capability.getClimateSubsystemThermostats(model)
  }
  
  public static func getThermostatSchedules(_ model: SubsystemModel) -> [String: Any]? {
    return capability.getClimateSubsystemThermostatSchedules(model)
  }
  
  public static func getClosedVents(_ model: SubsystemModel) -> [String]? {
    return capability.getClimateSubsystemClosedVents(model)
  }
  
  public static func getActiveFans(_ model: SubsystemModel) -> [String]? {
    return capability.getClimateSubsystemActiveFans(model)
  }
  
  public static func getPrimaryTemperatureDevice(_ model: SubsystemModel) -> String? {
    return capability.getClimateSubsystemPrimaryTemperatureDevice(model)
  }
  
  public static func setPrimaryTemperatureDevice(_ primaryTemperatureDevice: String, model: SubsystemModel) {
    
    
    capability.setClimateSubsystemPrimaryTemperatureDevice(primaryTemperatureDevice, model: model)
  }
  
  public static func getPrimaryHumidityDevice(_ model: SubsystemModel) -> String? {
    return capability.getClimateSubsystemPrimaryHumidityDevice(model)
  }
  
  public static func setPrimaryHumidityDevice(_ primaryHumidityDevice: String, model: SubsystemModel) {
    
    
    capability.setClimateSubsystemPrimaryHumidityDevice(primaryHumidityDevice, model: model)
  }
  
  public static func getPrimaryThermostat(_ model: SubsystemModel) -> String? {
    return capability.getClimateSubsystemPrimaryThermostat(model)
  }
  
  public static func setPrimaryThermostat(_ primaryThermostat: String, model: SubsystemModel) {
    
    
    capability.setClimateSubsystemPrimaryThermostat(primaryThermostat, model: model)
  }
  
  public static func getTemperature(_ model: SubsystemModel) -> NSNumber? {
    guard let temperature: Double = capability.getClimateSubsystemTemperature(model) else {
      return nil
    }
    return NSNumber(value: temperature)
  }
  
  public static func getHumidity(_ model: SubsystemModel) -> NSNumber? {
    guard let humidity: Double = capability.getClimateSubsystemHumidity(model) else {
      return nil
    }
    return NSNumber(value: humidity)
  }
  
  public static func getActiveHeaters(_ model: SubsystemModel) -> [String]? {
    return capability.getClimateSubsystemActiveHeaters(model)
  }
  
  public static func enableScheduler(_  model: SubsystemModel, thermostat: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestClimateSubsystemEnableScheduler(model, thermostat: thermostat))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disableScheduler(_  model: SubsystemModel, thermostat: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestClimateSubsystemDisableScheduler(model, thermostat: thermostat))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
