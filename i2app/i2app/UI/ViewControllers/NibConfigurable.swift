//
//  NibConfigurable.swift
//  i2app
//
//  Created by Arcus Team on 6/7/17.
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
 This protocol is used for views which are meant to be loaded from corresponding Nib prototypes. By setting a 
 prototype name and calling loadPrototype(), the view should contain the contents of the prototype in the 
 prototypeView property.
 */
protocol NibConfigurable: class {
  
  /**
   The name of the prototype to be loaded.
   */
  var prototypeName: String? { get set }
  
  /**
   The contents of the currently loaded prototype.
   */
  var prototypeView: UIView? { get set }

  // MARK: Extended

  /**
   Attempts to load the Nib prototype of name prototypeName and loads it into prototypeView.
   */
  func loadPrototype()

}

extension NibConfigurable where Self: UIView {
  func loadPrototype() {
    prototypeView?.removeFromSuperview()
    prototypeView = nil

    guard let prototype = loadViewFromNib() else {
      return
    }

    prototype.frame = bounds
    prototype.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(prototype)
    prototypeView = prototype
  }

  private func loadViewFromNib() -> UIView? {
    guard let nibName = prototypeName else { return nil }
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate(
      withOwner: self,
      options: nil).first as? UIView
  }
}
