//
//  UIButton+ClipAnimate.swift
//  i2app
//
//  Created by Arcus Team on 8/23/17.
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

/// Button Animations that are used by the camera clip button
///
extension UIButton {

  func addSpringAnimation() {
    addTarget(self, action: #selector(scaleDown), for: [.touchDown, .touchDragEnter])
    addTarget(self, action: #selector(scaleUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
  }

  @IBAction func scaleDown(_ button: UIButton) {
    UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
      button.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }, completion: nil)
  }

  @IBAction func scaleUp(_ button: UIButton) {
    if button.transform == .identity { return }
    UIView.animate(withDuration: 1,
                   delay: 0,
                   usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 30,
                   options: [.allowUserInteraction, .curveLinear],
                   animations: {
                    button.transform = .identity
    },
                   completion: nil)
  }
}
