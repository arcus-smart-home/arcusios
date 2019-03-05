//
//  ArcusNotificationConverter.swift
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

public protocol ArcusNotifiableEvent {
  var notificationName: Notification.Name { get }
  var notificationObject: Any? { get }
  var notificationInfo: [AnyHashable: Any]? { get }
}

extension ArcusNotifiableEvent {
  public var notificationObject: Any? {
    return nil
  }

  public var notificationInfo: [AnyHashable: Any]? {
    return nil
  }
}

public protocol ArcusNotificationConverter {
  // EXTENDED
  func notifyForEvent(_ event: ArcusNotifiableEvent)
}

extension ArcusNotificationConverter {
  public func notifyForEvent(_ event: ArcusNotifiableEvent) {
    notify(event, notificationCenter: NotificationCenter.default)
  }

  fileprivate func notificationForEvent(_ event: ArcusNotifiableEvent) -> Notification {
    if let model = event.notificationObject as? ArcusModel {
      return Notification(name: event.notificationName,
                          object: model,
                          userInfo: event.notificationInfo)
    }
    return Notification(name: event.notificationName,
                        object: event.notificationObject,
                        userInfo: event.notificationInfo)
  }

  fileprivate func notify(_ event: ArcusNotifiableEvent, notificationCenter: NotificationCenter) {
    notificationCenter.post(notificationForEvent(event))
  }
}
