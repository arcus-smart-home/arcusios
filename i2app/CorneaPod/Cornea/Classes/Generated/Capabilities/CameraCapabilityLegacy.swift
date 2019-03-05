
//
// CameraCapabilityLegacy.swift
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

public class CameraCapabilityLegacy: NSObject, ArcusCameraCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: CameraCapabilityLegacy  = CameraCapabilityLegacy()
  
  static let CameraBitratetypeCBR: String = CameraBitratetype.cbr.rawValue
  static let CameraBitratetypeVBR: String = CameraBitratetype.vbr.rawValue
  
  static let CameraIrLedModeON: String = CameraIrLedMode.on.rawValue
  static let CameraIrLedModeOFF: String = CameraIrLedMode.off.rawValue
  static let CameraIrLedModeAUTO: String = CameraIrLedMode.auto.rawValue
  

  
  public static func getPrivacy(_ model: DeviceModel) -> NSNumber? {
    guard let privacy: Bool = capability.getCameraPrivacy(model) else {
      return nil
    }
    return NSNumber(value: privacy)
  }
  
  public static func getResolutionssupported(_ model: DeviceModel) -> [String]? {
    return capability.getCameraResolutionssupported(model)
  }
  
  public static func getResolution(_ model: DeviceModel) -> String? {
    return capability.getCameraResolution(model)
  }
  
  public static func setResolution(_ resolution: String, model: DeviceModel) {
    
    
    capability.setCameraResolution(resolution, model: model)
  }
  
  public static func getBitratetype(_ model: DeviceModel) -> String? {
    return capability.getCameraBitratetype(model)?.rawValue
  }
  
  public static func setBitratetype(_ bitratetype: String, model: DeviceModel) {
    guard let bitratetype: CameraBitratetype = CameraBitratetype(rawValue: bitratetype) else { return }
    
    capability.setCameraBitratetype(bitratetype, model: model)
  }
  
  public static func getBitratessupported(_ model: DeviceModel) -> [String]? {
    return capability.getCameraBitratessupported(model)
  }
  
  public static func getBitrate(_ model: DeviceModel) -> String? {
    return capability.getCameraBitrate(model)
  }
  
  public static func setBitrate(_ bitrate: String, model: DeviceModel) {
    
    
    capability.setCameraBitrate(bitrate, model: model)
  }
  
  public static func getQualitiessupported(_ model: DeviceModel) -> [String]? {
    return capability.getCameraQualitiessupported(model)
  }
  
  public static func getQuality(_ model: DeviceModel) -> String? {
    return capability.getCameraQuality(model)
  }
  
  public static func setQuality(_ quality: String, model: DeviceModel) {
    
    
    capability.setCameraQuality(quality, model: model)
  }
  
  public static func getMinframerate(_ model: DeviceModel) -> NSNumber? {
    guard let minframerate: Int = capability.getCameraMinframerate(model) else {
      return nil
    }
    return NSNumber(value: minframerate)
  }
  
  public static func getMaxframerate(_ model: DeviceModel) -> NSNumber? {
    guard let maxframerate: Int = capability.getCameraMaxframerate(model) else {
      return nil
    }
    return NSNumber(value: maxframerate)
  }
  
  public static func getFramerate(_ model: DeviceModel) -> NSNumber? {
    guard let framerate: Int = capability.getCameraFramerate(model) else {
      return nil
    }
    return NSNumber(value: framerate)
  }
  
  public static func setFramerate(_ framerate: Int, model: DeviceModel) {
    
    
    capability.setCameraFramerate(framerate, model: model)
  }
  
  public static func getFlip(_ model: DeviceModel) -> NSNumber? {
    guard let flip: Bool = capability.getCameraFlip(model) else {
      return nil
    }
    return NSNumber(value: flip)
  }
  
  public static func setFlip(_ flip: Bool, model: DeviceModel) {
    
    
    capability.setCameraFlip(flip, model: model)
  }
  
  public static func getMirror(_ model: DeviceModel) -> NSNumber? {
    guard let mirror: Bool = capability.getCameraMirror(model) else {
      return nil
    }
    return NSNumber(value: mirror)
  }
  
  public static func setMirror(_ mirror: Bool, model: DeviceModel) {
    
    
    capability.setCameraMirror(mirror, model: model)
  }
  
  public static func getIrLedSupportedModes(_ model: DeviceModel) -> [String]? {
    return capability.getCameraIrLedSupportedModes(model)
  }
  
  public static func getIrLedMode(_ model: DeviceModel) -> String? {
    return capability.getCameraIrLedMode(model)?.rawValue
  }
  
  public static func setIrLedMode(_ irLedMode: String, model: DeviceModel) {
    guard let irLedMode: CameraIrLedMode = CameraIrLedMode(rawValue: irLedMode) else { return }
    
    capability.setCameraIrLedMode(irLedMode, model: model)
  }
  
  public static func getIrLedLuminance(_ model: DeviceModel) -> NSNumber? {
    guard let irLedLuminance: Int = capability.getCameraIrLedLuminance(model) else {
      return nil
    }
    return NSNumber(value: irLedLuminance)
  }
  
  public static func setIrLedLuminance(_ irLedLuminance: Int, model: DeviceModel) {
    
    
    capability.setCameraIrLedLuminance(irLedLuminance, model: model)
  }
  
  public static func startStreaming(_  model: DeviceModel, url: String, username: String, password: String, maxDuration: Int, stream: Bool) -> PMKPromise {
  
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCameraStartStreaming(model, url: url, username: username, password: password, maxDuration: maxDuration, stream: stream))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
