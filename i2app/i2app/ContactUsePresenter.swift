//
//  ContactUsePresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/19/18.
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
import SDWebImage
import Cornea

/**
 The order of these choices will determine the order of the options in the UI.
 */
enum ContactUseChoice: Int {
  case door = 0
  case window = 1
  case other = 2
}

protocol ContactUsePresenter: PairingCustomizationImagePresenter,
ArcusContactCapability,
ArcusDeviceCapability {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   The image of the current device.
   */
  var deviceImage: UIImage? { get set }
  
  /**
   The contact use choice currently selected
   */
  var selectedContactUseChoice: ContactUseChoice { get set }

  /**
   Called when a change happens to the Device Model of the given address.
   */
  func contactUsePresenterDataUpdated()
  
  // MARK: Extended

  /**
   Fetches the currently selected contact use type and calls update.
   */
  func contactUsePresenterFetchData()
  
  /**
   Sets the currently selected contact use.
   */
  func contactUsePresenterSaveData()
}

extension ContactUsePresenter {
  
  func contactUsePresenterFetchData() {
    guard let model = deviceModel() else {
      return
    }
    
    if let useHint = getContactUsehint(model) {
      // If the use hint is unknown the app should default to door
      if useHint == .unknown {
        selectedContactUseChoice = .door
      } else {
        switch useHint {
        case .door:
          selectedContactUseChoice = .door
        case .window:
          selectedContactUseChoice = .window
        default:
          selectedContactUseChoice = .other
        }
      }
    }
    
    fetchDeviceProductImage(device: model, completion: { [weak self] (image) in
      if let newImage = image {
        self?.deviceImage = newImage
        self?.contactUsePresenterDataUpdated()
      }
    })
    
    contactUsePresenterDataUpdated()
  }
  
  func contactUsePresenterSaveData() {
    guard let model = deviceModel() else {
      return
    }
    
    var hint = ContactUsehint.unknown
    
    switch selectedContactUseChoice {
    case .door:
      hint = .door
    case .window:
      hint = .window
    case .other:
      hint = .other
    }
    
    setContactUsehint(hint, model: model)
    model.commit()
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
