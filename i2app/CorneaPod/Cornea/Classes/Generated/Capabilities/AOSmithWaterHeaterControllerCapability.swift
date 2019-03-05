
//
// AOSmithWaterHeaterControllerCap.swift
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
  public static var aOSmithWaterHeaterControllerNamespace: String = "aosmithwaterheatercontroller"
  public static var aOSmithWaterHeaterControllerName: String = "AOSmithWaterHeaterController"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let aOSmithWaterHeaterControllerUpdaterate: String = "aosmithwaterheatercontroller:updaterate"
  static let aOSmithWaterHeaterControllerUnits: String = "aosmithwaterheatercontroller:units"
  static let aOSmithWaterHeaterControllerControlmode: String = "aosmithwaterheatercontroller:controlmode"
  static let aOSmithWaterHeaterControllerLeakdetect: String = "aosmithwaterheatercontroller:leakdetect"
  static let aOSmithWaterHeaterControllerLeak: String = "aosmithwaterheatercontroller:leak"
  static let aOSmithWaterHeaterControllerGridenabled: String = "aosmithwaterheatercontroller:gridenabled"
  static let aOSmithWaterHeaterControllerDryfire: String = "aosmithwaterheatercontroller:dryfire"
  static let aOSmithWaterHeaterControllerElementfail: String = "aosmithwaterheatercontroller:elementfail"
  static let aOSmithWaterHeaterControllerTanksensorfail: String = "aosmithwaterheatercontroller:tanksensorfail"
  static let aOSmithWaterHeaterControllerEcoerror: String = "aosmithwaterheatercontroller:ecoerror"
  static let aOSmithWaterHeaterControllerMasterdispfail: String = "aosmithwaterheatercontroller:masterdispfail"
  static let aOSmithWaterHeaterControllerErrors: String = "aosmithwaterheatercontroller:errors"
  static let aOSmithWaterHeaterControllerModelnumber: String = "aosmithwaterheatercontroller:modelnumber"
  static let aOSmithWaterHeaterControllerSerialnumber: String = "aosmithwaterheatercontroller:serialnumber"
  
}

public protocol ArcusAOSmithWaterHeaterControllerCapability: class, RxArcusService {
  /** The rate in seconds of how often the water heater polls the platform. */
  func getAOSmithWaterHeaterControllerUpdaterate(_ model: DeviceModel) -> Int?
  /** The rate in seconds of how often the water heater polls the platform. */
  func setAOSmithWaterHeaterControllerUpdaterate(_ updaterate: Int, model: DeviceModel)
/** The display unit of the temperation. */
  func getAOSmithWaterHeaterControllerUnits(_ model: DeviceModel) -> AOSmithWaterHeaterControllerUnits?
  /** The display unit of the temperation. */
  func setAOSmithWaterHeaterControllerUnits(_ units: AOSmithWaterHeaterControllerUnits, model: DeviceModel)
/** This is the mode setting of the device, not whether or not it is actually heating the water at the moment. */
  func getAOSmithWaterHeaterControllerControlmode(_ model: DeviceModel) -> AOSmithWaterHeaterControllerControlmode?
  /** This is the mode setting of the device, not whether or not it is actually heating the water at the moment. */
  func setAOSmithWaterHeaterControllerControlmode(_ controlmode: AOSmithWaterHeaterControllerControlmode, model: DeviceModel)
/** Enable or disable leak detection. Or report that no sensor is present and force to disabled. */
  func getAOSmithWaterHeaterControllerLeakdetect(_ model: DeviceModel) -> AOSmithWaterHeaterControllerLeakdetect?
  /** Enable or disable leak detection. Or report that no sensor is present and force to disabled. */
  func setAOSmithWaterHeaterControllerLeakdetect(_ leakdetect: AOSmithWaterHeaterControllerLeakdetect, model: DeviceModel)
/** Water conductivity detected on probes. */
  func getAOSmithWaterHeaterControllerLeak(_ model: DeviceModel) -> AOSmithWaterHeaterControllerLeak?
  /** This device was originally destined for utilities, so if the grid is controlling your device, it means you are responding to commands over Wifi. */
  func getAOSmithWaterHeaterControllerGridenabled(_ model: DeviceModel) -> Bool?
  /** Detects that a dry-fire condition was present */
  func getAOSmithWaterHeaterControllerDryfire(_ model: DeviceModel) -> Bool?
  /** Status of upper and lower elements */
  func getAOSmithWaterHeaterControllerElementfail(_ model: DeviceModel) -> AOSmithWaterHeaterControllerElementfail?
  /** Status of uppwer and lower temperature sensors. */
  func getAOSmithWaterHeaterControllerTanksensorfail(_ model: DeviceModel) -> AOSmithWaterHeaterControllerTanksensorfail?
  /** Mechanical tank over temperature sensor. */
  func getAOSmithWaterHeaterControllerEcoerror(_ model: DeviceModel) -> Bool?
  /** Master (ET) and Display (ESM) self-test status */
  func getAOSmithWaterHeaterControllerMasterdispfail(_ model: DeviceModel) -> AOSmithWaterHeaterControllerMasterdispfail?
  /** Contains a map of device error codes to verbose, user-friendly definitions. */
  func getAOSmithWaterHeaterControllerErrors(_ model: DeviceModel) -> [String: String]?
  /** Model number as recorded on the heater&#x27;s label  */
  func getAOSmithWaterHeaterControllerModelnumber(_ model: DeviceModel) -> String?
  /** Model number as recorded on the heater&#x27;s label  */
  func setAOSmithWaterHeaterControllerModelnumber(_ modelnumber: String, model: DeviceModel)
/** Serial number as recorded on the heater&#x27;s label  */
  func getAOSmithWaterHeaterControllerSerialnumber(_ model: DeviceModel) -> String?
  /** Serial number as recorded on the heater&#x27;s label  */
  func setAOSmithWaterHeaterControllerSerialnumber(_ serialnumber: String, model: DeviceModel)

  
}

