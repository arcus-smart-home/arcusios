
//
// SceneCapabilityLegacy.swift
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

public class SceneCapabilityLegacy: NSObject, ArcusSceneCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SceneCapabilityLegacy  = SceneCapabilityLegacy()
  
  static let SceneLastFireStatusNOTRUN: String = SceneLastFireStatus.notrun.rawValue
  static let SceneLastFireStatusSUCCESS: String = SceneLastFireStatus.success.rawValue
  static let SceneLastFireStatusFAILURE: String = SceneLastFireStatus.failure.rawValue
  static let SceneLastFireStatusPARTIAL: String = SceneLastFireStatus.partial.rawValue
  

  
  public static func getName(_ model: SceneModel) -> String? {
    return capability.getSceneName(model)
  }
  
  public static func setName(_ name: String, model: SceneModel) {
    
    
    capability.setSceneName(name, model: model)
  }
  
  public static func getCreated(_ model: SceneModel) -> Date? {
    guard let created: Date = capability.getSceneCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getModified(_ model: SceneModel) -> Date? {
    guard let modified: Date = capability.getSceneModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func getTemplate(_ model: SceneModel) -> String? {
    return capability.getSceneTemplate(model)
  }
  
  public static func getEnabled(_ model: SceneModel) -> NSNumber? {
    guard let enabled: Bool = capability.getSceneEnabled(model) else {
      return nil
    }
    return NSNumber(value: enabled)
  }
  
  public static func getNotification(_ model: SceneModel) -> NSNumber? {
    guard let notification: Bool = capability.getSceneNotification(model) else {
      return nil
    }
    return NSNumber(value: notification)
  }
  
  public static func setNotification(_ notification: Bool, model: SceneModel) {
    
    
    capability.setSceneNotification(notification, model: model)
  }
  
  public static func getScheduler(_ model: SceneModel) -> String? {
    return capability.getSceneScheduler(model)
  }
  
  public static func getFiring(_ model: SceneModel) -> NSNumber? {
    guard let firing: Bool = capability.getSceneFiring(model) else {
      return nil
    }
    return NSNumber(value: firing)
  }
  
  public static func getActions(_ model: SceneModel) -> [Any]? {
    return capability.getSceneActions(model)
  }
  
  public static func setActions(_ actions: [Any], model: SceneModel) {
    
    
    capability.setSceneActions(actions, model: model)
  }
  
  public static func getLastFireTime(_ model: SceneModel) -> Date? {
    guard let lastFireTime: Date = capability.getSceneLastFireTime(model) else {
      return nil
    }
    return lastFireTime
  }
  
  public static func getLastFireStatus(_ model: SceneModel) -> String? {
    return capability.getSceneLastFireStatus(model)?.rawValue
  }
  
  public static func fire(_ model: SceneModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSceneFire(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: SceneModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSceneDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
