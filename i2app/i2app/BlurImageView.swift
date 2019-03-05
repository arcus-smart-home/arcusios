//
//  BlurImageView.swift
//  i2app
//
//  Created by Arcus Team on 10/4/17.
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
 Variation of Image View that automatically applies blur. This class uses the BlurImageView prototype.
 */
@IBDesignable
class BlurImageView: UIImageView, NibConfigurable {

  /**
   Required by NibConfigurable
   */
  @IBInspectable var prototypeName: String? {
    didSet {
      loadPrototype()
    }
  }

  /**
   Required by NibConfigurable
   */
  var prototypeView: UIView?

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    loadPrototype()
    prototypeView?.prepareForInterfaceBuilder()
  }
}
