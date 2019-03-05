
//
// PresenceCap.swift
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
  public static var presenceNamespace: String = "pres"
  public static var presenceName: String = "Presence"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let presencePresence: String = "pres:presence"
  static let presencePresencechanged: String = "pres:presencechanged"
  static let presencePerson: String = "pres:person"
  static let presenceUsehint: String = "pres:usehint"
  
}

public protocol ArcusPresenceCapability: class, RxArcusService {
  /** Reflects the state of a presence device. */
  func getPresencePresence(_ model: DeviceModel) -> PresencePresence?
  /** UTC date time of last presence change */
  func getPresencePresencechanged(_ model: DeviceModel) -> Date?
  /** The address of the person currently associated with this presence detector */
  func getPresencePerson(_ model: DeviceModel) -> String?
  /** The address of the person currently associated with this presence detector */
  func setPresencePerson(_ person: String, model: DeviceModel)
/** What this presence detector is used for.  PERSON detects presence/absence of a person, OTHER something else (pet for example), UNKNOWN is unassigned. */
  func getPresenceUsehint(_ model: DeviceModel) -> PresenceUsehint?
  /** What this presence detector is used for.  PERSON detects presence/absence of a person, OTHER something else (pet for example), UNKNOWN is unassigned. */
  func setPresenceUsehint(_ usehint: PresenceUsehint, model: DeviceModel)

  
}

extension ArcusPresenceCapability {
  public func getPresencePresence(_ model: DeviceModel) -> PresencePresence? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.presencePresence] as? String,
      let enumAttr: PresencePresence = PresencePresence(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPresencePresencechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.presencePresencechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPresencePerson(_ model: DeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.presencePerson] as? String
  }
  
  public func setPresencePerson(_ person: String, model: DeviceModel) {
    model.set([Attributes.presencePerson: person as AnyObject])
  }
  public func getPresenceUsehint(_ model: DeviceModel) -> PresenceUsehint? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.presenceUsehint] as? String,
      let enumAttr: PresenceUsehint = PresenceUsehint(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setPresenceUsehint(_ usehint: PresenceUsehint, model: DeviceModel) {
    model.set([Attributes.presenceUsehint: usehint.rawValue as AnyObject])
  }
  
}
