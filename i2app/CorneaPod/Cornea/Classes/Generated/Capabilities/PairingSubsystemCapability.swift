
//
// PairingSubsystemCap.swift
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
  public static var pairingSubsystemNamespace: String = "subpairing"
  public static var pairingSubsystemName: String = "PairingSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let pairingSubsystemPairingMode: String = "subpairing:pairingMode"
  static let pairingSubsystemPairingModeChanged: String = "subpairing:pairingModeChanged"
  static let pairingSubsystemPairingDevices: String = "subpairing:pairingDevices"
  static let pairingSubsystemSearchProductAddress: String = "subpairing:searchProductAddress"
  static let pairingSubsystemSearchDeviceFound: String = "subpairing:searchDeviceFound"
  static let pairingSubsystemSearchIdle: String = "subpairing:searchIdle"
  static let pairingSubsystemSearchIdleTimeout: String = "subpairing:searchIdleTimeout"
  static let pairingSubsystemSearchTimeout: String = "subpairing:searchTimeout"
  
}

public protocol ArcusPairingSubsystemCapability: class, RxArcusService {
  /** The current pairing state of the associated place. Note that unlike subplacemonitor:pairingState this represents the state the system is attempting to enforce, not the current state of the hub. */
  func getPairingSubsystemPairingMode(_ model: SubsystemModel) -> PairingSubsystemPairingMode?
  /** The last time the pairing mode changed. */
  func getPairingSubsystemPairingModeChanged(_ model: SubsystemModel) -> Date?
  /** The addresses of any new devices discovered.  These will persist until the device state is (1) PAIRED and (2) Dismiss or DismissAll is invoked. */
  func getPairingSubsystemPairingDevices(_ model: SubsystemModel) -> [String]?
  /** The Address of the product that the end user is currently trying to pair.  This will be cleared / replaced when the device is successfully paired or the system leaves pairing mode. */
  func getPairingSubsystemSearchProductAddress(_ model: SubsystemModel) -> String?
  /** Whether or not a device has been found during the most recent search flow.  When this is set to true searchIdle will be set to false and searchIdleTimeout will be cleared. */
  func getPairingSubsystemSearchDeviceFound(_ model: SubsystemModel) -> Bool?
  /** Indicates a new device has not been found within the searchIdleTimeout and the user should be prompted for help. */
  func getPairingSubsystemSearchIdle(_ model: SubsystemModel) -> Bool?
  /** The time that the current search operation will set searchIdle to true. */
  func getPairingSubsystemSearchIdleTimeout(_ model: SubsystemModel) -> Date?
  /** The time that the system will stop searching for devices unless an additional &#x27;Search&#x27; operation is invoked. */
  func getPairingSubsystemSearchTimeout(_ model: SubsystemModel) -> Date?
  
  /** Gets all the PairingDevices from the pairingDevices attribute. */
  func requestPairingSubsystemListPairingDevices(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Attempts to pair the requested type of device. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is not a hub connected device then the hub will not be put in pairing mode. */
  func requestPairingSubsystemStartPairing(_  model: SubsystemModel, productAddress: String, mock: Bool)
   throws -> Observable<ArcusSessionEvent>/**  Attempts to pair the requested device. This will also start / reset the IdlePairing timer. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is a cloud connected device then the system will enter pairing mode for the given device. If the requested product is an OAuth connected device, an error will be returned. If no productId is specified this will turn all hub radios into pairing mode and search for all types of devices.           */
  func requestPairingSubsystemSearch(_  model: SubsystemModel, productAddress: String, form: [String: String])
   throws -> Observable<ArcusSessionEvent>/** Retrieves the help steps for the product currently being search for, or steps specific to the active pairing protocols. */
  func requestPairingSubsystemListHelpSteps(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/**  Dismisses all devices from pairingDevices that are in the PAIRED state. This should be invoked when cancelling / exiting pairing. This will take the hub out of pairing mode. This will take the hub out of unpairing mode.  */
  func requestPairingSubsystemDismissAll(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** This clears all timeouts, takes the place/hub out of pairing or unpairing mode, and takes the state back to IDLE. */
  func requestPairingSubsystemStopSearching(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/**  Retrieves the factory reset steps for the product currently being search for, or steps specific to the active pairing protocols. This will take the hub out of pairing mode.           */
  func requestPairingSubsystemFactoryReset(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Gets the information about a kit.  This is a pair of product id, and the protocoladdress of that device.  Protocol address can be used to determine the state of the kitted device. */
  func requestPairingSubsystemGetKitInformation(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusPairingSubsystemCapability {
  public func getPairingSubsystemPairingMode(_ model: SubsystemModel) -> PairingSubsystemPairingMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.pairingSubsystemPairingMode] as? String,
      let enumAttr: PairingSubsystemPairingMode = PairingSubsystemPairingMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPairingSubsystemPairingModeChanged(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.pairingSubsystemPairingModeChanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPairingSubsystemPairingDevices(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingSubsystemPairingDevices] as? [String]
  }
  
  public func getPairingSubsystemSearchProductAddress(_ model: SubsystemModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingSubsystemSearchProductAddress] as? String
  }
  
  public func getPairingSubsystemSearchDeviceFound(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingSubsystemSearchDeviceFound] as? Bool
  }
  
  public func getPairingSubsystemSearchIdle(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingSubsystemSearchIdle] as? Bool
  }
  
  public func getPairingSubsystemSearchIdleTimeout(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.pairingSubsystemSearchIdleTimeout] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPairingSubsystemSearchTimeout(_ model: SubsystemModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.pairingSubsystemSearchTimeout] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestPairingSubsystemListPairingDevices(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemListPairingDevicesRequest = PairingSubsystemListPairingDevicesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingSubsystemStartPairing(_  model: SubsystemModel, productAddress: String, mock: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemStartPairingRequest = PairingSubsystemStartPairingRequest()
    request.source = model.address
    
    
    
    request.setProductAddress(productAddress)
    
    request.setMock(mock)
    
    return try sendRequest(request)
  }
  
  public func requestPairingSubsystemSearch(_  model: SubsystemModel, productAddress: String, form: [String: String])
   throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemSearchRequest = PairingSubsystemSearchRequest()
    request.source = model.address
    
    
    
    request.setProductAddress(productAddress)
    
    request.setForm(form)
    
    return try sendRequest(request)
  }
  
  public func requestPairingSubsystemListHelpSteps(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemListHelpStepsRequest = PairingSubsystemListHelpStepsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingSubsystemDismissAll(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemDismissAllRequest = PairingSubsystemDismissAllRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingSubsystemStopSearching(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemStopSearchingRequest = PairingSubsystemStopSearchingRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingSubsystemFactoryReset(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemFactoryResetRequest = PairingSubsystemFactoryResetRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingSubsystemGetKitInformation(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingSubsystemGetKitInformationRequest = PairingSubsystemGetKitInformationRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
