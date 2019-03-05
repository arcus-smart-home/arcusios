//
//  OffsetScrollViewKeyboardAnimatable.swift
//  i2app
//
//  Created by Arcus Team on 3/27/18.
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


/**
 Protocol only for UIViewControllers that need to push content up when a keyboard is displayed. The content
 in this case is also assumed to be offset with a vertical margin from the bottom of the screen.

 *PairingInstructionViewController* is the first View Controller to use this protocol and can be used for a
 usage example

 - warning: the bottom content inset will be set to zero on completion of the animation

 - warning: This may not work perfectly for switching between multiple adjustable views, start a refactor
            at the function scrollRectToVisible to enhance

 Sample Implementation

 ```
 // Adds scrolling functionality
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 addKeyboardScrolling()
 }

 // Cleans up the observers
 override func viewDidDisappear(_ animated: Bool) {
 super.viewDidDisappear(animated)
 cleanUpKeyboardScrollingObservers()
 }

 // OPTIONAL: Provides an element to scroll to when the keyboard is out.
 func activeViewForKeyboardScroll() -> UIView? {
 return myTextField
 }
 ```
 */
protocol OffsetScrollViewKeyboardAnimatable: class {

  /**
   The scroll view used to push the content up.
   */
  var keyboardAnimationView: UIScrollView! { get }

  /**
   Observer created from observing UIKeyboardDidShow notification. This observer is only needed for clean
   up purposes.
   */
  var keyboardAnimatableShowObserver: Any? { get set }

  /**
   Observer created from observing UIKeyboardWillHide notification. This observer is only needed for clean
   up purposes.
   */
  var keyboardAnimatableHideObserver: Any? { get set }

  // MARK: Extended

  /**
   This function adds the necessary notificaiton observations to execute the scroll logic when the keyboard
   is either displayed or hidden.
   */
  func addKeyboardScrolling()

  /**
   This function removes the observers created when adding the keyboard scrolling functionality.
   */
  func cleanUpKeyboardScrollingObservers()

  /**
   Override this function to provide an element that should be scrolled to view once the keyboard is out.
   - returns: Element guaranteed to be visible when the keyboard is out. For example, an active text field.
   */
  func activeViewForKeyboardScroll() -> UIView?

  /**
   Margin between the active View and the top of the keyboard

   extended to be 10 for UIViewController
   */
  var activeViewBottomMargin: CGFloat { get }
}

extension OffsetScrollViewKeyboardAnimatable where Self: UIViewController {

  var activeViewBottomMargin: CGFloat {
    return 10.0
  }

  func activeViewForKeyboardScroll() -> UIView? {
    return nil
  }

  func addKeyboardScrolling() {
    keyboardAnimatableShowObserver = NotificationCenter.default.addObserver(
      forName: NSNotification.Name.UIKeyboardWillShow,
      object: nil,
      queue: nil) { (notification) in
        self.keyboardWillShow(notification)
    }

    keyboardAnimatableHideObserver = NotificationCenter.default.addObserver(
      forName: NSNotification.Name.UIKeyboardWillHide,
      object: nil,
      queue: nil) { (notification) in
        self.keyboardWillHide(notification)
    }
  }

  func cleanUpKeyboardScrollingObservers() {
    if let showObserver = keyboardAnimatableShowObserver {
      NotificationCenter.default.removeObserver(showObserver)
    }

    if let hideObserver = keyboardAnimatableHideObserver {
      NotificationCenter.default.removeObserver(hideObserver)
    }
  }

  fileprivate func keyboardWillShow(_ notification: Notification) {
    guard let window = UIApplication.shared.delegate?.window as? UIWindow,
      let scrollSuperview = keyboardAnimationView.superview,
      let info = notification.userInfo,
      let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
        return
    }
    let transformToGlobalFrame = scrollSuperview.convert(keyboardAnimationView.frame, to: nil)
    // We factor in the activeViewBottomMargin here
    let offset = window.bounds.height - // Screen Height minus
      (transformToGlobalFrame.origin.y + transformToGlobalFrame.size.height) - // the bottom of our view minus
      self.activeViewBottomMargin // the margin we want to keep

    let currentInset = keyboardAnimationView.contentInset
    let contentInset = UIEdgeInsets(top: currentInset.top,
                                    left: currentInset.left,
                                    bottom: keyboardFrame.height  - offset,
                                    right: currentInset.right)
    keyboardAnimationView.contentInset = contentInset
    keyboardAnimationView.scrollIndicatorInsets = contentInset

    // warning: This may not work perfectly for switching between multiple adjustable views
    if let activeView = self.activeViewForKeyboardScroll() {
      let currentFrame = CGRect(x: view.frame.origin.x,
                                y: view.frame.origin.y,
                                width: view.frame.width,
                                height: view.frame.height - keyboardFrame.height)

      if !currentFrame.contains(activeView.frame.origin) {
        keyboardAnimationView.scrollRectToVisible(activeView.frame, animated: true)
      }
    }
  }

  fileprivate func keyboardWillHide(_ notification: Notification) {
    let currentInset = keyboardAnimationView.contentInset
    let contentInset = UIEdgeInsets(top: currentInset.top,
                                    left: currentInset.left,
                                    bottom: 0,
                                    right: currentInset.right)
    keyboardAnimationView.contentInset = contentInset
    keyboardAnimationView.scrollIndicatorInsets = contentInset
  }

}
