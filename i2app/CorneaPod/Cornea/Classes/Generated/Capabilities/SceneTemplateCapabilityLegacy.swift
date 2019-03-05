
//
// SceneTemplateCapabilityLegacy.swift
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

public class SceneTemplateCapabilityLegacy: NSObject, ArcusSceneTemplateCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SceneTemplateCapabilityLegacy  = SceneTemplateCapabilityLegacy()
  

  
  public static func getAdded(_ model: SceneTemplateModel) -> Date? {
    guard let added: Date = capability.getSceneTemplateAdded(model) else {
      return nil
    }
    return added
  }
  
  public static func getModified(_ model: SceneTemplateModel) -> Date? {
    guard let modified: Date = capability.getSceneTemplateModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func getName(_ model: SceneTemplateModel) -> String? {
    return capability.getSceneTemplateName(model)
  }
  
  public static func getDescription(_ model: SceneTemplateModel) -> String? {
    return capability.getSceneTemplateDescription(model)
  }
  
  public static func getCustom(_ model: SceneTemplateModel) -> NSNumber? {
    guard let custom: Bool = capability.getSceneTemplateCustom(model) else {
      return nil
    }
    return NSNumber(value: custom)
  }
  
  public static func getAvailable(_ model: SceneTemplateModel) -> NSNumber? {
    guard let available: Bool = capability.getSceneTemplateAvailable(model) else {
      return nil
    }
    return NSNumber(value: available)
  }
  
  public static func create(_  model: SceneTemplateModel, placeId: String, name: String, actions: [Any]) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSceneTemplateCreate(model, placeId: placeId, name: name, actions: actions))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func resolveActions(_  model: SceneTemplateModel, placeId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSceneTemplateResolveActions(model, placeId: placeId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
