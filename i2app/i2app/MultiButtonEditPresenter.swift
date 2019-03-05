//
//  MultiButtonEditPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/26/18.
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

struct MultiButtonEditActionViewModel {
  var name = ""
  var isSelected = false
  var templateId = ""
}

struct MultiButtonEditViewModel {
  var deviceName = ""
  var actions = [MultiButtonEditActionViewModel]()
}

protocol MultiButtonEditPresenter: ArcusDeviceCapability,
ArcusRuleCapability,
ArcusRuleTemplateCapability,
ArcusRuleService {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   The type of the button in current context
   */
  var buttonType: String { get set }
  
  /**
   The id of the currently selected template
   */
  var currentTemplateId: String { get set }
  
  /**
   The list of long names for the templates associated to the device
   */
  var templateNames: [String] { get set }
  
  /**
   List of template ids for the device
   */
  var templateIds: [String] { get set }
  
  /**
   Required by RxSwift to track observables.
   */
  var disposeBag: DisposeBag { get }
  
  /**
   View model containing the data needed for the view.
   */
  var multiButtonEditData: MultiButtonEditViewModel { get set }
  
  /**
   Called whenever there is a chage in the choices available.
   */
  func multiButtonEditUpdated()
  
  /**
   Called when a save action has completed
   */
  func multiButtonEditSaveCompleted()
  
  // MARK: Extended
  
  /**
   Retrieves the data to be used by the view. Calls multiButtonEditUpdated() once the data has been
   retrieved.
   */
  func multiButtonEditFetchData()
  
  /**
   Saves the selected action.
   */
  func multiButtonEditSaveSelection()
  
}

extension MultiButtonEditPresenter {
  
  func multiButtonEditSaveSelection() {
    guard let device = deviceModel(),
      let place = currentPlace(),
      let productId = getDeviceProductId(device) else {
        return
    }
    
    var context = [String: String]()
    
    if productId == kGen2FourButtonFob || productId == kGen3FourButtonFob {
      context = ["smart fob": device.address,
                 "button": buttonType]
    } else if productId == kGen1TwoButtonFob {
      context = ["key fob": device.address,
                 "button": buttonType]
    } else if productId == kGen1SmartButton || productId == kGen2SmartButton {
      context = ["button": buttonType]
    }
    
    do {
      let observable = try requestRuleServiceListRuleTemplates(place.modelId)
      observable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] (response) in
          if let response = response as? RuleServiceListRuleTemplatesResponse {
            self?.process(listTemplateResponse: response, context: context)
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - Retrieving template for button - \(buttonType).")
    }
  }
  
  func multiButtonEditFetchData() {
    guard let device = deviceModel(),
      let name = getDeviceName(device) else {
      return
    }
    
    let productId = getDeviceProductId(device)
    
    if productId == kGen3FourButtonFob {
      templateNames = DeviceModel.arcusGen3FourButtonFobRuleTemplateNames()
      templateIds = DeviceModel.arcusGen3FourButtonFobRuleTemplateIds()
    } else if productId == kGen2FourButtonFob {
      templateNames = DeviceModel.arcusGen2FourButtonFobRuleTemplateLongNames()
      templateIds = DeviceModel.arcusGen2FourButtonFobRuleTemplateIds()
    } else if productId == kGen1TwoButtonFob {
      templateNames = DeviceModel.arcusGen1TwoButtonFobRuleTemplateLongNames()
      templateIds = DeviceModel.arcusGen1TwoButtonFobRuleTemplateIds()
    } else if productId == kGen1SmartButton || productId == kGen2SmartButton {
      templateNames = DeviceModel.arcusSmartButtonRuleTemplateNames()
      templateIds = DeviceModel.arcusSmartButtonRuleTemplateIds()
    }
    
    var viewModel = MultiButtonEditViewModel()
    viewModel.deviceName = name
    
    var actions = [MultiButtonEditActionViewModel]()
    for (index, templateName) in templateNames.enumerated() {
      
      if templateName == "Activate a Rule" {
        break
      }
      
      var action = MultiButtonEditActionViewModel()
      action.name = templateName
      
      if index < templateIds.count {
        action.templateId = templateIds[index]
      
        if templateIds[index] == currentTemplateId {
          action.isSelected = true
        } else {
          action.isSelected = false
        }
      }
      
      actions.append(action)
    }
    
    viewModel.actions = actions
    multiButtonEditData = viewModel
    multiButtonEditUpdated()
  }
  
  private func process(listTemplateResponse response: RuleServiceListRuleTemplatesResponse,
                       context: [String: String]) {
    guard let templates = response.getRuleTemplates(),
      let rules = CorneaHolder.shared.modelCache?.fetchModels(Constants.ruleNamespace)
        as? [RuleModel] else {
      return
    }
    
    var rulesToDelete = [RuleModel]()
    for rule in rules {
      if let context = getRuleContext(rule) as? [String: String] {
        if context["button"] == buttonType && context.values.contains(deviceAddress) {
          if let ruleTemplate = getRuleTemplate(rule) {
            if templateIds.contains(ruleTemplate) {
              rulesToDelete.append(rule)
            }
          }
        }
      }
    }
    
    var deleteCount = 0
    for rule in rulesToDelete {
      do {
        let observable = try requestRuleDelete(rule)
        observable
          .observeOn(MainScheduler.asyncInstance)
          .subscribe( onNext: { [weak self] _ in
            deleteCount += 1
            if deleteCount == rulesToDelete.count {
              self?.createRule(templates: templates, context: context)
            }
          })
          .disposed(by: disposeBag)
      } catch {
        deleteCount += 1
        if deleteCount == rulesToDelete.count {
          self.createRule(templates: templates, context: context)
        }
        DDLogError("Error - Error deleting rule")
      }
    }
  }
  
  private func createRule(templates: [Any], context: [String: String]) {
    guard let place = currentPlace() else {
      return
    }
    
    for template in templates {
      if let templateAttributes = template as? [String: AnyObject] {
        let templateModel = RuleTemplateModel(attributes: templateAttributes)
        if templateModel.modelId == currentTemplateId {
          do {
            let name = getRuleTemplateName(templateModel) ?? ""
            let description = getRuleTemplateDescription(templateModel) ?? ""
            let observable = try requestRuleTemplateCreateRule(templateModel,
                                                               placeId: place.modelId,
                                                               name: name,
                                                               description: description,
                                                               context: context)
            observable
              .observeOn(MainScheduler.asyncInstance)
              .subscribe( onNext: { [weak self] _ in
                self?.multiButtonEditSaveCompleted()
                return
              })
              .disposed(by: disposeBag)
          } catch {
            multiButtonEditSaveCompleted()
            DDLogError("Error - Error creating rule")
          }
        }
      }
    }
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
  private func currentPlace() -> PlaceModel? {
    return RxCornea.shared.settings?.currentPlace ?? nil
  }
}
