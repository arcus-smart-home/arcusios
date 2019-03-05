//
//  FavoriteDevicePresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/27/18.
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

fileprivate let favoriteTag = "FAVORITE"

struct FavoriteDeviceViewModel {
  var deviceName = ""
  var isFavorite = false
}

protocol FavoriteDevicePresenter: ArcusDeviceCapability {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }

  /**
   View Model to populate the view
   */
  var viewModel: FavoriteDeviceViewModel { get set }
  
  /**
   Called when a change happens to the Device Model of the given address.
   */
  func favoriteDevicePresenterDataUpdated()
  
  // MARK: Extended

  /**
   Toggles the favorite state for the device model by adding/removing the appropiate tag.
   */
  func favoriteDevicePresenterSaveFavoriteState()
  
  /**
   Retrieves the current favorite state of the device model
   - returns: Boolean indicating the favorite state.
   */
  func favoriteDevicePresenterFetchData()
}

extension FavoriteDevicePresenter {
  
  func favoriteDevicePresenterSaveFavoriteState() {
    guard let model = deviceModel() else {
      return
    }
    
    toggleFavoriteStateForModel(model)
  }
  
  func favoriteDevicePresenterFetchData() {
    guard let model = deviceModel(), let tags = model.tags else {
      return
    }
    
    var newViewModel = FavoriteDeviceViewModel()
    
    for tag in tags {
      if let tag = tag as? String, tag == favoriteTag {
        newViewModel.isFavorite = true
      }
    }
    
    if let name = getDeviceName(model) {
      viewModel.deviceName = name
    }
    
    viewModel = newViewModel
    favoriteDevicePresenterDataUpdated()
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
  private func toggleFavoriteStateForModel(_ model: DeviceModel) {
    guard let tags = model.tags else {
      return
    }
    
    do {
      if !viewModel.isFavorite {
        _ = try model.rxRemoveTags(["tags": [favoriteTag] as AnyObject])
      } else {
        var currentTags = tags
        currentTags.append(favoriteTag as AnyObject)
        
        _ = try model.rxAddTags(currentTags)
      }
      model.commit()
    } catch {
      DDLogError("Error while adding/removing favorite tag.")
    }
  }
  
}
