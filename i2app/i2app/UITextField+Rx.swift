//
//  UITextField+Rx.swift
//  i2app
//
//  Created by Arcus Team on 5/4/18.
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
import RxSwift
import RxCocoa

/**
 `Raective` extension to add `rx.isSecureTextEntry` to `UITextField`
 */
extension Reactive where Base: UITextField {
  /// Bindable sink for `isSecureTextEntry` property.
  public var isSecureTextEntry: UIBindingObserver<Base, Bool> {
    return UIBindingObserver(UIElement: self.base) { control, value in
      control.isSecureTextEntry = value
    }
  }
}
