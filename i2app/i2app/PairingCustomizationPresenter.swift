//
//  PairingCustomizationPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/28/18.
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

protocol PairingCustomizationPresenter: ArcusPairingSubsystemCapability, ArcusPairingDeviceCapability,
StaticResourceImageURLHelper {
  
  /**
   Fetches the customization steps for a given device address.
   - parameter deviceAddress: The text representing the device address.
   - parameter completion: Block called when fetch is complete. Nil is passed into the block when error.
   */
  func pairingCustomizationPresenterFetchSteps(deviceAddress: String,
                                               completion: @escaping (PairingCustomizationViewModel?) -> Void)
  
}

extension PairingCustomizationPresenter {
  
  func pairingCustomizationPresenterFetchSteps(
    deviceAddress: String, completion: @escaping (PairingCustomizationViewModel?) -> Void) {
    
    guard let model = pairingDeviceModel(deviceAddress) else {
      completion(nil)
      return
    }
    
    var productId: String?
    if let productAddress = getPairingDeviceProductAddress(model),
      let id = productIdForProductAddress(productAddress) {
      productId = id
    }
    
    do {
      let observable = try requestPairingDeviceCustomize(model)
      let disposable = observable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] response in
          if let strongSelf = self,
            let response = response as? PairingDeviceCustomizeResponse {
            completion(strongSelf.process(response: response, productId: productId))
          }
        })
      disposable.addDisposableTo(disposeBag)
    } catch {
      completion(nil)
      DDLogError("Error - CustomizationStepPresenter: Calling customize")
    }
  }
  
  private func process(response: PairingDeviceCustomizeResponse,
                       productId: String?) -> PairingCustomizationViewModel? {
    guard let stepDictionaries = response.getSteps() as? [[String: AnyObject]] else {
      return nil
    }
    
    var stepViewModels = [PairingCustomizationStepViewModel]()
     
    for (index, stepDictionary) in stepDictionaries.enumerated() {
      var stepViewModel = PairingCustomizationStepViewModel(stepDictionary: stepDictionary, stepIndex: index)
      
      // Add image url for the step based of the Step ID
      if let stepId = stepViewModel.identifier {
        stepViewModel.imageURL = getCustomizationStepImageUrl(stepId: stepId.lowercased())
      }
      
      // Only add currently supported steps.
      if isSupported(stepType: stepViewModel.stepType) {
        stepViewModels.append(stepViewModel)
      }
    }
    var viewModel = PairingCustomizationViewModel()
    viewModel.steps = stepViewModels
    
    return viewModel
  }
  
  private func snakeCase(_ text: String) -> String? {
    let pattern = "([a-z0-9])([A-Z])"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: text.count)
    let parsedText = regex?.stringByReplacingMatches(in: text,
                                                     options: [],
                                                     range: range,
                                                     withTemplate: "$1_$2")
    return parsedText?.lowercased()
  }
  
  private func isSupported(stepType: PairingCustomizationStepType?) -> Bool {
    guard let type = stepType else { return false }
    
    let supportedCustomizationSteps: [PairingCustomizationStepType] = [
      .name,
      .favorite,
      .contactType,
      .presenceAssignment,
      .weatherRadioStation,
      .securityMode,
      .promonAlarm,
      .waterHeater,
      .stateCountySelect,
      .room,
      .irrigationZone,
      .multiIrrigationZone,
      .multiButtonAssignment,
      .otaUpgrade,
      .info,
      .contactTest
    ]
    
    return supportedCustomizationSteps.contains(type)
  }
  
  private func productIdForProductAddress(_ address: String) -> String? {
    guard let cache = RxCornea.shared.modelCache,
      let model = cache.fetchModel(address) as? ProductModel else {
        return nil
    }
    
    return model.productId()
  }
  
  private func pairingDeviceModel(_ deviceAddress: String) -> PairingDeviceModel? {
    guard let cache = RxCornea.shared.modelCache,
      let pairingDevices = cache.fetchModels(Constants.pairingDeviceNamespace)as? [PairingDeviceModel] else {
        return nil
    }
    
    for pairingModel in pairingDevices {
      if getPairingDeviceDeviceAddress(pairingModel) == deviceAddress {
        return pairingModel
      }
    }
    
    return nil
  }
}
