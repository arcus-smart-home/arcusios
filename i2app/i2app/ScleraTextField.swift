//
//  ScleraTextField.swift
//  i2app
//
//  Created by Arcus Team on 10/3/17.
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
 Class that defines the behavior of a generic text field.
 */
@IBDesignable
class ScleraTextField: SkyFloatingLabelTextField {

  /**
   Block used to validate the content of the field. This will be called automatically when the field 
   loses focus.
   */
  var inlineValidation = {}

  /**
   Indicates that the field has an error.
   */
  private(set) var hasError = false

  private var errorLabel: UILabel?
  private var previousPlaceholderColor: UIColor?

  override public init (frame: CGRect) {
    super.init(frame: frame)

    customizeDefaultBehavior()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    customizeDefaultBehavior()
  }

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()

    customizeDefaultBehavior()
  }

  @discardableResult
  override func resignFirstResponder() -> Bool {
    // Execute inline validation
    inlineValidation()

    return super.resignFirstResponder()
  }

  /*
   Defines the behavior of when the float label should be visible. The float label and the placeholder 
   text are inverse of one another and should never both appear at the same time.
   - returns: An indicator for the visibility of the float label.
   */
  override func isTitleVisible() -> Bool {
    var currentText: String = ""
    if let text = text {
      currentText = text
    }
    let isVisible = isFirstResponder || !currentText.isEmpty

    // Check if the placeholder needs to be hidden.
    if isVisible {
      // Only clear the placeholder color if needed
      if placeholderColor != UIColor.clear {
        previousPlaceholderColor = placeholderColor
        placeholderColor = UIColor.clear
      }
    } else {
      if previousPlaceholderColor != nil {
        placeholderColor = previousPlaceholderColor!
      } else {
        placeholderColor = ScleraColor.text
      }
    }

    return isVisible
  }

  /**
   Shows the error style in the text field. If a string is provided, the text will also be made visible 
   with the error style.
   - parameter errorText: The text to be displayed discribing the error.
   */
  func showError(errorText: String = "") {
    clipsToBounds = false

    // Remove any previous error labels
    errorLabel?.removeFromSuperview()
    errorLabel = nil

    errorLabel = UILabel(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: 25))
    if let error = errorLabel {
      error.text = errorText
      error.textColor = ScleraColor.alert
      error.font = UIFont(name: "AvenirNext-Regular", size: 12)
      addSubview(error)
    }

    titleColor = ScleraColor.alert
    selectedTitleColor = ScleraColor.alert
    lineColor = ScleraColor.alert
    selectedLineColor = ScleraColor.alert
    hasError = true
  }

  /**
   Removes the error style from the text field.
   */
  func removeError() {
    // Remove the error label
    errorLabel?.removeFromSuperview()
    errorMessage = nil
    errorLabel = nil

    // Reset to the original non-error colors
    lineColor = ScleraColor.disabled
    selectedLineColor = ScleraColor.disabled
    titleColor = ScleraColor.text
    selectedTitleColor = ScleraColor.text
    hasError = false
  }

  @objc private func hideKeyboard() {
    _ = resignFirstResponder()
  }

  private func customizeDefaultBehavior() {
    inputAccessoryView = keyboardToolbar(#selector(hideKeyboard))

    // Do not capitalize the floating label text
    titleFormatter = { (text: String) -> String in
      return text
    }

    titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)

    // Placeholder
    placeholderColor = ScleraColor.text
    previousPlaceholderColor = ScleraColor.text

    // Field Line
    lineHeight = 0.5
    selectedLineHeight = 0.5
    lineColor = ScleraColor.disabled
    selectedLineColor = ScleraColor.disabled

    // Float Label
    titleColor = ScleraColor.text
    selectedTitleColor = ScleraColor.text
  }

  private func keyboardToolbar(_ doneSelector: Selector) -> UIToolbar {
    let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: frame.size.height, height: 44))

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
