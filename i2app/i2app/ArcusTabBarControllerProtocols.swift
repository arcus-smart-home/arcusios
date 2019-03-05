//
//  ArcusTabBarControllerProtocols.swift
//  i2app
//
//  Created by Arcus Team on 1/4/17.
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

protocol ArcusTabBarDataSource {
    func hideTabBar()
    func tabViewControllers() -> [UIViewController]
}

extension ArcusTabBarDataSource where Self: UITabBarController {
    func hideTabBar() {
        self.tabBar.isHidden = true
    }
}

protocol ArcusTabBarComponent {
    var segmentedControl: ArcusSegmentedControl! { get set }

    func configureSegmentedControl(_ tabBarController: UITabBarController?)
    func setSelectedSegment(_ index: Int)
    func tabSegmentedControlValueChanged(_ sender: AnyObject)
}

extension ArcusTabBarComponent where Self: UIViewController {
    func configureSegmentedControl(_ tabBarController: UITabBarController?) {
        if tabBarController != nil {
            setSelectedSegment(tabBarController!.selectedIndex)
        }
    }

    func setSelectedSegment(_ index: Int) {
        segmentedControl.selectedSegmentIndex = index
    }

    func tabSegmentedControlValueChanged(_ sender: AnyObject) {
        guard let segmentedControl: ArcusSegmentedControl = sender as? ArcusSegmentedControl else {
            return
        }

        if tabBarController != nil {
            tabBarController!.selectedIndex = segmentedControl.selectedSegmentIndex
        }
    }
}
