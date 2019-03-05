
//
// HubZigbeeCapabilityLegacy.swift
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

public class HubZigbeeCapabilityLegacy: NSObject, ArcusHubZigbeeCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubZigbeeCapabilityLegacy  = HubZigbeeCapabilityLegacy()
  
  static let HubZigbeePowermodeDEFAULT: String = HubZigbeePowermode.hubZigbeeDefault.rawValue
  static let HubZigbeePowermodeBOOST: String = HubZigbeePowermode.boost.rawValue
  static let HubZigbeePowermodeALTERNATE: String = HubZigbeePowermode.alternate.rawValue
  static let HubZigbeePowermodeBOOST_AND_ALTERNATE: String = HubZigbeePowermode.boost_and_alternate.rawValue
  
  static let HubZigbeeStateUP: String = HubZigbeeState.up.rawValue
  static let HubZigbeeStateDOWN: String = HubZigbeeState.down.rawValue
  static let HubZigbeeStateJOIN_FAILED: String = HubZigbeeState.join_failed.rawValue
  static let HubZigbeeStateMOVE_FAILED: String = HubZigbeeState.move_failed.rawValue
  

  
  public static func getPanid(_ model: HubModel) -> NSNumber? {
    guard let panid: Int = capability.getHubZigbeePanid(model) else {
      return nil
    }
    return NSNumber(value: panid)
  }
  
  public static func getExtid(_ model: HubModel) -> NSNumber? {
    guard let extid: Int = capability.getHubZigbeeExtid(model) else {
      return nil
    }
    return NSNumber(value: extid)
  }
  
  public static func getChannel(_ model: HubModel) -> NSNumber? {
    guard let channel: Int = capability.getHubZigbeeChannel(model) else {
      return nil
    }
    return NSNumber(value: channel)
  }
  
  public static func getPower(_ model: HubModel) -> NSNumber? {
    guard let power: Int = capability.getHubZigbeePower(model) else {
      return nil
    }
    return NSNumber(value: power)
  }
  
  public static func getPowermode(_ model: HubModel) -> String? {
    return capability.getHubZigbeePowermode(model)?.rawValue
  }
  
  public static func getProfile(_ model: HubModel) -> NSNumber? {
    guard let profile: Int = capability.getHubZigbeeProfile(model) else {
      return nil
    }
    return NSNumber(value: profile)
  }
  
  public static func getSecurity(_ model: HubModel) -> NSNumber? {
    guard let security: Int = capability.getHubZigbeeSecurity(model) else {
      return nil
    }
    return NSNumber(value: security)
  }
  
  public static func getSupportednwks(_ model: HubModel) -> NSNumber? {
    guard let supportednwks: Int = capability.getHubZigbeeSupportednwks(model) else {
      return nil
    }
    return NSNumber(value: supportednwks)
  }
  
  public static func getJoining(_ model: HubModel) -> NSNumber? {
    guard let joining: Bool = capability.getHubZigbeeJoining(model) else {
      return nil
    }
    return NSNumber(value: joining)
  }
  
  public static func getUpdateid(_ model: HubModel) -> NSNumber? {
    guard let updateid: Int = capability.getHubZigbeeUpdateid(model) else {
      return nil
    }
    return NSNumber(value: updateid)
  }
  
  public static func getEui64(_ model: HubModel) -> NSNumber? {
    guard let eui64: Int = capability.getHubZigbeeEui64(model) else {
      return nil
    }
    return NSNumber(value: eui64)
  }
  
  public static func getTceui64(_ model: HubModel) -> NSNumber? {
    guard let tceui64: Int = capability.getHubZigbeeTceui64(model) else {
      return nil
    }
    return NSNumber(value: tceui64)
  }
  
  public static func getUptime(_ model: HubModel) -> NSNumber? {
    guard let uptime: Int = capability.getHubZigbeeUptime(model) else {
      return nil
    }
    return NSNumber(value: uptime)
  }
  
  public static func getVersion(_ model: HubModel) -> String? {
    return capability.getHubZigbeeVersion(model)
  }
  
  public static func getManufacturer(_ model: HubModel) -> NSNumber? {
    guard let manufacturer: Int = capability.getHubZigbeeManufacturer(model) else {
      return nil
    }
    return NSNumber(value: manufacturer)
  }
  
  public static func getState(_ model: HubModel) -> String? {
    return capability.getHubZigbeeState(model)?.rawValue
  }
  
  public static func getPendingPairing(_ model: HubModel) -> [Any]? {
    return capability.getHubZigbeePendingPairing(model)
  }
  
  public static func reset(_  model: HubModel, type: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeReset(model, type: type))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func scan(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZigbeeScan(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getConfig(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZigbeeGetConfig(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getStats(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZigbeeGetStats(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getNodeDesc(_  model: HubModel, nwk: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeGetNodeDesc(model, nwk: nwk))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getActiveEp(_  model: HubModel, nwk: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeGetActiveEp(model, nwk: nwk))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getSimpleDesc(_  model: HubModel, nwk: Int, ep: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeGetSimpleDesc(model, nwk: nwk, ep: ep))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getPowerDesc(_  model: HubModel, nwk: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeGetPowerDesc(model, nwk: nwk))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func identify(_  model: HubModel, eui64: Int, duration: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeIdentify(model, eui64: eui64, duration: duration))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func remove(_  model: HubModel, eui64: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeRemove(model, eui64: eui64))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func factoryReset(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZigbeeFactoryReset(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func formNetwork(_  model: HubModel, eui64: Int, panId: Int, extPanId: Int, channel: Int, nwkkey: String, nwkfc: Int, apsfc: Int, updateid: Int) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeeFormNetwork(model, eui64: eui64, panId: panId, extPanId: extPanId, channel: channel, nwkkey: nwkkey, nwkfc: nwkfc, apsfc: apsfc, updateid: updateid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func fixMigration(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZigbeeFixMigration(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func networkInformation(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubZigbeeNetworkInformation(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func pairingLinkKey(_  model: HubModel, euid: String, linkkey: String, timeout: Int) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeePairingLinkKey(model, euid: euid, linkkey: linkkey, timeout: timeout))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func pairingInstallCode(_  model: HubModel, euid: String, installcode: String, timeout: Int) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubZigbeePairingInstallCode(model, euid: euid, installcode: installcode, timeout: timeout))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
