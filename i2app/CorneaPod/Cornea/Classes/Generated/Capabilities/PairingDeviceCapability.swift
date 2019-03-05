
//
// PairingDeviceCap.swift
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
  public static var pairingDeviceNamespace: String = "pairdev"
  public static var pairingDeviceName: String = "PairingDevice"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let pairingDevicePairingState: String = "pairdev:pairingState"
  static let pairingDevicePairingPhase: String = "pairdev:pairingPhase"
  static let pairingDevicePairingProgress: String = "pairdev:pairingProgress"
  static let pairingDeviceCustomizations: String = "pairdev:customizations"
  static let pairingDeviceDeviceAddress: String = "pairdev:deviceAddress"
  static let pairingDeviceProductAddress: String = "pairdev:productAddress"
  static let pairingDeviceRemoveMode: String = "pairdev:removeMode"
  static let pairingDeviceProtocolAddress: String = "pairdev:protocolAddress"
  
}

public protocol ArcusPairingDeviceCapability: class, RxArcusService {
  /**  The current state of pairing for the device:      PAIRING - The system has discovered a device and is in the process of configuring it. (deviceAddress will be null)     MISPAIRED - The device failed to pair properly and must be removed / factory reset and re-paired (deviceAddress will be null)     MISCONFIGURED - The system was unable to fully configure the device, but it can retry without going through a full re-pair process. (deviceAddress may be null)     PAIRED - The device successfully paired. (deviceAddress will be populated)              */
  func getPairingDevicePairingState(_ model: PairingDeviceModel) -> PairingDevicePairingState?
  /** The current pairing phase. */
  func getPairingDevicePairingPhase(_ model: PairingDeviceModel) -> PairingDevicePairingPhase?
  /** The percent of pairing completion the platform believes the device has made it through. */
  func getPairingDevicePairingProgress(_ model: PairingDeviceModel) -> Int?
  /** The set of customizations that have been applied to this device, this must be updated via the AddCustomization call */
  func getPairingDeviceCustomizations(_ model: PairingDeviceModel) -> [String]?
  /** The address to the associated device object.  This will only be populated once the device has gone sufficiently far in the pairing process. */
  func getPairingDeviceDeviceAddress(_ model: PairingDeviceModel) -> String?
  /** The address of the product associated with this device.  This will start out populated if StartPairing with a product is used to start the pairing process.  If at some point it is determined this device is not the product we thought we were pairing it will be cleared. */
  func getPairingDeviceProductAddress(_ model: PairingDeviceModel) -> String?
  /** The mode of removal */
  func getPairingDeviceRemoveMode(_ model: PairingDeviceModel) -> PairingDeviceRemoveMode?
  /** Protocol address for the device. */
  func getPairingDeviceProtocolAddress(_ model: PairingDeviceModel) -> String?
  
  /**  Retrieves the customization steps for the given device, the deviceId should match the value from discoveredDeviceIds or PairingDevice#deviceId. If this call is successful the hub will no longer be in any pairing mode.           */
  func requestPairingDeviceCustomize(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent>/** Used by the client to indicate which customizations they have applied to the device.  The set may be read from the customizations attribute. */
  func requestPairingDeviceAddCustomization(_  model: PairingDeviceModel, customization: String)
   throws -> Observable<ArcusSessionEvent>/**  Dismisses a device from the pairing subsystem.  This should be called when customization is completed or skipped. This call is idempotent, so if the device has previously been dismissed this will not return an error, unlike Customize.           */
  func requestPairingDeviceDismiss(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent>/**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the PairingDevice. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This will take the hub out of pairing mode and may put it in unpairing mode depending on the device being removed.           */
  func requestPairingDeviceRemove(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent>/**  Causes the hub to blacklist this device and treat it as if it was deleted even though it still has connectivity to the hub. This will take the hub out of pairing mode.           */
  func requestPairingDeviceForceRemove(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusPairingDeviceCapability {
  public func getPairingDevicePairingState(_ model: PairingDeviceModel) -> PairingDevicePairingState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.pairingDevicePairingState] as? String,
      let enumAttr: PairingDevicePairingState = PairingDevicePairingState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPairingDevicePairingPhase(_ model: PairingDeviceModel) -> PairingDevicePairingPhase? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.pairingDevicePairingPhase] as? String,
      let enumAttr: PairingDevicePairingPhase = PairingDevicePairingPhase(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPairingDevicePairingProgress(_ model: PairingDeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingDevicePairingProgress] as? Int
  }
  
  public func getPairingDeviceCustomizations(_ model: PairingDeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingDeviceCustomizations] as? [String]
  }
  
  public func getPairingDeviceDeviceAddress(_ model: PairingDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingDeviceDeviceAddress] as? String
  }
  
  public func getPairingDeviceProductAddress(_ model: PairingDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingDeviceProductAddress] as? String
  }
  
  public func getPairingDeviceRemoveMode(_ model: PairingDeviceModel) -> PairingDeviceRemoveMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.pairingDeviceRemoveMode] as? String,
      let enumAttr: PairingDeviceRemoveMode = PairingDeviceRemoveMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPairingDeviceProtocolAddress(_ model: PairingDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingDeviceProtocolAddress] as? String
  }
  
  
  public func requestPairingDeviceCustomize(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingDeviceCustomizeRequest = PairingDeviceCustomizeRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingDeviceAddCustomization(_  model: PairingDeviceModel, customization: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PairingDeviceAddCustomizationRequest = PairingDeviceAddCustomizationRequest()
    request.source = model.address
    
    
    
    request.setCustomization(customization)
    
    return try sendRequest(request)
  }
  
  public func requestPairingDeviceDismiss(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingDeviceDismissRequest = PairingDeviceDismissRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingDeviceRemove(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingDeviceRemoveRequest = PairingDeviceRemoveRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPairingDeviceForceRemove(_ model: PairingDeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PairingDeviceForceRemoveRequest = PairingDeviceForceRemoveRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
