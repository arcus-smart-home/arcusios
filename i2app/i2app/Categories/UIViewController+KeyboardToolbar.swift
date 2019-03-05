//
//  UIViewController+KeyboardToolbar.swift
//  i2app
//
//  Created by Arcus Team on 5/22/16.
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

extension UIViewController {

  func keyboardToolbar(_ previousSelector: Selector,
                       nextSelector: Selector,
                       doneSelector: Selector) -> UIToolbar {
    let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))

    let leftPreviousButton = UIBarButtonItem.init(image: UIImage.init(named: "BackButton"),
                                                  style: .plain,
                                                  target: self,
                                                  action: previousSelector)
    let fixed = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace,
                                     target: nil,
                                     action: nil)
    fixed.width = 20
    let leftNextButton = UIBarButtonItem.init(image: UIImage.init(named: "NextToolbarButton"),
                                              style: .plain,
                                              target: self,
                                              action: nextSelector)
    let flex = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let rightDoneButton = UIBarButtonItem.init(title: "Done",
                                               style: .plain,
                                               target: self,
                                               action: doneSelector)

    toolbar.barStyle = .blackTranslucent
    toolbar.items = [leftPreviousButton, fixed, leftNextButton, flex, rightDoneButton]
    toolbar.tintColor = UIColor.white

    return toolbar
  }

  func keyboardToolbar(_ doneSelector: Selector) -> UIToolbar {
    let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.height, height: 44))

    let flex = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
    let doneButton = UIBarButtonItem.init(title: "Done",
                                          style: .plain,
                                          target: self,
                                          action: doneSelector)

    toolbar.barStyle = .blackTranslucent
    toolbar.items = [flex, doneButton]
    toolbar.tintColor = UIColor.white

    return toolbar
  }
}
