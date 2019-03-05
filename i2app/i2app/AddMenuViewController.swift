//
//  AddMenuViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/6/18.
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

import RxSwift

struct AddMenuSegue {
  static let addKit = "KitSetupSegue"
  static let addDevice = "BrandListSegue"
  static let addRule = "AddRuleSegue"
  static let addPlace = "AddPlaceSegue"
  static let addPlaceGuest = "AddPlaceGuestSegue"
  static let addPerson = "AddPersonSegue"
  static let addCare = "AddCareSegue"
  static let popupCarePremium = "PopupCarePremiumSegue"
  static let popupHubAlreadyPaired = "PopupHubAlreadyPairedSegue"
  static let popupHubOffline = "PopupHubOfflineSegue"
  static let popupAddArcus = "PopupAddArcusSegue"
}

class AddMenuViewController: UIViewController, AddMenuPresenter {
  
  @IBOutlet weak var tableView: UITableView!
  
  var disposeBag = DisposeBag()
  
  var addMenuViewModel = AddMenuViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    
    observeViewModel()
    addMenuFetchOptions()
  }
  
  private func configureViews() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
    
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  }
  
  private func observeViewModel() {
    addMenuViewModel.rows.asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.handleViewModelChange()
      })
      .disposed(by: disposeBag)
  }
  
  private func handleViewModelChange() {
    tableView.reloadData()
  }
  
  fileprivate func handleSelection(atRow row: Int) {
    guard row < addMenuViewModel.rows.value.count else {
      return
    }
    
    let viewModel = addMenuViewModel.rows.value[row]
    
    switch viewModel.type {
    case .hub:
      handleHubSelection()
    case .device:
      handleDeviceSelection()
    case .rule:
      handleRulesSelection()
    case .scene:
      handleScenesSelection()
    case .place:
      handlePlaceSelection()
    case .person:
      handlePersonSelection()
    case .care:
      handleCareSelection()
    case .addArcus:
      handleAddArcusSelection()
    default:
      break
    }
  }
  
  private func handleAddArcusSelection() {
    if addMenuViewModel.isUserAccountOwner {
      performSegue(withIdentifier: AddMenuSegue.popupAddArcus, sender: self)
    } else {
      performSegue(withIdentifier: AddMenuSegue.addPlaceGuest, sender: self)
    }
  }
  
  private func handleHubSelection() {
    ArcusAnalytics.tag(named: AnalyticsTags.AddHubClick)
    
    switch addMenuViewModel.hubDisposition {
    case .notPaired:
      navigationController?.pushViewController(HubPairingBuilder.buildHubOrKit(), animated: true)
    case .allPaired:
      performSegue(withIdentifier: AddMenuSegue.popupHubAlreadyPaired, sender: self)
    case .kitIncomplete:
      performSegue(withIdentifier: AddMenuSegue.addKit, sender: self)
    case .offline:
      performSegue(withIdentifier: AddMenuSegue.popupHubOffline, sender: self)
    default:
      break
    }
  }
  
  private func handleDeviceSelection() {
    ArcusAnalytics.tag(AnalyticsTags.AddDeviceClick, attributes: [:])
    performSegue(withIdentifier: AddMenuSegue.addDevice, sender: self)
  }
  
  private func handleRulesSelection() {
    ArcusAnalytics.tag(AnalyticsTags.AddRuleClick, attributes: [:])
    if addMenuViewModel.needsRulesTutorial {
      if let tutorial = TutorialViewController.create(with: .rules, andCompletionBlock: { [weak self] in
        self?.performSegue(withIdentifier: AddMenuSegue.addRule, sender: self)
      }) {
        present(tutorial, animated: true, completion: nil)
      }
    } else {
      performSegue(withIdentifier: AddMenuSegue.addRule, sender: self)
    }
  }
  
  private func handleScenesSelection() {
    ArcusAnalytics.tag(AnalyticsTags.AddSceneClick, attributes: [:])
    if addMenuViewModel.needsScenesTutorial {
      if let tutorial = TutorialViewController.create(with: .scenes, andCompletionBlock: { [weak self] in
        self?.navigationController?.pushViewController(ChooseSceneViewController.create(), animated: true)
      }) {
        present(tutorial, animated: true, completion: nil)
      }
    } else {
      navigationController?.pushViewController(ChooseSceneViewController.create(), animated: true)
    }
  }
  
  private func handlePlaceSelection() {
    ArcusAnalytics.tag(AnalyticsTags.AddPlaceClick, attributes: [:])
    performSegue(withIdentifier: AddMenuSegue.addPlace, sender: self)
  }
  
  private func handlePersonSelection() {
    ArcusAnalytics.tag(AnalyticsTags.AddPersonClick, attributes: [:])
    performSegue(withIdentifier: AddMenuSegue.addPerson, sender: self)
  }
  
  private func handleCareSelection() {
    if addMenuViewModel.isAccountPremium {
      ArcusAnalytics.tag(AnalyticsTags.AddBehaviorClick, attributes: [:])
      performSegue(withIdentifier: AddMenuSegue.addCare, sender: self)
    } else {
      performSegue(withIdentifier: AddMenuSegue.popupCarePremium, sender: self)
    }
  }
  
}

extension AddMenuViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addMenuViewModel.rows.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard indexPath.row < addMenuViewModel.rows.value.count else {
      return UITableViewCell()
    }
    
    let viewModel = addMenuViewModel.rows.value[indexPath.row]
    let prototype = viewModel.type == .section ? "AddMenuSectionCell" : "AddMenuRowCell"
    
    var cell = UITableViewCell()
    if let menuCell = tableView.dequeueReusableCell(withIdentifier: prototype) as? AddMenuCell {
      menuCell.cellImage.image = UIImage(named: viewModel.imageName)
      menuCell.cellTitle.text = viewModel.title
      
      if let subtitleLabel = menuCell.cellSubtitle {
        subtitleLabel.text = viewModel.subtitle
      }
      
      if let topConstraint = menuCell.topConstraint {
        topConstraint.constant = indexPath.row == 0 ? 21 : 51
      }
      
      cell = menuCell
    }
    
    return cell
  }
  
}

extension AddMenuViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    handleSelection(atRow: indexPath.row)
  }
  
}


