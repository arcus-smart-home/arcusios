
//
// HubAVCap.swift
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
  public static var hubAVNamespace: String = "hubav"
  public static var hubAVName: String = "HubAV"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubAVNumAvailable: String = "hubav:numAvailable"
  static let hubAVNumPaired: String = "hubav:numPaired"
  static let hubAVNumDisconnected: String = "hubav:numDisconnected"
  static let hubAVAvdevs: String = "hubav:avdevs"
  
}

public protocol ArcusHubAVCapability: class, RxArcusService {
  /** Number of AV devices available for pairing */
  func getHubAVNumAvailable(_ model: HubModel) -> Int?
  /** Number of AV devices paired to the hub */
  func getHubAVNumPaired(_ model: HubModel) -> Int?
  /** Number of AV devices that are no longer connected */
  func getHubAVNumDisconnected(_ model: HubModel) -> Int?
  /** List of AV devices (by UUID) with current mode */
  func getHubAVAvdevs(_ model: HubModel) -> [String: String]?
  
  /** Pair an AV device to the hub */
  func requestHubAVPair(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Release an AV device from the hub */
  func requestHubAVRelease(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Get current state of AV device */
  func requestHubAVGetState(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Get IPv4 address of AV device */
  func requestHubAVGetIPAddress(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Get model of AV device */
  func requestHubAVGetModel(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Start audio on an AV device given an URL */
  func requestHubAVAudioStart(_  model: HubModel, uuid: String, url: String, metadata: String)
   throws -> Observable<ArcusSessionEvent>/** Stop audio on an AV device */
  func requestHubAVAudioStop(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Pause audio on an AV device */
  func requestHubAVAudioPause(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Seek audio on an AV device */
  func requestHubAVAudioSeekTo(_  model: HubModel, uuid: String, unit: String, target: Int)
   throws -> Observable<ArcusSessionEvent>/** Set volume on an AV device */
  func requestHubAVSetVolume(_  model: HubModel, uuid: String, volume: Int)
   throws -> Observable<ArcusSessionEvent>/** Get volume on an AV device */
  func requestHubAVGetVolume(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Set mute on an AV device */
  func requestHubAVSetMute(_  model: HubModel, uuid: String, mute: Bool)
   throws -> Observable<ArcusSessionEvent>/** Get mute on an AV device */
  func requestHubAVGetMute(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>/** Get information about current audio track */
  func requestHubAVAudioInfo(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubAVCapability {
  public func getHubAVNumAvailable(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAVNumAvailable] as? Int
  }
  
  public func getHubAVNumPaired(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAVNumPaired] as? Int
  }
  
  public func getHubAVNumDisconnected(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAVNumDisconnected] as? Int
  }
  
  public func getHubAVAvdevs(_ model: HubModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubAVAvdevs] as? [String: String]
  }
  
  
  public func requestHubAVPair(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVPairRequest = HubAVPairRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVRelease(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVReleaseRequest = HubAVReleaseRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVGetState(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVGetStateRequest = HubAVGetStateRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVGetIPAddress(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVGetIPAddressRequest = HubAVGetIPAddressRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVGetModel(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVGetModelRequest = HubAVGetModelRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVAudioStart(_  model: HubModel, uuid: String, url: String, metadata: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVAudioStartRequest = HubAVAudioStartRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    request.setUrl(url)
    
    request.setMetadata(metadata)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVAudioStop(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVAudioStopRequest = HubAVAudioStopRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVAudioPause(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVAudioPauseRequest = HubAVAudioPauseRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVAudioSeekTo(_  model: HubModel, uuid: String, unit: String, target: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVAudioSeekToRequest = HubAVAudioSeekToRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    request.setUnit(unit)
    
    request.setTarget(target)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVSetVolume(_  model: HubModel, uuid: String, volume: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVSetVolumeRequest = HubAVSetVolumeRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    request.setVolume(volume)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVGetVolume(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVGetVolumeRequest = HubAVGetVolumeRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVSetMute(_  model: HubModel, uuid: String, mute: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVSetMuteRequest = HubAVSetMuteRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    request.setMute(mute)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVGetMute(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVGetMuteRequest = HubAVGetMuteRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
  public func requestHubAVAudioInfo(_  model: HubModel, uuid: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubAVAudioInfoRequest = HubAVAudioInfoRequest()
    request.source = model.address
    
    
    
    request.setUuid(uuid)
    
    return try sendRequest(request)
  }
  
}
