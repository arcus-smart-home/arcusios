
//
// ProMonitoringSettingsCap.swift
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
  public static var proMonitoringSettingsNamespace: String = "promon"
  public static var proMonitoringSettingsName: String = "ProMonitoringSettings"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let proMonitoringSettingsNotifyWhenAvailable: String = "promon:notifyWhenAvailable"
  static let proMonitoringSettingsTrial: String = "promon:trial"
  static let proMonitoringSettingsActivatedOn: String = "promon:activatedOn"
  static let proMonitoringSettingsSupportedAlerts: String = "promon:supportedAlerts"
  static let proMonitoringSettingsMonitoredAlerts: String = "promon:monitoredAlerts"
  static let proMonitoringSettingsAddressVerification: String = "promon:addressVerification"
  static let proMonitoringSettingsPermitRequired: String = "promon:permitRequired"
  static let proMonitoringSettingsPermitNumber: String = "promon:permitNumber"
  static let proMonitoringSettingsAdults: String = "promon:adults"
  static let proMonitoringSettingsChildren: String = "promon:children"
  static let proMonitoringSettingsPets: String = "promon:pets"
  static let proMonitoringSettingsDirections: String = "promon:directions"
  static let proMonitoringSettingsGateCode: String = "promon:gateCode"
  static let proMonitoringSettingsInstructions: String = "promon:instructions"
  static let proMonitoringSettingsTestCallStatus: String = "promon:testCallStatus"
  static let proMonitoringSettingsTestCallTime: String = "promon:testCallTime"
  static let proMonitoringSettingsTestCallMessage: String = "promon:testCallMessage"
  static let proMonitoringSettingsExternalId: String = "promon:externalId"
  static let proMonitoringSettingsCertUrl: String = "promon:certUrl"
  
}

public protocol ArcusProMonitoringSettingsCapability: class, RxArcusService {
  /** The user should be notified when the service becomes available in their area. */
  func getProMonitoringSettingsNotifyWhenAvailable(_ model: ProMonitoringSettingsModel) -> Bool?
  /** The user should be notified when the service becomes available in their area. */
  func setProMonitoringSettingsNotifyWhenAvailable(_ notifyWhenAvailable: Bool, model: ProMonitoringSettingsModel)
/** Indicates whether this is a member of the trial population or not.  To enable trial access send the invitation code to JoinTrial. */
  func getProMonitoringSettingsTrial(_ model: ProMonitoringSettingsModel) -> Bool?
  /** The date that professional monitoring was activated at this place, or not specified if it is not active. */
  func getProMonitoringSettingsActivatedOn(_ model: ProMonitoringSettingsModel) -> Date?
  /** The set of alerts that have enough devices to be monitored at this place. */
  func getProMonitoringSettingsSupportedAlerts(_ model: ProMonitoringSettingsModel) -> [Any]?
  /** The set of alerts which will be forwarded to the monitoring service. */
  func getProMonitoringSettingsMonitoredAlerts(_ model: ProMonitoringSettingsModel) -> [String]?
  /** Will be UNVERIFIED until UpdateAddress is invoked, which upon success will be changed to RESIDENTIAL. */
  func getProMonitoringSettingsAddressVerification(_ model: ProMonitoringSettingsModel) -> ProMonitoringSettingsAddressVerification?
  /** Whether or not a permit is required at this location.  This will be populate appropriately after address is updated. */
  func getProMonitoringSettingsPermitRequired(_ model: ProMonitoringSettingsModel) -> Bool?
  /** The permit number. */
  func getProMonitoringSettingsPermitNumber(_ model: ProMonitoringSettingsModel) -> String?
  /** The permit number. */
  func setProMonitoringSettingsPermitNumber(_ permitNumber: String, model: ProMonitoringSettingsModel)
/** The number of adults that live in the residence. */
  func getProMonitoringSettingsAdults(_ model: ProMonitoringSettingsModel) -> Int?
  /** The number of adults that live in the residence. */
  func setProMonitoringSettingsAdults(_ adults: Int, model: ProMonitoringSettingsModel)
/** The number of children that live in the residence. */
  func getProMonitoringSettingsChildren(_ model: ProMonitoringSettingsModel) -> Int?
  /** The number of children that live in the residence. */
  func setProMonitoringSettingsChildren(_ children: Int, model: ProMonitoringSettingsModel)
/** The number of pets that live in the residence. */
  func getProMonitoringSettingsPets(_ model: ProMonitoringSettingsModel) -> Int?
  /** The number of pets that live in the residence. */
  func setProMonitoringSettingsPets(_ pets: Int, model: ProMonitoringSettingsModel)
/** Additional directions on how to get to the house. */
  func getProMonitoringSettingsDirections(_ model: ProMonitoringSettingsModel) -> String?
  /** Additional directions on how to get to the house. */
  func setProMonitoringSettingsDirections(_ directions: String, model: ProMonitoringSettingsModel)
/** The code to get onto the property, if applicable. */
  func getProMonitoringSettingsGateCode(_ model: ProMonitoringSettingsModel) -> String?
  /** The code to get onto the property, if applicable. */
  func setProMonitoringSettingsGateCode(_ gateCode: String, model: ProMonitoringSettingsModel)
/** Additional instructions for emergency dispatchers. */
  func getProMonitoringSettingsInstructions(_ model: ProMonitoringSettingsModel) -> String?
  /** Additional instructions for emergency dispatchers. */
  func setProMonitoringSettingsInstructions(_ instructions: String, model: ProMonitoringSettingsModel)
/** The current state of a test call. */
  func getProMonitoringSettingsTestCallStatus(_ model: ProMonitoringSettingsModel) -> ProMonitoringSettingsTestCallStatus?
  /** The last time a test call was started, will not be set until a test call is invoked for the first time. */
  func getProMonitoringSettingsTestCallTime(_ model: ProMonitoringSettingsModel) -> Date?
  /** Additional text describing the current test call state. */
  func getProMonitoringSettingsTestCallMessage(_ model: ProMonitoringSettingsModel) -> String?
  /** external id/stages id used to reference the site created in stages. */
  func getProMonitoringSettingsExternalId(_ model: ProMonitoringSettingsModel) -> String?
  /** The fully-qualified url for the certificate. */
  func getProMonitoringSettingsCertUrl(_ model: ProMonitoringSettingsModel) -> String?
  
