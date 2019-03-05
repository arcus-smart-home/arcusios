
//
// AlertCapabilityLegacy.swift
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

public class AlertCapabilityLegacy: NSObject, ArcusAlertCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: AlertCapabilityLegacy  = AlertCapabilityLegacy()
  
  static let AlertStateQUIET: String = AlertState.quiet.rawValue
  static let AlertStateALERTING: String = AlertState.alerting.rawValue
  

  
  public static func getState(_ model: DeviceModel) -> String? {
    return capability.getAlertState(model)?.rawValue
  }
  
  public static func setState(_ state: String, model: DeviceModel) {
    guard let state: AlertState = AlertState(rawValue: state) else { return }
    
    capability.setAlertState(state, model: model)
  }
  
  public static func getMaxAlertSecs(_ model: DeviceModel) -> NSNumber? {
    guard let maxAlertSecs: Int = capability.getAlertMaxAlertSecs(model) else {
      return nil
    }
    return NSNumber(value: maxAlertSecs)
  }
  
  public static func setMaxAlertSecs(_ maxAlertSecs: Int, model: DeviceModel) {
    
    
    capability.setAlertMaxAlertSecs(maxAlertSecs, model: model)
  }
  
  public static func getDefaultMaxAlertSecs(_ model: DeviceModel) -> NSNumber? {
    guard let defaultMaxAlertSecs: Int = capability.getAlertDefaultMaxAlertSecs(model) else {
      return nil
    }
    return NSNumber(value: defaultMaxAlertSecs)
  }
  
  public static func getLastAlertTime(_ model: DeviceModel) -> Date? {
    guard let lastAlertTime: Date = capability.getAlertLastAlertTime(model) else {
      return nil
    }
    return lastAlertTime
  }
  
}
