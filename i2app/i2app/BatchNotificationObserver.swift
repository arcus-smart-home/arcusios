//
//  BatchNotificationObserver.swift
//  i2app
//
//  Created by Arcus Team on 3/7/17.
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

protocol BatchNotificationObserver: class {
  // Extended.
  func observeBatchNotifications(_ notificationStrings: [String], selector: Selector)
  func observeBatchNotifications(_ notifications: [Notification.Name], selector: Selector)
  func removeBatchtNotificationObservers(_ notificationNames: [Notification.Name])
  func removeAllBatchNotificationObservers()
}

extension BatchNotificationObserver {
  func observeBatchNotifications(_ notificationsStrings: [String], selector: Selector) {
    for notification in notificationsStrings {
      NotificationCenter.default.addObserver(self,
                                             selector: selector,
                                             name: Notification.Name(rawValue: notification),
                                             object: nil)
    }
  }

  func observeBatchNotifications(_ notifications: [Notification.Name], selector: Selector) {
    for notification in notifications {
      NotificationCenter.default
        .addObserver(self,
                     selector: selector,
                     name: notification,
                     object: nil)
    }
  }

  func removeBatchtNotificationObservers(_ notificationNames: [Notification.Name]) {
    for name in notificationNames {
      NotificationCenter.default
        .removeObserver(self, name: name, object: nil)
    }
  }

  func removeAllBatchNotificationObservers() {
    NotificationCenter.default.removeObserver(self)
  }
}
