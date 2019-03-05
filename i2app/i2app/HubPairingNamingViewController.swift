//
//  HubPairingNamingViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/13/18.
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
import RxSwift

class HubPairingNamingViewController: UIViewController, HubPairingNamingPresenter {

  var nameHubViewModel = NameHubViewModel()

  /**
   Required by HubPairingNamingPresenter
   */
  var disposeBag = DisposeBag()

  /**
   Required by NameDevicePresenter
   */
  var deviceImageSize = CGSize.zero

  /**
   Required by NameDevicePresenter
   */
  var deviceImageScale: CGFloat = 0

  /**
   Required by ScrollViewKeyboardAnimatable
   */
  var keyboardAnimatableShowObserver: Any?

  /**
   Required by ScrollViewKeyboardAnimatable
   */
  @IBOutlet weak var keyboardAnimationView: UIScrollView!

  /**
   Required by ScrollViewKeyboardAnimatable
   */
  var keyboardAnimatableHideObserver: Any?

  /**
   Required by ImagePickerViewable
   */
  let imagePicker = UIImagePickerController()

  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var nameTextField: ScleraTextField!
  @IBOutlet weak var deviceImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    configureViews()
    nameHubPresenterFetchData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    updateViews()
    addKeyboardScrolling()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    cleanUpKeyboardScrollingObservers()
    _ = validateNameField()
  }

  @IBAction func actionButtonPressed(_ sender: Any) {
    guard validateNameField() else {
      return
    }
    if let fieldText = nameTextField.text {
      nameHubViewModel.deviceName = fieldText
    }
    nameHubPresenterSaveData()
  }

  @IBAction func cameraButtonPressed(_ sender: Any) {
    presentAlertControllerForImagePicker()
  }

  // MARK: Naming Presenter

  func nameHubDataUpdated() {
    updateViews()
  }

  @discardableResult private func validateNameField() -> Bool {
    guard let currentName = nameTextField.text,
      currentName != "" else {
        applyErrorToNameField()
        return false
    }

    removeErrorFromNameField()
    return true
  }

  fileprivate func removeErrorFromNameField() {
    nameTextField.removeError()
    actionButton.isEnabled = true
  }

  private func applyErrorToNameField() {
    nameTextField.showError(errorText: "Missing Hub Name")
    actionButton.isEnabled = false
  }

  private func configureViews() {
    removeScleraBackButton()
    addScleraStyleToNavigationTitle()
    deviceImageView.layer.cornerRadius = self.deviceImageView.frame.size.width/2.0
    deviceImageView.contentMode = UIViewContentMode.scaleAspectFill
    deviceImageView.clipsToBounds = true

    nameTextField.inlineValidation = {
      self.validateNameField()
    }
  }

  fileprivate func updateViews() {
    if let image = nameHubViewModel.deviceImage {
      deviceImageView.image = image
    } else if let image = nameHubViewModel.deviceImagePlaceholder {
      deviceImageView.image = image
    }
    nameTextField.text = nameHubViewModel.deviceName
    validateNameField()
  }

  func shouldPresentNext() {
    if navigationController?.topViewController == self {
      performSegue(withIdentifier: HubPairingSegues.complete.rawValue,
                 sender: nil)
    }
  }
  
  func shouldPresentSuccessKit() {
    if navigationController?.topViewController == self {
      performSegue(withIdentifier: HubPairingSegues.successKit.rawValue, sender: self)
    }
  }
}

extension HubPairingNamingViewController: ScrollViewKeyboardAnimatable {

  func activeViewForKeyboardScroll() -> UIView? {
    return nameTextField
  }

}

extension HubPairingNamingViewController: ImagePickerViewable {

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    nameHubViewModel.deviceImage = getPickedMedia(withInfo: info)
    // Save the current device name before updating the view
    if let name = nameTextField.text,
      !name.isEmpty {
      nameHubViewModel.deviceName = name
    }
    updateViews()
    dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }

}

extension HubPairingNamingViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if textField == nameTextField {
      removeErrorFromNameField()
    }

    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = textField.text {
      nameHubViewModel.deviceName = text
    }
    updateViews()
  }
}
