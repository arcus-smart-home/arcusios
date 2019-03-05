
//
// VideoService.swift
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
  public static let videoServiceNamespace: String = "video"
  public static let videoServiceName: String = "VideoService"
  public static let videoServiceAddress: String = "SERV:video:"
}

/** Entry points for video recordings. */
public protocol ArcusVideoService: RxArcusService {
  /** Lists all recordings available for a given place. */
  func requestVideoServiceListRecordings(_ placeId: String, all: Bool, type: String) throws -> Observable<ArcusSessionEvent>/** Lists paged recordings available for a given place. */
  func requestVideoServicePageRecordings(_ placeId: String, limit: Int, token: String, all: Bool, inprogress: Bool, type: String, latest: Date, earliest: Date, cameras: [String], tags: [String]) throws -> Observable<ArcusSessionEvent>/** Starts a video recording or live streaming session. */
  func requestVideoServiceStartRecording(_ placeId: String, accountId: String, cameraAddress: String, stream: Bool, duration: Int) throws -> Observable<ArcusSessionEvent>/** Stops a video recording or live streaming session. */
  func requestVideoServiceStopRecording(_ placeId: String, recordingId: String) throws -> Observable<ArcusSessionEvent>/** Gets the video storage quota for a place. */
  func requestVideoServiceGetQuota(_ placeId: String) throws -> Observable<ArcusSessionEvent>/** Gets the video favorite video quota for a place. */
  func requestVideoServiceGetFavoriteQuota(_ placeId: String) throws -> Observable<ArcusSessionEvent>/** Delete all recordings for the given place. */
  func requestVideoServiceDeleteAll(_ placeId: String, includeFavorites: Bool) throws -> Observable<ArcusSessionEvent>
}

extension ArcusVideoService {
  public func requestVideoServiceListRecordings(_ placeId: String, all: Bool, type: String) throws -> Observable<ArcusSessionEvent> {
    let request: VideoServiceListRecordingsRequest = VideoServiceListRecordingsRequest()
    request.source = Constants.videoServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setAll(all)
    request.setType(type)

    return try sendRequest(request)
  }
  public func requestVideoServicePageRecordings(_ placeId: String, limit: Int, token: String, all: Bool, inprogress: Bool, type: String, latest: Date, earliest: Date, cameras: [String], tags: [String]) throws -> Observable<ArcusSessionEvent> {
    let request: VideoServicePageRecordingsRequest = VideoServicePageRecordingsRequest()
    request.source = Constants.videoServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setLimit(limit)
    request.setToken(token)
    request.setAll(all)
    request.setInprogress(inprogress)
    request.setType(type)
    request.setLatest(latest)
    request.setEarliest(earliest)
    request.setCameras(cameras)
    request.setTags(tags)

    return try sendRequest(request)
  }
  public func requestVideoServiceStartRecording(_ placeId: String, accountId: String, cameraAddress: String, stream: Bool, duration: Int) throws -> Observable<ArcusSessionEvent> {
    let request: VideoServiceStartRecordingRequest = VideoServiceStartRecordingRequest()
    request.source = Constants.videoServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setAccountId(accountId)
    request.setCameraAddress(cameraAddress)
    request.setStream(stream)
    request.setDuration(duration)

    return try sendRequest(request)
  }
  public func requestVideoServiceStopRecording(_ placeId: String, recordingId: String) throws -> Observable<ArcusSessionEvent> {
    let request: VideoServiceStopRecordingRequest = VideoServiceStopRecordingRequest()
    request.source = Constants.videoServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setRecordingId(recordingId)

    return try sendRequest(request)
  }
  public func requestVideoServiceGetQuota(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: VideoServiceGetQuotaRequest = VideoServiceGetQuotaRequest()
    request.source = Constants.videoServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestVideoServiceGetFavoriteQuota(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: VideoServiceGetFavoriteQuotaRequest = VideoServiceGetFavoriteQuotaRequest()
    request.source = Constants.videoServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestVideoServiceDeleteAll(_ placeId: String, includeFavorites: Bool) throws -> Observable<ArcusSessionEvent> {
    let request: VideoServiceDeleteAllRequest = VideoServiceDeleteAllRequest()
    request.source = Constants.videoServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setIncludeFavorites(includeFavorites)

    return try sendRequest(request)
  }
  
}
