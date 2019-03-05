//
//  ArcusPopupViewController.swift
//  i2app
//
//  Created by Arcus Team on 1/25/18.
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

/// A View Controller superclass that conforms to ArcusPopupAnimatable that speeds up the work to
/// animate a View Controller in a popover style
class ArcusPopupViewController: UIViewController, ArcusPopupAnimatable {

  /// A translucent grey view that is crossfaded overtop the presenting content
  @IBOutlet weak var backgroundView: UIView!

  /// The View that is animated up on presentation
  @IBOutlet weak var popoverView: UIView!
  
  /// Dismisses the popup when the background view is tapped.
  @IBInspectable var dismissOnBackgroundTap: Bool = false

  /// This object handles the Animation
  var animationController = ArcusPopupAnimationController()

  /// ArcusPopupViewController should all be created using a Nib or a Storyboard. This function
  /// ensures we set the view controller as its own transitioning delegate
  override func awakeFromNib() {
    super.awakeFromNib()
    self.transitioningDelegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureBackgroundDismiss()
  }
  
  private func configureBackgroundDismiss() {
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTap))
    backgroundView.addGestureRecognizer(recognizer)
    backgroundView.isUserInteractionEnabled = true
  }
  
  @objc private func onBackgroundTap() {
    if dismissOnBackgroundTap {
      dismiss(animated: true, completion: nil)
    }
  }
}

/// This UIViewController is capable of transitioning itself overtop the window, override this by setting
/// another transitioningDelegate before calling `slideIn()`
extension ArcusPopupViewController: UIViewControllerTransitioningDelegate {

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
