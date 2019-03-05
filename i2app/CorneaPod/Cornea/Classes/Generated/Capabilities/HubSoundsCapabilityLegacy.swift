
//
// HubSoundsCapabilityLegacy.swift
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

public class HubSoundsCapabilityLegacy: NSObject, ArcusHubSoundsCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubSoundsCapabilityLegacy  = HubSoundsCapabilityLegacy()
  

  
  public static func getPlaying(_ model: HubModel) -> NSNumber? {
    guard let playing: Bool = capability.getHubSoundsPlaying(model) else {
      return nil
    }
    return NSNumber(value: playing)
  }
  
  public static func getSource(_ model: HubModel) -> String? {
    return capability.getHubSoundsSource(model)
  }
  
  public static func playTone(_  model: HubModel, tone: String, durationSec: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubSoundsPlayTone(model, tone: tone, durationSec: durationSec))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func quiet(_ model: HubModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHubSoundsQuiet(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
