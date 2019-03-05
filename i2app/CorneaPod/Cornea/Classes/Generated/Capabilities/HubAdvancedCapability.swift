
//
// HubAdvancedCap.swift
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
  public static var hubAdvancedNamespace: String = "hubadv"
  public static var hubAdvancedName: String = "HubAdvanced"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubAdvancedMac: String = "hubadv:mac"
  static let hubAdvancedHardwarever: String = "hubadv:hardwarever"
  static let hubAdvancedOsver: String = "hubadv:osver"
  static let hubAdvancedAgentver: String = "hubadv:agentver"
  static let hubAdvancedSerialNum: String = "hubadv:serialNum"
  static let hubAdvancedMfgInfo: String = "hubadv:mfgInfo"
  static let hubAdvancedBootloaderVer: String = "hubadv:bootloaderVer"
  static let hubAdvancedFirmwareGroup: String = "hubadv:firmwareGroup"
  static let hubAdvancedLastReset: String = "hubadv:lastReset"
  static let hubAdvancedLastDeviceAddRemove: String = "hubadv:lastDeviceAddRemove"
  static let hubAdvancedLastRestartReason: String = "hubadv:lastRestartReason"
  static let hubAdvancedLastRestartTime: String = "hubadv:lastRestartTime"
  static let hubAdvancedLastFailedWatchdogChecksTime: String = "hubadv:lastFailedWatchdogChecksTime"
  static let hubAdvancedLastFailedWatchdogChecks: String = "hubadv:lastFailedWatchdogChecks"
  static let hubAdvancedLastDbCheck: String = "hubadv:lastDbCheck"
  static let hubAdvancedLastDbCheckResults: String = "hubadv:lastDbCheckResults"
  static let hubAdvancedMigrationDualEui64: String = "hubadv:migrationDualEui64"
  static let hubAdvancedMigrationDualEui64Fixed: String = "hubadv:migrationDualEui64Fixed"
  static let hubAdvancedMfgBatchNumber: String = "hubadv:mfgBatchNumber"
  static let hubAdvancedMfgDate: String = "hubadv:mfgDate"
  static let hubAdvancedMfgFactoryID: String = "hubadv:mfgFactoryID"
  static let hubAdvancedHwFlashSize: String = "hubadv:hwFlashSize"
  
}

public protocol ArcusHubAdvancedCapability: class, RxArcusService {
  /** Primary MAC address of the hub (corresponds to ethernet MAC) */
  func getHubAdvancedMac(_ model: HubModel) -> String?
  /** Version of the hardware */
  func getHubAdvancedHardwarever(_ model: HubModel) -> String?
  /** Version of the base hub OS software */
  func getHubAdvancedOsver(_ model: HubModel) -> String?
  /** Version of the agent code running on the hub */
  func getHubAdvancedAgentver(_ model: HubModel) -> String?
  /** Serial number of the hub */
  func getHubAdvancedSerialNum(_ model: HubModel) -> String?
  /** Manufacturing information */
  func getHubAdvancedMfgInfo(_ model: HubModel) -> String?
  /** Version of the bootloader running on the hub */
  func getHubAdvancedBootloaderVer(_ model: HubModel) -> String?
  /** Firmware group the hub belongs to */
  func getHubAdvancedFirmwareGroup(_ model: HubModel) -> String?
  /** A time UUID indicating the last time the hub was started in a factory fresh state. */
  func getHubAdvancedLastReset(_ model: HubModel) -> String?
  /** A time UUID indicating the last time a device was either added or removed from the hub. */
  func getHubAdvancedLastDeviceAddRemove(_ model: HubModel) -> String?
  /** The reason for the last hub restart. */
  func getHubAdvancedLastRestartReason(_ model: HubModel) -> HubAdvancedLastRestartReason?
  /** The time of the last hub restart. */
  func getHubAdvancedLastRestartTime(_ model: HubModel) -> Date?
  /** The last time some watchdog checks failed */
  func getHubAdvancedLastFailedWatchdogChecksTime(_ model: HubModel) -> Date?
  /** The set of failed watchdog checks, this is provided on a best effort basis and may not accurately reflect what actually caused a watchdog reset (we might fail to persist this information if an I/O failure caused the watchdog reset). */
  func getHubAdvancedLastFailedWatchdogChecks(_ model: HubModel) -> [String]?
  /** The last time an integrity check was run on the hub db. */
  func getHubAdvancedLastDbCheck(_ model: HubModel) -> Date?
  /** A string describing the results of the last db check. */
  func getHubAdvancedLastDbCheckResults(_ model: HubModel) -> String?
  /** True if the hub has ever had the dual EUI-64 problem after migration. */
  func getHubAdvancedMigrationDualEui64(_ model: HubModel) -> Bool?
  /** True if the hub has had the fix for the dual EUI-64 issue applied. */
  func getHubAdvancedMigrationDualEui64Fixed(_ model: HubModel) -> Bool?
  /** Manufacturing raw batch number */
  func getHubAdvancedMfgBatchNumber(_ model: HubModel) -> String?
  /** Date of manufacture */
  func getHubAdvancedMfgDate(_ model: HubModel) -> Date?
  /** Manufacturing factory ID */
  func getHubAdvancedMfgFactoryID(_ model: HubModel) -> Int?
  /** Size of flash, in bytes */
  func getHubAdvancedHwFlashSize(_ model: HubModel) -> Int?
  
