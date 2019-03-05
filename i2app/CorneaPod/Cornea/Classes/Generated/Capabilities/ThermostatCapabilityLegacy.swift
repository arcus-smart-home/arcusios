
//
// ThermostatCapabilityLegacy.swift
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

public class ThermostatCapabilityLegacy: NSObject, ArcusThermostatCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ThermostatCapabilityLegacy  = ThermostatCapabilityLegacy()
  
  static let ThermostatHvacmodeOFF: String = ThermostatHvacmode.off.rawValue
  static let ThermostatHvacmodeAUTO: String = ThermostatHvacmode.auto.rawValue
  static let ThermostatHvacmodeCOOL: String = ThermostatHvacmode.cool.rawValue
  static let ThermostatHvacmodeHEAT: String = ThermostatHvacmode.heat.rawValue
  static let ThermostatHvacmodeECO: String = ThermostatHvacmode.eco.rawValue
  
  static let ThermostatEmergencyheatON: String = ThermostatEmergencyheat.on.rawValue
  static let ThermostatEmergencyheatOFF: String = ThermostatEmergencyheat.off.rawValue
  
  static let ThermostatControlmodePRESENCE: String = ThermostatControlmode.presence.rawValue
  static let ThermostatControlmodeMANUAL: String = ThermostatControlmode.manual.rawValue
  static let ThermostatControlmodeSCHEDULESIMPLE: String = ThermostatControlmode.schedulesimple.rawValue
  static let ThermostatControlmodeSCHEDULEADVANCED: String = ThermostatControlmode.scheduleadvanced.rawValue
  
  static let ThermostatActiveRUNNING: String = ThermostatActive.running.rawValue
  static let ThermostatActiveNOTRUNNING: String = ThermostatActive.notrunning.rawValue
  

  
  public static func getCoolsetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let coolsetpoint: Double = capability.getThermostatCoolsetpoint(model) else {
      return nil
    }
    return NSNumber(value: coolsetpoint)
  }
  
  public static func setCoolsetpoint(_ coolsetpoint: Double, model: DeviceModel) {
    
    
    capability.setThermostatCoolsetpoint(coolsetpoint, model: model)
  }
  
  public static func getHeatsetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let heatsetpoint: Double = capability.getThermostatHeatsetpoint(model) else {
      return nil
    }
    return NSNumber(value: heatsetpoint)
  }
  
  public static func setHeatsetpoint(_ heatsetpoint: Double, model: DeviceModel) {
    
    
    capability.setThermostatHeatsetpoint(heatsetpoint, model: model)
  }
  
  public static func getMinsetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let minsetpoint: Double = capability.getThermostatMinsetpoint(model) else {
      return nil
    }
    return NSNumber(value: minsetpoint)
  }
  
  public static func getMaxsetpoint(_ model: DeviceModel) -> NSNumber? {
    guard let maxsetpoint: Double = capability.getThermostatMaxsetpoint(model) else {
      return nil
    }
    return NSNumber(value: maxsetpoint)
  }
  
  public static func getSetpointseparation(_ model: DeviceModel) -> NSNumber? {
    guard let setpointseparation: Double = capability.getThermostatSetpointseparation(model) else {
      return nil
    }
    return NSNumber(value: setpointseparation)
  }
  
  public static func getHvacmode(_ model: DeviceModel) -> String? {
    return capability.getThermostatHvacmode(model)?.rawValue
  }
  
  public static func setHvacmode(_ hvacmode: String, model: DeviceModel) {
    guard let hvacmode: ThermostatHvacmode = ThermostatHvacmode(rawValue: hvacmode) else { return }
    
    capability.setThermostatHvacmode(hvacmode, model: model)
  }
  
  public static func getSupportedmodes(_ model: DeviceModel) -> [String]? {
    return capability.getThermostatSupportedmodes(model)
  }
  
  public static func getSupportsAuto(_ model: DeviceModel) -> NSNumber? {
    guard let supportsAuto: Bool = capability.getThermostatSupportsAuto(model) else {
      return nil
    }
    return NSNumber(value: supportsAuto)
  }
  
  public static func getFanmode(_ model: DeviceModel) -> NSNumber? {
    guard let fanmode: Int = capability.getThermostatFanmode(model) else {
      return nil
    }
    return NSNumber(value: fanmode)
  }
  
  public static func setFanmode(_ fanmode: Int, model: DeviceModel) {
    
    
    capability.setThermostatFanmode(fanmode, model: model)
  }
  
  public static func getMaxfanspeed(_ model: DeviceModel) -> NSNumber? {
    guard let maxfanspeed: Int = capability.getThermostatMaxfanspeed(model) else {
      return nil
    }
    return NSNumber(value: maxfanspeed)
  }
  
  public static func getAutofanspeed(_ model: DeviceModel) -> NSNumber? {
    guard let autofanspeed: Int = capability.getThermostatAutofanspeed(model) else {
      return nil
    }
    return NSNumber(value: autofanspeed)
  }
  
  public static func getEmergencyheat(_ model: DeviceModel) -> String? {
    return capability.getThermostatEmergencyheat(model)?.rawValue
  }
  
  public static func setEmergencyheat(_ emergencyheat: String, model: DeviceModel) {
    guard let emergencyheat: ThermostatEmergencyheat = ThermostatEmergencyheat(rawValue: emergencyheat) else { return }
    
    capability.setThermostatEmergencyheat(emergencyheat, model: model)
  }
  
  public static func getControlmode(_ model: DeviceModel) -> String? {
    return capability.getThermostatControlmode(model)?.rawValue
  }
  
  public static func setControlmode(_ controlmode: String, model: DeviceModel) {
    guard let controlmode: ThermostatControlmode = ThermostatControlmode(rawValue: controlmode) else { return }
    
    capability.setThermostatControlmode(controlmode, model: model)
  }
  
  public static func getFiltertype(_ model: DeviceModel) -> String? {
    return capability.getThermostatFiltertype(model)
  }
  
  public static func setFiltertype(_ filtertype: String, model: DeviceModel) {
    
    
    capability.setThermostatFiltertype(filtertype, model: model)
  }
  
  public static func getFilterlifespanruntime(_ model: DeviceModel) -> NSNumber? {
    guard let filterlifespanruntime: Int = capability.getThermostatFilterlifespanruntime(model) else {
      return nil
    }
    return NSNumber(value: filterlifespanruntime)
  }
  
  public static func setFilterlifespanruntime(_ filterlifespanruntime: Int, model: DeviceModel) {
    
    
    capability.setThermostatFilterlifespanruntime(filterlifespanruntime, model: model)
  }
  
  public static func getFilterlifespandays(_ model: DeviceModel) -> NSNumber? {
    guard let filterlifespandays: Int = capability.getThermostatFilterlifespandays(model) else {
      return nil
    }
    return NSNumber(value: filterlifespandays)
  }
  
  public static func setFilterlifespandays(_ filterlifespandays: Int, model: DeviceModel) {
    
    
    capability.setThermostatFilterlifespandays(filterlifespandays, model: model)
  }
  
  public static func getRuntimesincefilterchange(_ model: DeviceModel) -> NSNumber? {
    guard let runtimesincefilterchange: Int = capability.getThermostatRuntimesincefilterchange(model) else {
      return nil
    }
    return NSNumber(value: runtimesincefilterchange)
  }
  
  public static func getDayssincefilterchange(_ model: DeviceModel) -> NSNumber? {
    guard let dayssincefilterchange: Int = capability.getThermostatDayssincefilterchange(model) else {
      return nil
    }
    return NSNumber(value: dayssincefilterchange)
  }
  
  public static func getActive(_ model: DeviceModel) -> String? {
    return capability.getThermostatActive(model)?.rawValue
  }
  
  public static func changeFilter(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestThermostatChangeFilter(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setIdealTemperature(_  model: DeviceModel, temperature: Double) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestThermostatSetIdealTemperature(model, temperature: temperature))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func incrementIdealTemperature(_  model: DeviceModel, amount: Double) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestThermostatIncrementIdealTemperature(model, amount: amount))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func decrementIdealTemperature(_  model: DeviceModel, amount: Double) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestThermostatDecrementIdealTemperature(model, amount: amount))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
