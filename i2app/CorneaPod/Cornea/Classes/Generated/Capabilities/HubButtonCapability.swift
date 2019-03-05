
//
// HubButtonCap.swift
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
  public static var hubButtonNamespace: String = "hubbutton"
  public static var hubButtonName: String = "HubButton"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubButtonState: String = "hubbutton:state"
  static let hubButtonDuration: String = "hubbutton:duration"
  static let hubButtonStatechanged: String = "hubbutton:statechanged"
  
}

public protocol ArcusHubButtonCapability: class, RxArcusService {
  /** Reflects the current state of the button where pressed implies the user has pressed the button and released the opposite. Also used to set the state of the button. */
  func getHubButtonState(_ model: HubModel) -> HubButtonState?
  /** Reflects the current state of the button where pressed implies the user has pressed the button and released the opposite. Also used to set the state of the button. */
  func setHubButtonState(_ state: HubButtonState, model: HubModel)
/** How long has the button been in the given state */
  func getHubButtonDuration(_ model: HubModel) -> Int?
  /** UTC date time of last state change */
  func getHubButtonStatechanged(_ model: HubModel) -> Date?
  
  
}

extension ArcusHubButtonCapability {
  public func getHubButtonState(_ model: HubModel) -> HubButtonState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubButtonState] as? String,
      let enumAttr: HubButtonState = HubButtonState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setHubButtonState(_ state: HubButtonState, model: HubModel) {
    model.set([Attributes.hubButtonState: state.rawValue as AnyObject])
  }
  public func getHubButtonDuration(_ model: HubModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubButtonDuration] as? Int
  }
  
  public func getHubButtonStatechanged(_ model: HubModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.hubButtonStatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
