
//
// MockAlarmIncidentCap.swift
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
  public static var mockAlarmIncidentNamespace: String = "incidentmock"
  public static var mockAlarmIncidentName: String = "MockAlarmIncident"
}



public protocol ArcusMockAlarmIncidentCapability: class, RxArcusService {
  
  /** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Adds the history entry for contacting a person.  If no person is specified the person issuing the call will be used. */
  func requestMockAlarmIncidentContacted(_  model: AlarmIncidentModel, person: String)
   throws -> Observable<ArcusSessionEvent>/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to CANCELLED and the alertState to COMPLETE.  Also creates the appropriate history entries.             If no person is specified the person issuing the call will be used. */
  func requestMockAlarmIncidentDispatchCancelled(_  model: AlarmIncidentModel, person: String)
   throws -> Observable<ArcusSessionEvent>/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.             If the alertState is CANCELLING it should be changed to COMPLETE. */
  func requestMockAlarmIncidentDispatchAccepted(_  model: AlarmIncidentModel, authority: String)
   throws -> Observable<ArcusSessionEvent>/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.           If the alertState is CANCELLING it should be changed to COMPLETE. */
  func requestMockAlarmIncidentDispatchRefused(_  model: AlarmIncidentModel, authority: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusMockAlarmIncidentCapability {
  
  public func requestMockAlarmIncidentContacted(_  model: AlarmIncidentModel, person: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: MockAlarmIncidentContactedRequest = MockAlarmIncidentContactedRequest()
    request.source = model.address
    
    
    
    request.setPerson(person)
    
    return try sendRequest(request)
  }
  
  public func requestMockAlarmIncidentDispatchCancelled(_  model: AlarmIncidentModel, person: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: MockAlarmIncidentDispatchCancelledRequest = MockAlarmIncidentDispatchCancelledRequest()
    request.source = model.address
    
    
    
    request.setPerson(person)
    
    return try sendRequest(request)
  }
  
  public func requestMockAlarmIncidentDispatchAccepted(_  model: AlarmIncidentModel, authority: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: MockAlarmIncidentDispatchAcceptedRequest = MockAlarmIncidentDispatchAcceptedRequest()
    request.source = model.address
    
    
    
    request.setAuthority(authority)
    
    return try sendRequest(request)
  }
  
  public func requestMockAlarmIncidentDispatchRefused(_  model: AlarmIncidentModel, authority: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: MockAlarmIncidentDispatchRefusedRequest = MockAlarmIncidentDispatchRefusedRequest()
    request.source = model.address
    
    
    
    request.setAuthority(authority)
    
    return try sendRequest(request)
  }
  
}
