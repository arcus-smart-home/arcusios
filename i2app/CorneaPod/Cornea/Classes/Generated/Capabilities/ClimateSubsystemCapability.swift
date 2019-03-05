
//
// ClimateSubsystemCap.swift
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
  public static var climateSubsystemNamespace: String = "subclimate"
  public static var climateSubsystemName: String = "ClimateSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let climateSubsystemControlDevices: String = "subclimate:controlDevices"
  static let climateSubsystemTemperatureDevices: String = "subclimate:temperatureDevices"
  static let climateSubsystemHumidityDevices: String = "subclimate:humidityDevices"
  static let climateSubsystemThermostats: String = "subclimate:thermostats"
  static let climateSubsystemThermostatSchedules: String = "subclimate:thermostatSchedules"
  static let climateSubsystemClosedVents: String = "subclimate:closedVents"
  static let climateSubsystemActiveFans: String = "subclimate:activeFans"
  static let climateSubsystemPrimaryTemperatureDevice: String = "subclimate:primaryTemperatureDevice"
  static let climateSubsystemPrimaryHumidityDevice: String = "subclimate:primaryHumidityDevice"
  static let climateSubsystemPrimaryThermostat: String = "subclimate:primaryThermostat"
  static let climateSubsystemTemperature: String = "subclimate:temperature"
  static let climateSubsystemHumidity: String = "subclimate:humidity"
  static let climateSubsystemActiveHeaters: String = "subclimate:activeHeaters"
  
}

public protocol ArcusClimateSubsystemCapability: class, RxArcusService {
  /** The addresses of all the climate control devices in the climate subsystem, this includes thermostats, fans, vents and spaceheaters. */
  func getClimateSubsystemControlDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of all the devices in the place that have the temperature capability. */
  func getClimateSubsystemTemperatureDevices(_ model: SubsystemModel) -> [String]?
  /** The addresses of all the devices in the place that have the humidity capability. */
  func getClimateSubsystemHumidityDevices(_ model: SubsystemModel) -> [String]?
  /** DEPRECATED: This attribute is deprecated and will be removed in future iterations! The addresses of all the devices in the place that have the thermostat capability. */
  func getClimateSubsystemThermostats(_ model: SubsystemModel) -> [String]?
  /** The current status of the schedule for each thermostat */
  func getClimateSubsystemThermostatSchedules(_ model: SubsystemModel) -> [String: Any]?
  /**  The addresses of all vents that are currently closed. */
  func getClimateSubsystemClosedVents(_ model: SubsystemModel) -> [String]?
  /** The addresses of all fans that are currently turned on. */
  func getClimateSubsystemActiveFans(_ model: SubsystemModel) -> [String]?
  /** The temperature sensor that should be used when displaying the temperature for the whole place.  This may be null if no devices support temperature. */
  func getClimateSubsystemPrimaryTemperatureDevice(_ model: SubsystemModel) -> String?
  /** The temperature sensor that should be used when displaying the temperature for the whole place.  This may be null if no devices support temperature. */
  func setClimateSubsystemPrimaryTemperatureDevice(_ primaryTemperatureDevice: String, model: SubsystemModel)
/**  The humidity sensor that should be used when displaying the humidity for the whole place.  This may be null if no devices support humidity. */
  func getClimateSubsystemPrimaryHumidityDevice(_ model: SubsystemModel) -> String?
  /**  The humidity sensor that should be used when displaying the humidity for the whole place.  This may be null if no devices support humidity. */
  func setClimateSubsystemPrimaryHumidityDevice(_ primaryHumidityDevice: String, model: SubsystemModel)
/** The primary thermostat for the house, this may be null if there are no thermostat devices. */
  func getClimateSubsystemPrimaryThermostat(_ model: SubsystemModel) -> String?
  /** The primary thermostat for the house, this may be null if there are no thermostat devices. */
  func setClimateSubsystemPrimaryThermostat(_ primaryThermostat: String, model: SubsystemModel)
/** The current temperature for the place, this may be null if there are no temperature devices.  This is currently calculated from primaryTemperatureDevice. */
  func getClimateSubsystemTemperature(_ model: SubsystemModel) -> Double?
  /** The current humidity for the place, this may be null if there are no humidity devices.  This is currently calculated from primaryHumidityDevice. */
  func getClimateSubsystemHumidity(_ model: SubsystemModel) -> Double?
  /** The addresses of all devices that implement spaceheater and have heatstate value of ON */
  func getClimateSubsystemActiveHeaters(_ model: SubsystemModel) -> [String]?
  
