//
//  otaUpgradePresenter.swift
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
import RxSwift
import Cornea

struct OTAUpgradeViewModel {
  var percentageCompleted = 0
}

protocol OTAUpgradePresenter: ArcusDeviceOtaCapability {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   View model used to populate the view.
   */
  var viewModel: OTAUpgradeViewModel { get set }
  
  /**
   Call when changes are made to the view model due to platform events.
   */
  func otaUpgradeViewModelUpdated()
  
  // MARK: Extended
  
  /*
   Starts observing changes on the current device model.
   */
  func otaUpgradeObserveChanges()
  
  /**
   Retrieves the data and calls otaUpgradeViewModelUpdated when the view model is updated.
   */
  func otaUpgradeFetchData()
  
}

extension OTAUpgradePresenter {
  
  func otaUpgradeObserveChanges() {
    guard let model = deviceModel() else {
      return
    }
    
    let observer = model.getEvents()
    let disposable = observer
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] _ in
        self?.otaUpgradeFetchData()
      })
    
    disposable.addDisposableTo(disposeBag)
  }
  
  func otaUpgradeFetchData() {
    guard let device = deviceModel() else {
      return
    }

    var newViewModel = OTAUpgradeViewModel()
    
    if let percentage = getDeviceOtaProgressPercent(device) {
      newViewModel.percentageCompleted = Int(percentage)
    }
    
    viewModel = newViewModel
    otaUpgradeViewModelUpdated()
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
