
//
// WiFiScanCap.swift
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
  public static var wiFiScanNamespace: String = "wifiscan"
  public static var wiFiScanName: String = "WiFiScan"
}



public protocol ArcusWiFiScanCapability: class, RxArcusService {
  
  /** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
  func requestWiFiScanStartWifiScan(_  model: DeviceModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent>/** Ends any active WiFiScan. If no scan is active, this is a no-op. */
  func requestWiFiScanEndWifiScan(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusWiFiScanCapability {
  
  public func requestWiFiScanStartWifiScan(_  model: DeviceModel, timeout: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: WiFiScanStartWifiScanRequest = WiFiScanStartWifiScanRequest()
    request.source = model.address
    
    
    
    request.setTimeout(timeout)
    
    return try sendRequest(request)
  }
  
  public func requestWiFiScanEndWifiScan(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: WiFiScanEndWifiScanRequest = WiFiScanEndWifiScanRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
