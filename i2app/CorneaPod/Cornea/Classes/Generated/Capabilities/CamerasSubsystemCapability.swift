
//
// CamerasSubsystemCap.swift
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
  public static var camerasSubsystemNamespace: String = "subcameras"
  public static var camerasSubsystemName: String = "CamerasSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let camerasSubsystemCameras: String = "subcameras:cameras"
  static let camerasSubsystemOfflineCameras: String = "subcameras:offlineCameras"
  static let camerasSubsystemWarnings: String = "subcameras:warnings"
  static let camerasSubsystemRecordingEnabled: String = "subcameras:recordingEnabled"
  static let camerasSubsystemMaxSimultaneousStreams: String = "subcameras:maxSimultaneousStreams"
  
}

public protocol ArcusCamerasSubsystemCapability: class, RxArcusService {
  /** The addresses of cameras defined at this place */
  func getCamerasSubsystemCameras(_ model: SubsystemModel) -> [String]?
  /** The addresses of offline cameras defined at this place */
  func getCamerasSubsystemOfflineCameras(_ model: SubsystemModel) -> [String]?
  /** A set of warnings about devices.  The key is the address of the device with a warning and the value is an I18N code with the description of the problem. */
  func getCamerasSubsystemWarnings(_ model: SubsystemModel) -> [String: String]?
  /** Whether or not recording is enabled based on the service level */
  func getCamerasSubsystemRecordingEnabled(_ model: SubsystemModel) -> Bool?
  /** An estimate of how many simultaneous streams can be supported.  NOTE: While this is currently r/w for testing purposes, it will likely be made read-only in the future and should not be directly exposed as a writable attribute to the end-user. */
  func getCamerasSubsystemMaxSimultaneousStreams(_ model: SubsystemModel) -> Int?
  /** An estimate of how many simultaneous streams can be supported.  NOTE: While this is currently r/w for testing purposes, it will likely be made read-only in the future and should not be directly exposed as a writable attribute to the end-user. */
  func setCamerasSubsystemMaxSimultaneousStreams(_ maxSimultaneousStreams: Int, model: SubsystemModel)

  
}

extension ArcusCamerasSubsystemCapability {
  public func getCamerasSubsystemCameras(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.camerasSubsystemCameras] as? [String]
  }
  
  public func getCamerasSubsystemOfflineCameras(_ model: SubsystemModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.camerasSubsystemOfflineCameras] as? [String]
  }
  
  public func getCamerasSubsystemWarnings(_ model: SubsystemModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.camerasSubsystemWarnings] as? [String: String]
  }
  
  public func getCamerasSubsystemRecordingEnabled(_ model: SubsystemModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.camerasSubsystemRecordingEnabled] as? Bool
  }
  
  public func getCamerasSubsystemMaxSimultaneousStreams(_ model: SubsystemModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.camerasSubsystemMaxSimultaneousStreams] as? Int
  }
  
  public func setCamerasSubsystemMaxSimultaneousStreams(_ maxSimultaneousStreams: Int, model: SubsystemModel) {
    model.set([Attributes.camerasSubsystemMaxSimultaneousStreams: maxSimultaneousStreams as AnyObject])
  }
  
}
