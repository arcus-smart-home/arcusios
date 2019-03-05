//
//  UIButton+Event.swift
//  i2app
//
//  Created by Arcus Team on 9/16/16.
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

extension UIButton {
  fileprivate func setOrTriggerClosure(_ closure:((_ button: UIButton) -> Void)? = nil) {

    //struct to keep track of current closure
    struct __ {
      static var closure: ((_ button: UIButton) -> Void)?
    }

    //if closure has been passed in, set the struct to use it
    if closure != nil {
      __.closure = closure
    } else {
      //otherwise trigger the closure
      __.closure?(self)
    }
  }
  @objc fileprivate func triggerActionClosure() {
    self.setOrTriggerClosure()
  }
  //func setActionTo(closure: (UIButton) -> Void, forEvents: UIControlEvents) {
  func setActionTo(_ forEvents: UIControlEvents, closure: @escaping (_ button: UIButton) -> Void) {
    self.setOrTriggerClosure(closure)
    self.addTarget(self, action:
      #selector(UIButton.triggerActionClosure),
                   for: forEvents)
  }
}
