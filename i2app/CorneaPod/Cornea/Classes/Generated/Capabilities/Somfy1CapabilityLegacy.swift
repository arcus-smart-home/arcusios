
//
// Somfy1CapabilityLegacy.swift
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

public class Somfy1CapabilityLegacy: NSObject, ArcusSomfy1Capability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: Somfy1CapabilityLegacy  = Somfy1CapabilityLegacy()
  
  static let Somfy1ModeSHADE: String = Somfy1Mode.shade.rawValue
  static let Somfy1ModeBLIND: String = Somfy1Mode.blind.rawValue
  
  static let Somfy1ReversedNORMAL: String = Somfy1Reversed.normal.rawValue
  static let Somfy1ReversedREVERSED: String = Somfy1Reversed.reversed.rawValue
  

  
  public static func getMode(_ model: DeviceModel) -> String? {
    return capability.getSomfy1Mode(model)?.rawValue
  }
  
  public static func setMode(_ mode: String, model: DeviceModel) {
    guard let mode: Somfy1Mode = Somfy1Mode(rawValue: mode) else { return }
    
    capability.setSomfy1Mode(mode, model: model)
  }
  
  public static func getReversed(_ model: DeviceModel) -> String? {
    return capability.getSomfy1Reversed(model)?.rawValue
  }
  
  public static func setReversed(_ reversed: String, model: DeviceModel) {
    guard let reversed: Somfy1Reversed = Somfy1Reversed(rawValue: reversed) else { return }
    
    capability.setSomfy1Reversed(reversed, model: model)
  }
  
}
