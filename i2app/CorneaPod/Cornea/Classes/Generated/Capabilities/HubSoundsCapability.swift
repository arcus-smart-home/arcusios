
//
// HubSoundsCap.swift
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
  public static var hubSoundsNamespace: String = "hubsounds"
  public static var hubSoundsName: String = "HubSounds"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubSoundsPlaying: String = "hubsounds:playing"
  static let hubSoundsSource: String = "hubsounds:source"
  
}

public protocol ArcusHubSoundsCapability: class, RxArcusService {
  /** Is the hub playing a sounds? */
  func getHubSoundsPlaying(_ model: HubModel) -> Bool?
  /** Source of the sounds being played.  File from URL or pre-programmed tone name */
  func getHubSoundsSource(_ model: HubModel) -> String?
  
  /** Causes the hub to play the chime sound. */
  func requestHubSoundsPlayTone(_  model: HubModel, tone: String, durationSec: Int)
   throws -> Observable<ArcusSessionEvent>/** Stop playing any sound. */
  func requestHubSoundsQuiet(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubSoundsCapability {
  public func getHubSoundsPlaying(_ model: HubModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSoundsPlaying] as? Bool
  }
  
  public func getHubSoundsSource(_ model: HubModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubSoundsSource] as? String
  }
  
  
  public func requestHubSoundsPlayTone(_  model: HubModel, tone: String, durationSec: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubSoundsPlayToneRequest = HubSoundsPlayToneRequest()
    request.source = model.address
    
    
    
    request.setTone(tone)
    
    request.setDurationSec(durationSec)
    
    return try sendRequest(request)
  }
  
  public func requestHubSoundsQuiet(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubSoundsQuietRequest = HubSoundsQuietRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