  /** Checks if the current place supports professional monitoring or not. */
  func requestProMonitoringSettingsCheckAvailability(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent>/** Allows the user to join the trial group by submitting a trial code. */
  func requestProMonitoringSettingsJoinTrial(_  model: ProMonitoringSettingsModel, code: String)
   throws -> Observable<ArcusSessionEvent>/** Validates that the place&#x27;s address is recognized by the professional monitoring system. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
  func requestProMonitoringSettingsValidateAddress(_  model: ProMonitoringSettingsModel, streetAddress: Any)
   throws -> Observable<ArcusSessionEvent>/** Validate the address with UCC, and updates the  current place&#x27;s address if it is changed.  The address is optional and if not specified will use the address of the current place. */
  func requestProMonitoringSettingsUpdateAddress(_  model: ProMonitoringSettingsModel, streetAddress: Any, residential: Bool)
   throws -> Observable<ArcusSessionEvent>/** Lists the departments which service a place, generally used to figure out where to get a permit from. */
  func requestProMonitoringSettingsListDepartments(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent>/** Gets the set of professionally monitored devices which are currently offline. */
  func requestProMonitoringSettingsCheckSensors(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent>/**           This enrolls and activates professional monitoring at the given place.  Billing will be updated and the place will be professionally monitored.          Note that if testCall is set to true this may return successfully, and then fail later if the test call fails.           */
  func requestProMonitoringSettingsActivate(_  model: ProMonitoringSettingsModel, testCall: Bool)
   throws -> Observable<ArcusSessionEvent>/**              This instructs the monitoring service to place a call to the number associated with the place.  This call will return immediately, but the lastCallStatus should be watched to determine when the test call is completed.             Note that if a test call is already in progress this will return the existing testCallTime, and as such may be retried safely.           */
  func requestProMonitoringSettingsTestCall(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent>/** Downgrades the account to premium, deactivates the place and clears all promonitoring settings */
  func requestProMonitoringSettingsReset(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusProMonitoringSettingsCapability {
  public func getProMonitoringSettingsNotifyWhenAvailable(_ model: ProMonitoringSettingsModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsNotifyWhenAvailable] as? Bool
  }
  
  public func setProMonitoringSettingsNotifyWhenAvailable(_ notifyWhenAvailable: Bool, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsNotifyWhenAvailable: notifyWhenAvailable as AnyObject])
  }
  public func getProMonitoringSettingsTrial(_ model: ProMonitoringSettingsModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsTrial] as? Bool
  }
  
  public func getProMonitoringSettingsActivatedOn(_ model: ProMonitoringSettingsModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.proMonitoringSettingsActivatedOn] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getProMonitoringSettingsSupportedAlerts(_ model: ProMonitoringSettingsModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsSupportedAlerts] as? [Any]
  }
  
  public func getProMonitoringSettingsMonitoredAlerts(_ model: ProMonitoringSettingsModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsMonitoredAlerts] as? [String]
  }
  
