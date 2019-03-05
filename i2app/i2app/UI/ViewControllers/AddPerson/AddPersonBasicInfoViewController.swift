//
//  AddPersonBasicInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/28/16.
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

class AddPersonBasicInfoViewController: BaseTextViewController {
  @IBOutlet var headerLabel: ArcusLabel!
  @IBOutlet var firstNameTextField: AccountTextField!
  @IBOutlet var lastNameTextField: AccountTextField!
  @IBOutlet var emailTextField: AccountTextField!
  @IBOutlet var confirmEmailTextField: AccountTextField!
  @IBOutlet var nextButton: ArcusButton!

  @IBOutlet var personInfoTextFields: [AccountTextField]!

  internal var addPersonModel: AddPersonModel?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)

    self.configureTextFields()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.configureForm(self.addPersonModel)
  }

  // MARK: UI Configuration
  func configureForm(_ addPersonModel: AddPersonModel?) {
    if addPersonModel != nil {
      self.firstNameTextField.text = addPersonModel?.firstName
      self.lastNameTextField.text = addPersonModel?.lastName
      self.emailTextField.text = addPersonModel?.emailAddress
      self.confirmEmailTextField.text = addPersonModel?.emailAddress
    }
  }

  func configureTextFields() {
    for textField in self.personInfoTextFields {
      textField.textColor = UIColor.black
      textField.floatingLabelTextColor = UIColor.black.withAlphaComponent(0.6)
      textField.floatingLabelActiveTextColor = UIColor.black
      textField.activeSeparatorColor = UIColor.black.withAlphaComponent(0.4)
      textField.separatorColor = UIColor.black.withAlphaComponent(0.4)
      textField.isRequired = false
      if textField == self.firstNameTextField || textField == self.lastNameTextField {
        textField.setupType(AccountTextFieldTypeGeneral,
                            fontType: FontDataType_Medium_18_Black_NoSpace,
                            placeholderFontType: FontDataTypeAccountTextFieldPlaceholder)
      } else if textField == self.emailTextField ||
        textField == self.confirmEmailTextField {
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.setupType(AccountTextFieldTypeEmail,
                            fontType: FontDataType_Medium_18_Black_NoSpace,
                            placeholderFontType: FontDataTypeAccountTextFieldPlaceholder)
      }
    }
  }

  // MARK: IBActions
  @IBAction func nextButtonPressed(_ sender: ArcusButton) {
    if self.addPersonModel?.accessType != PersonAccessType.fullAccess && self.emailTextField.text!.isEmpty {
      let subtitle = NSLocalizedString("Without an email address, this person will not receive emails "
        + "about Alarms, Rules, or other transactional emails about your Place. " +
        "Are you sure you want to skip?", comment: "")
      self.displayMessage(
        NSLocalizedString("NO EMAIL ADDRESS", comment: ""),
        subtitle: subtitle,
        backgroundColor: UIColor.white,
        buttonOne: NSLocalizedString("NO", comment: ""),
        buttonTwo: NSLocalizedString("YES", comment: ""),
        buttoneOneStyle: FontDataTypeButtonDark,
        buttonTwoStyle: FontDataTypeButtonPink,
        withTarget: self,
        withButtonOneSelector: #selector(self.slideOutTwoButtonAlert),
        andButtonTwoSelector: #selector(self.validateAndUpdate))
    } else {
      presentAddPersonRelation()
    }
  }

  func presentAddPersonRelation() {
    if self.updateAddPersonModel() {
      if addPersonModel?.accessType != .fullAccess {
        addPersonModel?.savePersonModel(true, completionHandler: { (success, _) in
          if success {
            self.performSegue(withIdentifier: "AddPersonRelationSegue", sender: self)
          } else {
            self.displayGenericErrorMessage()
          }
        })
      } else {
        performSegue(withIdentifier: "AddPersonRelationSegue", sender: self)
      }
    }
  }

  func validateAndUpdate() {
    self.slideOutTwoButtonAlert()
    presentAddPersonRelation()
  }

  func updateAddPersonModel() -> Bool {
    let validation = self.isDataValid()

    if validation.isValid == true {
      self.addPersonModel?.firstName = self.firstNameTextField.text
      self.addPersonModel?.lastName = self.lastNameTextField.text

      let emailAddress =
        self.emailTextField.text?.replacingOccurrences(of: " ", with: "")
      self.addPersonModel?.emailAddress = emailAddress
    } else {
      self.displayErrorMessage(validation.errorMessage,
                               withTitle: validation.errorTitle)
    }

    return validation.isValid
  }

  func isDataValid() -> (isValid: Bool,
    errorTitle: String,
    errorMessage: String) {
      var isValid: Bool = true
      var errorTitle: String = ""
      var errorMessage: String = ""

      // No first name: Invalid
      if self.firstNameTextField.text?.isEmpty == true {
        self.showTextFieldIsInvalid(self.firstNameTextField)

        isValid = false
        errorTitle = "Name required"
        errorMessage = "Please enter a name for the person you would like to add."
      }

      // No last name: Invalid
      if self.lastNameTextField.text?.isEmpty == true {
        self.showTextFieldIsInvalid(self.lastNameTextField)

        isValid = false
        errorTitle = "Name required"
        errorMessage = "Please enter a name for the person you would like to add."
      }

      // Validate for a full access person
      if self.addPersonModel?.accessType == PersonAccessType.fullAccess {
        if self.emailTextField.text!.isValidEmail() == false ||
          self.confirmEmailTextField.text!.isValidEmail() == false {
          self.showTextFieldIsInvalid(self.emailTextField)
          self.showTextFieldIsInvalid(self.confirmEmailTextField)

          isValid = false
          errorTitle = "Invalid Email Address"
          errorMessage = "The Email and Confirm Email Addresses " +
          "must be valid. Please try again."
        }

        if self.emailTextField.text?.isEmpty == true {
          self.showTextFieldIsInvalid(self.emailTextField)

          isValid = false
          errorTitle = "Email required"
          errorMessage = "Email is required for full access."
        } else if self.confirmEmailTextField.text?.isEmpty == true {
          self.showTextFieldIsInvalid(self.confirmEmailTextField)

          isValid = false
          errorTitle = "Email required"
          errorMessage = "Email is required for full access"
        } else if self.emailTextField.text != self.confirmEmailTextField.text {
          self.showTextFieldIsInvalid(self.emailTextField)
          self.showTextFieldIsInvalid(self.confirmEmailTextField)

          isValid = false
          errorTitle = "Email Addresses do not match"
          errorMessage = "The Email and Confirm Email Addresses " +
          "do not match. Please try again."
        }

      }

        // Validate for a partial-access person with an email entry
      else if self.emailTextField.text?.isEmpty == false ||
        self.confirmEmailTextField.text?.isEmpty == false {

        if self.emailTextField.text!.isValidEmail() == false ||
          self.confirmEmailTextField.text!.isValidEmail() == false {
          self.showTextFieldIsInvalid(self.emailTextField)
          self.showTextFieldIsInvalid(self.confirmEmailTextField)

          isValid = false
          errorTitle = "Invalid Email Address"
          errorMessage = "The Email and Confirm Email Addresses " +
          "must be valid. Please try again."
        }

        if self.emailTextField.text != self.confirmEmailTextField.text {
          self.showTextFieldIsInvalid(self.emailTextField)
          self.showTextFieldIsInvalid(self.confirmEmailTextField)

          isValid = false
          errorTitle = "Email Addresses do not match"
          errorMessage = "The Email and Confirm Email Addresses " +
          "do not match. Please try again."
        }
      }

      return (isValid, errorTitle, errorMessage)
  }

  func showTextFieldIsInvalid(_ textField: AccountTextField) {
    self.shakeAnimation(textField)

    textField.animateEvenIfNotFirstResponder = true
    textField.showFloatingLabel(true)
    textField.separatorView.backgroundColor = ObjCMacroAdapter.arcusPinkAlertColor()

    let text: String = NSLocalizedString("Missing Information", comment: "")
    let attributedText: NSAttributedString =
      NSAttributedString(string: text.uppercased(),
                         attributes: [NSForegroundColorAttributeName: ObjCMacroAdapter.arcusPinkAlertColor(),
                                      NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 11.0)!,
                                      NSKernAttributeName: 2.0])

    textField.floatingLabel.attributedText = attributedText
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonRelationSegue" {
      let selectRelationViewController: AddPersonSelectRelationViewController? =
        segue.destination as? AddPersonSelectRelationViewController
      selectRelationViewController?.addPersonModel = self.addPersonModel
    }
  }
}
