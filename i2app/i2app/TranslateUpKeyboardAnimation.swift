//
//  TranslateUpKeyboardAnimation.swift
//  i2app
//
//  Created by Arcus Team on 6/29/17.
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

/** Handles Common ways to change a UIView when the keyboard is presented
 
 All functions of this protocol are extended for UIViewControllers
 
 Sample Implementation
 
 ```
    // Ensure the notification is added
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(_:)),
                                             name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                             object: nil)
    }
    // Ensure the notification is removed
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      NotificationCenter.default.removeObserver(self,
                                                name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                                object: nil)
    }
    // use the Mixin
    extension YourClass: TranslateUpKeyboardAnimation {
      @objc func keyboardWillChangeFrame(_ note: Notification) {
        keyboardWillChangeFrameMoveFrameUp(note)
      }
    }
 ```

 */
protocol TranslateUpKeyboardAnimation {
  func keyboardWillChangeFrameMoveFrameUp(_ note: Notification)
}

extension TranslateUpKeyboardAnimation where Self: UIViewController {

  /// Handle the keyboard becoming visible
  func keyboardWillChangeFrameMoveFrameUp(_ note: Notification) {
    //this animation will move the entire view up by the height of the keyboard
    guard let info = note.userInfo,
      let keyboardEndFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let keyboardBeginFrame = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
      let animationCurveRawValue = (info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue,
      let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
        return
    }

    var newFrame = self.view.frame
    let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRawValue)
    let keyboardFrameEnd = self.view.convert(keyboardEndFrame, to: nil)
    let keyboardFrameBegin = self.view.convert(keyboardBeginFrame, to: nil)
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y)

    UIView.animate(withDuration: animationDuration, delay: 0.0, options:animationCurve,
                   animations: {
                    self.view.frame = newFrame
    }, completion:nil)
  }
}
