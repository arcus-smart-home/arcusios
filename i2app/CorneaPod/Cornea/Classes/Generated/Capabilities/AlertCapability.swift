
//
// AlertCap.swift
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
  public static var alertNamespace: String = "alert"
  public static var alertName: String = "Alert"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let alertState: String = "alert:state"
  static let alertMaxAlertSecs: String = "alert:maxAlertSecs"
  static let alertDefaultMaxAlertSecs: String = "alert:defaultMaxAlertSecs"
  static let alertLastAlertTime: String = "alert:lastAlertTime"
  
}

public protocol ArcusAlertCapability: class, RxArcusService {
  /** Reflects the current state of the alert where quiet means that whatever alarm the device is now silent and alerting implies the device is currently alarming (blinking lights, making some noise). */
  func getAlertState(_ model: DeviceModel) -> AlertState?
  /** Reflects the current state of the alert where quiet means that whatever alarm the device is now silent and alerting implies the device is currently alarming (blinking lights, making some noise). */
  func setAlertState(_ state: AlertState, model: DeviceModel)
/** Maximum number of seconds that the alert device will stay in alerting state before it will be reset to quiet automatically by its driver. 0 = No Limit. */
  func getAlertMaxAlertSecs(_ model: DeviceModel) -> Int?
  /** Maximum number of seconds that the alert device will stay in alerting state before it will be reset to quiet automatically by its driver. 0 = No Limit. */
  func setAlertMaxAlertSecs(_ maxAlertSecs: Int, model: DeviceModel)
/** Default value of maxAlertSecs. */
  func getAlertDefaultMaxAlertSecs(_ model: DeviceModel) -> Int?
  /** The last time this device went to alert state. */
  func getAlertLastAlertTime(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusAlertCapability {
  public func getAlertState(_ model: DeviceModel) -> AlertState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.alertState] as? String,
      let enumAttr: AlertState = AlertState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setAlertState(_ state: AlertState, model: DeviceModel) {
    model.set([Attributes.alertState: state.rawValue as AnyObject])
  }
  public func getAlertMaxAlertSecs(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alertMaxAlertSecs] as? Int
  }
  
  public func setAlertMaxAlertSecs(_ maxAlertSecs: Int, model: DeviceModel) {
    model.set([Attributes.alertMaxAlertSecs: maxAlertSecs as AnyObject])
  }
  public func getAlertDefaultMaxAlertSecs(_ model: DeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.alertDefaultMaxAlertSecs] as? Int
  }
  
  public func getAlertLastAlertTime(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.alertLastAlertTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
