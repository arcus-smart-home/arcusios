
//
// RecordingCapEvents.swift
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
  /** Used to retrieve URLs that can be used for viewing this recording. */
  static let recordingView: String = "video:View"
  /** Used to retrieve URLs that can be used for viewing this recording. */
  static let recordingDownload: String = "video:Download"
  /** Marks this recording for deletion. */
  static let recordingDelete: String = "video:Delete"
  /** Resurrects this recording if possible. */
  static let recordingResurrect: String = "video:Resurrect"
  
}

// MARK: Enumerations

/** The recording type. STREAM indicates a live streaming session. */
public enum RecordingType: String {
  case stream = "STREAM"
  case recording = "RECORDING"
}

// MARK: Requests

/** Used to retrieve URLs that can be used for viewing this recording. */
public class RecordingViewRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.recordingView
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
    return RecordingViewResponse(message)
  }

  
}

public class RecordingViewResponse: SessionEvent {
  
  
  /** A URL that can be used to stream video using the HLS protocol. */
  public func getHls() -> String? {
    return self.attributes["hls"] as? String
  }
  /** This parameter was deprecated in 2018.07.  A URL that can be used to stream video using the MPEG-DASH protocol. */
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

/** Used to retrieve URLs that can be used for viewing this recording. */
public class RecordingDownloadRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.recordingDownload
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
    return RecordingDownloadResponse(message)
  }

  
}

public class RecordingDownloadResponse: SessionEvent {
  
  
  /** A URL that can be used to download an MP4 formatted version of the recording.. */
  public func getMp4() -> String? {
    return self.attributes["mp4"] as? String
  }
  /** A URL that can be used to download a JPG preview image of the recording. */
  public func getPreview() -> String? {
    return self.attributes["preview"] as? String
  }
  /** A UTC timestamp indicating when the URLs returned are no longer valid. */
  public func getExpiration() -> Date? {
    return self.attributes["expiration"] as? Date
  }
  /** An estimate of the size of the mp4 file. */
  public func getMp4SizeEstimate() -> Int? {
    return self.attributes["mp4SizeEstimate"] as? Int
  }
}

/** Marks this recording for deletion. */
public class RecordingDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.recordingDelete
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
    return RecordingDeleteResponse(message)
  }

  
}

public class RecordingDeleteResponse: SessionEvent {
  
}

/** Resurrects this recording if possible. */
public class RecordingResurrectRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.recordingResurrect
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
    return RecordingResurrectResponse(message)
  }

  
}

public class RecordingResurrectResponse: SessionEvent {
  
}

