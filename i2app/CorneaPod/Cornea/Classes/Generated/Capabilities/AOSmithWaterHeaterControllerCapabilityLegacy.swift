
//
// AOSmithWaterHeaterControllerCapabilityLegacy.swift
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

public class AOSmithWaterHeaterControllerCapabilityLegacy: NSObject, ArcusAOSmithWaterHeaterControllerCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: AOSmithWaterHeaterControllerCapabilityLegacy  = AOSmithWaterHeaterControllerCapabilityLegacy()
  
  static let AOSmithWaterHeaterControllerUnitsC: String = AOSmithWaterHeaterControllerUnits.c.rawValue
  static let AOSmithWaterHeaterControllerUnitsF: String = AOSmithWaterHeaterControllerUnits.f.rawValue
  
  static let AOSmithWaterHeaterControllerControlmodeSTANDARD: String = AOSmithWaterHeaterControllerControlmode.standard.rawValue
  static let AOSmithWaterHeaterControllerControlmodeVACATION: String = AOSmithWaterHeaterControllerControlmode.vacation.rawValue
  static let AOSmithWaterHeaterControllerControlmodeENERGY_SMART: String = AOSmithWaterHeaterControllerControlmode.energy_smart.rawValue
  
  static let AOSmithWaterHeaterControllerLeakdetectDISABLED: String = AOSmithWaterHeaterControllerLeakdetect.disabled.rawValue
  static let AOSmithWaterHeaterControllerLeakdetectENABLED: String = AOSmithWaterHeaterControllerLeakdetect.enabled.rawValue
  static let AOSmithWaterHeaterControllerLeakdetectNOTDETECTED: String = AOSmithWaterHeaterControllerLeakdetect.notdetected.rawValue
  
  static let AOSmithWaterHeaterControllerLeakNONE: String = AOSmithWaterHeaterControllerLeak.none.rawValue
  static let AOSmithWaterHeaterControllerLeakDETECTED: String = AOSmithWaterHeaterControllerLeak.detected.rawValue
  static let AOSmithWaterHeaterControllerLeakUNPLUGGED: String = AOSmithWaterHeaterControllerLeak.unplugged.rawValue
  static let AOSmithWaterHeaterControllerLeakERROR: String = AOSmithWaterHeaterControllerLeak.error.rawValue
  
  static let AOSmithWaterHeaterControllerElementfailNONE: String = AOSmithWaterHeaterControllerElementfail.none.rawValue
  static let AOSmithWaterHeaterControllerElementfailUPPER: String = AOSmithWaterHeaterControllerElementfail.upper.rawValue
  static let AOSmithWaterHeaterControllerElementfailLOWER: String = AOSmithWaterHeaterControllerElementfail.lower.rawValue
  static let AOSmithWaterHeaterControllerElementfailUPPER_LOWER: String = AOSmithWaterHeaterControllerElementfail.upper_lower.rawValue
  
  static let AOSmithWaterHeaterControllerTanksensorfailNONE: String = AOSmithWaterHeaterControllerTanksensorfail.none.rawValue
  static let AOSmithWaterHeaterControllerTanksensorfailUPPER: String = AOSmithWaterHeaterControllerTanksensorfail.upper.rawValue
  static let AOSmithWaterHeaterControllerTanksensorfailLOWER: String = AOSmithWaterHeaterControllerTanksensorfail.lower.rawValue
  static let AOSmithWaterHeaterControllerTanksensorfailUPPER_LOWER: String = AOSmithWaterHeaterControllerTanksensorfail.upper_lower.rawValue
  
  static let AOSmithWaterHeaterControllerMasterdispfailNONE: String = AOSmithWaterHeaterControllerMasterdispfail.none.rawValue
  static let AOSmithWaterHeaterControllerMasterdispfailMASTER: String = AOSmithWaterHeaterControllerMasterdispfail.master.rawValue
  static let AOSmithWaterHeaterControllerMasterdispfailDISPLAY: String = AOSmithWaterHeaterControllerMasterdispfail.display.rawValue
  

  
  public static func getUpdaterate(_ model: DeviceModel) -> NSNumber? {
    guard let updaterate: Int = capability.getAOSmithWaterHeaterControllerUpdaterate(model) else {
      return nil
    }
    return NSNumber(value: updaterate)
  }
  
  public static func setUpdaterate(_ updaterate: Int, model: DeviceModel) {
    
    
    capability.setAOSmithWaterHeaterControllerUpdaterate(updaterate, model: model)
  }
  
  public static func getUnits(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerUnits(model)?.rawValue
  }
  
  public static func setUnits(_ units: String, model: DeviceModel) {
    guard let units: AOSmithWaterHeaterControllerUnits = AOSmithWaterHeaterControllerUnits(rawValue: units) else { return }
    
    capability.setAOSmithWaterHeaterControllerUnits(units, model: model)
  }
  
  public static func getControlmode(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerControlmode(model)?.rawValue
  }
  
  public static func setControlmode(_ controlmode: String, model: DeviceModel) {
    guard let controlmode: AOSmithWaterHeaterControllerControlmode = AOSmithWaterHeaterControllerControlmode(rawValue: controlmode) else { return }
    
    capability.setAOSmithWaterHeaterControllerControlmode(controlmode, model: model)
  }
  
  public static func getLeakdetect(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerLeakdetect(model)?.rawValue
  }
  
  public static func setLeakdetect(_ leakdetect: String, model: DeviceModel) {
    guard let leakdetect: AOSmithWaterHeaterControllerLeakdetect = AOSmithWaterHeaterControllerLeakdetect(rawValue: leakdetect) else { return }
    
    capability.setAOSmithWaterHeaterControllerLeakdetect(leakdetect, model: model)
  }
  
  public static func getLeak(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerLeak(model)?.rawValue
  }
  
  public static func getGridenabled(_ model: DeviceModel) -> NSNumber? {
    guard let gridenabled: Bool = capability.getAOSmithWaterHeaterControllerGridenabled(model) else {
      return nil
    }
    return NSNumber(value: gridenabled)
  }
  
  public static func getDryfire(_ model: DeviceModel) -> NSNumber? {
    guard let dryfire: Bool = capability.getAOSmithWaterHeaterControllerDryfire(model) else {
      return nil
    }
    return NSNumber(value: dryfire)
  }
  
  public static func getElementfail(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerElementfail(model)?.rawValue
  }
  
  public static func getTanksensorfail(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerTanksensorfail(model)?.rawValue
  }
  
  public static func getEcoerror(_ model: DeviceModel) -> NSNumber? {
    guard let ecoerror: Bool = capability.getAOSmithWaterHeaterControllerEcoerror(model) else {
      return nil
    }
    return NSNumber(value: ecoerror)
  }
  
  public static func getMasterdispfail(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerMasterdispfail(model)?.rawValue
  }
  
  public static func getErrors(_ model: DeviceModel) -> [String: String]? {
    return capability.getAOSmithWaterHeaterControllerErrors(model)
  }
  
  public static func getModelnumber(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerModelnumber(model)
  }
  
  public static func setModelnumber(_ modelnumber: String, model: DeviceModel) {
    
    
    capability.setAOSmithWaterHeaterControllerModelnumber(modelnumber, model: model)
  }
  
  public static func getSerialnumber(_ model: DeviceModel) -> String? {
    return capability.getAOSmithWaterHeaterControllerSerialnumber(model)
  }
  
  public static func setSerialnumber(_ serialnumber: String, model: DeviceModel) {
    
    
    capability.setAOSmithWaterHeaterControllerSerialnumber(serialnumber, model: model)
  }
  
}
