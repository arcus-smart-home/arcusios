//
//  ArcusModalAnimationController.swift
//  i2app
//
//  Created by Arcus Team on 1/19/18.
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

/// An object that transitions a View Controller conforming to ArcusPopupAnimatable
class ArcusPopupAnimationController: NSObject {
  var presenting = true
  var slideDuration: TimeInterval = 0.35
}

extension ArcusPopupAnimationController: UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return slideDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if presenting {
      animateIn(using: transitionContext)
    } else {
      animateOut(using: transitionContext)
    }
  }

  private func animateIn(using transitionContext: UIViewControllerContextTransitioning) {
    /// Gaurd against a bad API declaration (Any? instead of a gaurenteed VC!)
    guard let to = transitionContext.view(forKey: .to),
      let toAnimatable = transitionContext.viewController(forKey: .to) as? ArcusPopupAnimatable else {
      print("Fatal error transitioning In a Modal View Controller")
      return
    }
    to.translatesAutoresizingMaskIntoConstraints = true
    let startingFrame = transitionContext.containerView.bounds
    to.frame = startingFrame
    transitionContext.containerView.addSubview(to)

    // Setup the animation
    to.layoutIfNeeded() // adjust the height of our content to the width of the containerView
    let popoverFinish = toAnimatable.popoverView.frame
    var popoverStart = popoverFinish
    popoverStart.origin.y = startingFrame.height
    toAnimatable.popoverView.frame = popoverStart
    toAnimatable.backgroundView.isHidden = true

    UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                   delay: 0.0,
                   options: [.curveEaseOut, .transitionCrossDissolve],
                   animations: {
                    toAnimatable.backgroundView.isHidden = false
    })

    let springVelocity = CGFloat(1.0 / self.transitionDuration(using: transitionContext))
    UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                   delay: 0.1,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    toAnimatable.popoverView.frame = popoverFinish
                    to.layoutIfNeeded()
    }) { finished in
      transitionContext.completeTransition(finished)
    }
  }

  private func animateOut(using transitionContext: UIViewControllerContextTransitioning) {
    guard let from = transitionContext.view(forKey: .from),
      let fromAnimatable = transitionContext.viewController(forKey: .from) as? ArcusPopupAnimatable else {
      print("Fatal error transitioning Out a Modal View Controller")
      return
    }

    // Setup Animation
    var endFrame = fromAnimatable.popoverView.frame
    endFrame.origin.y = transitionContext.containerView.bounds.height
    let duration = self.transitionDuration(using: transitionContext)
    let springVelocity = CGFloat(1.0 / self.transitionDuration(using: transitionContext))

    // Animate
    UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                   delay: 0.0,
                   options: [.curveEaseOut, .transitionCrossDissolve],
                   animations: {
                    fromAnimatable.backgroundView.isHidden = true
    })

    UIView.animate(withDuration: duration,
                   delay: 0.0,
                   usingSpringWithDamping: 1.0,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    fromAnimatable.popoverView.frame = endFrame
                    from.layoutIfNeeded()
    }) { finished in
      from.removeFromSuperview()
      transitionContext.completeTransition(finished)
    }
  }
}
