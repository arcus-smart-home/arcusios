
//
// ButtonCap.swift
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
  public static var buttonNamespace: String = "but"
  public static var buttonName: String = "Button"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let buttonState: String = "but:state"
  static let buttonStatechanged: String = "but:statechanged"
  
}

public protocol ArcusButtonCapability: class, RxArcusService {
  /** Reflects the current state of the button where pressed implies the user has pressed the button and released the opposite. Also used to set the state of the button. */
  func getButtonState(_ model: DeviceModel) -> ButtonState?
  /** Reflects the current state of the button where pressed implies the user has pressed the button and released the opposite. Also used to set the state of the button. */
  func setButtonState(_ state: ButtonState, model: DeviceModel)
/** UTC date time of last state change */
  func getButtonStatechanged(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusButtonCapability {
  public func getButtonState(_ model: DeviceModel) -> ButtonState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.buttonState] as? String,
      let enumAttr: ButtonState = ButtonState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setButtonState(_ state: ButtonState, model: DeviceModel) {
    model.set([Attributes.buttonState: state.rawValue as AnyObject])
  }
  public func getButtonStatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.buttonStatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
