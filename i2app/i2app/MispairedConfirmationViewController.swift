//
//  MispairedConfirmationViewController.swift
//  i2app
//
//  Arcus Team on 4/30/18.
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

protocol ConfirmationDelegate: class {
  func onConfirmed()
  func onRejected()
}

class MispairedConfirmationViewController: MispairedBaseViewController, ArcusPopupAnimatable {

  /// A translucent grey view that is crossfaded overtop the presenting content
  @IBOutlet weak var backgroundView: UIView!

  /// The View that is animated up on presentation
  @IBOutlet weak var popoverView: UIView!

  /// This object handles the Animation
  var animationController = ArcusPopupAnimationController()

  weak var delegate: ConfirmationDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.transitioningDelegate = self
  }
  
  @IBAction func onConfirmTapped(_ sender: Any?) {
    presentingViewController?.dismiss(animated: true) {
      self.delegate?.onConfirmed()
    }
  }
  
  @IBAction func onRejectTapped(_ sender: Any?) {
    presentingViewController?.dismiss(animated: true) {
      self.delegate?.onRejected()
    }
  }

}

/// This UIViewController is capable of transitioning itself overtop the window, override this by setting
/// another transitioningDelegate before calling `slideIn()`
extension MispairedConfirmationViewController: UIViewControllerTransitioningDelegate {

  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animationController.presenting = true
    return animationController
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animationController.presenting = false
    return animationController
  }
}
