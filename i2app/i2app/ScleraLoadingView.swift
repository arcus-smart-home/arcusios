//
//  ScleraLoadingView.swift
//  i2app
//
//  Created by Arcus Team on 10/5/17.
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

/**
 Provides a dark overlay with a large spinner in the middle. This class uses the LoadingOverlayView prototype
 to layout it's elements.
 */
@IBDesignable
class ScleraLoadingView: UIView, NibConfigurable {

  /**
   Required by NibConfigurable.
   */
  @IBInspectable var prototypeName: String? = "" {
    didSet {
      loadPrototype()
    }
  }

  /**
   Required by NibConfigurable.
   */
  var prototypeView: UIView?

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    loadPrototype()
    prototypeView?.prepareForInterfaceBuilder()
  }

  /**
   Makes the view visible.
   */
  func show() {
    alpha = 0
    isHidden = false

    UIView.animate(withDuration: 0.25, animations: {
      self.alpha = 1.0
    })
  }

  /**
   Hides the view.
   */
  func hide() {
    UIView.animate(withDuration: 0.25, animations: {
      self.alpha = 0.0
    }) { _ in
      // After fading out hide the entire view
      self.isHidden = true
    }
  }
}
