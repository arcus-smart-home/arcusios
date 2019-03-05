
//
// HubButtonCapabilityLegacy.swift
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

public class HubButtonCapabilityLegacy: NSObject, ArcusHubButtonCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubButtonCapabilityLegacy  = HubButtonCapabilityLegacy()
  
  static let HubButtonStateRELEASED: String = HubButtonState.released.rawValue
  static let HubButtonStatePRESSED: String = HubButtonState.pressed.rawValue
  static let HubButtonStateDOUBLE_PRESSED: String = HubButtonState.double_pressed.rawValue
  

  
  public static func getState(_ model: HubModel) -> String? {
    return capability.getHubButtonState(model)?.rawValue
  }
  
  public static func setState(_ state: String, model: HubModel) {
    guard let state: HubButtonState = HubButtonState(rawValue: state) else { return }
    
    capability.setHubButtonState(state, model: model)
  }
  
  public static func getDuration(_ model: HubModel) -> NSNumber? {
    guard let duration: Int = capability.getHubButtonDuration(model) else {
      return nil
    }
    return NSNumber(value: duration)
  }
  
  public static func getStatechanged(_ model: HubModel) -> Date? {
    guard let statechanged: Date = capability.getHubButtonStatechanged(model) else {
      return nil
    }
    return statechanged
  }
  
}
