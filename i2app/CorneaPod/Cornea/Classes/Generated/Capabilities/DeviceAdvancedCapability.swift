
//
// DeviceAdvancedCap.swift
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
  public static var deviceAdvancedNamespace: String = "devadv"
  public static var deviceAdvancedName: String = "DeviceAdvanced"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let deviceAdvancedDrivername: String = "devadv:drivername"
  static let deviceAdvancedDriverversion: String = "devadv:driverversion"
  static let deviceAdvancedDrivercommit: String = "devadv:drivercommit"
  static let deviceAdvancedDriverhash: String = "devadv:driverhash"
  static let deviceAdvancedDriverstate: String = "devadv:driverstate"
  static let deviceAdvancedProtocol: String = "devadv:protocol"
  static let deviceAdvancedSubprotocol: String = "devadv:subprotocol"
  static let deviceAdvancedProtocolid: String = "devadv:protocolid"
  static let deviceAdvancedErrors: String = "devadv:errors"
  static let deviceAdvancedAdded: String = "devadv:added"
  static let deviceAdvancedFirmwareVersion: String = "devadv:firmwareVersion"
  static let deviceAdvancedHubLocal: String = "devadv:hubLocal"
  static let deviceAdvancedDegraded: String = "devadv:degraded"
  static let deviceAdvancedDegradedCode: String = "devadv:degradedCode"
  
}

public protocol ArcusDeviceAdvancedCapability: class, RxArcusService {
  /** The name of the driver handling the device. */
  func getDeviceAdvancedDrivername(_ model: DeviceModel) -> String?
  /** The current verison of the driver handling the device. */
  func getDeviceAdvancedDriverversion(_ model: DeviceModel) -> String?
  /** The commit id from the commit that this file was last changed in. */
  func getDeviceAdvancedDrivercommit(_ model: DeviceModel) -> String?
  /** A hash of the contents of the file. */
  func getDeviceAdvancedDriverhash(_ model: DeviceModel) -> String?
  /** The state of the driver.            CREATED - Transient state meaning the device has been created but the driver is not running.  Clients should not see this state generally.            PROVISIONING - The driver is still in the process of configuring the device for initial use.            ACTIVE - The driver is fully loaded.  Note there may be additional error preventing it from running &#x27;normally&#x27;, see devadv:errors.            UNSUPPORTED - The device is using the fallback driver, it is not really supported by the platform.  This is often due to pairing errors, in which case devadv:errors will be populated.            RECOVERABLE - The device has been deleted from the hub, but may be recovered by re-pairing it with the hub.            UNRECOVERABLE - The device has been deleted from the hub and it is not possible to re-pair it.            TOMBSTONED - The user has force removed the device but it still exists in the hub database.             */
  func getDeviceAdvancedDriverstate(_ model: DeviceModel) -> DeviceAdvancedDriverstate?
  /** Protocol supported by the device; should initially be one of (zwave, zigbee, alljoyn, ipcd) */
  func getDeviceAdvancedProtocol(_ model: DeviceModel) -> String?
  /** Sub-protocol supported by the device. For zigbee devices, this may be ha1.1, ha1.2, etc. */
  func getDeviceAdvancedSubprotocol(_ model: DeviceModel) -> String?
  /** Protocol specific identifier for this device. This should be globally unique. For zigbee devices this will be the mac address. For zwave devices, this should be homeid.deviceid. */
  func getDeviceAdvancedProtocolid(_ model: DeviceModel) -> String?
  /** A map where the keys are the errorCode and the values are a more descriptive error message.  These errors should be used for devices that have an error status that may be cleared or may simply indicate the device has passed its usable lifetime.  This is not intended for maintenance errors such as low battery or air filter change. */
  func getDeviceAdvancedErrors(_ model: DeviceModel) -> [String: String]?
  /** Time at which this device was most recently added (date of driver instantiation) */
  func getDeviceAdvancedAdded(_ model: DeviceModel) -> Date?
  /** The firmware version of the device, primarily for devices that do not support OTA. For ZigBee devices it contains the version from the basic cluster, the OTA cluster version goes in devota. */
  func getDeviceAdvancedFirmwareVersion(_ model: DeviceModel) -> String?
  /** True if the device is operating in a hub local manner. */
  func getDeviceAdvancedHubLocal(_ model: DeviceModel) -> Bool?
  /** True if the device is operating in a degraded manner for any reason. */
  func getDeviceAdvancedDegraded(_ model: DeviceModel) -> Bool?
  /** The code string indicating the reason that a device is operating in a degraded manner. */
  func getDeviceAdvancedDegradedCode(_ model: DeviceModel) -> String?
  /** The code string indicating the reason that a device is operating in a degraded manner. */
  func setDeviceAdvancedDegradedCode(_ degradedCode: String, model: DeviceModel)

  /** Upgrades the driver for this device to the driver specified.  If not specified it will look for the most current driver for this device. */
  func requestDeviceAdvancedUpgradeDriver(_  model: DeviceModel, driverName: String, driverVersion: String)
   throws -> Observable<ArcusSessionEvent>/** Gets the currently defined reflexes for the driver as a json object. */
  func requestDeviceAdvancedGetReflexes(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Attempts to re-apply initial configuration for the device, this may leave it in an unusable state if it fails. */
  func requestDeviceAdvancedReconfigure(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusDeviceAdvancedCapability {
  public func getDeviceAdvancedDrivername(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedDrivername] as? String
  }
  
  public func getDeviceAdvancedDriverversion(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedDriverversion] as? String
  }
  
  public func getDeviceAdvancedDrivercommit(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedDrivercommit] as? String
  }
  
  public func getDeviceAdvancedDriverhash(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedDriverhash] as? String
  }
  
  public func getDeviceAdvancedDriverstate(_ model: DeviceModel) -> DeviceAdvancedDriverstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.deviceAdvancedDriverstate] as? String,
      let enumAttr: DeviceAdvancedDriverstate = DeviceAdvancedDriverstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getDeviceAdvancedProtocol(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedProtocol] as? String
  }
  
  public func getDeviceAdvancedSubprotocol(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedSubprotocol] as? String
  }
  
  public func getDeviceAdvancedProtocolid(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedProtocolid] as? String
  }
  
  public func getDeviceAdvancedErrors(_ model: DeviceModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedErrors] as? [String: String]
  }
  
  public func getDeviceAdvancedAdded(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.deviceAdvancedAdded] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getDeviceAdvancedFirmwareVersion(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedFirmwareVersion] as? String
  }
  
  public func getDeviceAdvancedHubLocal(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedHubLocal] as? Bool
  }
  
  public func getDeviceAdvancedDegraded(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedDegraded] as? Bool
  }
  
  public func getDeviceAdvancedDegradedCode(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceAdvancedDegradedCode] as? String
  }
  
  public func setDeviceAdvancedDegradedCode(_ degradedCode: String, model: DeviceModel) {
    model.set([Attributes.deviceAdvancedDegradedCode: degradedCode as AnyObject])
  }
  
  public func requestDeviceAdvancedUpgradeDriver(_  model: DeviceModel, driverName: String, driverVersion: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: DeviceAdvancedUpgradeDriverRequest = DeviceAdvancedUpgradeDriverRequest()
    request.source = model.address
    
    
    
    request.setDriverName(driverName)
    
    request.setDriverVersion(driverVersion)
    
    return try sendRequest(request)
  }
  
  public func requestDeviceAdvancedGetReflexes(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceAdvancedGetReflexesRequest = DeviceAdvancedGetReflexesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestDeviceAdvancedReconfigure(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceAdvancedReconfigureRequest = DeviceAdvancedReconfigureRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
