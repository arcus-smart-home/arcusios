//
//  IrrigationMultiCustomizeViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/23/18.
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

class IrrigationMultiCustomizeViewController: UIViewController {
  
  /**
   Required by PairingCustomizationStepPresenter & IrrigationMultiCustomizePresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var deviceAddress = ""
  
  /**
   Required by IrrigationMultiCustomizePresenter
   */
  var deviceImage: UIImage?
  
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
   Required by IrrigationMultiCustomizePresenter
   */
  var irrigationData = IrrigationMultiCustomizeViewModel()
  
  @IBOutlet weak var deviceImageView: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  let tableViewContentSizeKey = "contentSize"
  
  static func create() -> IrrigationMultiCustomizeViewController? {
    let storyboard = UIStoryboard(name: "IrrigationCustomization", bundle: nil)
    let id = "IrrigationMultiCustomizeViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? IrrigationMultiCustomizeViewController else {
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
    
    irrigationMultiCustomizeObserveChanges()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    irrigationMultiCustomizeFetchData()
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
    if let navigation = segue.destination as? UINavigationController,
    let singleIrrigation = navigation.visibleViewController as? IrrigationSingleCustomizationViewController,
    let rowSelected = sender as? Int {
      singleIrrigation.deviceAddress = deviceAddress
      singleIrrigation.zoneContext = rowSelected + 1
    }
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    addCustomization(PairingCustomizationStepType.multiIrrigationZone.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeMultiIrrigationZone)
    
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
  
  fileprivate func updateViews() {
    if let image = deviceImage {
      deviceImageView.image = image
    }
    
    tableView.reloadData()
  }
  
  fileprivate func updateTableViewHeight() {
    guard tableViewHeight.constant != tableView.contentSize.height else {
      return
    }
    
    tableViewHeight.constant = tableView.contentSize.height
  }
  
}

extension IrrigationMultiCustomizeViewController: PairingCustomizationStepPresenter {
  
}

extension IrrigationMultiCustomizeViewController: IrrigationMultiCustomizePresenter {
  func irrigationMultiCustomizeDataUpdated() {
    updateViews()
  }
}

extension IrrigationMultiCustomizeViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return irrigationData.zones.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard irrigationData.zones.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "IrrigationMultiCustomizeCell")
        as? IrrigationMultiCustomizeCell else {
          return UITableViewCell()
    }
    
    let viewModel = irrigationData.zones[indexPath.row]
    cell.zoneName.text = viewModel.zoneName
    cell.zoneTitle.text = viewModel.zoneTitle
    
    if let image = deviceImage {
      cell.zoneImageView.image = image
    }
    
    return cell
  }
  
}

extension IrrigationMultiCustomizeViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SingleIrrigationZoneSegue", sender: indexPath.row)
  }
  
}
