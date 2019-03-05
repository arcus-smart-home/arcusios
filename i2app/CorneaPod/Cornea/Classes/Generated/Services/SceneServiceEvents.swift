
//
// SceneServiceEvents.swift
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
  /** Lists all scenes defined for a given place */
  public static let sceneServiceListScenes: String = "scene:ListScenes"
  /** Lists all the scene templates available for a given place */
  public static let sceneServiceListSceneTemplates: String = "scene:ListSceneTemplates"
  
}

// MARK: Requests

/** Lists all scenes defined for a given place */
public class SceneServiceListScenesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SceneServiceListScenesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sceneServiceListScenes
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
    return SceneServiceListScenesResponse(message)
  }
  // MARK: ListScenesRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class SceneServiceListScenesResponse: SessionEvent {
  
  
  /** The scenes */
  public func getScenes() -> [Any]? {
    return self.attributes["scenes"] as? [Any]
  }
}

/** Lists all the scene templates available for a given place */
public class SceneServiceListSceneTemplatesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SceneServiceListSceneTemplatesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.sceneServiceListSceneTemplates
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
    return SceneServiceListSceneTemplatesResponse(message)
  }
  // MARK: ListSceneTemplatesRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class SceneServiceListSceneTemplatesResponse: SessionEvent {
  
  
  /** The scene templates */
  public func getSceneTemplates() -> [Any]? {
    return self.attributes["sceneTemplates"] as? [Any]
  }
}

