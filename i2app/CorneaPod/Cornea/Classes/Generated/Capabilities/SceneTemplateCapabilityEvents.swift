
//
// SceneTemplateCapEvents.swift
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

// MARK: Commands
fileprivate struct Commands {
  /** Creates a scene instance from a given scene template */
  static let sceneTemplateCreate: String = "scenetmpl:Create"
  /** Resolves the actions that are applicable to a scene template. */
  static let sceneTemplateResolveActions: String = "scenetmpl:ResolveActions"
  
}

// MARK: Enumerations

// MARK: Requests

/** Creates a scene instance from a given scene template */
public class SceneTemplateCreateRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SceneTemplateCreateRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sceneTemplateCreate
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return SceneTemplateCreateResponse(message)
  }

  // MARK: CreateRequest Attributes
  struct Attributes {
    /** The platform-owned identifier for the place at which the scene is being created */
    static let placeId: String = "placeId"
/** Default: Name of the scene template.  The name assigned to the scene, defaults to the template name. */
    static let name: String = "name"
/** Default: Empty list.  A list of Actions for the scene to execute */
    static let actions: String = "actions"
 }
  
  /** The platform-owned identifier for the place at which the scene is being created */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** Default: Name of the scene template.  The name assigned to the scene, defaults to the template name. */
  public func setName(_ name: String) {
    attributes[Attributes.name] = name as AnyObject
  }

  
  /** Default: Empty list.  A list of Actions for the scene to execute */
  public func setActions(_ actions: [Any]) {
    attributes[Attributes.actions] = actions as AnyObject
  }

  
}

public class SceneTemplateCreateResponse: SessionEvent {
  
  
  /** The address of the created scene */
  public func getAddress() -> String? {
    return self.attributes["address"] as? String
  }
}

/** Resolves the actions that are applicable to a scene template. */
public class SceneTemplateResolveActionsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SceneTemplateResolveActionsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sceneTemplateResolveActions
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return SceneTemplateResolveActionsResponse(message)
  }

  // MARK: ResolveActionsRequest Attributes
  struct Attributes {
    /** The place id of the scene to resolve. */
    static let placeId: String = "placeId"
 }
  
  /** The place id of the scene to resolve. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class SceneTemplateResolveActionsResponse: SessionEvent {
  
  
  /** The resolved actions for the place and scene. */
  public func getActions() -> [Any]? {
    return self.attributes["actions"] as? [Any]
  }
}

