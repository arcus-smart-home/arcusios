//
//  SlideTableViewFooterView.swift
//  i2app
//
//  Created by Arcus Team on 6/6/18.
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

@IBDesignable
class SlideMenuTableViewFooterView: UIView, NibConfigurable {
  
  @IBInspectable var prototypeName: String? {
    didSet {
      loadPrototype()
    }
  }
  
  var prototypeView: UIView?
  
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var patentPendingLabel: ArcusLabel!
  @IBOutlet weak var versionInfoLabel: ArcusLabel!
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    loadPrototype()
    prototypeView?.prepareForInterfaceBuilder()
  }
  
  override func awakeFromNib() {
    loadPrototype()
  }
  
  func setVersionInfo(versionString: String) {
    versionInfoLabel.text = "Version \(versionString)"
  }
  
  func setupLogoutButton() {
    if let attributes: [String: Any] = FontData.getFontWithSize(9.0, bold: true, kerning: 2.0, color: UIColor.black) as? [String: Any] {
      let logoutString = NSLocalizedString("Log Out", comment: "").uppercased()
      let logoutTitle: NSAttributedString = NSAttributedString(string: logoutString, attributes: attributes)
      logoutButton.setAttributedTitle(logoutTitle, for: .normal)
    }
  }
}
