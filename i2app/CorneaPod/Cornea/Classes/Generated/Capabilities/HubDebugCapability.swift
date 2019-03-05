
//
// HubDebugCap.swift
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
  public static var hubDebugNamespace: String = "hubdebug"
  public static var hubDebugName: String = "HubDebug"
}



public protocol ArcusHubDebugCapability: class, RxArcusService {
  
  /** Gets the current contents of the HubOS syslog file. */
  func requestHubDebugGetFiles(_  model: HubModel, paths: [String])
   throws -> Observable<ArcusSessionEvent>/** Gets the current contents of the agent database. */
  func requestHubDebugGetAgentDb(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Gets the current contents of the HubOS syslog file. */
  func requestHubDebugGetSyslog(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Gets the current contents of the HubOS bootlog file. */
  func requestHubDebugGetBootlog(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Gets the current list of processes from the HubOS. */
  func requestHubDebugGetProcesses(_ model: HubModel) throws -> Observable<ArcusSessionEvent>/** Gets the current process load information from the HubOS. */
  func requestHubDebugGetLoad(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubDebugCapability {
  
  public func requestHubDebugGetFiles(_  model: HubModel, paths: [String])
   throws -> Observable<ArcusSessionEvent> {
    let request: HubDebugGetFilesRequest = HubDebugGetFilesRequest()
    request.source = model.address
    
    
    
    request.setPaths(paths)
    
    return try sendRequest(request)
  }
  
  public func requestHubDebugGetAgentDb(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubDebugGetAgentDbRequest = HubDebugGetAgentDbRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubDebugGetSyslog(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubDebugGetSyslogRequest = HubDebugGetSyslogRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubDebugGetBootlog(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubDebugGetBootlogRequest = HubDebugGetBootlogRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubDebugGetProcesses(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubDebugGetProcessesRequest = HubDebugGetProcessesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHubDebugGetLoad(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubDebugGetLoadRequest = HubDebugGetLoadRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
