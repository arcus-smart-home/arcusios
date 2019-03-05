
//
// HoneywellTCCCap.swift
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
  public static var honeywellTCCNamespace: String = "honeywelltcc"
  public static var honeywellTCCName: String = "HoneywellTCC"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let honeywellTCCRequiresLogin: String = "honeywelltcc:requiresLogin"
  static let honeywellTCCAuthorizationState: String = "honeywelltcc:authorizationState"
  
}

public protocol ArcusHoneywellTCCCapability: class, RxArcusService {
  /** Set to true when the end user needs to login into their Honeywell account to refresh tokens */
  func getHoneywellTCCRequiresLogin(_ model: DeviceModel) -> Bool?
  /** Whether the device is currently authorized for use by Arcus */
  func getHoneywellTCCAuthorizationState(_ model: DeviceModel) -> HoneywellTCCAuthorizationState?
  
  
}

extension ArcusHoneywellTCCCapability {
  public func getHoneywellTCCRequiresLogin(_ model: DeviceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.honeywellTCCRequiresLogin] as? Bool
  }
  
  public func getHoneywellTCCAuthorizationState(_ model: DeviceModel) -> HoneywellTCCAuthorizationState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.honeywellTCCAuthorizationState] as? String,
      let enumAttr: HoneywellTCCAuthorizationState = HoneywellTCCAuthorizationState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
}
