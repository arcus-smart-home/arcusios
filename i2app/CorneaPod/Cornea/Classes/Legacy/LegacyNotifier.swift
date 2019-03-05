//
//  LegacyNotifier.swift
//  i2app
//
//  Created by Arcus Team on 12/11/17.
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

public protocol ArcusLegacyNotifier {
  static func publishModelChangedNotifications(_ updatedAttributes: [String: AnyObject],
                                               name: String,
                                               model: ArcusModel)
  static func publishAttributeChangeNotification(_ updatedAttributes: [String: AnyObject], model: ArcusModel)
  static func processTagChangeNotifications(_ updatedAttributes: [String: AnyObject],
                                            attributes: [String: AnyObject])
  
}

public class LegacyNotifier: ArcusLegacyNotifier {
  class ModelFactory: ArcusModelFactory {}

  public static func publishModelChangedNotifications(_ updatedAttributes: [String: AnyObject],
                                               name: String,
                                               model: ArcusModel) {
    for (key, value) in updatedAttributes {
      let notificationName: Notification.Name = Notification.Name(rawValue: name)
      let object: [String: AnyObject] = [key: value]
      let userInfo: [String: AnyObject] = [Constants.kModel: model as AnyObject]
      NotificationCenter.default
        .post(name: notificationName, object: object, userInfo: userInfo)
    }
  }

  public static func publishAttributeChangeNotification(_ updatedAttributes: [String: AnyObject], model: ArcusModel) {
    for (key, value) in updatedAttributes {
      var anyValue = value
      if let int64Value = value as? Int64 {
        anyValue = NSNumber(value: int64Value)
      }
      let name: String = RxArcusModel.attributeChangedNotification(key)
      let notificationName: Notification.Name = Notification.Name(rawValue: name)
      let userInfo: [String: AnyObject] = [Constants.kModel: model as AnyObject]
      NotificationCenter.default
        .post(name: notificationName, object: [key: anyValue], userInfo: userInfo)
    }
  }

  public static func processTagChangeNotifications(_ updatedAttributes: [String: AnyObject],
                                            attributes: [String: AnyObject]) {
    if let updatedTags = updatedAttributes["base:tags"] as? [String] {
      if let currentTags = attributes["base:tags"] as? [String] {
        // Tag was deleted
        publishTagRemovedNotification(currentTags, updatedTags: updatedTags,
                                      model: ModelFactory().build(attributes))
        // Notify for updated tags
        publishTagUpdatedNotification(updatedTags, model: ModelFactory().build(attributes))
      }
    }
  }

  // MARK: Private Functions

  private static func publishTagRemovedNotification(_ currentTags: [String], updatedTags: [String], model: ArcusModel) {
    for tag in currentTags {
      if updatedTags.contains(where: { $0 == tag }) == false {
        // Notify for deleted tag
        let name: String = RxArcusModel.tagChangedNotification(tag)
        let notificationName: Notification.Name = Notification.Name(rawValue: name)
        let object: [String: AnyObject] = ["base:tags": tag as AnyObject]
        let userInfo: [String: AnyObject] = [Constants.kModel: model as AnyObject]
        NotificationCenter.default
          .post(name: notificationName, object: object, userInfo: userInfo)
      }
    }
  }

  private static func publishTagUpdatedNotification(_ updatedTags: [String], model: ArcusModel) {
    for tag in updatedTags {
      let name: String = RxArcusModel.tagChangedNotification(tag)
      let notificationName: Notification.Name = Notification.Name(rawValue: name)
      let object: [String: AnyObject] = ["base:tags": tag as AnyObject]
      let userInfo: [String: AnyObject] = [Constants.kModel: model as AnyObject]
      NotificationCenter.default
        .post(name: notificationName, object: object, userInfo: userInfo)
    }
  }
}

