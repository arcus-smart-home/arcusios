//
//  PresenceAssignmentViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/22/18.
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

class PresenceAssignmentViewController: UIViewController {
  
  /**
   Required by PairingCustomizationStepPresenter & PresenceAssignmentPresenter
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
  
  /**
   Required by PresenceAssignmentPresenter
   */
  var presenceAssignmentChoices = [PresenceAssignmentChoiceViewModel]()
  
  /**
   Required by PresenceAssignmentPresenter
   */
  var deviceModelDisposable: Disposable?
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  let tableViewContentSizeKey = "contentSize"
  
  static func create() -> PresenceAssignmentViewController? {
    let storyboard = UIStoryboard(name: "PresenceAssignment", bundle: nil)
    let id = "PresenceAssignmentViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? PresenceAssignmentViewController else {
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    presenceAssignmentObserveChanges()
    presenceAssignmentFetchChoices()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    deviceModelDisposable?.dispose()
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
    addCustomization(PairingCustomizationStepType.presenceAssignment.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizePresenceAssignment)
    
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

extension PresenceAssignmentViewController: PairingCustomizationStepPresenter {
  
}

extension PresenceAssignmentViewController: PresenceAssignmentPresenter {
  
  func presenceAssignmentChoicesUpdated() {
    tableView.reloadData()
  }
  
}

extension PresenceAssignmentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenceAssignmentChoices.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard presenceAssignmentChoices.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell")
      as? PresenceAssignmentSelectionCell else {
      return UITableViewCell()
    }
    
    let choice = presenceAssignmentChoices[indexPath.row]
    let check = choice.isSelected ? "check_teal_30x30" : "uncheck_30x30"
    
    cell.personLabel.text = choice.choiceText
    cell.checkmarkImageView.image = UIImage(named: check)
    cell.personImageView.image = choice.choiceImage
      .exactZoomScaleAndCutSize(inCenter: CGSize(width: 45, height: 45))
      .roundCornerImageWithsize(CGSize(width: 45, height: 45))
    
    return cell
  }
  
}

extension PresenceAssignmentViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row < presenceAssignmentChoices.count else {
      return
    }
    
    presenceAssignmentSelect(choice: presenceAssignmentChoices[indexPath.row])
  }
  
}
