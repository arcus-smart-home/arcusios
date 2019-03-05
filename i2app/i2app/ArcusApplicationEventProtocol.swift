//
//  ArcusApplicationServiceEvent.swift
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

/**

 */
enum ApplicationEventType {
  case finishedLaunching
  case willResignActive
  case didEnterBackground
  case willEnterForeground
  case didBecomeActive
  case willTerminate
  case didRegisterForRemoteNotifications
  case didReceiveRemoteNotification
  case didFailRegisterForRemoteNotifications
  case userNotificationCenterDidReceiveResponse
  case userNotificationCenterWillPresentNotification
  case didReceiveMemoryWarning
  case continueUserActivity
}

/**

 */
protocol ArcusApplicationServiceEvent {

  /**

   */
  var application: UIApplication { get }

  /**

   */
  var launchOptions: [UIApplicationLaunchOptionsKey: Any]? { get }

  /**

   */
  var type: ApplicationEventType { get }

  /**

   */
  var payload: Any? { get }

}
