
//
// PopulationCapabilityLegacy.swift
//
// Generated on 22/05/18
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

public class PopulationCapabilityLegacy: NSObject, ArcusPopulationCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PopulationCapabilityLegacy  = PopulationCapabilityLegacy()
  

  
  public static func getName(_ model: PopulationModel) -> String? {
    return capability.getPopulationName(model)
  }
  
  public static func getDescription(_ model: PopulationModel) -> String? {
    return capability.getPopulationDescription(model)
  }
  
  public static func getIsDefault(_ model: PopulationModel) -> NSNumber? {
    guard let isDefault: Bool = capability.getPopulationIsDefault(model) else {
      return nil
    }
    return NSNumber(value: isDefault)
  }
  
  public static func getPopulations(_ model: PopulationModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPopulationGetPopulations(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
