//
//  NameDeviceViewController.swift
//  i2app
//
//  Created by Arcus Team on 2/20/18.
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

import Foundation
import Cornea
import RxSwift

class NameDeviceViewController: UIViewController {

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
   Required by NameDevicePresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by NameDevicePresenter and PairingCustomizationStepPresenter
   */
  var deviceAddress = ""

  /**
   Required by NameDevicePresenter
   */
  var deviceImageSize = CGSize.zero
  
  /**
   Required by NameDevicePresenter
   */
  var deviceImageScale: CGFloat = 0

  /**
   Required by NameDevicePresenter
   */
  var nameDeviceViewModel = NameDeviceViewModel()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  @IBOutlet weak var actionButton: UIButton!
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  @IBOutlet weak var cancelButton: UIButton?
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var pairingCustomizationViewModel = PairingCustomizationViewModel()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var stepIndex = 0
  
  /**
   Required by ImagePickerViewable
   */
  let imagePicker = UIImagePickerController()
  
  @IBOutlet weak var nameTextField: ScleraTextField!
  @IBOutlet weak var stepTitle: UILabel!
  @IBOutlet weak var stepInfo: UILabel!
  @IBOutlet weak var deviceImageView: UIImageView!
  
  static func create() -> NameDeviceViewController {
    let storyboard = UIStoryboard(name: "NameDevice", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "NameDeviceViewController")
      as? NameDeviceViewController {
      return viewController
    }
    
    return NameDeviceViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    nameDevicePresenterFetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    addKeyboardScrolling()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    cleanUpKeyboardScrollingObservers()
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    guard validateNameField() else {
      return
    }
    
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeName)
    
    if let fieldText = nameTextField.text {
      nameDeviceViewModel.deviceName = fieldText
    }
    
    nameDevicePresenterSaveData()
    addCustomization(PairingCustomizationStepType.name.rawValue)
    
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  @IBAction func cameraButtonPressed(_ sender: Any) {
    presentAlertControllerForImagePicker()
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
    nameTextField.showError(errorText: "Missing device name")
    actionButton.isEnabled = false
  }
  
  private func configureViews() {
    addScleraStyleToNavigationTitle()
    updateActionButtonText()
    showCancelIfNeeded()
    addCustomizationStepBackButtonIfNeeded()
    
    if let imageSize = deviceImageView.image?.size {
      deviceImageSize = imageSize
    }
    
    if let imageScale = deviceImageView.image?.scale {
      deviceImageScale = imageScale
    }
    
    deviceImageView.layer.cornerRadius = deviceImageView.frame.size.width/2.0
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      stepTitle.text = title
    }
    if let description = currentStepViewModel()?.description, description.count > 0 {
      stepInfo.text = description.joined(separator: "\n\n")
    }
    
    nameTextField.inlineValidation = {
      self.validateNameField()
    }
  }
  
  fileprivate func updateViews() {
    if let image = nameDeviceViewModel.deviceImage {
      deviceImageView.image = image
    } else if let image = nameDeviceViewModel.deviceImagePlaceholder {
      deviceImageView.image = image
    }
    
    nameTextField.text = nameDeviceViewModel.deviceName
    validateNameField()
  }
}

extension NameDeviceViewController: ScrollViewKeyboardAnimatable {
  
  func activeViewForKeyboardScroll() -> UIView? {
    return nameTextField
  }
  
}

extension NameDeviceViewController: ImagePickerViewable {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    nameDeviceViewModel.deviceImage = getPickedMedia(withInfo: info)
    updateViews()
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension NameDeviceViewController: UITextFieldDelegate {
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
      nameDeviceViewModel.deviceName = text
    }
    updateViews()
  }
}

extension NameDeviceViewController: PairingCustomizationStepPresenter {
  
}

extension NameDeviceViewController: NameDevicePresenter {
  
  func nameDeviceDataUpdated() {
    updateViews()
  }
  
}
