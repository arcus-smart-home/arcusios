
//
// VideoServiceEvents.swift
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
// MARK: Commands
fileprivate struct Commands {
  /** Lists all recordings available for a given place. */
  public static let videoServiceListRecordings: String = "video:ListRecordings"
  /** Lists paged recordings available for a given place. */
  public static let videoServicePageRecordings: String = "video:PageRecordings"
  /** Starts a video recording or live streaming session. */
  public static let videoServiceStartRecording: String = "video:StartRecording"
  /** Stops a video recording or live streaming session. */
  public static let videoServiceStopRecording: String = "video:StopRecording"
  /** Gets the video storage quota for a place. */
  public static let videoServiceGetQuota: String = "video:GetQuota"
  /** Gets the video favorite video quota for a place. */
  public static let videoServiceGetFavoriteQuota: String = "video:GetFavoriteQuota"
  /** Delete all recordings for the given place. */
  public static let videoServiceDeleteAll: String = "video:DeleteAll"
  
}

// MARK: Requests

/** Lists all recordings available for a given place. */
public class VideoServiceListRecordingsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: VideoServiceListRecordingsRequest Enumerations
  /** Type of recording. Required to be one of the following ANY, STREAM, or RECORDING */
  public enum VideoServiceType: String {
   case any = "ANY"
   case stream = "STREAM"
   case recording = "RECORDING"
   
  }
  override init() {
    super.init()
    self.command = Commands.videoServiceListRecordings
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return VideoServiceListRecordingsResponse(message)
  }
  // MARK: ListRecordingsRequest Attributes
  struct Attributes {
    /** UUID of the place. */
    static let placeId: String = "placeId"
/** List all recordings, including ones marked for deletion but not yet deleted */
    static let all: String = "all"
/** Type of recording. Required to be one of the following ANY, STREAM, or RECORDING */
    static let type: String = "type"
 }
  
  /** UUID of the place. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** List all recordings, including ones marked for deletion but not yet deleted */
  public func setAll(_ all: Bool) {
    attributes[Attributes.all] = all as AnyObject
  }

  
  /** Type of recording. Required to be one of the following ANY, STREAM, or RECORDING */
  public func setType(_ type: String) {
    if let value = VideoServiceType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
}

public class VideoServiceListRecordingsResponse: SessionEvent {
  
  
  /** The recordings */
  public func getRecordings() -> [Any]? {
    return self.attributes["recordings"] as? [Any]
  }
}

