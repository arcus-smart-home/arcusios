//
//  WaterHeaterCustomizationPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/3/18.
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

protocol WaterHeaterCustomizationPresenter: ArcusAOSmithWaterHeaterControllerCapability {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   Required by RxSwift to track observables.
   */
  var disposeBag: DisposeBag { get }
  
  /**
   Data needed for the water heater view.
   */
  var waterHeaterData: WaterHeaterCustomizationViewModel { get set }

  /**
   Function called when the water heater data has been updated.
   */
  func waterHeaterDataUpdated()
  
  // MARK: Extended
  
  /**
   Retrieves the available water heater data. Calls waterHeaterDataUpdated() when the data
   has been updated.
   */
  func waterHeaterFetchData()
  
  /**
   Starts observing changes for the water heater in context.
   */
  func waterHeaterObserveChanges()
  
  /**
   Writes the available water heater data.
   */
  func waterHeaterSaveData()
  
}

extension WaterHeaterCustomizationPresenter {
  
  func waterHeaterObserveChanges() {
    guard let model = deviceModel() else {
      return
    }
    
    let observer = model.getEvents()
    let disposable = observer
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] _ in
        self?.waterHeaterFetchData()
      })
    
    disposable.addDisposableTo(disposeBag)
  }
  
  func waterHeaterFetchData() {
    guard let device = deviceModel() else {
        return
    }
    
    if let modelNumber = getAOSmithWaterHeaterControllerModelnumber(device) {
      waterHeaterData.modelNumber = modelNumber
    }
    if let serialNumber = getAOSmithWaterHeaterControllerSerialnumber(device) {
      waterHeaterData.serialNumber = serialNumber
    }
    
    waterHeaterDataUpdated()
  }
  
  func waterHeaterSaveData() {
    guard let device = deviceModel() else {
      return
    }
    
    setAOSmithWaterHeaterControllerModelnumber(waterHeaterData.modelNumber,
                                               model: device)
    setAOSmithWaterHeaterControllerSerialnumber(waterHeaterData.serialNumber,
                                                model: device)
    _ = device.commit()
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
