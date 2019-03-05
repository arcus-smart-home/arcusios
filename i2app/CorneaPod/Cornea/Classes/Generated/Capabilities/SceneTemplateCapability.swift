
//
// SceneTemplateCap.swift
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
  public static var sceneTemplateNamespace: String = "scenetmpl"
  public static var sceneTemplateName: String = "SceneTemplate"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let sceneTemplateAdded: String = "scenetmpl:added"
  static let sceneTemplateModified: String = "scenetmpl:modified"
  static let sceneTemplateName: String = "scenetmpl:name"
  static let sceneTemplateDescription: String = "scenetmpl:description"
  static let sceneTemplateCustom: String = "scenetmpl:custom"
  static let sceneTemplateAvailable: String = "scenetmpl:available"
  
}

public protocol ArcusSceneTemplateCapability: class, RxArcusService {
  /** Timestamp that the scene template was added to the catalog */
  func getSceneTemplateAdded(_ model: SceneTemplateModel) -> Date?
  /** Timestamp that the scene template was last modified */
  func getSceneTemplateModified(_ model: SceneTemplateModel) -> Date?
  /** The name of the rule template */
  func getSceneTemplateName(_ model: SceneTemplateModel) -> String?
  /** A description of the rule template */
  func getSceneTemplateDescription(_ model: SceneTemplateModel) -> String?
  /** True if this is a custom template that may be re-used. */
  func getSceneTemplateCustom(_ model: SceneTemplateModel) -> Bool?
  /** Indicates if the scene template is in use or not. */
  func getSceneTemplateAvailable(_ model: SceneTemplateModel) -> Bool?
  
  /** Creates a scene instance from a given scene template */
  func requestSceneTemplateCreate(_  model: SceneTemplateModel, placeId: String, name: String, actions: [Any])
   throws -> Observable<ArcusSessionEvent>/** Resolves the actions that are applicable to a scene template. */
  func requestSceneTemplateResolveActions(_  model: SceneTemplateModel, placeId: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusSceneTemplateCapability {
  public func getSceneTemplateAdded(_ model: SceneTemplateModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.sceneTemplateAdded] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSceneTemplateModified(_ model: SceneTemplateModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.sceneTemplateModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getSceneTemplateName(_ model: SceneTemplateModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneTemplateName] as? String
  }
  
  public func getSceneTemplateDescription(_ model: SceneTemplateModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneTemplateDescription] as? String
  }
  
  public func getSceneTemplateCustom(_ model: SceneTemplateModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneTemplateCustom] as? Bool
  }
  
  public func getSceneTemplateAvailable(_ model: SceneTemplateModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.sceneTemplateAvailable] as? Bool
  }
  
  
  public func requestSceneTemplateCreate(_  model: SceneTemplateModel, placeId: String, name: String, actions: [Any])
   throws -> Observable<ArcusSessionEvent> {
    let request: SceneTemplateCreateRequest = SceneTemplateCreateRequest()
    request.source = model.address
    
    
    
    request.setPlaceId(placeId)
    
    request.setName(name)
    
    request.setActions(actions)
    
    return try sendRequest(request)
  }
  
  public func requestSceneTemplateResolveActions(_  model: SceneTemplateModel, placeId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: SceneTemplateResolveActionsRequest = SceneTemplateResolveActionsRequest()
    request.source = model.address
    
    
    
    request.setPlaceId(placeId)
    
    return try sendRequest(request)
  }
  
}
