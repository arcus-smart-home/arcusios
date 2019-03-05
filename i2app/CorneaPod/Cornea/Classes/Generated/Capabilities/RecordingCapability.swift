
//
// RecordingCap.swift
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
  public static var recordingNamespace: String = "video"
  public static var recordingName: String = "Recording"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let recordingName: String = "video:name"
  static let recordingAccountid: String = "video:accountid"
  static let recordingPlaceid: String = "video:placeid"
  static let recordingCameraid: String = "video:cameraid"
  static let recordingPersonid: String = "video:personid"
  static let recordingTimestamp: String = "video:timestamp"
  static let recordingWidth: String = "video:width"
  static let recordingHeight: String = "video:height"
  static let recordingBandwidth: String = "video:bandwidth"
  static let recordingFramerate: String = "video:framerate"
  static let recordingPrecapture: String = "video:precapture"
  static let recordingType: String = "video:type"
  static let recordingDuration: String = "video:duration"
  static let recordingSize: String = "video:size"
  static let recordingDeleted: String = "video:deleted"
  static let recordingDeleteTime: String = "video:deleteTime"
  static let recordingCompleted: String = "video:completed"
  static let recordingVideoCodec: String = "video:videoCodec"
  static let recordingAudioCodec: String = "video:audioCodec"
  
}

public protocol ArcusRecordingCapability: class, RxArcusService {
  /** Human readable name for the device */
  func getRecordingName(_ model: RecordingModel) -> String?
  /** Human readable name for the device */
  func setRecordingName(_ name: String, model: RecordingModel)
/** The place that the recording is associated with. */
  func getRecordingAccountid(_ model: RecordingModel) -> String?
  /** The place that the recording is associated with. */
  func getRecordingPlaceid(_ model: RecordingModel) -> String?
  /** The camera that the recording is associated with. */
  func getRecordingCameraid(_ model: RecordingModel) -> String?
  /** The person that the recording is associated with. */
  func getRecordingPersonid(_ model: RecordingModel) -> String?
  /** A timestamp identifying when the recording was made. */
  func getRecordingTimestamp(_ model: RecordingModel) -> Date?
  /** The width of the recording in pixels. */
  func getRecordingWidth(_ model: RecordingModel) -> Int?
  /** The height of the recording in pixels. */
  func getRecordingHeight(_ model: RecordingModel) -> Int?
  /** The target bandwidth of the video in bps. */
  func getRecordingBandwidth(_ model: RecordingModel) -> Int?
  /** The frame rate of the video in fps. */
  func getRecordingFramerate(_ model: RecordingModel) -> Double?
  /** The precapture time in seconds, or 0 if no precaptured video is present. */
  func getRecordingPrecapture(_ model: RecordingModel) -> Double?
  /** The recording type. STREAM indicates a live streaming session. */
  func getRecordingType(_ model: RecordingModel) -> RecordingType?
  /** The duration of the recording in seconds */
  func getRecordingDuration(_ model: RecordingModel) -> Double?
  /** The side of the recording in bytes. */
  func getRecordingSize(_ model: RecordingModel) -> Int?
  /** If true then the recording has been scheduled for deletion. */
  func getRecordingDeleted(_ model: RecordingModel) -> Bool?
  /** If the recording has been scheduled for deletion then this represents the time at which the recording will be permanently removed. */
  func getRecordingDeleteTime(_ model: RecordingModel) -> Date?
  /** If the recording has been completed. */
  func getRecordingCompleted(_ model: RecordingModel) -> Bool?
  /** The recordings video codec */
  func getRecordingVideoCodec(_ model: RecordingModel) -> String?
  /** The recordings audio codec */
  func getRecordingAudioCodec(_ model: RecordingModel) -> String?
  
  /** Used to retrieve URLs that can be used for viewing this recording. */
  func requestRecordingView(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent>/** Used to retrieve URLs that can be used for viewing this recording. */
  func requestRecordingDownload(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent>/** Marks this recording for deletion. */
  func requestRecordingDelete(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent>/** Resurrects this recording if possible. */
  func requestRecordingResurrect(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusRecordingCapability {
  public func getRecordingName(_ model: RecordingModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingName] as? String
  }
  
  public func setRecordingName(_ name: String, model: RecordingModel) {
    model.set([Attributes.recordingName: name as AnyObject])
  }
  public func getRecordingAccountid(_ model: RecordingModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingAccountid] as? String
  }
  
  public func getRecordingPlaceid(_ model: RecordingModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingPlaceid] as? String
  }
  
  public func getRecordingCameraid(_ model: RecordingModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingCameraid] as? String
  }
  
  public func getRecordingPersonid(_ model: RecordingModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingPersonid] as? String
  }
  
  public func getRecordingTimestamp(_ model: RecordingModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.recordingTimestamp] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getRecordingWidth(_ model: RecordingModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingWidth] as? Int
  }
  
  public func getRecordingHeight(_ model: RecordingModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingHeight] as? Int
  }
  
  public func getRecordingBandwidth(_ model: RecordingModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingBandwidth] as? Int
  }
  
  public func getRecordingFramerate(_ model: RecordingModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingFramerate] as? Double
  }
  
  public func getRecordingPrecapture(_ model: RecordingModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingPrecapture] as? Double
  }
  
  public func getRecordingType(_ model: RecordingModel) -> RecordingType? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.recordingType] as? String,
      let enumAttr: RecordingType = RecordingType(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getRecordingDuration(_ model: RecordingModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingDuration] as? Double
  }
  
  public func getRecordingSize(_ model: RecordingModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingSize] as? Int
  }
  
  public func getRecordingDeleted(_ model: RecordingModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingDeleted] as? Bool
  }
  
  public func getRecordingDeleteTime(_ model: RecordingModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.recordingDeleteTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getRecordingCompleted(_ model: RecordingModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingCompleted] as? Bool
  }
  
  public func getRecordingVideoCodec(_ model: RecordingModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingVideoCodec] as? String
  }
  
  public func getRecordingAudioCodec(_ model: RecordingModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.recordingAudioCodec] as? String
  }
  
  
  public func requestRecordingView(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent> {
    let request: RecordingViewRequest = RecordingViewRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestRecordingDownload(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent> {
    let request: RecordingDownloadRequest = RecordingDownloadRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestRecordingDelete(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent> {
    let request: RecordingDeleteRequest = RecordingDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestRecordingResurrect(_ model: RecordingModel) throws -> Observable<ArcusSessionEvent> {
    let request: RecordingResurrectRequest = RecordingResurrectRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
