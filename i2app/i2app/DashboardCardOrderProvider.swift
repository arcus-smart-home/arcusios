//
//  DashboardCardOrderProvider.swift
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

protocol DashboardCardOrderProvider {
  var viewModels: [DashboardCardViewModel] {get set}

  func fetchCompletedDashboardCardViewModelsArray(_ viewModels: [DashboardCardViewModel])

  // MARK: Extended
  func fetchDashboardCardViewModelsArray()
  func viewModelIndexForType(_ type: DashboardCardType) -> Int
}

extension DashboardCardOrderProvider {
  func fetchDashboardCardViewModelsArray() {

    // Disallow this method from executing on a background thread as doing so will cause threading issues
    // when anothe thread mutates viewModels while we access it
    DispatchQueue.main.async {
      var orderedModels = [DashboardCardViewModel]()

      // Go through the old cards to build a new ordered array of view models
      if let oldCardModels = DashboardCardsManager.shareInstance().getEnabledCards()
        as? [DashboardCardModel] {
        for cardModel in oldCardModels {
          // The view model should be optional in case the old cards have a type not supported
          var viewModel: DashboardCardViewModel?

          // create a new view model according to the type of the card
          switch cardModel.type {
          case DashboardCardTypeFavorites:
            viewModel = DashboardFavoriteViewModel()
          case DashboardCardTypeHistory:
            viewModel = DashboardHistoryViewModel()
          case DashboardCardTypeLightsSwitches:
            viewModel = DashboardLightsSwitchesViewModel()
          case DashboardCardTypeClimate:
            viewModel = DashboardClimateViewModel()
          case DashboardCardTypeDoorsLocks:
            viewModel = DashboardDoorsLocksViewModel()
          case DashboardCardTypeCameras:
            viewModel = DashboardCamerasViewModel()
          case DashboardCardTypeWater:
            viewModel = DashboardWaterViewModel()
          case DashboardCardTypeCare:
            viewModel = DashboardCareViewModel()
          case DashboardCardTypeLawnGarden:
            viewModel = DashboardLawnGardenViewModel()
          case DashboardCardTypeAlarms:
            viewModel = DashboardAlarmsViewModel()
          case DashboardCardTypeHomeFamily:
            viewModel = DashboardHomeFamilyViewModel()
          case DashboardCardTypeSantaTracker:
            viewModel = DashboardSantaTrackerViewModel()
          default: break
          }

          if viewModel != nil {
            // Check if there is already a type of this model in the current view models.
            // Doing this will preserve the data.
            let indexOfModel: Int = self.viewModelIndexForType(viewModel!.type)
            if indexOfModel != NSNotFound && indexOfModel < self.viewModels.count {
              viewModel = self.viewModels[indexOfModel]
            }

            // Update the view model enableness for the new order
            viewModel!.isEnabled = cardModel.getDefineServiceCardType() != DashboardCardStatusDisabled

            orderedModels.append(viewModel!)
          }
        }
      }

      self.fetchCompletedDashboardCardViewModelsArray(orderedModels)
    }

  }
}
