
//
// DeviceService.swift
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
  public static let deviceServiceNamespace: String = "dev"
  public static let deviceServiceName: String = "DeviceService"
  public static let deviceServiceAddress: String = "SERV:dev:"
}

/** Entry points for the device service, which covers global operations on devices not handled by the device object capabilities. */
public protocol ArcusDeviceService: RxArcusService {
  /** A request to synchronize the hub local reflexes with device services */
  func requestDeviceServiceSyncDevices(_ accountId: String, placeId: String, reflexVersion: Int, devices: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusDeviceService {
  public func requestDeviceServiceSyncDevices(_ accountId: String, placeId: String, reflexVersion: Int, devices: String) throws -> Observable<ArcusSessionEvent> {
    let request: DeviceServiceSyncDevicesRequest = DeviceServiceSyncDevicesRequest()
    request.source = Constants.deviceServiceAddress
    
    
    request.setAccountId(accountId)
    request.setPlaceId(placeId)
    request.setReflexVersion(reflexVersion)
    request.setDevices(devices)

    return try sendRequest(request)
  }
  
}
