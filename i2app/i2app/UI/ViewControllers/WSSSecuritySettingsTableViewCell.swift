//
//  WSSSecuritySettingsTableViewCell.swift
//  i2app
//
//  Created by Arcus Team on 7/15/16.
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

class WSSSecuritySettingsTableViewCell: UITableViewCell {
  @IBOutlet var textField: AccountTextField!
  @IBOutlet var showPasswordLabel: ArcusLabel!
  @IBOutlet var clearButton: UIButton!

  internal var showHidePasswordBlock: ((_ show: Bool) -> (Void))!
  var showPassword: Bool = false
  var tapRecognizer: UITapGestureRecognizer?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func awakeFromNib() {
    self.configureTapGesture()
  }

  func configureTapGesture() {
    if self.tapRecognizer == nil {
      self.tapRecognizer =
        UITapGestureRecognizer(target: self,
                               action: #selector(showHidePasswordTapped(_:)))

      if self.showPasswordLabel != nil {
        self.showPasswordLabel.addGestureRecognizer(self.tapRecognizer!)
      }
    }
  }

  @IBAction func showHidePasswordTapped(_ sender: UITapGestureRecognizer) {
    self.showPassword = !self.showPassword
    if self.showPassword {
      self.showPasswordLabel.text = "Hide Password"
    } else {
      self.showPasswordLabel.text = "Show Password"
    }
    self.textField.isSecureTextEntry = !self.showPassword
  }
}
