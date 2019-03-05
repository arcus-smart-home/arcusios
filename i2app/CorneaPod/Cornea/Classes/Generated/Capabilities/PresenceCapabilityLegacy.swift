
//
// PresenceCapabilityLegacy.swift
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

public class PresenceCapabilityLegacy: NSObject, ArcusPresenceCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PresenceCapabilityLegacy  = PresenceCapabilityLegacy()
  
  static let PresencePresencePRESENT: String = PresencePresence.present.rawValue
  static let PresencePresenceABSENT: String = PresencePresence.absent.rawValue
  
  static let PresenceUsehintUNKNOWN: String = PresenceUsehint.unknown.rawValue
  static let PresenceUsehintPERSON: String = PresenceUsehint.person.rawValue
  static let PresenceUsehintOTHER: String = PresenceUsehint.other.rawValue
  

  
  public static func getPresence(_ model: DeviceModel) -> String? {
    return capability.getPresencePresence(model)?.rawValue
  }
  
  public static func getPresencechanged(_ model: DeviceModel) -> Date? {
    guard let presencechanged: Date = capability.getPresencePresencechanged(model) else {
      return nil
    }
    return presencechanged
  }
  
  public static func getPerson(_ model: DeviceModel) -> String? {
    return capability.getPresencePerson(model)
  }
  
  public static func setPerson(_ person: String, model: DeviceModel) {
    
    
    capability.setPresencePerson(person, model: model)
  }
  
  public static func getUsehint(_ model: DeviceModel) -> String? {
    return capability.getPresenceUsehint(model)?.rawValue
  }
  
  public static func setUsehint(_ usehint: String, model: DeviceModel) {
    guard let usehint: PresenceUsehint = PresenceUsehint(rawValue: usehint) else { return }
    
    capability.setPresenceUsehint(usehint, model: model)
  }
  
}
