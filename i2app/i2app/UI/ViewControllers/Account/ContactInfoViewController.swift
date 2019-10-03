//
//  ContactInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/4/16.
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

class ContactInfoViewController: BaseTextViewController {
  @IBOutlet var firstNameField: AccountTextField!
  @IBOutlet var lastNameField: AccountTextField!
  @IBOutlet var phoneField: AccountTextField!
  @IBOutlet var emailField: AccountTextField!
  @IBOutlet var passwordDisplayField: AccountTextField!
  
  @IBOutlet var contactInfoFields: [AccountTextField]!
  
  internal var currentPerson: PersonModel?
  internal var accessType: PlaceAccessType? = .unknown
  
  var editMode: Bool = false
  
  @IBOutlet var passwordRelatedViews: [UIView]!
  
  class func create() -> ContactInfoViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "AccountSettings", bundle:nil)
    let viewController: ContactInfoViewController? =
      storyboard.instantiateViewController(withIdentifier: String(describing: ContactInfoViewController.self))
        as? ContactInfoViewController
    
    return viewController!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    var text = "Edit"
    if editMode {
      text = "Done"
    }
    self.navBar(withTitle: "Contact Information",
                andRightButtonText: text,
                with: #selector(editButtonPressed))
    self.addBackButtonItemAsLeftButtonItem()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
    self.configureContactInfoTextFields()
    self.setContactInformation()
  }
  
  // MARK: - UI Configuration
  func configureContactInfoTextFields() {
    for textField in self.contactInfoFields {
      textField.setAccountFieldStyle(AccountTextFieldStyleWhite)
      textField.textColor = UIColor.white
      textField.floatingLabelTextColor = UIColor.white.withAlphaComponent(0.6)
      textField.floatingLabelActiveTextColor = UIColor.white
      textField.activeSeparatorColor = UIColor.white.withAlphaComponent(0.4)
      textField.separatorColor = UIColor.white.withAlphaComponent(0.4)
      textField.isUserInteractionEnabled = false
    }
    self.firstNameField.setupType(AccountTextFieldTypeGeneral)
    self.lastNameField.setupType(AccountTextFieldTypeGeneral)
    self.phoneField.setupType(AccountTextFieldTypePhone,
                              isRequired: self.accessType != .hobbit)
    self.emailField.setupType(AccountTextFieldTypeEmail,
                              isRequired: self.accessType != .hobbit)
    self.passwordDisplayField.setupType(AccountTextFieldTypePassword)
    if let accessType = accessType, accessType == .hobbit {
      for view in passwordRelatedViews {
        view.isHidden = true
      }
    }
  }
  
  func toggleTextFieldUserInteraction() {
    for textfield in self.contactInfoFields {
      textfield.isUserInteractionEnabled = self.editMode
    }
  }
  
  func setContactInformation() {
    self.firstNameField.text = self.currentPerson?.firstName
    self.lastNameField.text = self.currentPerson?.lastName
    self.phoneField.text = self.currentPerson?.phoneNumber
    self.emailField.text = self.currentPerson?.emailAddress
    self.passwordDisplayField.text = Constants.kPasswordPlaceholder
  }
  
  // MARK: - IBActions
  @IBAction func editButtonPressed(_ sender: AnyObject) {
    if editMode {
      // Save changes
      if updateCurrentPerson() {
        toggleEditState()
      }
    } else {
      toggleEditState()
    }
  }
  
  func toggleEditState() {
    editMode = !editMode
    toggleTextFieldUserInteraction()

    var text = "EDIT"
    if editMode {
      text = "DONE"
    }
    navBar(withTitle: "Contact Information",
           andRightButtonText: text,
           with: #selector(editButtonPressed(_:)),
           selectorTarget: self)
  }
  
  func updateCurrentPerson() -> Bool {
    var errorMessage: NSString? = ""
    let success: Bool = isDataValid(&errorMessage)
    if success {
      // Hobbits may delete their phone number but should be warned that they won't be notified if they do so
      if phoneField.text?.count == 0 && accessType == .hobbit {
        let msg = "A person without a phone number specified will not be notified in the event of an alarm."
        displayErrorMessage(msg, withTitle: "WARNING")
      }
      
      guard let person = currentPerson,
        let firstName = firstNameField.text,
        let lastName = lastNameField.text,
        let phone = phoneField.text,
        let email = emailField.text else { return false }
      
      PersonCapabilityLegacy.setFirstName(firstName, model: person)
      PersonCapabilityLegacy.setLastName(lastName, model: person)
      PersonCapabilityLegacy.setMobileNumber(phone, model: person)
      PersonCapabilityLegacy.setEmail(email, model: person)
      
      createGif()
      DispatchQueue.global(qos: .background).async {
        _ = self.currentPerson?.commit()
          .swiftThenInBackground { _ in
            _ = self.currentPerson?.refresh()
              .swiftThen({_ in
                self.hideGif()
                
                return nil
              })
              .swiftCatch({ error in
                self.hideGif()
                
                let receivedError: NSError? = error as? NSError
                self.displayGenericErrorMessageWithError(receivedError)
                
                return nil
              })
            return nil
          }
          .swiftCatch { error in
            self.hideGif()
            
            let receivedError: NSError? = error as? NSError
            self.displayGenericErrorMessageWithError(receivedError)
            
            return nil
        }
      }
    } else {
      if self.phoneField.text?.count == 0 {
        let msg = "A phone number is required so Arcus can contact you in the event of an alarm."
        self.displayErrorMessage(msg, withTitle: "Phone Number Required")
      } else {
        let message = errorMessage as String?
        self.displayErrorMessage(message,
                                 withTitle: "Error")
      }
    }
    return success
  }
  
}
