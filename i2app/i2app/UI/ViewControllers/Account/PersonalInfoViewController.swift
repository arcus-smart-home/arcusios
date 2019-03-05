//
//  PersonalInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/17/16.
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
import PromiseKit

class PersonalInfoViewController: BaseTextViewController, RegistrationConfigHolder {
  //This is how far the top of the phone number explanation should be from the bottom of
  //the screen when the screen is bigger than an iPhone 6
  static let iPhone6Height: Float = 667.0
  static let explanationTopConstraintOffset: Float = 182.0

  @IBOutlet internal var lastNameTextField: AccountTextField!
  @IBOutlet internal var firstNameTextField: AccountTextField!
  @IBOutlet internal var phoneNumberTextField: AccountTextField!
  @IBOutlet internal var personalizationLabel: UILabel!
  @IBOutlet internal var phoneNumberExplanationLabel: UILabel!
  @IBOutlet internal var photoButton: UIButton!
  @IBOutlet internal var nextButton: UIButton!
  @IBOutlet internal var scrollView: UIScrollView!
  @IBOutlet internal var phoneNumberExplanationTopConstraint: NSLayoutConstraint!

  internal var config: RegistrationConfig?

  class func create() -> PersonalInfoViewController {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc: PersonalInfoViewController? = storyboard
      .instantiateViewController(withIdentifier: "PersonalInfoViewController")
      as? PersonalInfoViewController

    vc?.config = AccountRegistrationConfig()

    return vc!
  }

  class func create(_ config: RegistrationConfig) -> PersonalInfoViewController {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc: PersonalInfoViewController? = storyboard
      .instantiateViewController(withIdentifier: "PersonalInfoViewController")
      as? PersonalInfoViewController

    vc?.config = config

    return vc!
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setNavBarTitle(NSLocalizedString("About You", comment: ""))
    // We need to hide the back button for this screen
    self.navigationItem.setHidesBackButton(true, animated: false)

    self.setupView()
  }

  func setupView() {
    self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "")
    self.firstNameTextField.setupType(AccountTextFieldTypeGeneral)

    self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "")
    self.lastNameTextField.setupType(AccountTextFieldTypeGeneral)

    self.phoneNumberTextField.placeholder = "0"
    self.phoneNumberTextField.keyboardType = UIKeyboardType.numberPad
    self.phoneNumberTextField.setupType(AccountTextFieldTypePhone)

    self.nextButton.styleSet(NSLocalizedString("next", comment: ""),
                             andButtonType:FontDataTypeButtonDark,
                             upperCase:true)

    self.personalizationLabel.text = NSLocalizedString("Tell us about yourself and add a photo if you like.",
                                                       comment: "")
    let txt = NSLocalizedString("Your phone number will only be used to call you when an alarm is triggered.",
                                comment: "")
    self.phoneNumberExplanationLabel.text = txt
  }

  // MARK: Save Registration Context

  override func saveRegistrationContext() {
    self.createGif()

    guard let firstName = self.firstNameTextField.text,
      let lastName = self.lastNameTextField.text,
      let phone = self.phoneNumberTextField.text,
      let personModel = RxCornea.shared.settings?.currentPerson,
      let accountModel = RxCornea.shared.settings?.currentAccount else {
        return
    }

    DispatchQueue.global(qos: .background).async {
      var promise: PMKPromise?
      if self.config is AccountRegistrationConfig {
        promise = AccountController
          .setPersonDetailsAndCompleteStep(firstName,
                                           lastName: lastName,
                                           phoneNumber: phone,
                                           personModel: personModel,
                                           accountModel: accountModel)
      } else if self.config is InvitationRegistrationConfig {
        promise = AccountController.setPersonDetails(firstName,
                                                         lastName: lastName,
                                                         phoneNumber: phone,
                                                         personModel: personModel,
                                                         accountModel: accountModel)
      }

      _ = promise?.swiftThen { _ in
        self.hideGif()

        var vc: UIViewController?

        if self.config is AccountRegistrationConfig {
          vc = AccountCreationHomeInfoViewController.create()
        } else if let _: InvitationRegistrationConfig = self.config
          as? InvitationRegistrationConfig {
          vc = SecurityQuestionsViewController.create(self.config!)
        }

        self.navigationController?.pushViewController(vc!, animated: true)

        return nil
        }
        .swiftCatch { error in
          guard let error = error as? NSError else { return nil }
          self.hideGif()

          self.displayErrorMessage(error.localizedDescription)

          return nil
      }

    }
  }

  @IBAction func photoButtonPressed(_ sender: AnyObject) {
    if let imageId: String = RxCornea.shared.settings?.currentPerson?.modelId as String? {
      ImagePicker.sharedInstance()
        .present(in: self, withImageId: imageId) { image in
          ImagePicker.save(image, imageName: imageId)

          self.photoButton.layer.cornerRadius = self.photoButton.frame.size.width/2.0
          self.photoButton.layer.borderColor = UIColor.black.cgColor
          self.photoButton.layer.borderWidth = 1.0
          self.photoButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
          self.photoButton.setImage(image, for: UIControlState())
      }
    }
  }

  @IBAction func nextButtonPressed(_ sender: AnyObject) {
    //        DDLogWarn(@"Account Creation: trying to save About you information")
    super.validateTextFields()
  }
}
