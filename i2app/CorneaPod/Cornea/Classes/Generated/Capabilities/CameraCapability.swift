
//
// CameraCap.swift
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
  public static var cameraNamespace: String = "camera"
  public static var cameraName: String = "Camera"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let cameraPrivacy: String = "camera:privacy"
  static let cameraResolutionssupported: String = "camera:resolutionssupported"
  static let cameraResolution: String = "camera:resolution"
  static let cameraBitratetype: String = "camera:bitratetype"
  static let cameraBitratessupported: String = "camera:bitratessupported"
  static let cameraBitrate: String = "camera:bitrate"
  static let cameraQualitiessupported: String = "camera:qualitiessupported"
  static let cameraQuality: String = "camera:quality"
  static let cameraMinframerate: String = "camera:minframerate"
  static let cameraMaxframerate: String = "camera:maxframerate"
  static let cameraFramerate: String = "camera:framerate"
  static let cameraFlip: String = "camera:flip"
  static let cameraMirror: String = "camera:mirror"
  static let cameraIrLedSupportedModes: String = "camera:irLedSupportedModes"
  static let cameraIrLedMode: String = "camera:irLedMode"
  static let cameraIrLedLuminance: String = "camera:irLedLuminance"
  
}

public protocol ArcusCameraCapability: class, RxArcusService {
  /** When true, camera&#x27;s privacy function is enabled */
  func getCameraPrivacy(_ model: DeviceModel) -> Bool?
  /** List of resolutions supported by the camera e.g. 160x120, 320x240, 640x480, 1280x960  */
  func getCameraResolutionssupported(_ model: DeviceModel) -> [String]?
  /** Current resolution of the camera. Must appear in resolutionssupported list. */
  func getCameraResolution(_ model: DeviceModel) -> String?
  /** Current resolution of the camera. Must appear in resolutionssupported list. */
  func setCameraResolution(_ resolution: String, model: DeviceModel)
/** Constant bit rate or variable bit rate */
  func getCameraBitratetype(_ model: DeviceModel) -> CameraBitratetype?
  /** Constant bit rate or variable bit rate */
  func setCameraBitratetype(_ bitratetype: CameraBitratetype, model: DeviceModel)
/** List of bitrates supported by the camera e.g. 32K, 64K, 96K, 128K, 256K, 384K, 512K, 768K, 1024K, 1280K, 2048K */
  func getCameraBitratessupported(_ model: DeviceModel) -> [String]?
  /** Only valid when bitrate type is cbr. Must appear in bitratessupported list. */
  func getCameraBitrate(_ model: DeviceModel) -> String?
  /** Only valid when bitrate type is cbr. Must appear in bitratessupported list. */
  func setCameraBitrate(_ bitrate: String, model: DeviceModel)
/** List of quality levels supported by the camera e.g Very Low, Low, Normal, High, Very High */
  func getCameraQualitiessupported(_ model: DeviceModel) -> [String]?
  /** Current quality of the camera. Must appear in qualitiessupported list. */
  func getCameraQuality(_ model: DeviceModel) -> String?
  /** Current quality of the camera. Must appear in qualitiessupported list. */
  func setCameraQuality(_ quality: String, model: DeviceModel)
/** Minimum framerate supported. */
  func getCameraMinframerate(_ model: DeviceModel) -> Int?
  /** Maximum framerate supported. */
  func getCameraMaxframerate(_ model: DeviceModel) -> Int?
  /** Current framerate of the camera. Must be minframerate &lt;= framerate &lt;= maxframerate */
  func getCameraFramerate(_ model: DeviceModel) -> Int?
  /** Current framerate of the camera. Must be minframerate &lt;= framerate &lt;= maxframerate */
  func setCameraFramerate(_ framerate: Int, model: DeviceModel)
/** When true, camera&#x27;s image is flipped vertically */
  func getCameraFlip(_ model: DeviceModel) -> Bool?
  /** When true, camera&#x27;s image is flipped vertically */
  func setCameraFlip(_ flip: Bool, model: DeviceModel)
/** When true, camera&#x27;s image is mirrored horizontally */
  func getCameraMirror(_ model: DeviceModel) -> Bool?
  /** When true, camera&#x27;s image is mirrored horizontally */
  func setCameraMirror(_ mirror: Bool, model: DeviceModel)
/** What camera IR LED modes are supported? */
  func getCameraIrLedSupportedModes(_ model: DeviceModel) -> [String]?
  /** Reflects the mode of IR LED on the camera. */
  func getCameraIrLedMode(_ model: DeviceModel) -> CameraIrLedMode?
  /** Reflects the mode of IR LED on the camera. */
  func setCameraIrLedMode(_ irLedMode: CameraIrLedMode, model: DeviceModel)
/** Reflects the current IR LED luminance, on a scale of 1 to 5. */
  func getCameraIrLedLuminance(_ model: DeviceModel) -> Int?
  /** Reflects the current IR LED luminance, on a scale of 1 to 5. */
  func setCameraIrLedLuminance(_ irLedLuminance: Int, model: DeviceModel)

