
//
// ContactCap.swift
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
  public static var contactNamespace: String = "cont"
  public static var contactName: String = "Contact"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let contactContact: String = "cont:contact"
  static let contactContactchanged: String = "cont:contactchanged"
  static let contactUsehint: String = "cont:usehint"
  
}

public protocol ArcusContactCapability: class, RxArcusService {
  /** Reflects the state of the contact sensor (opened or closed). */
  func getContactContact(_ model: DeviceModel) -> ContactContact?
  /** UTC date time of last contact change */
  func getContactContactchanged(_ model: DeviceModel) -> Date?
  /** How the device should be treated for display to the user.  UNKNOWN indicates this value hasn&#x27;t been set and the user should be queried for how it was installed.  Some devices, such as door hinges, may populate this with an initial value of DOOR or WINDOW, but most drivers will initialize it to UNKNOWN */
  func getContactUsehint(_ model: DeviceModel) -> ContactUsehint?
  /** How the device should be treated for display to the user.  UNKNOWN indicates this value hasn&#x27;t been set and the user should be queried for how it was installed.  Some devices, such as door hinges, may populate this with an initial value of DOOR or WINDOW, but most drivers will initialize it to UNKNOWN */
  func setContactUsehint(_ usehint: ContactUsehint, model: DeviceModel)

  
}

extension ArcusContactCapability {
  public func getContactContact(_ model: DeviceModel) -> ContactContact? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.contactContact] as? String,
      let enumAttr: ContactContact = ContactContact(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getContactContactchanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.contactContactchanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getContactUsehint(_ model: DeviceModel) -> ContactUsehint? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.contactUsehint] as? String,
      let enumAttr: ContactUsehint = ContactUsehint(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setContactUsehint(_ usehint: ContactUsehint, model: DeviceModel) {
    model.set([Attributes.contactUsehint: usehint.rawValue as AnyObject])
  }
  
}
