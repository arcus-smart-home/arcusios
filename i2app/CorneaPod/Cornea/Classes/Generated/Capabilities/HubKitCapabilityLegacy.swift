
//
// HubKitCapabilityLegacy.swift
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

public class HubKitCapabilityLegacy: NSObject, ArcusHubKitCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubKitCapabilityLegacy  = HubKitCapabilityLegacy()
  
  static let HubKitTypeNONE: String = HubKitType.none.rawValue
  static let HubKitTypeTEST: String = HubKitType.test.rawValue
  static let HubKitTypePROMON: String = HubKitType.promon.rawValue
  

  
  public static func getType(_ model: HubModel) -> String? {
    return capability.getHubKitType(model)?.rawValue
  }
  
  public static func getKit(_ model: HubModel) -> [Any]? {
    return capability.getHubKitKit(model)
  }
  
  public static func getPendingPairing(_ model: HubModel) -> [Any]? {
    return capability.getHubKitPendingPairing(model)
  }
  
  public static func setKit(_  model: HubModel, type: String, devices: [Any]) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubKitSetKit(model, type: type, devices: devices))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
