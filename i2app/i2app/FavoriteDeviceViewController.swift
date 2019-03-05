//
//  FavoriteDeviceViewController.swift
//  i2app
//
//  Created by Arcus Team on 2/27/18.
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

class FavoriteDeviceViewController: UIViewController {
  
  @IBOutlet weak var heartFilled: UIImageView!
  @IBOutlet weak var actionInstructionLabel: UILabel!
  @IBOutlet weak var stepTitle: UILabel!
  @IBOutlet weak var stepInfo: UILabel!
  
  /**
   Required by FavoriteDevicePresenter
   */
  var disposeBag = DisposeBag()

  /**
   Required by FavoriteDevicePresenter and PairingCustomizationStepPresenter
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
  
  var viewModel = FavoriteDeviceViewModel()
  
  static func create() -> FavoriteDeviceViewController? {
    let storyboard = UIStoryboard(name: "FavoriteDevice", bundle: nil)
    let id = "FavoriteDeviceViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? FavoriteDeviceViewController else {
      return nil
    }
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
    
    favoriteDevicePresenterFetchData()
  }
  
  @IBAction func heartButtonPressed(_ sender: Any) {
    viewModel.isFavorite = !viewModel.isFavorite
    updateViews()
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    favoriteDevicePresenterSaveFavoriteState()
    addCustomization(PairingCustomizationStepType.favorite.rawValue)
    
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
      stepTitle.text = title
    }
    if let description = currentStepViewModel()?.description, description.count > 0 {
      stepInfo.text = description.joined(separator: "\n\n")
    }
  }
  
  fileprivate func updateViews() {
    let favoriteState = viewModel.isFavorite
    let instructionText = favoriteState ? "to remove from Favorites!" : "to add to Favorites!"
    
    actionInstructionLabel.text = instructionText
    
    // Animate Fill
    if favoriteState {
      if heartFilled.isHidden {
        heartFilled.alpha = 0
        heartFilled.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
          self.heartFilled.alpha = 1.0
        })
      }
    } else {
      if !heartFilled.isHidden {
        UIView.animate(withDuration: 0.3, animations: {
          self.heartFilled.alpha = 0
        }, completion: { (_) in
          self.heartFilled.isHidden = true
        })
      }
    }
  }
  
}

extension FavoriteDeviceViewController: PairingCustomizationStepPresenter {
  
}

extension FavoriteDeviceViewController: FavoriteDevicePresenter {
  
  func favoriteDevicePresenterDataUpdated() {
    updateViews()
  }
  
}
