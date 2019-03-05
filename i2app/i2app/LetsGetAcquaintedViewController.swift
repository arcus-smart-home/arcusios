//
//  LetsGetAcquaintedViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/26/18.
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
import RxSwift
import Cornea

extension Constants {
  static let kAccountCreationImageKey: String = "createdAccountImage"
  static let kAccountCreationSegue: String = "ShowAccountCreationSegue"
}

/**
 Struct defining strings used in `LetsGetAcquaintedViewController`
 */
struct LetGetAquaintedStrings {
  static let missingFirstNameError: String = "Missing First Name"
  static let missingLastNameError: String = "Missing Last Name"
  static let missingPhoneError: String = "Missing Phone Number"
  static let invalidPhoneError: String = "Invalid Phone Number"
}

class LetsGetAcquaintedViewController: UIViewController,
ArcusAccountCreationPresenter,
ScrollViewKeyboardAnimatable,
PhoneNumberMasking {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var personImage: UIImageView!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var firstNameTextField: ScleraTextField!
  @IBOutlet weak var lastNameTextField: ScleraTextField!
  @IBOutlet weak var phoneNumberTextField: ScleraTextField!
  @IBOutlet weak var nextButton: ScleraButton!

  // MARK: ScrollViewKeyboardAnimatable Properties
  var keyboardAnimationView: UIScrollView! {
    return scrollView
  }

  var keyboardAnimatableShowObserver: Any?
  var keyboardAnimatableHideObserver: Any?

  // MARK: ImagePickerViewable Properties
  let imagePicker = UIImagePickerController()

  // MARK: ArcusAccountCreationPresenter Properties
  var accountCreationModel: ArcusAccountCreationViewModel! = AccountCreationViewModel()
  var disposeBag: DisposeBag = DisposeBag()
  var disposable: Disposable?

  // MARK: View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Next button is disabled by default. (Disabling in the storyboard does not update the background color.)
    nextButton.isEnabled = false
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Add Sclera font to Navigation Title.
    addScleraStyleToNavigationTitle()

    // Update `personImage` ImageView to round edges of custom image.
    configurePersonImage()

    // Add observer of `AccountCreationModel.state` to enable/disable Next Button.
    observeAccountCreationModelState()

    // Configure scrolling for keyboard show/hide.
    addKeyboardScrolling()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Dispose of `AccountCreationModel.state` observer.
    removeAccountCreationModelStateObserver()

    // Remove keyboard observers.
    cleanUpKeyboardScrollingObservers()
  }

  // MARK: UI Configuration

  /**
   Update `personImage` ImageView to round edges of custom image.
   */
  func configurePersonImage() {
    personImage.layer.cornerRadius = personImage.frame.size.width / 2.0
    personImage.contentMode = UIViewContentMode.scaleAspectFill
    personImage.clipsToBounds = true
  }

  // MARK: UI Observers

  /**
   Add observer of `AccountCreationModel.state` to enable/disable Next Button.
   */
  func observeAccountCreationModelState() {
    disposable = accountCreationModel.state.asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] state in
        DDLogError(state.debugDescription)
        self?.nextButton.isEnabled = state.contains(.aquaintedViewSet)
      })
    disposable?.disposed(by: disposeBag)
  }

  /**
   Dispose of `AccountCreationModel.state` observer.
   */
  func removeAccountCreationModelStateObserver() {
    disposable?.dispose()
  }

  // MARK: IBActions

  @IBAction func cameraButtonPressed(_ sender: AnyObject) {
    presentAlertControllerForImagePicker()
  }

  @IBAction func cancelButtonPressed(_ sender: AnyObject) {
    navigationController?.dismiss(animated: true, completion: nil)
  }

  @IBAction func firstNameDidChange(_ sender: AnyObject) {
    guard let textField = sender as? UITextField else {
      return
    }
    userUpdatedFirstName(textField.text)
  }

  @IBAction func lastNameDidChange(_ sender: AnyObject) {
    guard let textField = sender as? UITextField else {
      return
    }
    userUpdatedLastName(textField.text)
  }

  @IBAction func phoneNumberDidChange(_ sender: AnyObject) {
    guard let textField = sender as? UITextField, let text = textField.text else {
      return
    }

    // Strip formatting mask.
    let phoneString = stripPhoneMask(text)

    // Attempt to update phone number.
    userUpdatedPhoneNumber(phoneString)

    // Apply formatting mask to textfield text.
    textField.text = applyPhoneMask(phoneString)
  }

  // MARK: ShowKeyboardAnimatable Functions

  /**
   Required by `ScrollViewKeyboardAnimatable`
  */
  func activeViewForKeyboardScroll() -> UIView? {
    if firstNameTextField.isFirstResponder {
      return firstNameTextField
    }

    if lastNameTextField.isFirstResponder {
      return lastNameTextField
    }

    if phoneNumberTextField.isFirstResponder {
      return phoneNumberTextField
    }
    return nil
  }

  // MARK: PrepareForSegue

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.kAccountCreationSegue {
      if var destination = segue.destination as? ArcusAccountCreationSubmissionPresenter {
        destination.accountCreationModel = self.accountCreationModel
      }
    }
  }
}

