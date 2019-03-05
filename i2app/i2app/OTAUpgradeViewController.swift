//
//  OTAUpgradeViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/26/18.
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

class OTAUpgradeViewController: UIViewController {
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by PairingCustomizationStepPresenter
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
  
  var viewModel = OTAUpgradeViewModel()
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var upgradePercentLabel: UILabel!
  @IBOutlet weak var upgradeProgressView: UIProgressView!
  
  static func create() -> OTAUpgradeViewController? {
    let storyboard = UIStoryboard(name: "OTAUpgrade", bundle: nil)
    let id = "OTAUpgradeViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? OTAUpgradeViewController else {
        return nil
    }
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
    
    otaUpgradeObserveChanges()
    otaUpgradeFetchData()
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    addCustomization(PairingCustomizationStepType.otaUpgrade.rawValue)
    
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  private func configureViews() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
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
    if let info = currentStepViewModel()?.info, let text = descriptionLabel.text {
      descriptionLabel.text = text + "\n\n\(info)"
    }
  }
  
  fileprivate func updateViews() {
    upgradePercentLabel.text = "\(viewModel.percentageCompleted)%"
    upgradeProgressView.setProgress(Float(viewModel.percentageCompleted) / 100.0, animated: true)
  }
  
}

extension OTAUpgradeViewController: OTAUpgradePresenter {
  
  func otaUpgradeViewModelUpdated() {
    updateViews()
  }
  
}

extension OTAUpgradeViewController: PairingCustomizationStepPresenter {
  
}
