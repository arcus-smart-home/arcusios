//
//  PairingCustomizationStepPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/28/18.
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
import SDWebImage

/**
 Required interface and helper methods for view controllers that are used as customization steps.
 */
protocol PairingCustomizationStepPresenter: ArcusPairingDeviceCapability {
  
  /**
   View model holding the data for all the customization steps.
   */
  var pairingCustomizationViewModel: PairingCustomizationViewModel { get set }
  
  /**
   The current step index.
   */
  var stepIndex: Int { get set }
  
  /**
   The device address of the device being customized.
   */
  var deviceAddress: String { get set }
  
  /**
   Button used for forward navigation from step to step.
   */
  var actionButton: UIButton! { get set }
  
  // MARK: Extended
  
  /**
   Button used for canceling the step if needed.
   */
  var cancelButton: UIButton? { get set }

  /**
   Adds the given text as a customization fort the device. If the tag already exists it will not be added
   again.
   - parameter customization: The text with the customization to be added.
   */
  func addCustomization(_ customization: String)
  
  /**
   Checks if the current step is the last step.
   - returns: Booloan indicating if the current step is the last step.
   */
  func isLastStep() -> Bool
  
  /**
   Shows the cancel button if it is needed for the step.
   */
  func showCancelIfNeeded()
  
  /**
   Retrieves the view model for the current step.
   - returns: View model representing the step data for the current step.
   */
  func currentStepViewModel() -> PairingCustomizationStepViewModel?
  
  /**
   Updates the action button with the appropiate text for the step.
   */
  func updateActionButtonText()
  
  /**
   Retrieves the view controller to be presented next.
   - returns: View Controller for the next step. Nil if there is not a next step.
   */
  func nextStepViewController() -> UIViewController?
  
  /**
   Retrieves the image for the current step if an image is needed.
   - parameter completion: Called with the retrieved image.
   */
  func fetchImageForStep(completion: @escaping (UIImage?) -> Void)
  
  /**
   Adds a back button if the customization step needs it.
   */
  func addCustomizationStepBackButtonIfNeeded()
  
}

extension PairingCustomizationStepPresenter where Self: UIViewController {
  
  func addCustomizationStepBackButtonIfNeeded() {
    if let navigation = navigationController,
      navigation.viewControllers.count > 1,
      navigation.viewControllers[0] != self {
      addScleraBackButton()
    }
  }
  
}

extension PairingCustomizationStepPresenter {
  
  var cancelButton: UIButton? {
    get {
      return nil
    }
    set {
      
    }
  }
  
  func showCancelIfNeeded() {
    guard let cancel = cancelButton,
      let currentStep = currentStepViewModel(),
      let stepOrder = currentStep.order else {
      cancelButton?.isHidden = true
      return
    }
    
    cancel.isHidden = stepOrder != 0
  }
  
  func addCustomization(_ customization: String) {
    guard let model = pairingDeviceModel(deviceAddress) else {
      return
    }
    
    // Exit if this customization already exists.
    if let currentCustomizations = getPairingDeviceCustomizations(model) {
      for existingCustomization in currentCustomizations where existingCustomization == customization {
        return
      }
    }
    
    do {
      _ = try requestPairingDeviceAddCustomization(model, customization: customization)
    } catch {
      DDLogError("Error while attempting to add customization: \(customization) to \(deviceAddress)")
    }
  }
  
  func isLastStep() -> Bool {
    return pairingCustomizationViewModel.steps.count == stepIndex + 1
  }
  
  func currentStepViewModel() -> PairingCustomizationStepViewModel? {
    guard pairingCustomizationViewModel.steps.count > stepIndex else {
      return nil
    }
    
    return pairingCustomizationViewModel.steps[stepIndex]
  }
  
  func updateActionButtonText() {
    let title = isLastStep() ? "DONE" : "NEXT"
    
    if let actionButton = actionButton as? ScleraButton {
      actionButton.setTitle(title, for: .normal)
    } else {
      actionButton.titleLabel?.text = title
    }
  }
  
  func nextStepViewController() -> UIViewController? {
    let nextIndex = stepIndex + 1
    
    guard !isLastStep(),
      pairingCustomizationViewModel.steps.count > nextIndex,
      let nextStepType = pairingCustomizationViewModel.steps[nextIndex].stepType else {
      return nil
    }
    
    let vc = PairingCustomizationViewControllerFactory.viewController(forStepType: nextStepType)
    vc?.stepIndex = nextIndex
    vc?.pairingCustomizationViewModel = pairingCustomizationViewModel
    vc?.deviceAddress = deviceAddress
    
    return vc
  }
  
  func fetchImageForStep(completion: @escaping (UIImage?) -> Void) {
    guard let imageURL = currentStepViewModel()?.imageURL,
      let imageManager = SDWebImageManager.shared() else {
      completion(nil)
      return
    }
    
    if imageManager.cachedImageExists(for: imageURL) {
      let key = imageManager.cacheKey(for: imageURL)
      
      if let image = SDImageCache.shared().imageFromDiskCache(forKey: key) {
        completion(image)
      } else {
        completion(nil)
      }
    } else {
      imageManager.downloadImage(with: imageURL,
                                 options: .retryFailed,
                                 progress: { (_, _) in },
                                 completed: { (image, _, _, _, _) in
                                  completion(image)
      })
    }
    
  }
  
  private func pairingDeviceModel(_ deviceAddress: String) -> PairingDeviceModel? {
    guard let cache = RxCornea.shared.modelCache,
      let pairingDevices = cache.fetchModels(Constants.pairingDeviceNamespace) as? [PairingDeviceModel] else {
        return nil
    }
    
    for pairingModel in pairingDevices {
      if getPairingDeviceDeviceAddress(pairingModel) == deviceAddress {
        return pairingModel
      }
    }
    
    return nil
  }
  
}
