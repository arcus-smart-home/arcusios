
//
// SceneCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var sceneNamespace: String = "scene"
  public static var sceneName: String = "Scene"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let sceneName: String = "scene:name"
  static let sceneCreated: String = "scene:created"
  static let sceneModified: String = "scene:modified"
  static let sceneTemplate: String = "scene:template"
  static let sceneEnabled: String = "scene:enabled"
  static let sceneNotification: String = "scene:notification"
  static let sceneScheduler: String = "scene:scheduler"
  static let sceneFiring: String = "scene:firing"
  static let sceneActions: String = "scene:actions"
  static let sceneLastFireTime: String = "scene:lastFireTime"
  static let sceneLastFireStatus: String = "scene:lastFireStatus"
  
}

public protocol ArcusSceneCapability: class, RxArcusService {
  /** The name of the scene */
  func getSceneName(_ model: SceneModel) -> String?
  /** The name of the scene */
  func setSceneName(_ name: String, model: SceneModel)
/** Timestamp that the rule was created */
  func getSceneCreated(_ model: SceneModel) -> Date?
  /** Timestamp that the rule was last modified */
  func getSceneModified(_ model: SceneModel) -> Date?
  /** The address of the template this scene was created from. */
  func getSceneTemplate(_ model: SceneModel) -> String?
  /** Whether or not this scene is enabled, currently this is tied directly to PREMIUM / BASIC status and may not be changed. */
  func getSceneEnabled(_ model: SceneModel) -> Bool?
  /** Whether or not a notification should be fired when this scene is executed. */
  func getSceneNotification(_ model: SceneModel) -> Bool?
  /** Whether or not a notification should be fired when this scene is executed. */
  func setSceneNotification(_ notification: Bool, model: SceneModel)
/** The id of the associated scheduler. */
  func getSceneScheduler(_ model: SceneModel) -> String?
  /** True while the scene is being executed, the scene may not be ran again until executing is false, at which point all actions have succeeded or failed. */
  func getSceneFiring(_ model: SceneModel) -> Bool?
  /** The actions associated with this scene. */
  func getSceneActions(_ model: SceneModel) -> [Any]?
  /** The actions associated with this scene. */
  func setSceneActions(_ actions: [Any], model: SceneModel)
/** The last time this scene was run. */
  func getSceneLastFireTime(_ model: SceneModel) -> Date?
  /** The actions associated with this scene. */
  func getSceneLastFireStatus(_ model: SceneModel) -> SceneLastFireStatus?
  
  /** Executes the scene */
  func requestSceneFire(_ model: SceneModel) throws -> Observable<ArcusSessionEvent>/** Deletes the scene */
  func requestSceneDelete(_ model: SceneModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSceneCapability {
  public func getSceneName(_ model: SceneModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneName] as? String
  }
  
  public func setSceneName(_ name: String, model: SceneModel) {
    model.set([Attributes.sceneName: name as AnyObject])
  }
  public func getSceneCreated(_ model: SceneModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.sceneCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSceneModified(_ model: SceneModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.sceneModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSceneTemplate(_ model: SceneModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneTemplate] as? String
  }
  
  public func getSceneEnabled(_ model: SceneModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneEnabled] as? Bool
  }
  
  public func getSceneNotification(_ model: SceneModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneNotification] as? Bool
  }
  
  public func setSceneNotification(_ notification: Bool, model: SceneModel) {
    model.set([Attributes.sceneNotification: notification as AnyObject])
  }
  public func getSceneScheduler(_ model: SceneModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneScheduler] as? String
  }
  
  public func getSceneFiring(_ model: SceneModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneFiring] as? Bool
  }
  
  public func getSceneActions(_ model: SceneModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneActions] as? [Any]
  }
  
  public func setSceneActions(_ actions: [Any], model: SceneModel) {
    model.set([Attributes.sceneActions: actions as AnyObject])
  }
  public func getSceneLastFireTime(_ model: SceneModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.sceneLastFireTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSceneLastFireStatus(_ model: SceneModel) -> SceneLastFireStatus? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.sceneLastFireStatus] as? String,
      let enumAttr: SceneLastFireStatus = SceneLastFireStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
  public func requestSceneFire(_ model: SceneModel) throws -> Observable<ArcusSessionEvent> {
    let request: SceneFireRequest = SceneFireRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestSceneDelete(_ model: SceneModel) throws -> Observable<ArcusSessionEvent> {
    let request: SceneDeleteRequest = SceneDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
