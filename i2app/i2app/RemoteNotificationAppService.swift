//
//  RemoteNotificationAppService.swift
//  i2app
//
//  Created by Arcus Team on 11/15/17.
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

import RxSwift
import UserNotifications
import Cornea

/**

 */
class RemoteNotificationAppService: ArcusApplicationServiceProtocol, DeviceTokenController {
  var disposeBag: DisposeBag = DisposeBag()

  /**

   */
  required init(eventPublisher: ArcusApplicationServiceEventPublisher) {
    observeApplicationEvents(eventPublisher)
  }

  func serviceDidFinishLaunching(_ event: ArcusApplicationServiceEvent) {
    let optionKey = UIApplicationLaunchOptionsKey.remoteNotification
    let application = UIApplication.shared

    RemoteNotificationHandler.shared.registerForRemoteNotifications(UIApplication.shared)

    guard let launchOptions = event.payload as? [UIApplicationLaunchOptionsKey: Any],
      let appDelegate = application.delegate as? AppDelegate,
      let userInfo = launchOptions[optionKey] as? [AnyHashable: Any],
      let rootViewController = appDelegate.window?.rootViewController else {
        return
    }

    RemoteNotificationHandler.shared.processRemoteNotification(application,
                                                               userInfo: userInfo,
                                                               rootViewController: rootViewController)
  }

  func serviceDidRegisterForRemoteNotifications(_ event: ArcusApplicationServiceEvent) {
    guard let deviceToken = event.payload as? NSData else {
      return
    }

    let token = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
    saveDeviceToken(token)
  }

  func serviceDidReceiveRemoteNotifications(_ event: ArcusApplicationServiceEvent) {
    guard let userInfo = event.payload as? [AnyHashable : Any],
      let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let root = appDelegate.window?.rootViewController else {
        return
    }

    RemoteNotificationHandler.shared.processRemoteNotification(event.application,
                                                               userInfo: userInfo,
                                                               rootViewController: root)
  }

  func serviceDidFailRegisterForRemoteNotifications(_ event: ArcusApplicationServiceEvent) {
    DDLogWarn("Failed to register remove notification.")
  }

  func serviceUserNotificationCenterWillPresentNotification(_ event: ArcusApplicationServiceEvent) {
    if #available(iOS 10.0, *) {
      guard let notification = event.payload as? UNNotification,
        let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let root = appDelegate.window?.rootViewController else {
          return
      }

      let userInfo = notification.request.content.userInfo

      RemoteNotificationHandler.shared.processRemoteNotification(event.application,
                                                                 userInfo: userInfo,
                                                                 rootViewController: root)
    }
  }
}
