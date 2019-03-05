//
//  CatalogNavigationControllerDelegate.swift
//  i2app
//
//  Created by Arcus Team on 2/23/18.
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

/// Class to handle the unique transitions needed for Pairing
/// NSObject subclass so we can create it in storyboards
class CatalogNavigationControllerDelegate: NSObject {
  var animator: UIViewControllerAnimatedTransitioning?
}

extension CatalogNavigationControllerDelegate: UINavigationControllerDelegate {

  func navigationController(_ navigationController: UINavigationController,
                            animationControllerFor operation: UINavigationControllerOperation,
                            from fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is CatalogDeviceListViewController,
      fromVC is CatalogBrandListViewController {
      // push to Device List
      animator = ArcusCrossfadePushAnimationController()
      return animator
    } else if toVC is CatalogBrandListViewController,
    fromVC is CatalogDeviceListViewController {
      //pop to Brand List
      animator = ArcusCrossfadePushAnimationController()
      return animator
    }
    return nil
  }
}