  /** Enables the scheduler associated with the given thermostat.  NOTE this will return a &#x27;timezone.notset&#x27; error if the place does not have a valid timezone. */
  func requestClimateSubsystemEnableScheduler(_  model: SubsystemModel, thermostat: String)
   throws -> Observable<ArcusSessionEvent>/** Enables the scheduler associated with the given thermostat. */
  func requestClimateSubsystemDisableScheduler(_  model: SubsystemModel, thermostat: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusClimateSubsystemCapability {
  public func getClimateSubsystemControlDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemControlDevices] as? [String]
  }
  
  public func getClimateSubsystemTemperatureDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemTemperatureDevices] as? [String]
  }
  
  public func getClimateSubsystemHumidityDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemHumidityDevices] as? [String]
  }
  
  public func getClimateSubsystemThermostats(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemThermostats] as? [String]
  }
  
  public func getClimateSubsystemThermostatSchedules(_ model: SubsystemModel) -> [String: Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemThermostatSchedules] as? [String: Any]
  }
  
  public func getClimateSubsystemClosedVents(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemClosedVents] as? [String]
  }
  
  public func getClimateSubsystemActiveFans(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemActiveFans] as? [String]
  }
  
  public func getClimateSubsystemPrimaryTemperatureDevice(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemPrimaryTemperatureDevice] as? String
  }
  
  public func setClimateSubsystemPrimaryTemperatureDevice(_ primaryTemperatureDevice: String, model: SubsystemModel) {
    model.set([Attributes.climateSubsystemPrimaryTemperatureDevice: primaryTemperatureDevice as AnyObject])
  }
  public func getClimateSubsystemPrimaryHumidityDevice(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemPrimaryHumidityDevice] as? String
  }
  
  public func setClimateSubsystemPrimaryHumidityDevice(_ primaryHumidityDevice: String, model: SubsystemModel) {
    model.set([Attributes.climateSubsystemPrimaryHumidityDevice: primaryHumidityDevice as AnyObject])
  }
  public func getClimateSubsystemPrimaryThermostat(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemPrimaryThermostat] as? String
  }
  
  public func setClimateSubsystemPrimaryThermostat(_ primaryThermostat: String, model: SubsystemModel) {
    model.set([Attributes.climateSubsystemPrimaryThermostat: primaryThermostat as AnyObject])
  }
  public func getClimateSubsystemTemperature(_ model: SubsystemModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemTemperature] as? Double
  }
  
  public func getClimateSubsystemHumidity(_ model: SubsystemModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemHumidity] as? Double
  }
  
  public func getClimateSubsystemActiveHeaters(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.climateSubsystemActiveHeaters] as? [String]
  }
  
  
  public func requestClimateSubsystemEnableScheduler(_  model: SubsystemModel, thermostat: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ClimateSubsystemEnableSchedulerRequest = ClimateSubsystemEnableSchedulerRequest()
    request.source = model.address
    
    
    
    request.setThermostat(thermostat)
    
    return try sendRequest(request)
  }
  
  public func requestClimateSubsystemDisableScheduler(_  model: SubsystemModel, thermostat: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ClimateSubsystemDisableSchedulerRequest = ClimateSubsystemDisableSchedulerRequest()
    request.source = model.address
    
    
    
    request.setThermostat(thermostat)
    
    return try sendRequest(request)
  }
  
}
