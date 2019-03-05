//
//  ArcusPopupAnimatable.swift
//  i2app
//
//  Created by Arcus Team on 1/22/18.
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

/// ArcusPopupAnimatable denotes that the ViewController contains the required views
/// to animate in a transition to a popover layout
/// These views will not be accessed until after the view has been created
/// and added to a super view
protocol ArcusPopupAnimatable: UIViewControllerTransitioningDelegate {
  var backgroundView: UIView! { get }
  var popoverView: UIView! { get }
  var animationController: ArcusPopupAnimationController { get }
}