  public func getProMonitoringSettingsAddressVerification(_ model: ProMonitoringSettingsModel) -> ProMonitoringSettingsAddressVerification? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.proMonitoringSettingsAddressVerification] as? String,
      let enumAttr: ProMonitoringSettingsAddressVerification = ProMonitoringSettingsAddressVerification(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getProMonitoringSettingsPermitRequired(_ model: ProMonitoringSettingsModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsPermitRequired] as? Bool
  }
  
  public func getProMonitoringSettingsPermitNumber(_ model: ProMonitoringSettingsModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsPermitNumber] as? String
  }
  
  public func setProMonitoringSettingsPermitNumber(_ permitNumber: String, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsPermitNumber: permitNumber as AnyObject])
  }
  public func getProMonitoringSettingsAdults(_ model: ProMonitoringSettingsModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsAdults] as? Int
  }
  
  public func setProMonitoringSettingsAdults(_ adults: Int, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsAdults: adults as AnyObject])
  }
  public func getProMonitoringSettingsChildren(_ model: ProMonitoringSettingsModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsChildren] as? Int
  }
  
  public func setProMonitoringSettingsChildren(_ children: Int, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsChildren: children as AnyObject])
  }
  public func getProMonitoringSettingsPets(_ model: ProMonitoringSettingsModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsPets] as? Int
  }
  
  public func setProMonitoringSettingsPets(_ pets: Int, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsPets: pets as AnyObject])
  }
  public func getProMonitoringSettingsDirections(_ model: ProMonitoringSettingsModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsDirections] as? String
  }
  
  public func setProMonitoringSettingsDirections(_ directions: String, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsDirections: directions as AnyObject])
  }
  public func getProMonitoringSettingsGateCode(_ model: ProMonitoringSettingsModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsGateCode] as? String
  }
  
  public func setProMonitoringSettingsGateCode(_ gateCode: String, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsGateCode: gateCode as AnyObject])
  }
  public func getProMonitoringSettingsInstructions(_ model: ProMonitoringSettingsModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsInstructions] as? String
  }
  
  public func setProMonitoringSettingsInstructions(_ instructions: String, model: ProMonitoringSettingsModel) {
    model.set([Attributes.proMonitoringSettingsInstructions: instructions as AnyObject])
  }
  public func getProMonitoringSettingsTestCallStatus(_ model: ProMonitoringSettingsModel) -> ProMonitoringSettingsTestCallStatus? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.proMonitoringSettingsTestCallStatus] as? String,
      let enumAttr: ProMonitoringSettingsTestCallStatus = ProMonitoringSettingsTestCallStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getProMonitoringSettingsTestCallTime(_ model: ProMonitoringSettingsModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.proMonitoringSettingsTestCallTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getProMonitoringSettingsTestCallMessage(_ model: ProMonitoringSettingsModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsTestCallMessage] as? String
  }
  
  public func getProMonitoringSettingsExternalId(_ model: ProMonitoringSettingsModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsExternalId] as? String
  }
  
  public func getProMonitoringSettingsCertUrl(_ model: ProMonitoringSettingsModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.proMonitoringSettingsCertUrl] as? String
  }
  
  
  public func requestProMonitoringSettingsCheckAvailability(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsCheckAvailabilityRequest = ProMonitoringSettingsCheckAvailabilityRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsJoinTrial(_  model: ProMonitoringSettingsModel, code: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsJoinTrialRequest = ProMonitoringSettingsJoinTrialRequest()
    request.source = model.address
    
    
    
    request.setCode(code)
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsValidateAddress(_  model: ProMonitoringSettingsModel, streetAddress: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsValidateAddressRequest = ProMonitoringSettingsValidateAddressRequest()
    request.source = model.address
    
    
    
    request.setStreetAddress(streetAddress)
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsUpdateAddress(_  model: ProMonitoringSettingsModel, streetAddress: Any, residential: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsUpdateAddressRequest = ProMonitoringSettingsUpdateAddressRequest()
    request.source = model.address
    
    
    
    request.setStreetAddress(streetAddress)
    
    request.setResidential(residential)
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsListDepartments(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsListDepartmentsRequest = ProMonitoringSettingsListDepartmentsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsCheckSensors(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsCheckSensorsRequest = ProMonitoringSettingsCheckSensorsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsActivate(_  model: ProMonitoringSettingsModel, testCall: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsActivateRequest = ProMonitoringSettingsActivateRequest()
    request.source = model.address
    
    
    
    request.setTestCall(testCall)
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsTestCall(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsTestCallRequest = ProMonitoringSettingsTestCallRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProMonitoringSettingsReset(_ model: ProMonitoringSettingsModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProMonitoringSettingsResetRequest = ProMonitoringSettingsResetRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
