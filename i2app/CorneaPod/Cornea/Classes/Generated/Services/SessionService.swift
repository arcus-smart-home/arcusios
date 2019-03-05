
//
// SessionService.swift
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
  public static let sessionServiceNamespace: String = "sess"
  public static let sessionServiceName: String = "SessionService"
  public static let sessionServiceAddress: String = "SERV:sess:"
}

/** Enables interactions with the current session. */
public protocol ArcusSessionService: RxArcusService {
  /** Sets the place that this session is associated with, the session will begin receiving broadcasts for the requested place */
  func requestSessionServiceSetActivePlace(_ placeId: String) throws -> Observable<ArcusSessionEvent>/** Logs an event to the server */
  func requestSessionServiceLog(_ category: String, code: String, message: String) throws -> Observable<ArcusSessionEvent>/** Persists a UI analytics tag on the server */
  func requestSessionServiceTag(_ name: String, context: [String: String]) throws -> Observable<ArcusSessionEvent>/** Lists the available places for the currently logged in user */
  func requestSessionServiceListAvailablePlaces() throws -> Observable<ArcusSessionEvent>/** Returns the preferences for the currently logged in user at their active place or empty if no preferences have been set or active place has not been set */
  func requestSessionServiceGetPreferences() throws -> Observable<ArcusSessionEvent>/** Sets the one or more preferences for the currently logged in user at their active place.  If a key is defined in their preferences but not specified here, it will not be cleared by this set. */
  func requestSessionServiceSetPreferences(_ prefs: Any) throws -> Observable<ArcusSessionEvent>/** Resets the preference with the given key for the currently logged in user at their active place.  This will remove the preference and return this preference to default. */
  func requestSessionServiceResetPreference(_ prefKey: String) throws -> Observable<ArcusSessionEvent>/** Lock the device by removing the mobile device record and logout the current session. */
  func requestSessionServiceLockDevice(_ deviceIdentifier: String, reason: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSessionService {
  public func requestSessionServiceSetActivePlace(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceSetActivePlaceRequest = SessionServiceSetActivePlaceRequest()
    request.source = Constants.sessionServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestSessionServiceLog(_ category: String, code: String, message: String) throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceLogRequest = SessionServiceLogRequest()
    request.source = Constants.sessionServiceAddress
    
    
    request.setCategory(category)
    request.setCode(code)
    request.setMessage(message)

    return try sendRequest(request)
  }
  public func requestSessionServiceTag(_ name: String, context: [String: String]) throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceTagRequest = SessionServiceTagRequest()
    request.source = Constants.sessionServiceAddress
    
    
    request.setName(name)
    request.setContext(context)

    return try sendRequest(request)
  }
  public func requestSessionServiceListAvailablePlaces() throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceListAvailablePlacesRequest = SessionServiceListAvailablePlacesRequest()
    request.source = Constants.sessionServiceAddress
    
    

    return try sendRequest(request)
  }
  public func requestSessionServiceGetPreferences() throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceGetPreferencesRequest = SessionServiceGetPreferencesRequest()
    request.source = Constants.sessionServiceAddress
    
    

    return try sendRequest(request)
  }
  public func requestSessionServiceSetPreferences(_ prefs: Any) throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceSetPreferencesRequest = SessionServiceSetPreferencesRequest()
    request.source = Constants.sessionServiceAddress
    
    
    request.setPrefs(prefs)

    return try sendRequest(request)
  }
  public func requestSessionServiceResetPreference(_ prefKey: String) throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceResetPreferenceRequest = SessionServiceResetPreferenceRequest()
    request.source = Constants.sessionServiceAddress
    
    
    request.setPrefKey(prefKey)

    return try sendRequest(request)
  }
  public func requestSessionServiceLockDevice(_ deviceIdentifier: String, reason: String) throws -> Observable<ArcusSessionEvent> {
    let request: SessionServiceLockDeviceRequest = SessionServiceLockDeviceRequest()
    request.source = Constants.sessionServiceAddress
    request.isRequest = true
    
    request.setDeviceIdentifier(deviceIdentifier)
    request.setReason(reason)

    return try sendRequest(request)
  }
  
}