  /** Restarts the Arcus Agent */
  func requestHubAdvancedRestart(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Reboots the hub */
  func requestHubAdvancedReboot(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Requests that the hub update its firmware */
  func requestHubAdvancedFirmwareUpdate(_  model: HubModel, url: String, priority: String, type: String, showLed: Bool)
   throws -> Observable<ArcusSessionEvent>/** Request to tell the hub to factory reset.  This should remove all personal data from the hub */
  func requestHubAdvancedFactoryReset(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Get a list of known device protocol addresses. */
  func requestHubAdvancedGetKnownDevices(_  model: HubModel, protocols: [String])
   throws -> Observable<ArcusSessionEvent>/** Get a list of known device protocol addresses. */
  func requestHubAdvancedGetDeviceInfo(_  model: HubModel, protocolAddress: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubAdvancedCapability {
  public func getHubAdvancedMac(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedMac] as? String
  }
  
  public func getHubAdvancedHardwarever(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedHardwarever] as? String
  }
  
  public func getHubAdvancedOsver(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedOsver] as? String
  }
  
  public func getHubAdvancedAgentver(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedAgentver] as? String
  }
  
  public func getHubAdvancedSerialNum(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedSerialNum] as? String
  }
  
  public func getHubAdvancedMfgInfo(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedMfgInfo] as? String
  }
  
  public func getHubAdvancedBootloaderVer(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedBootloaderVer] as? String
  }
  
  public func getHubAdvancedFirmwareGroup(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedFirmwareGroup] as? String
  }
  
  public func getHubAdvancedLastReset(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedLastReset] as? String
  }
  
  public func getHubAdvancedLastDeviceAddRemove(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedLastDeviceAddRemove] as? String
  }
  
  public func getHubAdvancedLastRestartReason(_ model: HubModel) -> HubAdvancedLastRestartReason? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubAdvancedLastRestartReason] as? String,
      let enumAttr: HubAdvancedLastRestartReason = HubAdvancedLastRestartReason(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHubAdvancedLastRestartTime(_ model: HubModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAdvancedLastRestartTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAdvancedLastFailedWatchdogChecksTime(_ model: HubModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAdvancedLastFailedWatchdogChecksTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAdvancedLastFailedWatchdogChecks(_ model: HubModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedLastFailedWatchdogChecks] as? [String]
  }
  
  public func getHubAdvancedLastDbCheck(_ model: HubModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAdvancedLastDbCheck] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAdvancedLastDbCheckResults(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedLastDbCheckResults] as? String
  }
  
  public func getHubAdvancedMigrationDualEui64(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedMigrationDualEui64] as? Bool
  }
  
  public func getHubAdvancedMigrationDualEui64Fixed(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedMigrationDualEui64Fixed] as? Bool
  }
  
  public func getHubAdvancedMfgBatchNumber(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedMfgBatchNumber] as? String
  }
  
  public func getHubAdvancedMfgDate(_ model: HubModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubAdvancedMfgDate] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHubAdvancedMfgFactoryID(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedMfgFactoryID] as? Int
  }
  
  public func getHubAdvancedHwFlashSize(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAdvancedHwFlashSize] as? Int
  }
  
  
  public func requestHubAdvancedRestart(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubAdvancedRestartRequest = HubAdvancedRestartRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubAdvancedReboot(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubAdvancedRebootRequest = HubAdvancedRebootRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubAdvancedFirmwareUpdate(_  model: HubModel, url: String, priority: String, type: String, showLed: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAdvancedFirmwareUpdateRequest = HubAdvancedFirmwareUpdateRequest()
    request.source = model.address
    
    
    
    request.setUrl(url)
    
    request.setPriority(priority)
    
    request.setType(type)
    
    request.setShowLed(showLed)
    
    return try sendRequest(request)
  }
  
  public func requestHubAdvancedFactoryReset(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubAdvancedFactoryResetRequest = HubAdvancedFactoryResetRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubAdvancedGetKnownDevices(_  model: HubModel, protocols: [String])
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAdvancedGetKnownDevicesRequest = HubAdvancedGetKnownDevicesRequest()
    request.source = model.address
    
    
    
    request.setProtocols(protocols)
    
    return try sendRequest(request)
  }
  
  public func requestHubAdvancedGetDeviceInfo(_  model: HubModel, protocolAddress: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAdvancedGetDeviceInfoRequest = HubAdvancedGetDeviceInfoRequest()
    request.source = model.address
    
    
    
    request.setProtocolAddress(protocolAddress)
    
    return try sendRequest(request)
  }
  
}
