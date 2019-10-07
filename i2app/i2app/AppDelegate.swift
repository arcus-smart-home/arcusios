//
//  AppDelegateNew.swift
//  i2app
//
//  Created by Arcus Team on 11/14/17.
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
import RxSwift
import SDWebImage
import UserNotifications
import Cornea

/**
 i2App's iOS Application App Delegate
 */
class AppDelegate: NSObject {
  var window: UIWindow?
  
  fileprivate var inactiveBlockerView = UIView()
}

// MARK: UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {

  fileprivate var eventObservable: PublishSubject<ArcusApplicationServiceEvent> {
    return ApplicationServiceEventPublisher.shared.eventObservable
  }
  
  func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
    return false
  }

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
    -> Bool {
      // Create the initial window
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.makeKeyAndVisible()

      // Create and inject Legacy Controller into RxCornea
      let legacyController: ArcusLegacyLogic = ArcusLegacyObject()
      RxCornea.shared.legacyLogic = legacyController
      RxCornea.shared.session?.userAgent = BuildConfigure.clientAgentInfo()
      RxCornea.shared.session?.clientVersion = BuildConfigure.clientVersionInfo()


      // Send generate the first application event
      let event = ApplicationEvent(application,
                                   type: .finishedLaunching,
                                   payload: launchOptions)
      eventObservable.onNext(event)

      // Configure Navigation Bar
      NavigationBarAppearanceManager.sharedInstance.setup()

      // Configure SDImageChacheBar
      SDImageCache.shared().maxCacheAge = 60 * 60 * 24

      // Set up the application so that the audio emitted by a clip can be heard even if the device is in
      // silent mode.
      do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      } catch {
        DDLogError("Application could not set AVAudioSession category to AVAudioSessionCategoryPlayback")
      }
      
      return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    let event = ApplicationEvent(application,
                                 type: .willResignActive)
    eventObservable.onNext(event)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    let event = ApplicationEvent(application,
                                 type: .didEnterBackground)
    eventObservable.onNext(event)
    
    if let window = window {
      inactiveBlockerView = UIView(frame: window.frame)
      inactiveBlockerView.backgroundColor = UIColor.white
      window.addSubview(inactiveBlockerView)
    }
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    let event = ApplicationEvent(application,
                                 type: .willEnterForeground)
    eventObservable.onNext(event)
    
    inactiveBlockerView.removeFromSuperview()
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    let event = ApplicationEvent(application,
                                 type: .didBecomeActive)
    eventObservable.onNext(event)
  }

  func applicationWillTerminate(_ application: UIApplication) {
    let event = ApplicationEvent(application,
                                 type: .willTerminate)
    eventObservable.onNext(event)
  }

  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let event = ApplicationEvent(application,
                                 type: .didRegisterForRemoteNotifications,
                                 payload: deviceToken)
    eventObservable.onNext(event)
  }

  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let event = ApplicationEvent(application,
                                 type: .didReceiveRemoteNotification,
                                 payload: userInfo)
    eventObservable.onNext(event)

    completionHandler(UIBackgroundFetchResult.newData)
  }

  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
    let event = ApplicationEvent(application,
                                 type: .didFailRegisterForRemoteNotifications,
                                 payload: error)
    eventObservable.onNext(event)
  }

  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    let event = ApplicationEvent(application,
                                 type: .didReceiveMemoryWarning)
    eventObservable.onNext(event)
  }

  public func application(_ application: UIApplication,
                          continue userActivity: NSUserActivity,
                          restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    let event = ApplicationEvent(application,
                                 type: .continueUserActivity,
                                 payload: userActivity)
    eventObservable.onNext(event)

    return true
  }
}

// MARK: UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  @available(iOS 10.0, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let event = ApplicationEvent(UIApplication.shared,
                                 type: .userNotificationCenterDidReceiveResponse,
                                 payload: response)
    eventObservable.onNext(event)
  }

  @available(iOS 10.0, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler
    completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let event = ApplicationEvent(UIApplication.shared,
                                 launchOptions: nil,
                                 type: .userNotificationCenterWillPresentNotification,
                                 payload: notification)
    eventObservable.onNext(event)
  }
}
