
//
// SwannBatteryCameraCap.swift
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
  public static var swannBatteryCameraNamespace: String = "swannbatterycamera"
  public static var swannBatteryCameraName: String = "SwannBatteryCamera"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let swannBatteryCameraSn: String = "swannbatterycamera:sn"
  static let swannBatteryCameraMode: String = "swannbatterycamera:mode"
  static let swannBatteryCameraTimeZone: String = "swannbatterycamera:timeZone"
  static let swannBatteryCameraMotionDetectSleep: String = "swannbatterycamera:motionDetectSleep"
  static let swannBatteryCameraStopUpload: String = "swannbatterycamera:stopUpload"
  
}

public protocol ArcusSwannBatteryCameraCapability: class, RxArcusService {
  /** The serial number of the camera */
  func getSwannBatteryCameraSn(_ model: DeviceModel) -> String?
  /** Current resolution of the camera. Must appear in resolutionssupported list. */
  func getSwannBatteryCameraMode(_ model: DeviceModel) -> SwannBatteryCameraMode?
  /** Offset from GMT in 30m increments */
  func getSwannBatteryCameraTimeZone(_ model: DeviceModel) -> Int?
  /** Offset from GMT in 30m increments */
  func setSwannBatteryCameraTimeZone(_ timeZone: Int, model: DeviceModel)
/** How long to sleep between motion detection. */
  func getSwannBatteryCameraMotionDetectSleep(_ model: DeviceModel) -> SwannBatteryCameraMotionDetectSleep?
  /** How long to sleep between motion detection. */
  func setSwannBatteryCameraMotionDetectSleep(_ motionDetectSleep: SwannBatteryCameraMotionDetectSleep, model: DeviceModel)
/** true to prevent the camera from upload clips, false otherwise. */
  func getSwannBatteryCameraStopUpload(_ model: DeviceModel) -> Bool?
  /** true to prevent the camera from upload clips, false otherwise. */
  func setSwannBatteryCameraStopUpload(_ stopUpload: Bool, model: DeviceModel)

  /** Wakes up the battery camera if it is asleep and tell it to stay awake for the given number of seconds.  If the camera is already awake, this will tell the camera to stay awake for the given number of seconds */
  func requestSwannBatteryCameraKeepAwake(_  model: DeviceModel, seconds: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusSwannBatteryCameraCapability {
  public func getSwannBatteryCameraSn(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.swannBatteryCameraSn] as? String
  }
  
  public func getSwannBatteryCameraMode(_ model: DeviceModel) -> SwannBatteryCameraMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.swannBatteryCameraMode] as? String,
      let enumAttr: SwannBatteryCameraMode = SwannBatteryCameraMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getSwannBatteryCameraTimeZone(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.swannBatteryCameraTimeZone] as? Int
  }
  
  public func setSwannBatteryCameraTimeZone(_ timeZone: Int, model: DeviceModel) {
    model.set([Attributes.swannBatteryCameraTimeZone: timeZone as AnyObject])
  }
  public func getSwannBatteryCameraMotionDetectSleep(_ model: DeviceModel) -> SwannBatteryCameraMotionDetectSleep? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.swannBatteryCameraMotionDetectSleep] as? String,
      let enumAttr: SwannBatteryCameraMotionDetectSleep = SwannBatteryCameraMotionDetectSleep(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setSwannBatteryCameraMotionDetectSleep(_ motionDetectSleep: SwannBatteryCameraMotionDetectSleep, model: DeviceModel) {
    model.set([Attributes.swannBatteryCameraMotionDetectSleep: motionDetectSleep.rawValue as AnyObject])
  }
  public func getSwannBatteryCameraStopUpload(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.swannBatteryCameraStopUpload] as? Bool
  }
  
  public func setSwannBatteryCameraStopUpload(_ stopUpload: Bool, model: DeviceModel) {
    model.set([Attributes.swannBatteryCameraStopUpload: stopUpload as AnyObject])
  }
  
  public func requestSwannBatteryCameraKeepAwake(_  model: DeviceModel, seconds: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: SwannBatteryCameraKeepAwakeRequest = SwannBatteryCameraKeepAwakeRequest()
    request.source = model.address
    
    
    
    request.setSeconds(seconds)
    
    return try sendRequest(request)
  }
  
}
