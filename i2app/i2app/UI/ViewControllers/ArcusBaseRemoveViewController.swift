//
//  ArcusBaseRemoveViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/24/16.
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
import Cornea

class ArcusBaseRemoveViewController: UIViewController, UITextFieldDelegate, RemovePersonAlertDelegate {

  @IBOutlet var headerLabel: ArcusLabel!
  @IBOutlet var footerLabel: ArcusLabel!
  @IBOutlet var removeTextField: ArcusFloatingLabelTextField!
  @IBOutlet var removeButton: ArcusButton!
  @IBOutlet var removeAlertView: RemovePersonAlertView! {
    didSet {
      self.removeAlertView.delegate = self
    }
  }
  @IBOutlet var removeAlertTrailingConstraint: NSLayoutConstraint?

  //-------------------------------------------------------------------------------
  // MARK: - SHOULD OVERRIDE IN ALL SUBCLASSES
  //-------------------------------------------------------------------------------
  //This is the string that should be checked against to determine if we should enable the remove button
  func removeButtonShouldBeEnabledString() -> String? {
    return nil
  }

  // MARK: Functions to override with call to super
  func confirmButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView) {
    hideRemovePersonAlertView()
  }

  func cancelButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView) {
    hideRemovePersonAlertView()
  }

  func closeButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView) {
    hideRemovePersonAlertView()
  }

  @IBAction func removeButtonPressed(_ sender: ArcusButton) {
    if removeTextField.isFirstResponder {
      removeTextField.resignFirstResponder()
    }

    showRemovePersonAlertView()
  }

  // MARK: - UIViewController & Helpers
  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToParentColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    configureTextField()
    enableRemoveButton(removeButtonShouldBeEnabled(removeTextField.text))

    navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  fileprivate func enableRemoveButton(_ enabled: Bool) {
    removeButton.isEnabled = enabled
    if enabled {
      removeButton.alpha = 1.0
    } else {
      removeButton.alpha = 0.6
    }
  }

  fileprivate func configureTextField() {
    removeTextField.textColor = UIColor.white
    removeTextField.floatingLabelTextColor =
      UIColor.white.withAlphaComponent(0.6)
    removeTextField.floatingLabelActiveTextColor = UIColor.white
    removeTextField
      .attributedPlaceholder = FontData.getString(removeTextField.placeholder,
                                                  withFont: FontDataTypeAccountTextFieldPlaceholderWhite)
    removeTextField.activeSeparatorColor = UIColor.white.withAlphaComponent(0.4)
    removeTextField.separatorColor = UIColor.white.withAlphaComponent(0.4)
    removeTextField.delegate = self
    removeTextField.inputAccessoryView = self.keyboardToolbar(#selector(keyboardDoneTapped))
    removeTextField.keyboardAppearance = .dark
    removeTextField.autocorrectionType = .no
  }

  fileprivate func removeButtonShouldBeEnabled(_ textFieldText: String?) -> Bool {
    guard let enableString = removeButtonShouldBeEnabledString() else {
      return true
    }

    if let removeTextFieldText = textFieldText {
      return removeTextFieldText.lowercased() == enableString.lowercased()
    } else {
      return false
    }
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let textFieldText = textField.text as NSString?
    enableRemoveButton(
      removeButtonShouldBeEnabled(textFieldText?.replacingCharacters(in: range, with: string))
    )
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    enableRemoveButton(removeButtonShouldBeEnabled(textField.text))
  }

  // MARK: Animation Helpers
  func showRemovePersonAlertView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.removeAlertTrailingConstraint?.constant = 0
      self.removeAlertView.layoutIfNeeded()
      self.view.layoutIfNeeded()
    })
  }

  func hideRemovePersonAlertView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.removeAlertTrailingConstraint?.constant = -self.removeAlertView.frame.size.height
      self.removeAlertView.layoutIfNeeded()
      self.view.layoutIfNeeded()
    })
  }

  // MARK: Keyboard Toolbar Selectors
  func keyboardDoneTapped() {
    view.endEditing(true)
  }

}
