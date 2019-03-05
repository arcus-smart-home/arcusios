//
//  DeviceViewControllerFactory.swift
//  i2app
//
//  Created by Arcus Team on 6/14/17.
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

protocol DeviceViewControllerFactory {
  /*
   static variable that can be used specify the storyboard used by a specific factory.
   **/
  static var storyboard: UIStoryboard { get }

  /* 
   Used to determine which viewController should be loaded based on storyboard and device.

   Implementation Example: `DeviceDetailsViewControllerFactory`

   - Parameters:
   - storyboard: The storyboard used to create the viewController
   - device: The DeviceModel used to create the viewController

   - Returns: The UIViewController to be loaded.
   **/
  static func viewController(_ storyboard: UIStoryboard,
                             device: DeviceModel) -> UIViewController
}
