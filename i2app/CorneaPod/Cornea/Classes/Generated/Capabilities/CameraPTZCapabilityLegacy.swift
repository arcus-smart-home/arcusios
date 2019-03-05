
//
// CameraPTZCapabilityLegacy.swift
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

public class CameraPTZCapabilityLegacy: NSObject, ArcusCameraPTZCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: CameraPTZCapabilityLegacy  = CameraPTZCapabilityLegacy()
  

  
  public static func getCurrentPan(_ model: DeviceModel) -> NSNumber? {
    guard let currentPan: Int = capability.getCameraPTZCurrentPan(model) else {
      return nil
    }
    return NSNumber(value: currentPan)
  }
  
  public static func getCurrentTilt(_ model: DeviceModel) -> NSNumber? {
    guard let currentTilt: Int = capability.getCameraPTZCurrentTilt(model) else {
      return nil
    }
    return NSNumber(value: currentTilt)
  }
  
  public static func getCurrentZoom(_ model: DeviceModel) -> NSNumber? {
    guard let currentZoom: Int = capability.getCameraPTZCurrentZoom(model) else {
      return nil
    }
    return NSNumber(value: currentZoom)
  }
  
  public static func getMaximumPan(_ model: DeviceModel) -> NSNumber? {
    guard let maximumPan: Int = capability.getCameraPTZMaximumPan(model) else {
      return nil
    }
    return NSNumber(value: maximumPan)
  }
  
  public static func getMinimumPan(_ model: DeviceModel) -> NSNumber? {
    guard let minimumPan: Int = capability.getCameraPTZMinimumPan(model) else {
      return nil
    }
    return NSNumber(value: minimumPan)
  }
  
  public static func getMaximumTilt(_ model: DeviceModel) -> NSNumber? {
    guard let maximumTilt: Int = capability.getCameraPTZMaximumTilt(model) else {
      return nil
    }
    return NSNumber(value: maximumTilt)
  }
  
  public static func getMinimumTilt(_ model: DeviceModel) -> NSNumber? {
    guard let minimumTilt: Int = capability.getCameraPTZMinimumTilt(model) else {
      return nil
    }
    return NSNumber(value: minimumTilt)
  }
  
  public static func getMaximumZoom(_ model: DeviceModel) -> NSNumber? {
    guard let maximumZoom: Int = capability.getCameraPTZMaximumZoom(model) else {
      return nil
    }
    return NSNumber(value: maximumZoom)
  }
  
  public static func getMinimumZoom(_ model: DeviceModel) -> NSNumber? {
    guard let minimumZoom: Int = capability.getCameraPTZMinimumZoom(model) else {
      return nil
    }
    return NSNumber(value: minimumZoom)
  }
  
  public static func gotoHome(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCameraPTZGotoHome(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func gotoAbsolute(_  model: DeviceModel, pan: Int, tilt: Int, zoom: Int) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCameraPTZGotoAbsolute(model, pan: pan, tilt: tilt, zoom: zoom))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func gotoRelative(_  model: DeviceModel, deltaPan: Int, deltaTilt: Int, deltaZoom: Int) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCameraPTZGotoRelative(model, deltaPan: deltaPan, deltaTilt: deltaTilt, deltaZoom: deltaZoom))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
