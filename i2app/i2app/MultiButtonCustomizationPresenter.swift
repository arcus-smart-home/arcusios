//
//  MultiButtonCustomizationPresenter.swift
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
import Cornea

struct MultiButtonCustomizationViewModel {
  var imageName = ""
  var buttonName = ""
  var buttonType = ""
  var buttonAction = ""
  var currentTemplateId = ""
}

protocol MultiButtonCustomizationPresenter: ArcusDeviceCapability,
ArcusRuleService,
ArcusRuleCapability {
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   Required by RxSwift to track observables.
   */
  var disposeBag: DisposeBag { get }
  
  /**
   View model containing the data needed for the view.
   */
  var viewModels: [MultiButtonCustomizationViewModel] { get set }
  
  /**
   Called whenever there is a chage in the choices available.
   */
  func multiButtonCustomizationUpdated()
  
  // MARK: Extended
  
  /*
   Starts observing changes on the current device model.
   */
  func multiButtonCustomizationObserveChanges()
  
  /**
   Retrieves the data to be used by the view. Calls multiButtonCustomizationUpdated() once the data has been
   retrieved.
   */
  func multiButtonCustomizationFetchData()
}

extension MultiButtonCustomizationPresenter {
  
  func multiButtonCustomizationObserveChanges() {
    guard let model = deviceModel() else {
      return
    }
    
    let observer = model.getEvents()
    let disposable = observer
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] _ in
        self?.multiButtonCustomizationFetchData()
      })
    
    disposable.addDisposableTo(disposeBag)
  }
  
  func multiButtonCustomizationFetchData() {
    guard let device = deviceModel(),
      let productId = getDeviceProductId(device),
      let instances = device.getInstances() else {
      return
    }
    
    let keys = Array(instances.keys)
    var viewModels = [MultiButtonCustomizationViewModel]()
    for orderedKey in Constants.kKeyFobOrderArray where keys.contains(orderedKey) {
      var viewModel = MultiButtonCustomizationViewModel()
      viewModel.buttonName = orderedKey.capitalized
      viewModel.buttonType = orderedKey
      viewModel.imageName = imageNameForButtonType(buttonType: orderedKey, productId: productId)
      retrieveTemplateIdForButtonType(orderedKey)
      
      let currentViewModelWithType = self.viewModels.filter { $0.buttonType == viewModel.buttonType }
      if currentViewModelWithType.count > 0 {
        viewModel.buttonAction = currentViewModelWithType.first!.buttonAction
        viewModel.currentTemplateId = currentViewModelWithType.first!.currentTemplateId
      }
      
      viewModels.append(viewModel)
    }
    
    self.viewModels = viewModels
    multiButtonCustomizationUpdated()
  }
  
  private func retrieveTemplateIdForButtonType(_ buttonType: String) {
    guard let place = currentPlace() else {
        return
    }
    
    do {
      let observable = try requestRuleServiceListRules(place.modelId)
      observable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] (response) in
          if let response = response as? RuleServiceListRulesResponse {
            self?.process(ruleListResponse: response, forButtonType: buttonType)
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - Retrieving rule for button - \(buttonType).")
    }
  }
  
  private func process(ruleListResponse response: RuleServiceListRulesResponse,
                       forButtonType buttonType: String) {
    guard let rules = CorneaHolder.shared.modelCache?.fetchModels(Constants.ruleNamespace)
      as? [RuleModel] else {
      return
    }
    
    for rule in rules {
      if let context = getRuleContext(rule) as? [String: String] {
        if context["button"] == buttonType && context.values.contains(deviceAddress) {
          if let templateId = getRuleTemplate(rule),
            let templateIds = ruleTemplateIds(),
            let templateNames = ruleTemplateNames(),
            let indexOfName = templateIds.index(of: templateId),
            indexOfName < templateNames.count {
            let templateName = templateNames[indexOfName]
            
            for (index, viewModel) in viewModels.enumerated() where viewModel.buttonType == buttonType {
              viewModels[index].buttonAction = templateName.capitalized
              viewModels[index].currentTemplateId = templateId
            }
          }
        }
      }
    }
    
    multiButtonCustomizationUpdated()
  }
  
  private func ruleTemplateIds() -> [String]? {
    guard let device = deviceModel() else {
      return nil
    }
    
    let productId = getDeviceProductId(device)
    
    if productId == kGen3FourButtonFob {
      return DeviceModel.arcusGen3FourButtonFobRuleTemplateIds()
    } else if productId == kGen2FourButtonFob {
      return DeviceModel.arcusGen2FourButtonFobRuleTemplateIds()
    } else if productId == kGen1TwoButtonFob {
      return DeviceModel.arcusGen1TwoButtonFobRuleTemplateIds()
    } else if productId == kGen1SmartButton || productId == kGen2SmartButton {
      return DeviceModel.arcusSmartButtonRuleTemplateIds()
    }
    
    return nil
  }
  
  private func ruleTemplateNames() -> [String]? {
    guard let device = deviceModel() else {
      return nil
    }
    
    let productId = getDeviceProductId(device)
    
    if productId == kGen3FourButtonFob {
      return DeviceModel.arcusGen3FourButtonFobRuleTemplateNames()
    } else if productId == kGen2FourButtonFob {
      return DeviceModel.arcusGen2FourButtonFobRuleTemplateNames()
    } else if productId == kGen1TwoButtonFob {
      return DeviceModel.arcusGen1TwoButtonFobRuleTemplateNames()
    } else if productId == kGen1SmartButton || productId == kGen2SmartButton {
      return DeviceModel.arcusSmartButtonRuleTemplateNames()
    }
    
    return nil
  }
  
  private func imageNameForButtonType(buttonType: String, productId: String) -> String {
    switch buttonType {
    case "circle":
      return "circle"
    case "diamond":
      return "diamond"
    case "square":
      return "square"
    case "hexagon":
      return "hexagon"
    case "away":
      if productId == kGen3FourButtonFob {
        return "away_v3"
      }
      return "away"
    case "a":
      return "a_v3"
    case "b":
      return "b_v3"
    case "home":
      if productId == kGen3FourButtonFob {
        return "home_v3"
      }
      return "home"
    default:
      return ""
    }
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
  private func currentPlace() -> PlaceModel? {
    return RxCornea.shared.settings?.currentPlace ?? nil
  }
  
}
