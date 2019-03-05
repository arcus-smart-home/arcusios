
//
// ContactCapabilityLegacy.swift
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

public class ContactCapabilityLegacy: NSObject, ArcusContactCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ContactCapabilityLegacy  = ContactCapabilityLegacy()
  
  static let ContactContactOPENED: String = ContactContact.opened.rawValue
  static let ContactContactCLOSED: String = ContactContact.closed.rawValue
  
  static let ContactUsehintDOOR: String = ContactUsehint.door.rawValue
  static let ContactUsehintWINDOW: String = ContactUsehint.window.rawValue
  static let ContactUsehintOTHER: String = ContactUsehint.other.rawValue
  static let ContactUsehintUNKNOWN: String = ContactUsehint.unknown.rawValue
  

  
  public static func getContact(_ model: DeviceModel) -> String? {
    return capability.getContactContact(model)?.rawValue
  }
  
  public static func getContactchanged(_ model: DeviceModel) -> Date? {
    guard let contactchanged: Date = capability.getContactContactchanged(model) else {
      return nil
    }
    return contactchanged
  }
  
  public static func getUsehint(_ model: DeviceModel) -> String? {
    return capability.getContactUsehint(model)?.rawValue
  }
  
  public static func setUsehint(_ usehint: String, model: DeviceModel) {
    guard let usehint: ContactUsehint = ContactUsehint(rawValue: usehint) else { return }
    
    capability.setContactUsehint(usehint, model: model)
  }
  
}
