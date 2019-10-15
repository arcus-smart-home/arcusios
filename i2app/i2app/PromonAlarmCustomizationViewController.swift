//
//  PromonAlarmCustomizationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/2/18.
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

class PromonAlarmCustomizationViewController: UIViewController {
  
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
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var linkURLButton: UIButton!
  
  let tableViewContentSizeKey = "contentSize"
  
  static func create() -> PromonAlarmCustomizationViewController? {
    let storyboard = UIStoryboard(name: "PromonAlarmCustomization", bundle: nil)
    let id = "PromonAlarmCustomizationViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? PromonAlarmCustomizationViewController else {
        return nil
    }
    
    return viewController
  }
  
  deinit {
    tableView.removeObserver(self, forKeyPath: tableViewContentSizeKey)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if keyPath == tableViewContentSizeKey {
      updateTableViewHeight()
    }
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    addCustomization(PairingCustomizationStepType.promonAlarm.rawValue)
    
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
      UIApplication.shared.open(url)
    }
  }
  
  private func configureViews() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
    updateActionButtonText()
    
    tableView.addObserver(self,
                          forKeyPath: tableViewContentSizeKey,
                          options: .new,
                          context: nil)
    linkURLButton.titleLabel?.textAlignment = .center
    
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
  
  fileprivate func updateTableViewHeight() {
    guard tableViewHeight.constant != tableView.contentSize.height else {
      return
    }
    
    tableViewHeight.constant = tableView.contentSize.height
  }
  
}

extension PromonAlarmCustomizationViewController: PairingCustomizationStepPresenter {
  
}

extension PromonAlarmCustomizationViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let currentStep = currentStepViewModel(),
      let choices = currentStep.choices else {
        return 0
    }
    
    return choices.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let currentStep = currentStepViewModel(),
      let choices = currentStep.choices,
      choices.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "PromonAlarmCustomizationCell")
        as? PromonAlarmCustomizationCell else {
          return UITableViewCell()
    }
    
    cell.alarmName.text = choices[indexPath.row].capitalized
    return cell
  }
  
}
