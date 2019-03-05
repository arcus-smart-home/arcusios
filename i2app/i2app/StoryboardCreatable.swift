//
//  StoryboardCreatable.swift
//  i2app
//
//  Created by Arcus Team on 1/13/17.
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

/// Support StoryboardCreatable and add `-create()`
/// - warning: extension assumes the Storyboard is in the Main Bundle
protocol StoryboardCreatable : class {
  static var storyboardName: String { get }
  static var storyboardIdentifier: String { get }
  static func createFromStoryboard() -> UIViewController
}

extension StoryboardCreatable where  Self : UIViewController {
  static func createFromStoryboard() -> UIViewController {
      return UIStoryboard(name: self.storyboardName, bundle: nil)
          .instantiateViewController(withIdentifier: self.storyboardIdentifier)
  }
}
