//
//  ContactTestPresenter.swift
//  i2app
//
//  Created by Arcus Team on 7/23/18.
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

struct ContactTestViewModel {
  var isDeviceOpened: Variable<Bool> = Variable(false)
  var imageOpenOnURL: URL?
  var imageOpenOffURL: URL?
  var imageCloseOnURL: URL?
  var imageCloseOffURL: URL?
}

protocol ContactTestPresenter: ArcusContactCapability, StaticResourceImageURLHelper,
PairingCustomizationStepPresenter {
  
  var contactTestViewModel: ContactTestViewModel { get set }
  
  var deviceAddress: String { get }
  
  // MARK: Extended
  
  func fetchContactTestDeviceState()
  
}

extension ContactTestPresenter {
  
  func fetchContactTestDeviceState() {
    observeEvents()
    fetchState()
  }
  
  private func fetchState() {
    guard let device = deviceModel(),
    let state = getContactContact(device) else {
      return
    }
    
    if let currentStep = currentStepViewModel(),
      let identifier = currentStep.identifier?.lowercased() {
      let openOn = "\(identifier)-open-on"
      let openOff = "\(identifier)-open-off"
      let closeOn = "\(identifier)-closed-on"
      let closeOff = "\(identifier)-closed-off"
      contactTestViewModel.imageOpenOnURL = getCustomizationStepImageUrl(stepId: openOn)
      contactTestViewModel.imageOpenOffURL = getCustomizationStepImageUrl(stepId: openOff)
      contactTestViewModel.imageCloseOnURL = getCustomizationStepImageUrl(stepId: closeOn)
      contactTestViewModel.imageCloseOffURL = getCustomizationStepImageUrl(stepId: closeOff)
    }
 
    contactTestViewModel.isDeviceOpened.value = state == .opened
  }
  
  private func observeEvents() {
    guard let device = deviceModel() else {
      return
    }
    
    device.getEvents()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.fetchState()
      })
      .disposed(by: disposeBag)
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
