//
//  ApptentiveAnalyticsEndpoint.swift
//  i2app
//
//  Arcus Team on 12/1/16.
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

@objc class ApptentiveAnalyticsEndpoint: NSObject, AnalyticsEndpoint {

  var registered = false

  func commitTag (_ name: String, attributes: [String:AnyObject]) {

    if !registered {
      let alarmStateChangeSelector = #selector(ApptentiveAnalyticsEndpoint.onAlarmStateChanged(_:))
      NotificationCenter.default.addObserver(self,
                                             selector: alarmStateChangeSelector,
                                             name: Notification.Name.activeAlarmIncidentChanged,
                                             object: nil)
      registered = true
    }
  }

  func onAlarmStateChanged(_ note: Notification) {

  }
  
  private func displayingViewController(inViewController viewController: UIViewController? = nil)
    -> UIViewController? {
      var root = viewController
      
      if root == nil {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        root = delegate?.window?.rootViewController
      }
      
      if let navigationController = root as? UINavigationController {
        return displayingViewController(inViewController: navigationController.visibleViewController)
      }
      if let tabController = root as? UITabBarController,
        let selected = tabController.selectedViewController {
        return displayingViewController(inViewController: selected)
      }
      if let presented = root?.presentedViewController {
        return displayingViewController(inViewController: presented)
      }
      
      return root
  }
}
