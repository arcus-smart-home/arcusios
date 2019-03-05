
//
// ProMonitoringSettingsCapabilityLegacy.swift
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

public class ProMonitoringSettingsCapabilityLegacy: NSObject, ArcusProMonitoringSettingsCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ProMonitoringSettingsCapabilityLegacy  = ProMonitoringSettingsCapabilityLegacy()
  
  static let ProMonitoringSettingsAddressVerificationUNVERIFIED: String = ProMonitoringSettingsAddressVerification.unverified.rawValue
  static let ProMonitoringSettingsAddressVerificationRESIDENTIAL: String = ProMonitoringSettingsAddressVerification.residential.rawValue
  
  static let ProMonitoringSettingsTestCallStatusIDLE: String = ProMonitoringSettingsTestCallStatus.idle.rawValue
  static let ProMonitoringSettingsTestCallStatusWAITING: String = ProMonitoringSettingsTestCallStatus.waiting.rawValue
  static let ProMonitoringSettingsTestCallStatusSUCCEEDED: String = ProMonitoringSettingsTestCallStatus.succeeded.rawValue
  static let ProMonitoringSettingsTestCallStatusFAILED: String = ProMonitoringSettingsTestCallStatus.failed.rawValue
  

  
  public static func getNotifyWhenAvailable(_ model: ProMonitoringSettingsModel) -> NSNumber? {
    guard let notifyWhenAvailable: Bool = capability.getProMonitoringSettingsNotifyWhenAvailable(model) else {
      return nil
    }
    return NSNumber(value: notifyWhenAvailable)
  }
  
  public static func setNotifyWhenAvailable(_ notifyWhenAvailable: Bool, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsNotifyWhenAvailable(notifyWhenAvailable, model: model)
  }
  
  public static func getTrial(_ model: ProMonitoringSettingsModel) -> NSNumber? {
    guard let trial: Bool = capability.getProMonitoringSettingsTrial(model) else {
      return nil
    }
    return NSNumber(value: trial)
  }
  
  public static func getActivatedOn(_ model: ProMonitoringSettingsModel) -> Date? {
    guard let activatedOn: Date = capability.getProMonitoringSettingsActivatedOn(model) else {
      return nil
    }
    return activatedOn
  }
  
  public static func getSupportedAlerts(_ model: ProMonitoringSettingsModel) -> [Any]? {
    return capability.getProMonitoringSettingsSupportedAlerts(model)
  }
  
  public static func getMonitoredAlerts(_ model: ProMonitoringSettingsModel) -> [String]? {
    return capability.getProMonitoringSettingsMonitoredAlerts(model)
  }
  
  public static func getAddressVerification(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsAddressVerification(model)?.rawValue
  }
  
  public static func getPermitRequired(_ model: ProMonitoringSettingsModel) -> NSNumber? {
    guard let permitRequired: Bool = capability.getProMonitoringSettingsPermitRequired(model) else {
      return nil
    }
    return NSNumber(value: permitRequired)
  }
  
  public static func getPermitNumber(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsPermitNumber(model)
  }
  
  public static func setPermitNumber(_ permitNumber: String, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsPermitNumber(permitNumber, model: model)
  }
  
  public static func getAdults(_ model: ProMonitoringSettingsModel) -> NSNumber? {
    guard let adults: Int = capability.getProMonitoringSettingsAdults(model) else {
      return nil
    }
    return NSNumber(value: adults)
  }
  
  public static func setAdults(_ adults: Int, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsAdults(adults, model: model)
  }
  
  public static func getChildren(_ model: ProMonitoringSettingsModel) -> NSNumber? {
    guard let children: Int = capability.getProMonitoringSettingsChildren(model) else {
      return nil
    }
    return NSNumber(value: children)
  }
  
  public static func setChildren(_ children: Int, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsChildren(children, model: model)
  }
  
  public static func getPets(_ model: ProMonitoringSettingsModel) -> NSNumber? {
    guard let pets: Int = capability.getProMonitoringSettingsPets(model) else {
      return nil
    }
    return NSNumber(value: pets)
  }
  
  public static func setPets(_ pets: Int, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsPets(pets, model: model)
  }
  
  public static func getDirections(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsDirections(model)
  }
  
  public static func setDirections(_ directions: String, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsDirections(directions, model: model)
  }
  
  public static func getGateCode(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsGateCode(model)
  }
  
  public static func setGateCode(_ gateCode: String, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsGateCode(gateCode, model: model)
  }
  
  public static func getInstructions(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsInstructions(model)
  }
  
  public static func setInstructions(_ instructions: String, model: ProMonitoringSettingsModel) {
    
    
    capability.setProMonitoringSettingsInstructions(instructions, model: model)
  }
  
  public static func getTestCallStatus(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsTestCallStatus(model)?.rawValue
  }
  
  public static func getTestCallTime(_ model: ProMonitoringSettingsModel) -> Date? {
    guard let testCallTime: Date = capability.getProMonitoringSettingsTestCallTime(model) else {
      return nil
    }
    return testCallTime
  }
  
  public static func getTestCallMessage(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsTestCallMessage(model)
  }
  
  public static func getExternalId(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsExternalId(model)
  }
  
  public static func getCertUrl(_ model: ProMonitoringSettingsModel) -> String? {
    return capability.getProMonitoringSettingsCertUrl(model)
  }
  
  public static func checkAvailability(_ model: ProMonitoringSettingsModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProMonitoringSettingsCheckAvailability(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func joinTrial(_  model: ProMonitoringSettingsModel, code: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProMonitoringSettingsJoinTrial(model, code: code))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func validateAddress(_  model: ProMonitoringSettingsModel, streetAddress: Any) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProMonitoringSettingsValidateAddress(model, streetAddress: streetAddress))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateAddress(_  model: ProMonitoringSettingsModel, streetAddress: Any, residential: Bool) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProMonitoringSettingsUpdateAddress(model, streetAddress: streetAddress, residential: residential))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listDepartments(_ model: ProMonitoringSettingsModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProMonitoringSettingsListDepartments(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func checkSensors(_ model: ProMonitoringSettingsModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProMonitoringSettingsCheckSensors(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func activate(_  model: ProMonitoringSettingsModel, testCall: Bool) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProMonitoringSettingsActivate(model, testCall: testCall))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func testCall(_ model: ProMonitoringSettingsModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProMonitoringSettingsTestCall(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func reset(_ model: ProMonitoringSettingsModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProMonitoringSettingsReset(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
