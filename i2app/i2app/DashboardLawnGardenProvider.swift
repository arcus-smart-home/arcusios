//
//  DashboardLawnGardenProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/1/17.
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

protocol DashboardLawnGardenProvider {
  // MARK: Extended
  func fetchDashboardLawnGarden()
}

extension DashboardLawnGardenProvider where Self: DashboardProvider {
  func fetchDashboardLawnGarden() {
    let viewModel = DashboardLawnGardenViewModel()

    if let controller: LawnNGardenSubsystemController =
      SubsystemsController.sharedInstance().lawnNGardenController {
      if controller.isAvailable() {
        viewModel.isEnabled = true

        let currentlyWateringZones: Int32 = controller.getCurrentlyWateringZonesCount(nil)
        if let nextZoneTime = controller.getNextZoneTime() as NSDate? {
          let formattedTime: String = nextZoneTime.formatBasedOnDayOfWeekAndHoursIncludingToday()
          let separatedWords: [String] = formattedTime.components(separatedBy: " ")
          if separatedWords.count > 0 {
            if !separatedWords[0].isEmpty {
              viewModel.scheduleDay = separatedWords[0]

              if separatedWords.count >= 3 {
                viewModel.scheduleTime = "\(separatedWords[1]) \(separatedWords[2].uppercased())"
              }
            }
          }
        }

        if currentlyWateringZones > 0 {
          viewModel.onIndicator = true
          viewModel.activeCount = Int(currentlyWateringZones)
        }
      }
    }

    self.storeViewModel(viewModel)
  }
}
