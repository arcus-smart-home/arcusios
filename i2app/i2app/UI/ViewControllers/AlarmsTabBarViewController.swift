//
//  AlarmsTabBarViewController.swift
//  i2app
//
//  Created by Arcus Team on 12/12/16.
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

import UIKit

class AlarmsTabBarViewController: UITabBarController, ArcusTabBarDataSource {

  // MARK: View Life Cycle
  internal static func create() -> AlarmsTabBarViewController? {
    let storyboard = UIStoryboard(name: "AlarmTabs", bundle: nil)
    guard let tabBarController = storyboard
      .instantiateInitialViewController() as? AlarmsTabBarViewController else {
        return nil
    }
    return tabBarController
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    hideTabBar()
    hidesBottomBarWhenPushed = true
    viewControllers = tabViewControllers()
    configureNavigationBar()
    configureBackgroundView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.configureNavigationBar()
  }

  func tabViewControllers() -> [UIViewController] {
    let statusStoryboard = UIStoryboard(name: "AlarmStatus", bundle: nil)
    let activityStoryboard = UIStoryboard(name: "AlarmActivity", bundle: nil)
    let moreStoryboard = UIStoryboard(name: "AlarmMore", bundle: nil)

    if let alarmStatusViewController = statusStoryboard.instantiateInitialViewController(),
      let alarmActivityViewController = activityStoryboard.instantiateInitialViewController(),
      let alarmMoreViewController = moreStoryboard.instantiateInitialViewController() {
      return [alarmStatusViewController,
              alarmActivityViewController,
              alarmMoreViewController]
    }
    return []
  }

  func configureNavigationBar() {
    navBar(withBackButtonAndTitle: navigationItem.title)
  }

  func configureBackgroundView() {
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
  }
}
