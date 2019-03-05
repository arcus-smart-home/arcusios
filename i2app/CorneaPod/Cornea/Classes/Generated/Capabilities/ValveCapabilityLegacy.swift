
//
// ValveCapabilityLegacy.swift
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

public class ValveCapabilityLegacy: NSObject, ArcusValveCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ValveCapabilityLegacy  = ValveCapabilityLegacy()
  
  static let ValveValvestateCLOSED: String = ValveValvestate.closed.rawValue
  static let ValveValvestateOPEN: String = ValveValvestate.open.rawValue
  static let ValveValvestateOPENING: String = ValveValvestate.opening.rawValue
  static let ValveValvestateCLOSING: String = ValveValvestate.closing.rawValue
  static let ValveValvestateOBSTRUCTION: String = ValveValvestate.obstruction.rawValue
  

  
  public static func getValvestate(_ model: DeviceModel) -> String? {
    return capability.getValveValvestate(model)?.rawValue
  }
  
  public static func setValvestate(_ valvestate: String, model: DeviceModel) {
    guard let valvestate: ValveValvestate = ValveValvestate(rawValue: valvestate) else { return }
    
    capability.setValveValvestate(valvestate, model: model)
  }
  
  public static func getValvestatechanged(_ model: DeviceModel) -> Date? {
    guard let valvestatechanged: Date = capability.getValveValvestatechanged(model) else {
      return nil
    }
    return valvestatechanged
  }
  
}
