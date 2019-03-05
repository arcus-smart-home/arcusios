
//
// Hub4gCap.swift
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
  public static var hub4gNamespace: String = "hub4g"
  public static var hub4gName: String = "Hub4g"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hub4gPresent: String = "hub4g:present"
  static let hub4gSimPresent: String = "hub4g:simPresent"
  static let hub4gSimProvisioned: String = "hub4g:simProvisioned"
  static let hub4gSimDisabled: String = "hub4g:simDisabled"
  static let hub4gSimDisabledDate: String = "hub4g:simDisabledDate"
  static let hub4gConnectionState: String = "hub4g:connectionState"
  static let hub4gVendor: String = "hub4g:vendor"
  static let hub4gModel: String = "hub4g:model"
  static let hub4gSerialNumber: String = "hub4g:serialNumber"
  static let hub4gImei: String = "hub4g:imei"
  static let hub4gImsi: String = "hub4g:imsi"
  static let hub4gIccid: String = "hub4g:iccid"
  static let hub4gPhoneNumber: String = "hub4g:phoneNumber"
  static let hub4gMode: String = "hub4g:mode"
  static let hub4gSignalBars: String = "hub4g:signalBars"
  static let hub4gConnectionStatus: String = "hub4g:connectionStatus"
  
}

public protocol ArcusHub4gCapability: class, RxArcusService {
  /** True if a 4G dongle is installed on the hub */
  func getHub4gPresent(_ model: HubModel) -> Bool?
  /** True if the installed 4G dongle has a sim card present */
  func getHub4gSimPresent(_ model: HubModel) -> Bool?
  /** True if the installed 4G sim card has been provisioned */
  func getHub4gSimProvisioned(_ model: HubModel) -> Bool?
  /** True if the installed 4G sim card has been marked invalid */
  func getHub4gSimDisabled(_ model: HubModel) -> Bool?
  /** Date when 4G sim card was disabled, if any */
  func getHub4gSimDisabledDate(_ model: HubModel) -> Date?
  /** Current state of 4g connection */
  func getHub4gConnectionState(_ model: HubModel) -> Hub4gConnectionState?
  /** String description of the 4G dongle vendor */
  func getHub4gVendor(_ model: HubModel) -> String?
  /** String description of the 4G dongle model */
  func getHub4gModel(_ model: HubModel) -> String?
  /** Serial number of 4G dongle */
  func getHub4gSerialNumber(_ model: HubModel) -> String?
  /** IMEI of 4G dongle */
  func getHub4gImei(_ model: HubModel) -> String?
  /** IMSI of 4G dongle */
  func getHub4gImsi(_ model: HubModel) -> String?
  /** ICCID of 4G dongle */
  func getHub4gIccid(_ model: HubModel) -> String?
  /** Phone number of 4G dongle */
  func getHub4gPhoneNumber(_ model: HubModel) -> String?
  /** Network connection mode */
  func getHub4gMode(_ model: HubModel) -> String?
  /** Signal strength in bars */
  func getHub4gSignalBars(_ model: HubModel) -> Int?
  /** Vendor specific connection status code */
  func getHub4gConnectionStatus(_ model: HubModel) -> String?
  
  /** Get 4G dongle information */
  func requestHub4gGetInfo(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Reset 4g connection statistics */
  func requestHub4gResetStatistics(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Get 4g connection statistics */
  func requestHub4gGetStatistics(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHub4gCapability {
  public func getHub4gPresent(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gPresent] as? Bool
  }
  
  public func getHub4gSimPresent(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gSimPresent] as? Bool
  }
  
  public func getHub4gSimProvisioned(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gSimProvisioned] as? Bool
  }
  
  public func getHub4gSimDisabled(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gSimDisabled] as? Bool
  }
  
  public func getHub4gSimDisabledDate(_ model: HubModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hub4gSimDisabledDate] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getHub4gConnectionState(_ model: HubModel) -> Hub4gConnectionState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hub4gConnectionState] as? String,
      let enumAttr: Hub4gConnectionState = Hub4gConnectionState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHub4gVendor(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gVendor] as? String
  }
  
  public func getHub4gModel(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gModel] as? String
  }
  
  public func getHub4gSerialNumber(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gSerialNumber] as? String
  }
  
  public func getHub4gImei(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gImei] as? String
  }
  
  public func getHub4gImsi(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gImsi] as? String
  }
  
  public func getHub4gIccid(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gIccid] as? String
  }
  
  public func getHub4gPhoneNumber(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gPhoneNumber] as? String
  }
  
  public func getHub4gMode(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gMode] as? String
  }
  
  public func getHub4gSignalBars(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gSignalBars] as? Int
  }
  
  public func getHub4gConnectionStatus(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hub4gConnectionStatus] as? String
  }
  
  
  public func requestHub4gGetInfo(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: Hub4gGetInfoRequest = Hub4gGetInfoRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHub4gResetStatistics(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: Hub4gResetStatisticsRequest = Hub4gResetStatisticsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHub4gGetStatistics(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: Hub4gGetStatisticsRequest = Hub4gGetStatisticsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
