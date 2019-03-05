//
//  DebugMenuMixin.swift
//  i2app
//
//  Created by Arcus Team on 12/5/17.
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

protocol DebugMenuMixin: class {
  var pinchCount: Int { get set }
  var pinchStart: Date { get set }
  func configureDebugGestureRecognizer(_ selector: Selector)
  func pinchReceived(_ sender: UIPinchGestureRecognizer)
}

extension DebugMenuMixin where Self: UIViewController {
  func configureDebugGestureRecognizer(_ selector: Selector) {
    guard let view = self.view else { return }

    let pinchRecognizer: UIPinchGestureRecognizer =
      UIPinchGestureRecognizer(target: self, action: selector)

    view.addGestureRecognizer(pinchRecognizer)
  }

  func pinchReceived(_ sender: UIPinchGestureRecognizer) {
    if sender.state != .ended {
      return
    }

    if pinchCount == 0 {
      pinchStart = Date()
    }

    pinchCount += 1

    let currentDate = Date()
    let currentTimestamp: Double = currentDate.timeIntervalSince1970
    let startTimestamp: Double = pinchStart.timeIntervalSince1970
    let delta: Double = currentTimestamp - startTimestamp

    if delta >= 5 {
      pinchCount = 0
    }

    if pinchCount == 3 {
      pinchCount = 0
      ApplicationRoutingService.defaultService.showDebugMenu()
    }
  }
}

extension UIViewController {
  @objc func pinchGestureReceived(_ sender: UIPinchGestureRecognizer) {
    guard let mixin = self as? DebugMenuMixin else { return }

    mixin.pinchReceived(sender)
  }
}