/** Lists paged recordings available for a given place. */
public class VideoServicePageRecordingsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: VideoServicePageRecordingsRequest Enumerations
  /** Type of recording.              ANY - Will return streams and recordings, this should not generally be used.             STREAM - Will return only streams, useful for attempting to piggy-back on an existing stream.             RECORDING - Will return only recordings, some may still be in progress and therefore missing information like duration. */
  public enum VideoServiceType: String {
   case any = "ANY"
   case stream = "STREAM"
   case recording = "RECORDING"
   
  }
  override init() {
    super.init()
    self.command = Commands.videoServicePageRecordings
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return VideoServicePageRecordingsResponse(message)
  }
  // MARK: PageRecordingsRequest Attributes
  struct Attributes {
    /** UUID of the place. */
    static let placeId: String = "placeId"
/** max number of recordings per page. */
    static let limit: String = "limit"
/** Token value to start the current page.  It should come from the nextToken value from the previous response. */
    static let token: String = "token"
/** Default: false If specified and set to true all recordings, including ones marked for deletion but not yet deleted will be returned */
    static let all: String = "all"
/** Default: true If specified and set to false inprogress recordings / streams will not be shown.  Note that inprogress=false AND type=STREAM will always return an empty result. */
    static let inprogress: String = "inprogress"
/** Type of recording.              ANY - Will return streams and recordings, this should not generally be used.             STREAM - Will return only streams, useful for attempting to piggy-back on an existing stream.             RECORDING - Will return only recordings, some may still be in progress and therefore missing information like duration. */
    static let type: String = "type"
/** No recordings that occur after this value will be returned. Since recordings are returned in descending order by time, recordings at the start of the list will be closer to this time.  Note if both token and latest are specified the earlier of the two values will be used. */
    static let latest: String = "latest"
/** No recordings that occur before this value will be returned. Since recordings are returned in descending order by time, recordings at the end of the list will be closer to this time. */
    static let earliest: String = "earliest"
/** Default: [] If specified, only recordings generated by the cameras in this set will be returned.  If not specified -or- the empty set, then all recordings will be returned regardless of camera. */
    static let cameras: String = "cameras"
/** Default: [] If specified, only recordings with *ANY* of the given tags will be included.  If not specified -or- the empty set, then all recordings will be returned regardless of tags. */
    static let tags: String = "tags"
 }
  
  /** UUID of the place. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** max number of recordings per page. */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** Token value to start the current page.  It should come from the nextToken value from the previous response. */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
  /** Default: false If specified and set to true all recordings, including ones marked for deletion but not yet deleted will be returned */
  public func setAll(_ all: Bool) {
    attributes[Attributes.all] = all as AnyObject
  }

  
  /** Default: true If specified and set to false inprogress recordings / streams will not be shown.  Note that inprogress=false AND type=STREAM will always return an empty result. */
  public func setInprogress(_ inprogress: Bool) {
    attributes[Attributes.inprogress] = inprogress as AnyObject
  }

  
  /** Type of recording.              ANY - Will return streams and recordings, this should not generally be used.             STREAM - Will return only streams, useful for attempting to piggy-back on an existing stream.             RECORDING - Will return only recordings, some may still be in progress and therefore missing information like duration. */
  public func setType(_ type: String) {
    if let value = VideoServiceType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
  /** No recordings that occur after this value will be returned. Since recordings are returned in descending order by time, recordings at the start of the list will be closer to this time.  Note if both token and latest are specified the earlier of the two values will be used. */
  public func setLatest(_ latest: Date) {
    let latest: Double = latest.millisecondsSince1970
    attributes[Attributes.latest] = latest as AnyObject
  }

  
  /** No recordings that occur before this value will be returned. Since recordings are returned in descending order by time, recordings at the end of the list will be closer to this time. */
  public func setEarliest(_ earliest: Date) {
    let earliest: Double = earliest.millisecondsSince1970
    attributes[Attributes.earliest] = earliest as AnyObject
  }

  
  /** Default: [] If specified, only recordings generated by the cameras in this set will be returned.  If not specified -or- the empty set, then all recordings will be returned regardless of camera. */
  public func setCameras(_ cameras: [String]) {
    attributes[Attributes.cameras] = cameras as AnyObject
  }

  
  /** Default: [] If specified, only recordings with *ANY* of the given tags will be included.  If not specified -or- the empty set, then all recordings will be returned regardless of tags. */
  public func setTags(_ tags: [String]) {
    attributes[Attributes.tags] = tags as AnyObject
  }

  
}

public class VideoServicePageRecordingsResponse: SessionEvent {
  
  
  /** the next token to continue paging with */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The recordings */
  public func getRecordings() -> [Any]? {
    return self.attributes["recordings"] as? [Any]
  }
}

/** Starts a video recording or live streaming session. */
public class VideoServiceStartRecordingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: VideoServiceStartRecordingRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.videoServiceStartRecording
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return VideoServiceStartRecordingResponse(message)
  }
  // MARK: StartRecordingRequest Attributes
  struct Attributes {
    /** UUID of the place. */
    static let placeId: String = "placeId"
/** UUID of the account. */
    static let accountId: String = "accountId"
/** UUID of the camera. */
    static let cameraAddress: String = "cameraAddress"
/** True to start live streaming, false to start recording. */
    static let stream: String = "stream"
/** The duration to record in seconds.  If not provided the default duration of 20 minutes will be used */
    static let duration: String = "duration"
 }
  
  /** UUID of the place. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** UUID of the account. */
  public func setAccountId(_ accountId: String) {
    attributes[Attributes.accountId] = accountId as AnyObject
  }

  
  /** UUID of the camera. */
  public func setCameraAddress(_ cameraAddress: String) {
    attributes[Attributes.cameraAddress] = cameraAddress as AnyObject
  }

  
  /** True to start live streaming, false to start recording. */
  public func setStream(_ stream: Bool) {
    attributes[Attributes.stream] = stream as AnyObject
  }

  
  /** The duration to record in seconds.  If not provided the default duration of 20 minutes will be used */
  public func setDuration(_ duration: Int) {
    attributes[Attributes.duration] = duration as AnyObject
  }

  
}

