//
//  ChooseCountyViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/13/18.
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

class ChooseCountyViewController: UIViewController {
  
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
  var disposeBag = DisposeBag()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var pairingCustomizationViewModel = PairingCustomizationViewModel()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var stepIndex = 0
  
  /**
   Required by ChooseCountyPresenter
   */
  var chooseCountyData = ChooseCountyViewModel()
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var errorBanner: ScleraBannerView!
  
  static func create() -> ChooseCountyViewController {
    let storyboard = UIStoryboard(name: "ChooseCounty", bundle: nil)
    let id = "ChooseCountyViewController"
    if let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? ChooseCountyViewController {
      return viewController
    }
    
    return ChooseCountyViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    chooseCountyFetchData()
    
    configureViews()
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    chooseCountySetLocation()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let destination = segue.destination as? ChooseCountyPopupViewController,
      let type = sender as? ChooseCountyPopupType {
      
      let stateTitle = "Choose a State"
      let countyTitle = "Choose a County"
      
      destination.popupDelegate = self
      destination.popupType = type
      
      if type == .state {
        destination.options = stateNames()
        destination.selectedOption = stateName(forStateCode: chooseCountyData.selectedState)
        destination.titleText = stateTitle
      } else {
        destination.options = countyNames()
        destination.selectedOption = chooseCountyData.selectedCounty
        destination.titleText = countyTitle
      }
    }
  }
  
  private func configureViews() {
    addScleraStyleToNavigationTitle()
    addScleraBackButton()
    updateActionButtonText()
    
    errorBanner.hide()
    tableView.tableFooterView = UIView()
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      titleLabel.text = title
    }
  }
  
  fileprivate func advanceToNextStep() {
    addCustomization(PairingCustomizationStepType.stateCountySelect.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeStateCountySelect)
    
    if let nextStep = nextStepViewController() {
      navigationController?.pushViewController(nextStep, animated: true)
    }
  }
  
  fileprivate func updateViews() {
    if chooseCountyData.selectedState == "" || chooseCountyData.selectedCounty == "" {
      actionButton.isEnabled = false
    } else {
      actionButton.isEnabled = true
    }
    
    if let button = actionButton as? ScleraButton {
      if chooseCountyData.isSettingLocation {
        button.startLoadingIndicator()
      } else {
        button.stopLoadingIndicator()
      }
    }
    
    tableView.reloadData()
  }
  
  private func stateName(forStateCode code: String) -> String {
    for state in chooseCountyData.states where state.code == code {
      return state.name
    }
    
    return ""
  }
  
  private func countyNames() -> [String] {
    var names = [String]()
    
    for county in chooseCountyData.counties {
      names.append(county.name)
    }
    
    return names
  }
  
  private func stateNames() -> [String] {
    var states = [String]()
    
    for state in chooseCountyData.states {
      states.append(state.name)
    }
    
    return states
  }
  
}

extension ChooseCountyViewController: PairingCustomizationStepPresenter {
  
}

extension ChooseCountyViewController: ChooseCountyPresenter {
  
  func chooseCountyViewModelUpdated() {
    updateViews()
  }
  
  func chooseCountySetLocationFailed() {
    updateViews()
    errorBanner.show()
    DDLogError("Error while setting a weather radio station location.")
  }
  
  func chooseCountySetLocationSuceeded() {
    errorBanner.hide()
    updateViews()
    advanceToNextStep()
  }
  
}

extension ChooseCountyViewController: ChooseCountyPopupDelegate {
  func chooseCountyPopupSelectedOption(_ option: String, _ popupType: ChooseCountyPopupType) {
    if popupType == .state {
      chooseCountySelectState(withName: option)
    } else {
      chooseCountyData.selectedCounty = option
      updateViews()
    }
  }
}

extension ChooseCountyViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    errorBanner.hide()
    
    let sender: ChooseCountyPopupType = indexPath.row == 0 ? .state : .county
    
    performSegue(withIdentifier: "showSelectionPopup", sender: sender)
  }
  
}

extension ChooseCountyViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell =
      tableView.dequeueReusableCell(withIdentifier: "ChooseCountyCell") as? ChooseCountyCell else {
        return UITableViewCell()
    }
    
    if indexPath.row == 0 {
      cell.optionTitle.text = "State"
      if chooseCountyData.selectedState == "" {
        cell.selectedValue.text = "Choose Your State"
      } else {
        cell.selectedValue.text = chooseCountyData.selectedState
      }
      if chooseCountyData.isLoadingState {
        cell.selectedValue.isHidden = true
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
      } else {
        cell.selectedValue.isHidden = false
        cell.activityIndicator.isHidden = true
      }
    } else {
      cell.optionTitle.text = "County Name"
      if chooseCountyData.selectedCounty == "" {
        cell.selectedValue.text = "Choose Your County"
      } else {
        cell.selectedValue.text = chooseCountyData.selectedCounty
      }
      if chooseCountyData.isLoadingCounty {
        cell.selectedValue.isHidden = true
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
      } else {
        cell.selectedValue.isHidden = false
        cell.activityIndicator.isHidden = true
      }
    }
    
    return cell
  }
  
}
