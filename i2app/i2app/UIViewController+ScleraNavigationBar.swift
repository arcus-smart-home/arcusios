//
//  UIViewController+ScleraNavigationBar.swift
//  i2app
//
//  Created by Arcus Team on 1/30/18.
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

/**
 Provides view controllers with the ability to add/style navigation bar elements for consistency with
 requirements from the Sclera Stylesheet.
 */
extension UIViewController {
  
  /**
   Adds Sclera style back button to the top left of the navigation bar.
   */
  func addScleraBackButton(delegate: BackButtonDelegate? = nil) {
    let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"),
                                     style: .plain,
                                     target: self,
                                     action: delegate == nil ?
                                      #selector(defaultBackButtonSelector) :
                                      #selector(delegate?.onBackButtonPressed)
                                     )
    
    navigationItem.backBarButtonItem = nil
    navigationItem.leftBarButtonItem = backButton
  }

  func removeScleraBackButton(animated: Bool = true) {
    navigationItem.backBarButtonItem = nil
    navigationItem.setHidesBackButton(true, animated: animated)
    
    navigationItem.leftBarButtonItem = nil
  }

  /**
   Styles the title text of the navigation bar with the Sclera required font.
   */
  func addScleraStyleToNavigationTitle() {
    guard let titleFont = UIFont(name: "AvenirNext-Regular", size: 18) else {
      return
    }
    
    navigationController?.navigationBar.titleTextAttributes = [
      NSFontAttributeName: titleFont
    ]
  }
  
  @objc private func defaultBackButtonSelector() {
    navigationController?.popViewController(animated: true)
  }
}

@objc protocol BackButtonDelegate {
  @objc func onBackButtonPressed()
}
