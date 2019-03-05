//
//  DashboardFavoritesPresenter.swift
//  i2app
//
//  Created by Arcus Team on 12/16/16.
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

import Cornea

protocol DashboardFavoritesProvider {
  weak var delegate: DashboardPresenterDelegate? { get set }

  // MARK: Extended
  func dashboardCurrentFavoritesCount() -> Int
  func fetchDashboardFavorites()
}

extension DashboardFavoritesProvider where Self: DashboardProvider {
  func dashboardCurrentFavoritesCount() -> Int {
    for viewModel in viewModels {
      if let viewModel = viewModel as? DashboardFavoriteViewModel {
        return viewModel.currentFavorites.count
      }
    }

    return 0
  }

  func fetchDashboardFavorites() {
    let viewModel = DashboardFavoriteViewModel()

    let favorites: [AnyObject] = FavoriteOrderedManager.shareInstance().getCurrentFavorites()

    for favorite in favorites {
      let currentFavorite = DashboardFavoriteItemViewModel()
      if let favoriteModel = favorite as? FavoriteSettingModel {
        let model: Model? = favoriteModel.getModel()

        if let modelName = model?.name as String? {
          currentFavorite.name = modelName
        }
        currentFavorite.image = UIImage(named: "PlaceholderWhite")!
        currentFavorite.dataModel = model!

        if let deviceModel = model as? DeviceModel {
          // Load the images for the given device models
          _ = ImageDownloader.downloadDeviceImage(DeviceCapability.getProductId(from: deviceModel),
                                                  withDevTypeId: deviceModel.devTypeHintToImageName(),
                                                  withPlaceHolder: nil,
                                                  isLarge: false,
                                                  isBlackStyle: false).swiftThenInBackground({
                                                    modelAnyObject in

                                                    if let image = modelAnyObject as? UIImage {
                                                      currentFavorite.image = image
                                                    }

                                                    // Handle C2C Device
                                                    if deviceModel.isC2CDevice() {
                                                      let imageName = deviceModel.isDisabledC2CDevice()
                                                        ? "icon_c2c_device_disconnected"
                                                        : "icon_c2c_device_connected"

                                                      currentFavorite.cloudImageView =
                                                        UIImageView(image:UIImage(named: imageName))
                                                    }

                                                    self.delegate?.shouldUpdateCards()
                                                    return nil
                                                  })
        } else if let sceneModel = model as? SceneModel {
          if let imageName: String = sceneModel.getTemplateName(),
            let image = UIImage(named: "scene_\(imageName)_white") {
            currentFavorite.image = image
          }
        }
        viewModel.currentFavorites.append(currentFavorite)
      }
    }

    self.storeViewModel(viewModel)
  }
}
