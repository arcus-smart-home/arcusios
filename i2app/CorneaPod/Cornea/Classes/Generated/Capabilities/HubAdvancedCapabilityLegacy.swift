
//
// HubAdvancedCapabilityLegacy.swift
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

public class HubAdvancedCapabilityLegacy: NSObject, ArcusHubAdvancedCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubAdvancedCapabilityLegacy  = HubAdvancedCapabilityLegacy()
  
  static let HubAdvancedLastRestartReasonUNKNOWN: String = HubAdvancedLastRestartReason.unknown.rawValue
  static let HubAdvancedLastRestartReasonFIRMWARE_UPDATE: String = HubAdvancedLastRestartReason.firmware_update.rawValue
  static let HubAdvancedLastRestartReasonREQUESTED: String = HubAdvancedLastRestartReason.requested.rawValue
  static let HubAdvancedLastRestartReasonSOFT_RESET: String = HubAdvancedLastRestartReason.soft_reset.rawValue
  static let HubAdvancedLastRestartReasonFACTORY_RESET: String = HubAdvancedLastRestartReason.factory_reset.rawValue
  static let HubAdvancedLastRestartReasonGATEWAY_FAILURE: String = HubAdvancedLastRestartReason.gateway_failure.rawValue
  static let HubAdvancedLastRestartReasonMIGRATION: String = HubAdvancedLastRestartReason.migration.rawValue
  static let HubAdvancedLastRestartReasonBACKUP_RESTORE: String = HubAdvancedLastRestartReason.backup_restore.rawValue
  static let HubAdvancedLastRestartReasonWATCHDOG: String = HubAdvancedLastRestartReason.watchdog.rawValue
  

  
  public static func getMac(_ model: HubModel) -> String? {
    return capability.getHubAdvancedMac(model)
  }
  
  public static func getHardwarever(_ model: HubModel) -> String? {
    return capability.getHubAdvancedHardwarever(model)
  }
  
  public static func getOsver(_ model: HubModel) -> String? {
    return capability.getHubAdvancedOsver(model)
  }
  
  public static func getAgentver(_ model: HubModel) -> String? {
    return capability.getHubAdvancedAgentver(model)
  }
  
  public static func getSerialNum(_ model: HubModel) -> String? {
    return capability.getHubAdvancedSerialNum(model)
  }
  
  public static func getMfgInfo(_ model: HubModel) -> String? {
    return capability.getHubAdvancedMfgInfo(model)
  }
  
  public static func getBootloaderVer(_ model: HubModel) -> String? {
    return capability.getHubAdvancedBootloaderVer(model)
  }
  
  public static func getFirmwareGroup(_ model: HubModel) -> String? {
    return capability.getHubAdvancedFirmwareGroup(model)
  }
  
  public static func getLastReset(_ model: HubModel) -> String? {
    return capability.getHubAdvancedLastReset(model)
  }
  
  public static func getLastDeviceAddRemove(_ model: HubModel) -> String? {
    return capability.getHubAdvancedLastDeviceAddRemove(model)
  }
  
  public static func getLastRestartReason(_ model: HubModel) -> String? {
    return capability.getHubAdvancedLastRestartReason(model)?.rawValue
  }
  
  public static func getLastRestartTime(_ model: HubModel) -> Date? {
    guard let lastRestartTime: Date = capability.getHubAdvancedLastRestartTime(model) else {
      return nil
    }
    return lastRestartTime
  }
  
  public static func getLastFailedWatchdogChecksTime(_ model: HubModel) -> Date? {
    guard let lastFailedWatchdogChecksTime: Date = capability.getHubAdvancedLastFailedWatchdogChecksTime(model) else {
      return nil
    }
    return lastFailedWatchdogChecksTime
  }
  
  public static func getLastFailedWatchdogChecks(_ model: HubModel) -> [String]? {
    return capability.getHubAdvancedLastFailedWatchdogChecks(model)
  }
  
  public static func getLastDbCheck(_ model: HubModel) -> Date? {
    guard let lastDbCheck: Date = capability.getHubAdvancedLastDbCheck(model) else {
      return nil
    }
    return lastDbCheck
  }
  
  public static func getLastDbCheckResults(_ model: HubModel) -> String? {
    return capability.getHubAdvancedLastDbCheckResults(model)
  }
  
  public static func getMigrationDualEui64(_ model: HubModel) -> NSNumber? {
    guard let migrationDualEui64: Bool = capability.getHubAdvancedMigrationDualEui64(model) else {
      return nil
    }
    return NSNumber(value: migrationDualEui64)
  }
  
  public static func getMigrationDualEui64Fixed(_ model: HubModel) -> NSNumber? {
    guard let migrationDualEui64Fixed: Bool = capability.getHubAdvancedMigrationDualEui64Fixed(model) else {
      return nil
    }
    return NSNumber(value: migrationDualEui64Fixed)
  }
  
  public static func getMfgBatchNumber(_ model: HubModel) -> String? {
    return capability.getHubAdvancedMfgBatchNumber(model)
  }
  
  public static func getMfgDate(_ model: HubModel) -> Date? {
    guard let mfgDate: Date = capability.getHubAdvancedMfgDate(model) else {
      return nil
    }
    return mfgDate
  }
  
  public static func getMfgFactoryID(_ model: HubModel) -> NSNumber? {
    guard let mfgFactoryID: Int = capability.getHubAdvancedMfgFactoryID(model) else {
      return nil
    }
    return NSNumber(value: mfgFactoryID)
  }
  
  public static func getHwFlashSize(_ model: HubModel) -> NSNumber? {
    guard let hwFlashSize: Int = capability.getHubAdvancedHwFlashSize(model) else {
      return nil
    }
    return NSNumber(value: hwFlashSize)
  }
  
  public static func restart(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubAdvancedRestart(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func reboot(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubAdvancedReboot(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func firmwareUpdate(_  model: HubModel, url: String, priority: String, type: String, showLed: Bool) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAdvancedFirmwareUpdate(model, url: url, priority: priority, type: type, showLed: showLed))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func factoryReset(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubAdvancedFactoryReset(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getKnownDevices(_  model: HubModel, protocols: [String]) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAdvancedGetKnownDevices(model, protocols: protocols))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getDeviceInfo(_  model: HubModel, protocolAddress: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAdvancedGetDeviceInfo(model, protocolAddress: protocolAddress))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
