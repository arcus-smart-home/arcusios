//
//  DashboardHistoryPresenter.swift
//  i2app
//
//  Created by Arcus Team on 12/15/16.
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

protocol DashboardHistoryProvider {
  // Mark: Extended
  func dashboardHistoryEntriesCount() -> Int
  func fetchDashboardHistory()
}

extension DashboardHistoryProvider where Self: DashboardProvider {
  func dashboardHistoryEntriesCount() -> Int {
    for viewModel in viewModels {
      if let historyViewModel = viewModel as? DashboardHistoryViewModel {
        return historyViewModel.historyEntries.count
      }
    }

    return 0
  }

  func fetchDashboardHistory() {
    DispatchQueue.global(qos: .background).async {
      guard let settings = RxCornea.shared.settings,
        let currentPlace = settings.currentPlace else { return }

      let historyViewModel = DashboardHistoryViewModel()

      _ = PlaceCapability.listDashboardEntries(withLimit: 3, withToken: "", on: currentPlace)
        .swiftThenInBackground({
          modelAnyObject in

          historyViewModel.historyEntries = [DashboardHistoryItemViewModel]()

          if let response = modelAnyObject as? PlaceListDashboardEntriesResponse,
            let results = response.getResults() {

            for result in results {
              guard let result = result as? [String: AnyObject] else { continue }

              let historyEntry = DashboardHistoryItemViewModel()
              let model = Model(attributes: result)
              let timeStamp = model.getAttribute("timestamp") as? NSNumber
              let eventTime = Date(timeIntervalSince1970: (timeStamp?.doubleValue)!/1000)
              let secondsSinceTime = fabs(eventTime.timeIntervalSinceNow)
              let secondsPerDay: Double = 60 * 60 * 24
              let olderThanAday = secondsSinceTime > secondsPerDay

              historyEntry.name = (model.getAttribute("subjectName") as? String)!
              historyEntry.entry = (model.getAttribute("longMessage") as? String)!
              historyEntry.time = (eventTime as NSDate).formatDateTimeStamp()

              // If the entry is older than a day then append a date stamp to the time
              if olderThanAday,
                let dateString = (eventTime as NSDate).formatDateStamp() {
                historyEntry.time = "\(historyEntry.time)\n\(dateString)"
              }

              // If a user is Basic only show the entry if it is less than a day old.

              var isPremium = false
              if let premium = RxCornea.shared.settings?.isPremiumAccount() {
                isPremium = premium
              }
              if isPremium || !olderThanAday {
                historyViewModel.historyEntries.append(historyEntry)
              }
            }
          }

          self.storeViewModel(historyViewModel)

          return nil
        })
    }
  }
}
