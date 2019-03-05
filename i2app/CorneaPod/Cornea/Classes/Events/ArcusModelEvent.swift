//
//  ArcusModelEvent.swift
//  i2app
//
//  Created by Arcus Team on 8/14/17.
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

public protocol ArcusModelEvent: ArcusEvent {
  var address: String { get set }
}

public struct ModelUpdateAttributesEvent: ArcusModelEvent {
  public var address: String
  public var changes: [String: AnyObject]

  public init(_ address: String, changes: [String: AnyObject]) {
    self.address = address
    self.changes = changes
  }
}

public struct ModelSetAttributesEvent: ArcusModelEvent {
  public var address: String
  public var attributes: [String: AnyObject]

  public init(_ address: String, attributes: [String: AnyObject]) {
    self.address = address
    self.attributes = attributes
  }
}

public struct ModelRefreshEvent: ArcusModelEvent, ArcusNotifiableEvent {
  public var address: String
  public var model: ArcusModel
  public var changes: [String: AnyObject]

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name = Notification.Name.modelRefresh

  public init(_ address: String, model: ArcusModel, changes: [String: AnyObject]) {
    self.address = address
    self.model = model
    self.changes = changes
  }
}
