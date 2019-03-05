//
//  ModelCacheEvents.swift
//  i2app
//
//  Created by Arcus Team on 8/9/17.
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

extension Constants {
  public static let kService: String = "SERV"
  public static let kDriv: String = "DRIV"
  public static let kModel: String = "Model"

  public static let kModelAddedNotification: String = "ModelAddedNotification"
  public static let kModelErrorNotification: String = "ModelErrorNotification"
  public static let kModelRemovedNotification: String = "ModelRemovedNotification"
  public static let kModelRefreshedNotification: String = "ModelRefreshedNotification"
}

extension Notification.Name {
  public static let modelAdded = Notification.Name(Constants.kModelAddedNotification)
  public static let modelDeleted = Notification.Name(Constants.kModelRemovedNotification)
  public static let modelError = Notification.Name(Constants.kModelErrorNotification)
  public static let modelRefresh = Notification.Name(Constants.kModelRefreshedNotification)
}

public struct ModelAddedEvent: ArcusModelCacheEvent, ArcusNotifiableEvent {
  public var address: String
  public var model: ArcusModel

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.modelAdded
  }

  public var notificationObject: Any? {
    return model
  }

  public init(_ address: String, model: ArcusModel) {
    self.address = address
    self.model = model
  }
}

public struct ModelUpdatedEvent: ArcusModelCacheEvent, ArcusNotifiableEvent {
  public var address: String
  public var model: ArcusModel
  public var changes: [String: AnyObject]

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.init(rawValue: "")
  }

  public init(_ address: String, model: ArcusModel, changes: [String: AnyObject]) {
    self.address = address
    self.model = model
    self.changes = changes
  }
}

public struct ModelDeletedEvent: ArcusModelCacheEvent, ArcusNotifiableEvent {
  public var address: String
  public var model: ArcusModel?
  public var success: Bool

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name = Notification.Name.modelDeleted

  public var notificationObject: Any? {
    return model
  }

  public init(_ address: String, model: ArcusModel? = nil, success: Bool) {
    self.address = address
    self.model = model
    self.success = success
  }
}

public struct ModelErrorEvent: ArcusModelCacheEvent, ArcusNotifiableEvent {
  public var address: String
  public var error: Error?

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.modelError
  }

  public init(_ address: String, error: Error?) {
    self.address = address
    self.error = error
  }
}

public struct ModelCacheFlushedEvent: ArcusModelCacheEvent {
  public var address: String = ""
}

