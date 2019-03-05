
//
// DeviceOtaCap.swift
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
  public static var deviceOtaNamespace: String = "devota"
  public static var deviceOtaName: String = "DeviceOta"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let deviceOtaCurrentVersion: String = "devota:currentVersion"
  static let deviceOtaTargetVersion: String = "devota:targetVersion"
  static let deviceOtaStatus: String = "devota:status"
  static let deviceOtaRetryCount: String = "devota:retryCount"
  static let deviceOtaLastAttempt: String = "devota:lastAttempt"
  static let deviceOtaProgressPercent: String = "devota:progressPercent"
  static let deviceOtaLastFailReason: String = "devota:lastFailReason"
  
}

public protocol ArcusDeviceOtaCapability: class, RxArcusService {
  /** Version of the currently installed firmware. */
  func getDeviceOtaCurrentVersion(_ model: DeviceModel) -> String?
  /** Version of the target firmware. */
  func getDeviceOtaTargetVersion(_ model: DeviceModel) -> String?
  /** Status of the current firmware update process. */
  func getDeviceOtaStatus(_ model: DeviceModel) -> DeviceOtaStatus?
  /** Current firmware update retry count. */
  func getDeviceOtaRetryCount(_ model: DeviceModel) -> Int?
  /** UTC date time of last retry attempt. */
  func getDeviceOtaLastAttempt(_ model: DeviceModel) -> Date?
  /** Progress of the current firmware download. */
  func getDeviceOtaProgressPercent(_ model: DeviceModel) -> Double?
  /** Reason for failure of the OTA (offline, timeout, refused, etc.). */
  func getDeviceOtaLastFailReason(_ model: DeviceModel) -> String?
  
  /** Requests that the hub update its firmware */
  func requestDeviceOtaFirmwareUpdate(_  model: DeviceModel, url: String, priority: String, md5: String)
   throws -> Observable<ArcusSessionEvent>/** Requests that the hub cancel an existing firmware update */
  func requestDeviceOtaFirmwareUpdateCancel(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusDeviceOtaCapability {
  public func getDeviceOtaCurrentVersion(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceOtaCurrentVersion] as? String
  }
  
  public func getDeviceOtaTargetVersion(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceOtaTargetVersion] as? String
  }
  
  public func getDeviceOtaStatus(_ model: DeviceModel) -> DeviceOtaStatus? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.deviceOtaStatus] as? String,
      let enumAttr: DeviceOtaStatus = DeviceOtaStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getDeviceOtaRetryCount(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceOtaRetryCount] as? Int
  }
  
  public func getDeviceOtaLastAttempt(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.deviceOtaLastAttempt] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getDeviceOtaProgressPercent(_ model: DeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceOtaProgressPercent] as? Double
  }
  
  public func getDeviceOtaLastFailReason(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.deviceOtaLastFailReason] as? String
  }
  
  
  public func requestDeviceOtaFirmwareUpdate(_  model: DeviceModel, url: String, priority: String, md5: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: DeviceOtaFirmwareUpdateRequest = DeviceOtaFirmwareUpdateRequest()
    request.source = model.address
    
    
    
    request.setUrl(url)
    
    request.setPriority(priority)
    
    request.setMd5(md5)
    
    return try sendRequest(request)
  }
  
  public func requestDeviceOtaFirmwareUpdateCancel(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceOtaFirmwareUpdateCancelRequest = DeviceOtaFirmwareUpdateCancelRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
