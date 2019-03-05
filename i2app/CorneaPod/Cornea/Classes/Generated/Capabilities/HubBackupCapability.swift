
//
// HubBackupCap.swift
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
  public static var hubBackupNamespace: String = "hubbackup"
  public static var hubBackupName: String = "HubBackup"
}



public protocol ArcusHubBackupCapability: class, RxArcusService {
  
  /** Performs a backup in the hub, returning a binary blob in response. */
  func requestHubBackupBackup(_  model: HubModel, type: String)
   throws -> Observable<ArcusSessionEvent>/** Performs a restore on the hub. */
  func requestHubBackupRestore(_  model: HubModel, type: String, data: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubBackupCapability {
  
  public func requestHubBackupBackup(_  model: HubModel, type: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubBackupBackupRequest = HubBackupBackupRequest()
    request.source = model.address
    
    
    
    request.setType(type)
    
    return try sendRequest(request)
  }
  
  public func requestHubBackupRestore(_  model: HubModel, type: String, data: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubBackupRestoreRequest = HubBackupRestoreRequest()
    request.source = model.address
    
    
    
    request.setType(type)
    
    request.setData(data)
    
    return try sendRequest(request)
  }
  
}
