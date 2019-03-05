
//
// CamerasSubsystemCapabilityLegacy.swift
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

public class CamerasSubsystemCapabilityLegacy: NSObject, ArcusCamerasSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: CamerasSubsystemCapabilityLegacy  = CamerasSubsystemCapabilityLegacy()
  

  
  public static func getCameras(_ model: SubsystemModel) -> [String]? {
    return capability.getCamerasSubsystemCameras(model)
  }
  
  public static func getOfflineCameras(_ model: SubsystemModel) -> [String]? {
    return capability.getCamerasSubsystemOfflineCameras(model)
  }
  
  public static func getWarnings(_ model: SubsystemModel) -> [String: String]? {
    return capability.getCamerasSubsystemWarnings(model)
  }
  
  public static func getRecordingEnabled(_ model: SubsystemModel) -> NSNumber? {
    guard let recordingEnabled: Bool = capability.getCamerasSubsystemRecordingEnabled(model) else {
      return nil
    }
    return NSNumber(value: recordingEnabled)
  }
  
  public static func getMaxSimultaneousStreams(_ model: SubsystemModel) -> NSNumber? {
    guard let maxSimultaneousStreams: Int = capability.getCamerasSubsystemMaxSimultaneousStreams(model) else {
      return nil
    }
    return NSNumber(value: maxSimultaneousStreams)
  }
  
  public static func setMaxSimultaneousStreams(_ maxSimultaneousStreams: Int, model: SubsystemModel) {
    
    
    capability.setCamerasSubsystemMaxSimultaneousStreams(maxSimultaneousStreams, model: model)
  }
  
}
