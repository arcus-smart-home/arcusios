
//
// CameraPTZCap.swift
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
  public static var cameraPTZNamespace: String = "cameraptz"
  public static var cameraPTZName: String = "CameraPTZ"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let cameraPTZCurrentPan: String = "cameraptz:currentPan"
  static let cameraPTZCurrentTilt: String = "cameraptz:currentTilt"
  static let cameraPTZCurrentZoom: String = "cameraptz:currentZoom"
  static let cameraPTZMaximumPan: String = "cameraptz:maximumPan"
  static let cameraPTZMinimumPan: String = "cameraptz:minimumPan"
  static let cameraPTZMaximumTilt: String = "cameraptz:maximumTilt"
  static let cameraPTZMinimumTilt: String = "cameraptz:minimumTilt"
  static let cameraPTZMaximumZoom: String = "cameraptz:maximumZoom"
  static let cameraPTZMinimumZoom: String = "cameraptz:minimumZoom"
  
}

public protocol ArcusCameraPTZCapability: class, RxArcusService {
  /** Curent camera pan position, in degrees */
  func getCameraPTZCurrentPan(_ model: DeviceModel) -> Int?
  /** Curent camera tilt position, in degrees */
  func getCameraPTZCurrentTilt(_ model: DeviceModel) -> Int?
  /** Curent camera zoom value */
  func getCameraPTZCurrentZoom(_ model: DeviceModel) -> Int?
  /** Maximum camera pan position, in degrees */
  func getCameraPTZMaximumPan(_ model: DeviceModel) -> Int?
  /** Minimum camera pan position, in degrees */
  func getCameraPTZMinimumPan(_ model: DeviceModel) -> Int?
  /** Maximum camera tilt position, in degrees */
  func getCameraPTZMaximumTilt(_ model: DeviceModel) -> Int?
  /** Minimum camera tilt position, in degrees */
  func getCameraPTZMinimumTilt(_ model: DeviceModel) -> Int?
  /** Maximum camera zoom value */
  func getCameraPTZMaximumZoom(_ model: DeviceModel) -> Int?
  /** Minimum camera zoom value */
  func getCameraPTZMinimumZoom(_ model: DeviceModel) -> Int?
  
  /** Moves the camera to its home position */
  func requestCameraPTZGotoHome(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Moves the camera to an absolute position */
  func requestCameraPTZGotoAbsolute(_  model: DeviceModel, pan: Int, tilt: Int, zoom: Int)
   throws -> Observable<ArcusSessionEvent>/** Moves the camera to a relative position */
  func requestCameraPTZGotoRelative(_  model: DeviceModel, deltaPan: Int, deltaTilt: Int, deltaZoom: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusCameraPTZCapability {
  public func getCameraPTZCurrentPan(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZCurrentPan] as? Int
  }
  
  public func getCameraPTZCurrentTilt(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZCurrentTilt] as? Int
  }
  
  public func getCameraPTZCurrentZoom(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZCurrentZoom] as? Int
  }
  
  public func getCameraPTZMaximumPan(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZMaximumPan] as? Int
  }
  
  public func getCameraPTZMinimumPan(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZMinimumPan] as? Int
  }
  
  public func getCameraPTZMaximumTilt(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZMaximumTilt] as? Int
  }
  
  public func getCameraPTZMinimumTilt(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZMinimumTilt] as? Int
  }
  
  public func getCameraPTZMaximumZoom(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZMaximumZoom] as? Int
  }
  
  public func getCameraPTZMinimumZoom(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.cameraPTZMinimumZoom] as? Int
  }
  
  
  public func requestCameraPTZGotoHome(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: CameraPTZGotoHomeRequest = CameraPTZGotoHomeRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCameraPTZGotoAbsolute(_  model: DeviceModel, pan: Int, tilt: Int, zoom: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: CameraPTZGotoAbsoluteRequest = CameraPTZGotoAbsoluteRequest()
    request.source = model.address
    
    
    
    request.setPan(pan)
    
    request.setTilt(tilt)
    
    request.setZoom(zoom)
    
    return try sendRequest(request)
  }
  
  public func requestCameraPTZGotoRelative(_  model: DeviceModel, deltaPan: Int, deltaTilt: Int, deltaZoom: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: CameraPTZGotoRelativeRequest = CameraPTZGotoRelativeRequest()
    request.source = model.address
    
    
    
    request.setDeltaPan(deltaPan)
    
    request.setDeltaTilt(deltaTilt)
    
    request.setDeltaZoom(deltaZoom)
    
    return try sendRequest(request)
  }
  
}
