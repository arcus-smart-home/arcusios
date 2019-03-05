//
//  CameraTabBarViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/3/17.
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

class CameraTabBarViewController: UITabBarController, ArcusTabBarDataSource {
  
  // MARK: View Life Cycle
  internal static func create() -> CameraTabBarViewController? {
    let storyboard = UIStoryboard(name: "CameraCard", bundle: nil)
    guard let tabBarController = storyboard
      .instantiateInitialViewController() as? CameraTabBarViewController else {
        return nil
    }
    return tabBarController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideTabBar()
    hidesBottomBarWhenPushed = true
    configureNavigationBar()
    configureBackgroundView()
  }
  
  func tabViewControllers() -> [UIViewController] {
    return self.viewControllers!
  }
  
  func configureNavigationBar() {
    navBar(withBackButtonAndTitle: navigationItem.title)
  }
  
  func configureBackgroundView() {
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
  }
}
