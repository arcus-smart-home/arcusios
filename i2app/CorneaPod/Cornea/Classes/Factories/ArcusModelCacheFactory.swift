//
//  ArcusModelCacheFactory.swift
//  i2app
//
//  Created by Arcus Team on 7/24/17.
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

public protocol ArcusModelCacheFactory: ArcusFactory {
  /*
   Create instance of class conforming to `ArcusModelCache`

   - Parameters
   - session: `ArcusSession` used to get cache related events.

   - Returns: Created instance of `ArcusModelCache`
   **/
  static func createArcusModelCache(_ session: ArcusSession) -> ArcusModelCache
}
