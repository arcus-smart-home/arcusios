//
//  Cornea.swift
//  i2app
//
//  Created by Arcus Team on 7/14/17.
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
//

import Foundation

public protocol Cornea {
  var session: ArcusSession? { get set }
  var modelCache: ArcusModelCache? { get set }
  var cacheLoader: ArcusModelCacheLoader? { get set }
  var settings: ArcusSettings? { get set }
  var legacyLogic: ArcusLegacyLogic? { get set }

  /**
   Create Application Services.  Intended to be called on start up. "Application Services" refer to
   classes that need to live in memory, and might need to observe `ArcusApplicationServiceProtocol` events.
   */
//  func createApplicationServices()
}
