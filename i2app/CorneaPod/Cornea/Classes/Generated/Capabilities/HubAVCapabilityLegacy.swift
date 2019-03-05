
//
// HubAVCapabilityLegacy.swift
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

public class HubAVCapabilityLegacy: NSObject, ArcusHubAVCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubAVCapabilityLegacy  = HubAVCapabilityLegacy()
  

  
  public static func getNumAvailable(_ model: HubModel) -> NSNumber? {
    guard let numAvailable: Int = capability.getHubAVNumAvailable(model) else {
      return nil
    }
    return NSNumber(value: numAvailable)
  }
  
  public static func getNumPaired(_ model: HubModel) -> NSNumber? {
    guard let numPaired: Int = capability.getHubAVNumPaired(model) else {
      return nil
    }
    return NSNumber(value: numPaired)
  }
  
  public static func getNumDisconnected(_ model: HubModel) -> NSNumber? {
    guard let numDisconnected: Int = capability.getHubAVNumDisconnected(model) else {
      return nil
    }
    return NSNumber(value: numDisconnected)
  }
  
  public static func getAvdevs(_ model: HubModel) -> [String: String]? {
    return capability.getHubAVAvdevs(model)
  }
  
  public static func pair(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVPair(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func release(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVRelease(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getState(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVGetState(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getIPAddress(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVGetIPAddress(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getModel(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVGetModel(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func audioStart(_  model: HubModel, uuid: String, url: String, metadata: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVAudioStart(model, uuid: uuid, url: url, metadata: metadata))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func audioStop(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVAudioStop(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func audioPause(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVAudioPause(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func audioSeekTo(_  model: HubModel, uuid: String, unit: String, target: Int) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVAudioSeekTo(model, uuid: uuid, unit: unit, target: target))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setVolume(_  model: HubModel, uuid: String, volume: Int) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVSetVolume(model, uuid: uuid, volume: volume))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getVolume(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVGetVolume(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setMute(_  model: HubModel, uuid: String, mute: Bool) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVSetMute(model, uuid: uuid, mute: mute))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getMute(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVGetMute(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func audioInfo(_  model: HubModel, uuid: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHubAVAudioInfo(model, uuid: uuid))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
