//
//  DashboardPlacesProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/2/17.
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

protocol DashboardPlacesProvider {
  func fetchCompletedDashboardPlaces(_ placeModalModels: [ArcusModalSelectionModel])

  // MARK: Extended
  func fetchDashboardPlaces()
}

extension DashboardPlacesProvider {
  func fetchDashboardPlaces() {
    DispatchQueue.global(qos: .background).async {
      // TODO: Refactor Provider to conform to protocol instead of using class.
      _ = SessionController.listAvailablePlaces()
        .swiftThenInBackground({ modelAnyObject in

        var placeModalModels = [ArcusModalSelectionModel]()

        if let models = modelAnyObject as? [PlaceAndRoleModel] {
          for model in models {
            let modalModel = ArcusModalSelectionModel()
            modalModel.title = model.placeName
            modalModel.itemDescription = model.placeLocation()
            modalModel.tag = model.placeId
            if let currentPlace: PlaceModel = RxCornea.shared.settings?.currentPlace {
              let isSelected: Bool = model.placeId == currentPlace.modelId as String
              modalModel.isSelected = isSelected
            }

            if let settings: ArcusSettings = RxCornea.shared.settings,
              let image: UIImage = settings.fetchHomeImage(model.placeId) {
              modalModel.image = image
            }

            placeModalModels.append(modalModel)
          }
        }

        self.fetchCompletedDashboardPlaces(placeModalModels)

        return nil
      })
    }
  }
}
