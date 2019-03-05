
//
// DimmerCap.swift
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
  public static var dimmerNamespace: String = "dim"
  public static var dimmerName: String = "Dimmer"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let dimmerBrightness: String = "dim:brightness"
  static let dimmerRampingtarget: String = "dim:rampingtarget"
  static let dimmerRampingtime: String = "dim:rampingtime"
  
}

public protocol ArcusDimmerCapability: class, RxArcusService {
  /** Reflects the current level of brightness, as a percentage. If ramping is not desired, this parameter can be set to immediately achieve the desired brightness level. */
  func getDimmerBrightness(_ model: DeviceModel) -> Int?
  /** Reflects the current level of brightness, as a percentage. If ramping is not desired, this parameter can be set to immediately achieve the desired brightness level. */
  func setDimmerBrightness(_ brightness: Int, model: DeviceModel)
/** Reflects the target brightness, as a percentage, that the dimmer is ramping towards. This should be set to current brightness if ramping is complete. This parameter is read-only and should be controlled via the RampBrightness method if ramping is desired. */
  func getDimmerRampingtarget(_ model: DeviceModel) -> Int?
  /** Number of seconds remaining at current ramping rate before brightness is equal to rampingtarget. When ramping is complete, this value should be set to 0. This parameter is read-only and should be controlled via the RampBrightness method if ramping is desired. */
  func getDimmerRampingtime(_ model: DeviceModel) -> Int?
  
  /** Sets a rampingtarget and a rampingtime for the dimmer. Brightness must be 0..100, seconds must be a positive integer. */
  func requestDimmerRampBrightness(_  model: DeviceModel, brightness: Int, seconds: Int)
   throws -> Observable<ArcusSessionEvent>/** Increments the brightness of the dimmer by a given amount. */
  func requestDimmerIncrementBrightness(_  model: DeviceModel, amount: Int)
   throws -> Observable<ArcusSessionEvent>/** Decrements the brightness of the dimmer by a given amount. */
  func requestDimmerDecrementBrightness(_  model: DeviceModel, amount: Int)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusDimmerCapability {
  public func getDimmerBrightness(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.dimmerBrightness] as? Int
  }
  
  public func setDimmerBrightness(_ brightness: Int, model: DeviceModel) {
    model.set([Attributes.dimmerBrightness: brightness as AnyObject])
  }
  public func getDimmerRampingtarget(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.dimmerRampingtarget] as? Int
  }
  
  public func getDimmerRampingtime(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.dimmerRampingtime] as? Int
  }
  
  
  public func requestDimmerRampBrightness(_  model: DeviceModel, brightness: Int, seconds: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: DimmerRampBrightnessRequest = DimmerRampBrightnessRequest()
    request.source = model.address
    
    
    
    request.setBrightness(brightness)
    
    request.setSeconds(seconds)
    
    return try sendRequest(request)
  }
  
  public func requestDimmerIncrementBrightness(_  model: DeviceModel, amount: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: DimmerIncrementBrightnessRequest = DimmerIncrementBrightnessRequest()
    request.source = model.address
    
    
    
    request.setAmount(amount)
    
    return try sendRequest(request)
  }
  
  public func requestDimmerDecrementBrightness(_  model: DeviceModel, amount: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: DimmerDecrementBrightnessRequest = DimmerDecrementBrightnessRequest()
    request.source = model.address
    
    
    
    request.setAmount(amount)
    
    return try sendRequest(request)
  }
  
}