// MARK: UITextFieldDelegate

extension LetsGetAcquaintedViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let textField = textField as? ScleraTextField else { return }

    var isValid: Bool = true

    defer {
      if isValid {
        textField.removeError()
      }
    }

    if textField == firstNameTextField {
      let string = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      if let firstName: String = string, validateFirstName(firstName) {

      } else {
        textField.showError(errorText: LetGetAquaintedStrings.missingFirstNameError)
        isValid = false
      }
    } else if textField == lastNameTextField {
      if let lastName: String = textField.text, validateLastName(lastName) {

      } else {
        textField.showError(errorText: LetGetAquaintedStrings.missingLastNameError)
        isValid = false
      }
    } else if textField == phoneNumberTextField {
      if let phoneNumber: String = textField.text, phoneNumber.count > 0 {
        if validatePhoneNumber(stripPhoneMask(phoneNumber)) {

        } else {
          textField.showError(errorText: LetGetAquaintedStrings.invalidPhoneError)
          isValid = false
        }
      } else {
        textField.showError(errorText: LetGetAquaintedStrings.missingPhoneError)
        isValid = false
      }
    }
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if textField == firstNameTextField || textField == lastNameTextField {

    } else if textField == phoneNumberTextField,
      let text = textField.text as NSString? {
      let newString = text.replacingCharacters(in: range, with: string)

      // If string contains leading 1 or "1 ", then allow it to be deleted.
      if let stringText = text as String?, stringText.count > 0,
        stringText[stringText.startIndex] == "1" && string == "" {
        return true
      }

      // Strip formatting mask.
      let phoneString = stripPhoneMask(newString)

      // Check for 1 before area code.
      var leadingOne = false
      if  phoneString.count > 0 {
        leadingOne = (phoneString[phoneString.startIndex] == "1")
      }

      // Do not allow updating if max length is met.
      if phoneString.count == 0 ||
        (phoneString.count > 10 && !leadingOne) ||
        phoneString.count > 11 {
        if (text.length + string.count - range.length) > 10 {
          return false
        }
      }

      // Don't allow non-numeric text entry. (Copy/Paste)
      if phoneString == "" && newString.count > 0 && newString != " " {
        return false
      }
    }
    return true
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    if let textField = textField as? ScleraTextField {
      textField.removeError()
    }

    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == firstNameTextField {
      _ = lastNameTextField.becomeFirstResponder()
    } else if textField == lastNameTextField {
      _ = phoneNumberTextField.becomeFirstResponder()
    } else if textField == phoneNumberTextField {
      _ = phoneNumberTextField.resignFirstResponder()
    }

    return true
  }
}

/**
 Required by `ImagePickerViewable`
 */
extension LetsGetAcquaintedViewController: ImagePickerViewable {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    // Scale the users image properly
    let scaledImage = ImagePicker.sharedInstance().scaleAndRotateImage(newImage)
    // Cache Image
    let key = Constants.kAccountCreationImageKey + UUID().uuidString.replacingOccurrences(of: "-", with: "")
    AKFileManager.default().cacheImage(scaledImage, forHash: key)
    accountCreationModel.temporaryUserImage = scaledImage
    
    // Update ImageView
    personImage.image = scaledImage

    // Dismiss image selection modal.
    dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // Dismiss image selection modal.
    dismiss(animated: true, completion: nil)
  }
}
