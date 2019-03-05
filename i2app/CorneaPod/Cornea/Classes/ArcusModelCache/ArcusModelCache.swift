//
//  ArcusModelCache.swift
//  i2app
//
//  Created by Arcus Team on 7/13/17.
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

public protocol ArcusModelCache: class {
  var models: [String: ArcusModel] { get set }
  var modelAccessQueue: DispatchQueue { get }

  /**
   Add model to the cache.

   - Parameters:
   - model: `ArcusModel` to add to the cache.
   */
  func addModel(_ model: ArcusModel)

  /**
   Add models to the cache.

   - Parameters:
   - model: Array of `ArcusModel` to add to the cache.
   */
  func addModels(_ models: [ArcusModel])

  /**
   Add model to the cache.

   - Parameters:
   - model: variadic `ArcusModels` to add to the cache.
   */
  func addModels(_ models: ArcusModel...)

  /**
   Update existing model in the cache.

   - Parameters:
   - address: `String` of existing `ArcusModel` to update in the cache.
   - changes: Dictionary of changes to make.
   */
  func updateModel(_ address: String, changes: [String: AnyObject])

  /**
   Delete model from the cache.

   - Parameters:
   - address: `String` address of existing `ArcusModel` to delete from the cache.
   */
  func deleteModel(_ address: String)

  /**
   Fetch model from the cache.

   - Parameters:
   - address: `String` address of the `ArcusModel` to fetch.

   - Returns: Optional `ArcusModel` for the supplied address.
   */
  func fetchModel(_ address: String) -> ArcusModel?

  /**
   Fetch models for the given type.

   - Parameters:
   - type: `String` of the namespace of `[ArcusModel]` to return.

   - Returns: Optional `[ArcusModel]` for the supplied type.
   */
  func fetchModels(_ namespace: String) -> [ArcusModel]?

  // TODO: Determine if necessary

  /**
   Clear the cache of all models.
   */
  func flush()
}

public protocol LegacyModelCache: class {
  var oldModelsDictionary: [String: AnyObject] { get set }
}
