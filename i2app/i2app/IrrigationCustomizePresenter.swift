//
//  IrrigationCustomizePresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/19/18.
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

struct IrrigationSingleCustomizationViewModel {
  var wateringTimes: [Int] {
    return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 20, 25, 30, 45, 60, 120, 180, 240]
  }
  
  var zoneName = "Zone Name"
  
  var selectedWateringTimeIndex = 0
}

protocol IrrigationCustomizePresenter: PairingCustomizationImagePresenter,
ArcusIrrigationZoneCapability,
ArcusIrrigationControllerCapability {
  
  /**
   The address of the current device being displayed.
   */
  var deviceAddress: String { get }
  
  /**
   The image of the device.
   */
  var deviceImage: UIImage? { get set }
  
  /**
   The zone number used for identification during customization for multi zone irrigation devices
   */
  var zoneContext: Int? { get }
  
  /**
   The data used to populate the view
   */
  var irrigationData: IrrigationSingleCustomizationViewModel { get set }
  
  /**
   Called when the view model has been updated
   */
  func irrigationCustomizeDataUpdated()
  
  // MARK: Extended
  
  /**
   Retrieves the irrigation data available for the device
   */
  func irrigationCustomizeFetchData()
  
  /**
   Saves the data currently stored in the view model
   */
  func irrigationCustomizeSaveData()
  
}

extension IrrigationCustomizePresenter {

  func irrigationCustomizeFetchData() {
    guard let device = deviceModel() else {
      return
    }
    
    var viewModel = IrrigationSingleCustomizationViewModel()
    
    let context = zoneContext ?? 1
    let zone = "z\(context)"
    let nameAttribute = "irr:zonename:\(zone)"
    let defaultDurationAttribute = "irr:defaultDuration:\(zone)"
    
    viewModel.zoneName = "Zone \(context)"
    
    if let defaultTime = device.attributes[defaultDurationAttribute] as? Int {
      for (index, time) in viewModel.wateringTimes.enumerated() where time == defaultTime {
        viewModel.selectedWateringTimeIndex = index
      }
    }
    
    if let zoneName = device.attributes[nameAttribute] as? String {
      viewModel.zoneName = zoneName
    }
    
    fetchDeviceProductImage(device: device) { [weak self] (image) in
      if let image = image {
        self?.deviceImage = image
        self?.irrigationCustomizeDataUpdated()
      }
    }
    
    irrigationData = viewModel
    irrigationCustomizeDataUpdated()
  }
  
  func irrigationCustomizeSaveData() {
    guard let device = deviceModel() else {
      return
    }
    
    let zone = "z\(zoneContext ?? 1)"
    let nameAttribute = "irr:zonename:\(zone)"
    let defaultDurationAttribute = "irr:defaultDuration:\(zone)"
    let selectedIndex = irrigationData.selectedWateringTimeIndex
    
    device.set([nameAttribute: irrigationData.zoneName as AnyObject])
    
    if irrigationData.wateringTimes.count > selectedIndex {
      let minutes = irrigationData.wateringTimes[selectedIndex]
      device.set([defaultDurationAttribute: minutes as AnyObject])
    }
    
    _ = device.commitChanges()
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
