//
//  IrrigationMultiCustomizePresenter.swift
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
import Cornea
import RxSwift

struct IrrigationMultiCustomizeZoneViewModel {
  var zoneName = "Zone Name"
  var zoneTitle = "Zone Title"
}

struct IrrigationMultiCustomizeViewModel {
  var zones = [IrrigationMultiCustomizeZoneViewModel]()
}

protocol IrrigationMultiCustomizePresenter: PairingCustomizationImagePresenter,
ArcusIrrigationControllerCapability,
ArcusIrrigationZoneCapability {
  
  /**
   The address of the current device being displayed.
   */
  var deviceAddress: String { get }
  
  /**
   The image of the device.
   */
  var deviceImage: UIImage? { get set }

  /**
   Data used to populate the view
   */
  var irrigationData: IrrigationMultiCustomizeViewModel { get set }
  
  /**
   Called when the view model has been updated
   */
  func irrigationMultiCustomizeDataUpdated()
  
  // MARK: Extended

  /**
   Initiates observations on the device model with the current device address
   */
  func irrigationMultiCustomizeObserveChanges()
  
  /**
   Retrieves the irrigation data for the device
   */
  func irrigationMultiCustomizeFetchData()
  
}

extension IrrigationMultiCustomizePresenter {
  
  func irrigationMultiCustomizeObserveChanges() {
    guard let model = deviceModel() else {
      return
    }
    
    let observer = model.getEvents()
    _ = observer
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] _ in
        self?.irrigationMultiCustomizeFetchData()
      }).disposed(by: disposeBag)
  }
  
  func irrigationMultiCustomizeFetchData() {
    guard let device = deviceModel() else {
      return
    }
    
    var zones = [IrrigationMultiCustomizeZoneViewModel]()
   
    if let numberOfZones = getIrrigationControllerNumZones(device), numberOfZones > 0 {
      for n in 1...numberOfZones {
        var viewModel = IrrigationMultiCustomizeZoneViewModel()
        
        let zoneIdentifier = "z\(n)"
        let nameAttribute = "irr:zonename:\(zoneIdentifier)"
        
        viewModel.zoneTitle = "Zone \(n)"
        
        if let zoneName = device.attributes[nameAttribute] as? String {
          viewModel.zoneName = zoneName
        } else {
          viewModel.zoneName = ""
        }
        
        zones.append(viewModel)
      }
    }
    
    fetchDeviceProductImage(device: device) { [weak self] (image) in
      if let image = image {
        self?.deviceImage = image
        self?.irrigationMultiCustomizeDataUpdated()
      }
    }
    
    irrigationData.zones = zones
    irrigationMultiCustomizeDataUpdated()
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
