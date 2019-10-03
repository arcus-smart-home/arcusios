//
//  AddPersonPhoneNumberViewController.swift
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
import CocoaLumberjack

class AddPersonPhoneNumberViewController: BaseTextViewController {
  @IBOutlet var photoBackground: UIImageView!
  @IBOutlet var phoneImage: ArcusBorderedImageView!
  @IBOutlet var photoButton: ArcusButton!
  @IBOutlet var instructionsLabel: ArcusLabel!
  @IBOutlet var instructionsSubLabel: ArcusLabel!
  @IBOutlet var acknowledgeLabel: ArcusLabel!
  @IBOutlet var phoneTextField: AccountTextField!
  @IBOutlet var nextButton: ArcusButton!

  internal var addPersonModel: AddPersonModel?
  fileprivate var initialSave: Bool! = true

  // MARK: View LifeCycle
  class func create() -> AddPersonPhoneNumberViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Person", bundle:nil)
    let viewController: AddPersonPhoneNumberViewController? =
      storyboard.instantiateViewController(withIdentifier: "AddPersonPhoneNumberViewController")
        as? AddPersonPhoneNumberViewController

    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)

    self.configureTextField()

    // By the time that a partial access person gets to this screen the person
    // has already been saved.
    if let addPersonModel = addPersonModel,
      addPersonModel.accessType != .fullAccess {
      initialSave = false
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if self.isMovingToParentViewController {
      self.configureForm(self.addPersonModel)
    }
  }

  // MARK: UI Configuration
  func configureForm(_ addPersonModel: AddPersonModel?) {
    if addPersonModel != nil {
      self.phoneTextField.text = addPersonModel?.phoneNumber
      if (self.phoneTextField.text?.count)! > 0 {
        self.nextButton.isEnabled = true
      }

      if addPersonModel?.image != nil {
        self.phoneImage.borderedModeEnabled = true
        self.phoneImage.image = addPersonModel?.image
      } else {
        self.phoneImage.borderedModeEnabled = false
      }
    }
  }

  func configureTextField() {
    self.phoneTextField.textColor = UIColor.black
    self.phoneTextField.floatingLabelTextColor =
      UIColor.black.withAlphaComponent(0.6)
    self.phoneTextField.floatingLabelActiveTextColor = UIColor.black
    self.phoneTextField.activeSeparatorColor = UIColor.black.withAlphaComponent(0.4)
    self.phoneTextField.separatorColor = UIColor.black.withAlphaComponent(0.4)
    self.phoneTextField.keyboardType = UIKeyboardType.phonePad
    self.phoneTextField.setupType(AccountTextFieldTypePhone,
                                  fontType: FontDataType_Medium_18_Black_NoSpace,
                                  placeholderFontType: FontDataTypeAccountTextFieldPlaceholder)
    self.phoneTextField.isRequired =
      (self.addPersonModel?.accessType == PersonAccessType.alarmNotificationsOnly)
  }

  // MARK: IBActions
  @IBAction func photoButtonPressed(_ sender: ArcusButton) {
    ImagePicker.sharedInstance().present(self,
                                         withImageId: "tempId",
                                         withCompletionBlock: {
                                          (image: UIImage?) -> Void in
                                          guard let personImage: UIImage = image else {
                                            DDLogInfo("Image selection has been canceled.")
                                            return
                                          }

                                          if personImage.isKind(of: UIImage.self) {
                                            self.addPersonModel!.image = personImage

                                            self.phoneImage.borderedModeEnabled = true
                                            self.phoneImage.image = self.addPersonModel!.image
                                          } else {
                                            self.phoneImage.borderedModeEnabled = false
                                          }
    })
  }

  @IBAction func nextButtonPressed(_ sender: ArcusButton) {
    if self.phoneTextField.text!.isEmpty {
      let subtitle = NSLocalizedString("Without a phone number, this person cannot be added to any "
        + "Alarm Notification List. Are you sure you want to skip?", comment: "")
      displayMessage(
        NSLocalizedString("NO PHONE NUMBER", comment: ""),
        subtitle: subtitle,
        backgroundColor: UIColor.white,
        buttonOne: NSLocalizedString("NO", comment: ""),
        buttonTwo: NSLocalizedString("YES", comment: ""),
        buttoneOneStyle: FontDataTypeButtonDark,
        buttonTwoStyle: FontDataTypeButtonPink,
        withTarget: self,
        withButtonOneSelector: #selector(self.slideOutTwoButtonAlert),
        andButtonTwoSelector: #selector(self.confirmNoPhone))
    } else {
      validateAndUpdate()
    }
  }

  func confirmNoPhone() {
    self.slideOutTwoButtonAlert()
    validateAndUpdate()
  }

  func validateAndUpdate() {
    if self.updateAddPersonModel() {
      self.addPersonModel?.savePersonModel(self.initialSave, completionHandler: { (success, _) in
        self.initialSave = false
        if success {
          if self.addPersonModel?.accessType == .fullAccess {
            self.performSegue(withIdentifier: "AddPersonNOSuccessSegue", sender: self)
          } else {
            if (self.addPersonModel?.pinCode ?? "").isEmpty {
              self.performSegue(withIdentifier: "PersonAddedSuccessSegue", sender: self)
            } else {
              // Display PIN screen if a PIN was created for this user
              self.performSegue(withIdentifier: "AddPersonPinCodeInfoSegue", sender: self)
            }
          }
        } else {
          self.displayGenericErrorMessage()
        }
      })
    }
  }

  func updateAddPersonModel() -> Bool {
    var string: NSString? = ""

    // Special case: No phone number is valid
    if self.phoneTextField.text!.isEmpty {
      return true
    }

    var success: Bool = self.isDataValid(&string)
    if success {
      success = self.phoneTextField.text!.isValidPhoneNumber()
      if success {
        self.addPersonModel?.phoneNumber = self.phoneTextField.text
      }
    } else {
      self.displayErrorMessage("Please provide a valid phone number",
                               withTitle: "Phone Number Invalid")
    }

    return success
  }

  // MARK: PerpareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonNOSuccessSegue" {
      let successViewController: AddPersonSuccessViewController? =
        segue.destination as? AddPersonSuccessViewController
      successViewController?.addPersonModel = self.addPersonModel
    } else if segue.identifier == "PersonAddedSuccessSegue" {
      let successViewController: AddPersonSuccessViewController? =
        segue.destination as? AddPersonSuccessViewController
      successViewController?.addPersonModel = self.addPersonModel
    } else if segue.identifier == "AddPersonPinCodeInfoSegue" {
      let pinInfoViewController: AddPersonInfoViewController? =
        segue.destination as? AddPersonInfoViewController
      pinInfoViewController?.addPersonModel = self.addPersonModel
    }
  }
}
