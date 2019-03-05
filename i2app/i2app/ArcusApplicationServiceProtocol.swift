//
//  ArcusApplicationServiceProtocol.swift
//  i2app
//
//  Created by Arcus Team on 10/25/17.
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
import Cornea
import RxSwift

/**
 Protocol defining what is needed to be an Application Service, An RxSwift way of getting application
 events from the App Delegate. This method however is testable and requires very little overhead
 in the UIApplicationDelegate. All of the functions in this protocol are exteneded with NoOps so
 conforming objects are not required to implement functions they do not need.

 UNUserNotificationCenterDelegate has also been included in the functionality to handle iOS 10
 Notification events
 */
protocol ArcusApplicationServiceProtocol: class {

  /**
   Dispose bag required for the observables
   */
  var disposeBag: DisposeBag { get }

  // MARK: Extended

  /**
   Called on setup
   */
  func observeApplicationEvents(_ eventPublisher: ArcusApplicationServiceEventPublisher)

  /**
   Emmited at UIApplicationDelegate function:

   ```
      func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
   ```

   - Parameter event: will have the launch options

   */
  func serviceDidFinishLaunching(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func applicationWillResignActive(_ application: UIApplication)
   ```
   */
  func serviceWillResignActive(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func applicationDidEnterBackground(_ application: UIApplication)
   ```
   */
  func serviceDidEnterBackground(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func applicationWillEnterForeground(_ application: UIApplication)
   ```
   */
  func serviceWillEnterForeground(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func applicationDidBecomeActive(_ application: UIApplication)
   ```
   */
  func serviceDidBecomeActive(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func applicationWillTerminate(_ application: UIApplication)
   ```
   */
  func serviceWillTerminate(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func applicationDidReceiveMemoryWarning(_ application: UIApplication)
   ```
   */
  func serviceDidReceiveApplicationMemoryWarning(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func application(_ application: UIApplication,
   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
   ```

   - Parameter event: will have the device token in the payload

   */
  func serviceDidRegisterForRemoteNotifications(_ event: ArcusApplicationServiceEvent)
  

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func application(_ application: UIApplication,
   didReceiveRemoteNotification userInfo: [AnyHashable : Any],
   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
   ```

   - Parameter event: will have the userInfo in the payload
   */
  func serviceDidReceiveRemoteNotifications(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UIApplicationDelegate function:

   ```
   func application(_ application: UIApplication,
   didFailToRegisterForRemoteNotificationsWithError error: Error) 
   ```
   - Parameter event: will have the error in the payload
   */
  func serviceDidFailRegisterForRemoteNotifications(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UNUserNotificationCenterDelegate function:

   ```
   func userNotificationCenter(_ center: UNUserNotificationCenter,
   didReceive response: UNNotificationResponse,
   withCompletionHandler completionHandler: @escaping () -> Void) 
   ```
   - Parameter event: will have the response in the payload
   */
  func serviceUserNotificationCenterDidReceiveResponse(_ event: ArcusApplicationServiceEvent)

  /**
   Emmited at UNUserNotificationCenterDelegate function:

   ```
   func userNotificationCenter(_ center: UNUserNotificationCenter,
   willPresent notification: UNNotification,
   withCompletionHandler
   completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
   ```
   - Parameter event: will have the notification in the payload
   */
  func serviceUserNotificationCenterWillPresentNotification(_ event: ArcusApplicationServiceEvent)

  /**

   */
  func serviceContinueUserActivity(_ event: ArcusApplicationServiceEvent)

}

extension ArcusApplicationServiceProtocol {
  func serviceDidFinishLaunching(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceWillResignActive(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceDidEnterBackground(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceWillEnterForeground(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceDidBecomeActive(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceWillTerminate(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceDidRegisterForRemoteNotifications(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceDidFailRegisterForRemoteNotifications(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceUserNotificationCenterDidReceiveResponse(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceUserNotificationCenterWillPresentNotification(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceDidReceiveRemoteNotifications(_ event: ArcusApplicationServiceEvent) {

  }

  func serviceDidReceiveApplicationMemoryWarning(_ event: ArcusApplicationServiceEvent) {
    DDLogError("ArcusApplicationServiceProtocol serviceDidReceiveApplicationMemoryWarning")
  }

  func serviceContinueUserActivity(_ event: ArcusApplicationServiceEvent) {
    DDLogError("ArcusApplicationServiceProtocol serviceContinueUserActivity")
  }

  func observeApplicationEvents(_ eventServer: ArcusApplicationServiceEventPublisher) {
    eventServer.getApplicationEvents()
      .subscribe(onNext: { [weak self] event in
        switch event.type {
        case .finishedLaunching:
          self?.serviceDidFinishLaunching(event)
        case .willResignActive:
          self?.serviceWillResignActive(event)
        case .didEnterBackground:
          self?.serviceDidEnterBackground(event)
        case .willEnterForeground:
          self?.serviceWillEnterForeground(event)
        case .didBecomeActive:
          self?.serviceDidBecomeActive(event)
        case .willTerminate:
          self?.serviceWillTerminate(event)
        case .didRegisterForRemoteNotifications:
          self?.serviceDidRegisterForRemoteNotifications(event)
        case .didReceiveRemoteNotification:
          self?.serviceDidReceiveRemoteNotifications(event)
        case .didFailRegisterForRemoteNotifications:
          self?.serviceDidFailRegisterForRemoteNotifications(event)
        case .userNotificationCenterDidReceiveResponse:
          self?.serviceUserNotificationCenterDidReceiveResponse(event)
        case .userNotificationCenterWillPresentNotification:
          self?.serviceUserNotificationCenterWillPresentNotification(event)
        case .didReceiveMemoryWarning:
          self?.serviceDidReceiveApplicationMemoryWarning(event)
        case .continueUserActivity:
          self?.serviceContinueUserActivity(event)
        }
      })
      .addDisposableTo(disposeBag)
  }
}