  /** Informs the camera to start streaming to some destination */
  func requestCameraStartStreaming(_  model: DeviceModel, url: String, username: String, password: String, maxDuration: Int, stream: Bool)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusCameraCapability {
  public func getCameraPrivacy(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPrivacy] as? Bool
  }
  
  public func getCameraResolutionssupported(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraResolutionssupported] as? [String]
  }
  
  public func getCameraResolution(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraResolution] as? String
  }
  
  public func setCameraResolution(_ resolution: String, model: DeviceModel) {
    model.set([Attributes.cameraResolution: resolution as AnyObject])
  }
  public func getCameraBitratetype(_ model: DeviceModel) -> CameraBitratetype? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.cameraBitratetype] as? String,
      let enumAttr: CameraBitratetype = CameraBitratetype(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setCameraBitratetype(_ bitratetype: CameraBitratetype, model: DeviceModel) {
    model.set([Attributes.cameraBitratetype: bitratetype.rawValue as AnyObject])
  }
  public func getCameraBitratessupported(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraBitratessupported] as? [String]
  }
  
  public func getCameraBitrate(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraBitrate] as? String
  }
  
  public func setCameraBitrate(_ bitrate: String, model: DeviceModel) {
    model.set([Attributes.cameraBitrate: bitrate as AnyObject])
  }
  public func getCameraQualitiessupported(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraQualitiessupported] as? [String]
  }
  
  public func getCameraQuality(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraQuality] as? String
  }
  
  public func setCameraQuality(_ quality: String, model: DeviceModel) {
    model.set([Attributes.cameraQuality: quality as AnyObject])
  }
  public func getCameraMinframerate(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraMinframerate] as? Int
  }
  
  public func getCameraMaxframerate(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraMaxframerate] as? Int
  }
  
  public func getCameraFramerate(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraFramerate] as? Int
  }
  
  public func setCameraFramerate(_ framerate: Int, model: DeviceModel) {
    model.set([Attributes.cameraFramerate: framerate as AnyObject])
  }
  public func getCameraFlip(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraFlip] as? Bool
  }
  
  public func setCameraFlip(_ flip: Bool, model: DeviceModel) {
    model.set([Attributes.cameraFlip: flip as AnyObject])
  }
  public func getCameraMirror(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraMirror] as? Bool
  }
  
  public func setCameraMirror(_ mirror: Bool, model: DeviceModel) {
    model.set([Attributes.cameraMirror: mirror as AnyObject])
  }
  public func getCameraIrLedSupportedModes(_ model: DeviceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraIrLedSupportedModes] as? [String]
  }
  
  public func getCameraIrLedMode(_ model: DeviceModel) -> CameraIrLedMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.cameraIrLedMode] as? String,
      let enumAttr: CameraIrLedMode = CameraIrLedMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setCameraIrLedMode(_ irLedMode: CameraIrLedMode, model: DeviceModel) {
    model.set([Attributes.cameraIrLedMode: irLedMode.rawValue as AnyObject])
  }
  public func getCameraIrLedLuminance(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraIrLedLuminance] as? Int
  }
  
  public func setCameraIrLedLuminance(_ irLedLuminance: Int, model: DeviceModel) {
    model.set([Attributes.cameraIrLedLuminance: irLedLuminance as AnyObject])
  }
  
  public func requestCameraStartStreaming(_  model: DeviceModel, url: String, username: String, password: String, maxDuration: Int, stream: Bool)
   throws -> Observable<ArcusSessionEvent> {
    let request: CameraStartStreamingRequest = CameraStartStreamingRequest()
    request.source = model.address
    
    
    
    request.setUrl(url)
    
    request.setUsername(username)
    
    request.setPassword(password)
    
    request.setMaxDuration(maxDuration)
    
    request.setStream(stream)
    
    return try sendRequest(request)
  }
  
}
