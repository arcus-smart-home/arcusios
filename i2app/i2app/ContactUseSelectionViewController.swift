//
//  ContactUseSelectionViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/19/18.
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
import Cornea

class ContactUseSelectionViewController: UIViewController {
  
  /**
   Required by ContactUseSelectionPresenter and PairingCustomizationStepPresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by ContactUseSelectionPresenter and PairingCustomizationStepPresenter
   */
  var deviceAddress = ""

  /**
   Required by ContactUseSelectionPresenter
   */
  var deviceImage: UIImage?
  
  /**
   Required by ContactUseSelectionPresenter
   */
  var selectedContactUseChoice = ContactUseChoice.other
  
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
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var deviceImageView: UIImageView!
  
  static func create() -> ContactUseSelectionViewController? {
    let storyboard = UIStoryboard(name: "ContactDevice", bundle: nil)
    let id = "ContactUseSelectionViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? ContactUseSelectionViewController else {
        return nil
    }
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
    
    contactUsePresenterFetchData()
  }

  @IBAction func actionButtonPressed(_ sender: Any) {
    contactUsePresenterSaveData()
    addCustomization(PairingCustomizationStepType.contactType.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeContactType)
    
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }

  fileprivate func updateViews() {
    if let deviceImage = deviceImage {
      deviceImageView.image = deviceImage
    }
    
    tableView.reloadData()
    updateActionButtonText()
  }
  
  fileprivate func populate(cell: ContactUseChoiceCell, forRow row: Int) -> ContactUseChoiceCell {
    var imageName = ""
    let checkName = row == selectedContactUseChoice.rawValue ? "check_teal_30x30" : "uncheck_30x30"
    var title = ""
    
    if let selectedType = ContactUseChoice(rawValue: row) {
      switch selectedType {
      case .door:
        imageName = "door_45x45"
        title = "Door"
      case .window:
        imageName = "window_45x45"
        title = "Window"
      case .other:
        imageName = "more_45x45"
        title = "Other"
      }
    }
    
    cell.checkImageView.image = UIImage(named: checkName)
    cell.choiceImageView.image = UIImage(named: imageName)
    cell.choiceLabel.text = title
    return cell
  }

  private func configureViews() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      titleLabel.text = title
    }
  }
  
}

extension ContactUseSelectionViewController: PairingCustomizationStepPresenter {
  
}

extension ContactUseSelectionViewController: ContactUsePresenter {

  func contactUsePresenterDataUpdated() {
    updateViews()
  }
  
}

extension ContactUseSelectionViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell =
      tableView.dequeueReusableCell(withIdentifier: "ChoiceCell") as? ContactUseChoiceCell else {
      return UITableViewCell()
    }
    
    return populate(cell: cell, forRow: indexPath.row)
  }
  
}

extension ContactUseSelectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedChoice = ContactUseChoice(rawValue: indexPath.row) else {
      return
    }
    
    selectedContactUseChoice = selectedChoice
    updateViews()
  }
  
}
