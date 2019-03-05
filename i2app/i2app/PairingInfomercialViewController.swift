//
//  PairingInfomercialViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/20/18.
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

class PairingInfomercialViewController: UIViewController {

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

  @IBOutlet weak var stepImage: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var linkURLButton: UIButton!
  
  static func create() -> PairingInfomercialViewController? {
    let storyboard = UIStoryboard(name: "PairingInfomercial", bundle: nil)
    let id = "PairingInfomercialViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? PairingInfomercialViewController else {
        return nil
    }
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  @IBAction func linkURLButtonPressed(_ sender: Any) {
    if let urlString = currentStepViewModel()?.linkURL, let url = URL(string: urlString) {
      UIApplication.shared.openURL(url)
    }
  }
  
  private func configureViews() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
    updateActionButtonText()
    
    // Set up image if needed
    fetchImageForStep { (image) in
      if let image = image {
        self.stepImage.image = image
        self.stepImage.isHidden = false
      }
    }
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      titleLabel.text = title
    }
    if let description = currentStepViewModel()?.description {
      descriptionLabel.text = description.joined(separator: "\n\n")
    }
    if let urlButtonText = currentStepViewModel()?.linkText {
      linkURLButton.isHidden = false
      linkURLButton.setTitle(urlButtonText, for: .normal)
    }
  }
  
}

extension PairingInfomercialViewController: PairingCustomizationStepPresenter {
  
}