public class VideoServiceStartRecordingResponse: SessionEvent {
  
  
  /** UUID of the recording that was started. */
  public func getRecordingId() -> String? {
    return self.attributes["recordingId"] as? String
  }
  /** A URL that can be used to stream video using the HLS protocol. */
  public func getHls() -> String? {
    return self.attributes["hls"] as? String
  }
  /** This attributed was deprecated in 2018.07.  A URL that can be used to stream video using the MPEG-DASH protocol. */
  public func getDash() -> String? {
    return self.attributes["dash"] as? String
  }
  /** A URL that can be used to retrieve a preview image for the recording. */
  public func getPreview() -> String? {
    return self.attributes["preview"] as? String
  }
  /** A UTC timestamp indicating when the URLs returned are no longer valid. */
  public func getExpiration() -> Date? {
    return self.attributes["expiration"] as? Date
  }
}

/** Stops a video recording or live streaming session. */
public class VideoServiceStopRecordingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: VideoServiceStopRecordingRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.videoServiceStopRecording
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return VideoServiceStopRecordingResponse(message)
  }
  // MARK: StopRecordingRequest Attributes
  struct Attributes {
    /** UUID of the place. */
    static let placeId: String = "placeId"
/** UUID of the recording. */
    static let recordingId: String = "recordingId"
 }
  
  /** UUID of the place. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** UUID of the recording. */
  public func setRecordingId(_ recordingId: String) {
    attributes[Attributes.recordingId] = recordingId as AnyObject
  }

  
}

public class VideoServiceStopRecordingResponse: SessionEvent {
  
}

/** Gets the video storage quota for a place. */
public class VideoServiceGetQuotaRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: VideoServiceGetQuotaRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.videoServiceGetQuota
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return VideoServiceGetQuotaResponse(message)
  }
  // MARK: GetQuotaRequest Attributes
  struct Attributes {
    /** UUID of the place. */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class VideoServiceGetQuotaResponse: SessionEvent {
  
  
  /** The total allowed usage in bytes. */
  public func getTotal() -> Double? {
    return self.attributes["total"] as? Double
  }
  /** The current usage in bytes. */
  public func getUsed() -> Double? {
    return self.attributes["used"] as? Double
  }
}

/** Gets the video favorite video quota for a place. */
public class VideoServiceGetFavoriteQuotaRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: VideoServiceGetFavoriteQuotaRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.videoServiceGetFavoriteQuota
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return VideoServiceGetFavoriteQuotaResponse(message)
  }
  // MARK: GetFavoriteQuotaRequest Attributes
  struct Attributes {
    /** UUID of the place. */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class VideoServiceGetFavoriteQuotaResponse: SessionEvent {
  
  
  /** The total allowed favorite videos. */
  public func getTotal() -> Int? {
    return self.attributes["total"] as? Int
  }
  /** The current number of favorite videos. */
  public func getUsed() -> Int? {
    return self.attributes["used"] as? Int
  }
}

/** Delete all recordings for the given place. */
public class VideoServiceDeleteAllRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: VideoServiceDeleteAllRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.videoServiceDeleteAll
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return VideoServiceDeleteAllResponse(message)
  }
  // MARK: DeleteAllRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
/** True if favorite recordings should be deleted also. */
    static let includeFavorites: String = "includeFavorites"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** True if favorite recordings should be deleted also. */
  public func setIncludeFavorites(_ includeFavorites: Bool) {
    attributes[Attributes.includeFavorites] = includeFavorites as AnyObject
  }

  
}

public class VideoServiceDeleteAllResponse: SessionEvent {
  
}

