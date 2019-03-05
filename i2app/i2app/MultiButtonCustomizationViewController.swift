//
//  MultiButtonCustomizationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/24/18.
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

class MultiButtonCustomizationViewController: UIViewController {
  
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
  
  var viewModels = [MultiButtonCustomizationViewModel]()
  
  let tableViewContentSizeKey = "contentSize"
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  static func create() -> MultiButtonCustomizationViewController? {
    let storyboard = UIStoryboard(name: "MultiButtonCustomization", bundle: nil)
    let id = "MultiButtonCustomizationViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? MultiButtonCustomizationViewController else {
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
    
    multiButtonCustomizationFetchData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    multiButtonCustomizationFetchData()
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if keyPath == tableViewContentSizeKey {
      updateTableViewHeight()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let cell = sender as? MultiButtonCustomizationCell,
      let navigation = segue.destination as? UINavigationController,
      let edit = navigation.visibleViewController as? MultiButtonEditViewController,
      cell.tag < viewModels.count {
      let viewModel = viewModels[cell.tag]
      edit.deviceAddress = deviceAddress
      edit.currentTemplateId = viewModel.currentTemplateId
      edit.buttonType = viewModel.buttonType
      edit.buttonName = viewModel.buttonName
    }
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    addCustomization(PairingCustomizationStepType.multiButtonAssignment.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeMultiButtonAssignment)
    
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
  }
  
  fileprivate func updateViews() {
    tableView.reloadData()
  }
  
  fileprivate func updateTableViewHeight() {
    guard tableViewHeight.constant != tableView.contentSize.height else {
      return
    }
    
    tableViewHeight.constant = tableView.contentSize.height
  }
  
}

extension MultiButtonCustomizationViewController: PairingCustomizationStepPresenter {
  
}

extension MultiButtonCustomizationViewController: MultiButtonCustomizationPresenter {
  
  func multiButtonCustomizationUpdated() {
    updateViews()
  }
  
}

extension MultiButtonCustomizationViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard viewModels.count > indexPath.row,
    let cell = tableView.dequeueReusableCell(withIdentifier: "MultiButtonCustomizationCell") as?
      MultiButtonCustomizationCell else {
        return UITableViewCell()
    }
    
    let viewModel = viewModels[indexPath.row]
    cell.buttonImage.image = UIImage(named: viewModel.imageName)?.invertColor()
    cell.nameLabel.text = viewModel.buttonName
    cell.actionLabel.text = viewModel.buttonAction
    cell.tag = indexPath.row
    
    return cell
  }
  
}
