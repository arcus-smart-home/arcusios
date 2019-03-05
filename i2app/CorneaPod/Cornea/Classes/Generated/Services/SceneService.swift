
//
// SceneService.swift
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
  public static let sceneServiceNamespace: String = "scene"
  public static let sceneServiceName: String = "SceneService"
  public static let sceneServiceAddress: String = "SERV:scene:"
}

/** Entry points for the scene service, which covers global operations such as listing scenes or scene templates for places. */
public protocol ArcusSceneService: RxArcusService {
  /** Lists all scenes defined for a given place */
  func requestSceneServiceListScenes(_ placeId: String) throws -> Observable<ArcusSessionEvent>/** Lists all the scene templates available for a given place */
  func requestSceneServiceListSceneTemplates(_ placeId: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusSceneService {
  public func requestSceneServiceListScenes(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: SceneServiceListScenesRequest = SceneServiceListScenesRequest()
    request.source = Constants.sceneServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestSceneServiceListSceneTemplates(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: SceneServiceListSceneTemplatesRequest = SceneServiceListSceneTemplatesRequest()
    request.source = Constants.sceneServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  
}
