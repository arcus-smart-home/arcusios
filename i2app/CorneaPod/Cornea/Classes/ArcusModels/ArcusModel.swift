//
//  ArcusModel.swift
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

// TODO: Move PromiseKit-based commit to it's own Mixin
import PromiseKit
import RxSwift

/**
 `Dictionary` extension that allows for merging to dictionaries into one.
 */
extension Dictionary {
  mutating func merge(_ dictonary: [Key: Value]) {
    for (key, value) in dictonary {
      updateValue(value, forKey: key)
    }
  }

  mutating func outerLeftJoin(_ rightDictionary: [Key: Value]) {
    for (key, _) in rightDictionary {
      removeValue(forKey: key)
    }
  }
}

/**
 `ArcusModel` class protocol.  Conforms to `ArcusCapability`.
 */
public protocol ArcusModel: class {
  var modelId: String { get }
  var address: String { get }

  /**
   Set Attributes on `ArcusModel`.  Func will add modified attributes to changes dictionary.
   Requires call to `commit()` to persist changes.

   - Parameters:
   - attibutes: Dictionary of attributes to add.
   */

  func set(_ attributes: [String: AnyObject])

  /**
   Get Attributes of `ArcusModel`

   - Parameters:

   - Returns: Dictionary of model's attributes.
   */
  func get() -> [String: AnyObject]

  /**
   Get Attribute Value for Key.

   - Parameters:
   - key: `String` identifier of the value to lookup.

   - Returns: `AnyObject` value for the key provided.
   */
  func getAttribute(_ key: String) -> AnyObject?

  /**
   Update the model with attributes.  This method is intended only to be used by the modelCache when receiving
   a valueChangeEvent.

   - Parameters:
   - updatedAttributes: Dictionary of the Attributes to update.
   */
  func modelUpdated(_ updatedAttributes: [String: AnyObject])

  // TODO: Relocation to RxSwiftModel?
  /**
   Commit model changes to the platform.

   - Parameters:
   - changes: `[String: AnyObject]` of attributes to commit to the platform.

   - Returns: `Observable` that will return the response from the platform.
   */
  func commit(_ changes: [String: AnyObject]) -> Observable<BaseSetAttributesResponse>

  /**
   Commit model's current changes to the platform.

   - Returns: `Observable` that will return the response from the platform.
   */
  func commitChanges() -> Observable<BaseSetAttributesResponse>

  // TODO: Relocation to RxSwiftModel?
  /**
   Refresh the model attributes from the platform.

   - Parameters:
   - address: `String` address of the model being refreshed.  This param is only being required to temporarily
               differentiate this `refresh()` from `LegacyModel refresh() -> PMKPromise`.
   - Returns: `Observable` that will return the response from the platform.
   */
  func refresh(_ address: String) -> Observable<BaseGetAttributesResponse>
}

/**
 `ArcusModel` protocol extension.
 */
extension ArcusModel where Self: ArcusModelInternal {}

/**
 `ArcusModelInternal` protocol.  Used to define properties on the model not intended to be directly accessed by
 classes that interact with instances of `ArcusModel`
 */
public protocol ArcusModelInternal {
  var attributes: [String: AnyObject] { get set }
  var changes: [String: AnyObject] { get set }
}

let kModelRefreshedNotification: String = "ModelRefreshed"
let kModelChangedNotification: String = "ModelChanged"
let kAttributeChangedNotification: String = "AttributeChanged"

/**
 `LegacyModel` Protocol
 */
public protocol LegacyModel: class {
  /**
   Legacy Support: Commit model changes to the platform.

   - Returns: `PMKPromise`
   */
  func commit() -> PMKPromise

  /**
   Refresh the model attributes from the platform.

   - Returns: `PMKPromise`
   */
  func refresh() -> PMKPromise

  // MARK: EXTENDED

  /**
   Check if model hasAttributes.

   - Returns: `Bool` indicating if model has attributes.
   */
  func hasAttributes() -> Bool

  /**
   Get the address of a model based on namespace and modelId.
   (Used to support certain legacy model extensions.  Avoid usage if possible.)

   - Parameters:
   - namespace: `String` representing the model's namespace.

   - Returns: `String` representing the created address.
   */
  func getAddressForNamespace(_ namespace: String) -> String

  static func addressForNamespace(_ namespace: String, modelId: String) -> String
  static func modelIdForAddress(_ address: String) -> String

  func modelChangedNotification() -> String
  
  static func attributeChangedNotificationName(_ attribute: String) -> Notification.Name
  static func attributeChangedNotification(_ attribute: String) -> String
  static func tagChangedNotification(_ tag: String) -> String
}

public protocol LegacyModelNotifier {
  func addModelNotificationName() -> String
  func updateModelNotificationName() -> String
  static func addModelNotificationName() -> String
  static func updateModelNotificationName() -> String
}

extension LegacyModelNotifier {
  public func addModelNotificationName() -> String {
    return Self.addModelNotificationName()
  }

  public func updateModelNotificationName() -> String {
    return Self.addModelNotificationName()
  }

  static public func addModelNotificationName() -> String {
    return ""
  }

  static public func updateModelNotificationName() -> String {
    return ""
  }
}
