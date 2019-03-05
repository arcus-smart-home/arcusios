
//
// CameraStatusCap.swift
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
  public static var cameraStatusNamespace: String = "camerastatus"
  public static var cameraStatusName: String = "CameraStatus"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let cameraStatusCamera: String = "camerastatus:camera"
  static let cameraStatusState: String = "camerastatus:state"
  static let cameraStatusLastRecording: String = "camerastatus:lastRecording"
  static let cameraStatusLastRecordingTime: String = "camerastatus:lastRecordingTime"
  static let cameraStatusActiveRecording: String = "camerastatus:activeRecording"
  
}

public protocol ArcusCameraStatusCapability: class, RxArcusService {
  /** The address of the associated camera. */
  func getCameraStatusCamera(_ model: CameraStatusModel) -> String?
  /** An *estimate* of the current state of the camera.  This should be used for displaying metadata not as a guarantee that prevents new recordings / streams from being attempted. */
  func getCameraStatusState(_ model: CameraStatusModel) -> CameraStatusState?
  /**  Address of the last recording completed by the camera. This will be the empty string in the following cases:  - Camera has never completed a recording  - The most recent recording has been deleted by the user            */
  func getCameraStatusLastRecording(_ model: CameraStatusModel) -> String?
  /**  Start time of the last recording that has completed for this camera. Note it will not be updated until the current recording completes.  Also it may contain a time for a non-existent recording if the user has deleted the most recent recording.           */
  func getCameraStatusLastRecordingTime(_ model: CameraStatusModel) -> Date?
  /** The address of the video that the camera is currently streaming / recording. */
  func getCameraStatusActiveRecording(_ model: CameraStatusModel) -> String?
  
  
}

extension ArcusCameraStatusCapability {
  public func getCameraStatusCamera(_ model: CameraStatusModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraStatusCamera] as? String
  }
  
  public func getCameraStatusState(_ model: CameraStatusModel) -> CameraStatusState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.cameraStatusState] as? String,
      let enumAttr: CameraStatusState = CameraStatusState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getCameraStatusLastRecording(_ model: CameraStatusModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraStatusLastRecording] as? String
  }
  
  public func getCameraStatusLastRecordingTime(_ model: CameraStatusModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.cameraStatusLastRecordingTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getCameraStatusActiveRecording(_ model: CameraStatusModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraStatusActiveRecording] as? String
  }
  
  
}
