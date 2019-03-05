//
//  SessionEvents.swift
//  i2app
//
//  Created by Arcus Team on 8/16/17.
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

// TODO: Add better docs.
/**
 `SessionCreatedEvent` struct
 */
public struct SessionCreatedEvent: ArcusSessionEvent, ArcusNotifiableEvent {
  public var type: String = ""
  public var source: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()
  public var correlationId: String = ""

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.init(rawValue: "SessionCreated")
  }

  public init() {}
}

/**
 `SessionEndedEvent` struct
 */
public struct SessionEndedEvent: ArcusSessionEvent, ArcusNotifiableEvent {
  public var type: String = ""
  public var source: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()
  public var correlationId: String = ""

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.init(rawValue: "SessionEnded")
  }

  public init() {}
}

/**
 `SessionMessageEvent` struct
 */
public struct SessionMessageEvent: ArcusSessionEvent, ArcusNotifiableEvent {
  public var type: String = ""
  public var source: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()
  public var correlationId: String = ""

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.init(rawValue: "")
  }

  public init() {}
}

/**
 `SessionModelChangeEvent` struct
 */
public struct SessionModelChangeEvent: ArcusSessionEvent {
  public var type: String = ""
  public var source: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()
  public var correlationId: String = ""

  public init() {}
}

/**
 `SessionActivePlaceClearedEvent` struct

 Event to the client when an active place is removed from the list of available places
 */
public struct SessionActivePlaceClearedEvent: ArcusSessionEvent, ArcusNotifiableEvent {
  public var type: String = ""
  public var source: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()
  public var correlationId: String = ""
  public var placeId: String? {
    if let placeId = attributes["placeId"] as? String {
      return placeId
    } else {
      return nil
    }
  }

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.init(rawValue: "ActivePlaceCleared")
  }

  public init() {}
}

/**
 `SessionActivePlaceClearedEvent` struct

 Event to the client when an active place is removed from the list of available places
 */
public struct SessionSettingActivePlaceEvent: ArcusSessionEvent, ArcusNotifiableEvent {
  public var type: String = ""
  public var source: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()
  public var correlationId: String = ""
  public var placeId: String = ""

  public init() {}
  
  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.placeChanged
  }

  public var notificationObject: Any? {
    return placeId
  }

  public init(placeId: String) {
    self.placeId = placeId
  }
}

/**
 `SessionErrorEvent` struct
 */
public struct SessionErrorEvent: ArcusSessionEvent, ArcusErrorEvent {
  public var type: String = ""
  public var source: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()
  public var correlationId: String = ""
  public var error: Error = ClientError(errorType: .unknown)

  public init() {}

  public init(_ message: ArcusClientMessage, error: Error? = nil) {
    self.init()
    self.type = message.type
    self.source = message.source
    self.attributes = message.attributes
    self.correlationId = message.correlationId

    if let error = error {
      self.error = error
    }
  }

  public func getErrorCode() -> String? {
    guard let code = attributes["code"] as? String else {
      return nil
    }
    return code
  }

  public func getErrorMessage() -> String? {
    guard let message = attributes["message"] as? String else {
      return nil
    }
    return message
  }
}
