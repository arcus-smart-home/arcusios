//
//  WaterHeaterCustomizationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/3/18.
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
import RxSwift

class WaterHeaterCustomizationViewController: UIViewController {
 
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
   Required by PairingCustomizationStepPresenter
   */
  @IBOutlet weak var actionButton: UIButton!
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var pairingCustomizationViewModel = PairingCustomizationViewModel()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var stepIndex = 0
  
  /**
   Required by WaterHeaterCustomizationPresenter
   */
  var waterHeaterData = WaterHeaterCustomizationViewModel()
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var modelNumberField: UITextField!
  
  @IBOutlet weak var serialNumberField: UITextField!

  static func create() -> WaterHeaterCustomizationViewController {
    let storyboard = UIStoryboard(name: "WaterHeaterCustomization", bundle: nil)
    let id = "WaterHeaterCustomizationViewController"
    if let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? WaterHeaterCustomizationViewController {
      return viewController
    }
    
    return WaterHeaterCustomizationViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    waterHeaterObserveChanges()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    waterHeaterFetchData()
    addKeyboardScrolling()
    updateActionButtonText()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    cleanUpKeyboardScrollingObservers()
  }

  @IBAction func actionButtonPressed(_ sender: Any) {
    retrieveDataFromFields()
    waterHeaterSaveData()
    addCustomization(PairingCustomizationStepType.waterHeater.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeWaterHeater)

    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  private func retrieveDataFromFields() {
    if let modelNumber = modelNumberField.text {
      waterHeaterData.modelNumber = modelNumber
    }
    if let serialNumber = serialNumberField.text {
      waterHeaterData.serialNumber = serialNumber
    }
  }
  
  private func configureViews() {
    addScleraStyleToNavigationTitle()
    addScleraBackButton()
    updateActionButtonText()
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      titleLabel.text = title
    }
    if let descriptionParagraphs = currentStepViewModel()?.description, descriptionParagraphs.count > 0 {
      descriptionLabel.text = descriptionParagraphs.joined(separator: "\n\n")
    }
  }
  
  fileprivate func updateViews() {
    modelNumberField.text = waterHeaterData.modelNumber
    serialNumberField.text = waterHeaterData.serialNumber
  }
  
}

extension WaterHeaterCustomizationViewController: PairingCustomizationStepPresenter {
  
}

extension WaterHeaterCustomizationViewController: WaterHeaterCustomizationPresenter {
  
  func waterHeaterDataUpdated() {
    updateViews()
  }
  
}

extension WaterHeaterCustomizationViewController: ScrollViewKeyboardAnimatable {
  
  func activeViewForKeyboardScroll() -> UIView? {
    if serialNumberField.isFirstResponder {
      return serialNumberField
    } else if modelNumberField.isFirstResponder {
      return modelNumberField
    }
    
    return nil
  }
  
}