extension ArcusAOSmithWaterHeaterControllerCapability {
  public func getAOSmithWaterHeaterControllerUpdaterate(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.aOSmithWaterHeaterControllerUpdaterate] as? Int
  }
  
  public func setAOSmithWaterHeaterControllerUpdaterate(_ updaterate: Int, model: DeviceModel) {
    model.set([Attributes.aOSmithWaterHeaterControllerUpdaterate: updaterate as AnyObject])
  }
  public func getAOSmithWaterHeaterControllerUnits(_ model: DeviceModel) -> AOSmithWaterHeaterControllerUnits? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.aOSmithWaterHeaterControllerUnits] as? String,
      let enumAttr: AOSmithWaterHeaterControllerUnits = AOSmithWaterHeaterControllerUnits(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setAOSmithWaterHeaterControllerUnits(_ units: AOSmithWaterHeaterControllerUnits, model: DeviceModel) {
    model.set([Attributes.aOSmithWaterHeaterControllerUnits: units.rawValue as AnyObject])
  }
  public func getAOSmithWaterHeaterControllerControlmode(_ model: DeviceModel) -> AOSmithWaterHeaterControllerControlmode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.aOSmithWaterHeaterControllerControlmode] as? String,
      let enumAttr: AOSmithWaterHeaterControllerControlmode = AOSmithWaterHeaterControllerControlmode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setAOSmithWaterHeaterControllerControlmode(_ controlmode: AOSmithWaterHeaterControllerControlmode, model: DeviceModel) {
    model.set([Attributes.aOSmithWaterHeaterControllerControlmode: controlmode.rawValue as AnyObject])
  }
  public func getAOSmithWaterHeaterControllerLeakdetect(_ model: DeviceModel) -> AOSmithWaterHeaterControllerLeakdetect? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.aOSmithWaterHeaterControllerLeakdetect] as? String,
      let enumAttr: AOSmithWaterHeaterControllerLeakdetect = AOSmithWaterHeaterControllerLeakdetect(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setAOSmithWaterHeaterControllerLeakdetect(_ leakdetect: AOSmithWaterHeaterControllerLeakdetect, model: DeviceModel) {
    model.set([Attributes.aOSmithWaterHeaterControllerLeakdetect: leakdetect.rawValue as AnyObject])
  }
  public func getAOSmithWaterHeaterControllerLeak(_ model: DeviceModel) -> AOSmithWaterHeaterControllerLeak? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.aOSmithWaterHeaterControllerLeak] as? String,
      let enumAttr: AOSmithWaterHeaterControllerLeak = AOSmithWaterHeaterControllerLeak(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAOSmithWaterHeaterControllerGridenabled(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.aOSmithWaterHeaterControllerGridenabled] as? Bool
  }
  
  public func getAOSmithWaterHeaterControllerDryfire(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.aOSmithWaterHeaterControllerDryfire] as? Bool
  }
  
  public func getAOSmithWaterHeaterControllerElementfail(_ model: DeviceModel) -> AOSmithWaterHeaterControllerElementfail? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.aOSmithWaterHeaterControllerElementfail] as? String,
      let enumAttr: AOSmithWaterHeaterControllerElementfail = AOSmithWaterHeaterControllerElementfail(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAOSmithWaterHeaterControllerTanksensorfail(_ model: DeviceModel) -> AOSmithWaterHeaterControllerTanksensorfail? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.aOSmithWaterHeaterControllerTanksensorfail] as? String,
      let enumAttr: AOSmithWaterHeaterControllerTanksensorfail = AOSmithWaterHeaterControllerTanksensorfail(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAOSmithWaterHeaterControllerEcoerror(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.aOSmithWaterHeaterControllerEcoerror] as? Bool
  }
  
  public func getAOSmithWaterHeaterControllerMasterdispfail(_ model: DeviceModel) -> AOSmithWaterHeaterControllerMasterdispfail? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.aOSmithWaterHeaterControllerMasterdispfail] as? String,
      let enumAttr: AOSmithWaterHeaterControllerMasterdispfail = AOSmithWaterHeaterControllerMasterdispfail(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getAOSmithWaterHeaterControllerErrors(_ model: DeviceModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.aOSmithWaterHeaterControllerErrors] as? [String: String]
  }
  
  public func getAOSmithWaterHeaterControllerModelnumber(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.aOSmithWaterHeaterControllerModelnumber] as? String
  }
  
  public func setAOSmithWaterHeaterControllerModelnumber(_ modelnumber: String, model: DeviceModel) {
    model.set([Attributes.aOSmithWaterHeaterControllerModelnumber: modelnumber as AnyObject])
  }
  public func getAOSmithWaterHeaterControllerSerialnumber(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.aOSmithWaterHeaterControllerSerialnumber] as? String
  }
  
  public func setAOSmithWaterHeaterControllerSerialnumber(_ serialnumber: String, model: DeviceModel) {
    model.set([Attributes.aOSmithWaterHeaterControllerSerialnumber: serialnumber as AnyObject])
  }
  
}
