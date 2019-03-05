
//
// CameraStatusCapabilityLegacy.swift
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
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class CameraStatusCapabilityLegacy: NSObject, ArcusCameraStatusCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: CameraStatusCapabilityLegacy  = CameraStatusCapabilityLegacy()
  
  static let CameraStatusStateOFFLINE: String = CameraStatusState.offline.rawValue
  static let CameraStatusStateIDLE: String = CameraStatusState.idle.rawValue
  static let CameraStatusStateRECORDING: String = CameraStatusState.recording.rawValue
  static let CameraStatusStateSTREAMING: String = CameraStatusState.streaming.rawValue
  

  
  public static func getCamera(_ model: CameraStatusModel) -> String? {
    return capability.getCameraStatusCamera(model)
  }
  
  public static func getState(_ model: CameraStatusModel) -> String? {
    return capability.getCameraStatusState(model)?.rawValue
  }
  
  public static func getLastRecording(_ model: CameraStatusModel) -> String? {
    return capability.getCameraStatusLastRecording(model)
  }
  
  public static func getLastRecordingTime(_ model: CameraStatusModel) -> Date? {
    guard let lastRecordingTime: Date = capability.getCameraStatusLastRecordingTime(model) else {
      return nil
    }
    return lastRecordingTime
  }
  
  public static func getActiveRecording(_ model: CameraStatusModel) -> String? {
    return capability.getCameraStatusActiveRecording(model)
  }
  
}
