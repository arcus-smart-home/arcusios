//
//  SecurityModeViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/29/18.
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

class SecurityModeViewController: UIViewController {
  
  /**
   Required by PairingCustomizationStepPresenter & SecurityModePresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by PairingCustomizationStepPresenter & SecurityModePresenter
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
   Required by SecurityModePresenter
   */
  var securityModeChoices = [SecurityModeChoiceViewModel]()
  
  @IBOutlet weak var stepImageView: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var infoLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  let tableViewContentSizeKey = "contentSize"
  
  static func create() -> SecurityModeViewController? {
    let storyboard = UIStoryboard(name: "SecurityMode", bundle: nil)
    let id = "SecurityModeViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? SecurityModeViewController else {
        return nil
    }
    
    return viewController
  }
  
  deinit {
    tableView.removeObserver(self, forKeyPath: tableViewContentSizeKey)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    securityModeFetchData()
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
    securityModeSaveData()
    addCustomization(PairingCustomizationStepType.securityMode.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeSecurityMode)
    
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
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 78
    tableView.tableFooterView = UIView()
    tableView.addObserver(self,
                          forKeyPath: tableViewContentSizeKey,
                          options: .new,
                          context: nil)
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      titleLabel.text = title
    }
    if let info = currentStepViewModel()?.info {
      infoLabel.text = info
    }
    if let descriptionParagraphs = currentStepViewModel()?.description, descriptionParagraphs.count > 0 {
      descriptionLabel.text = descriptionParagraphs.joined(separator: "\n\n")
    }
  }
  
  fileprivate func updateTableViewHeight() {
    guard tableViewHeight.constant != tableView.contentSize.height else {
      return
    }
    
    tableViewHeight.constant = tableView.contentSize.height
  }
  
}

extension SecurityModeViewController: PairingCustomizationStepPresenter {
  
}

extension SecurityModeViewController: SecurityModePresenter {
  
  func securityModeDataUpdated() {
    tableView.reloadData()
  }
  
}

extension SecurityModeViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return securityModeChoices.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard securityModeChoices.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityModeSelectionCell")
        as? SecurityModeSelectionCell else {
          return UITableViewCell()
    }
    
    let choice = securityModeChoices[indexPath.row]
    let checked = choice.isSelected ? "check_teal_30x30" : "uncheck_30x30"
    cell.choiceTitle.text = choice.title
    cell.choiceDescription.text = choice.description
    cell.checkmarkImageView.image = UIImage(named: checked)
    
    return cell
  }
  
}

extension SecurityModeViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row < securityModeChoices.count else {
      return
    }
    
    for (index, _) in securityModeChoices.enumerated() {
      securityModeChoices[index].isSelected = index == indexPath.row
    }
    
    tableView.reloadData()
  }
  
}
