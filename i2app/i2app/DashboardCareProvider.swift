//
//  DashboardCareProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/5/17.
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

protocol DashboardCareProvider {
  // MARK: Extended
  func fetchDashboardCare()
}

extension DashboardCareProvider where Self: DashboardProvider {
  func fetchDashboardCare() {
    DispatchQueue.global(qos: .background).async {
      let viewModel = DashboardCareViewModel()

      if NavigationBarAppearanceManager.sharedInstance.incidentTypes.contains(.care) {
        viewModel.backgroundColor = Appearance.carePurple
      } else {
        viewModel.backgroundColor = UIColor.clear
      }

      if let controller = SubsystemsController.sharedInstance().careController,
        let settings: ArcusSettings = RxCornea.shared.settings,
          settings.isPremiumAccount() == true &&
          controller.allDeviceIds.count > 0 {
        viewModel.isEnabled = true

        if controller.numberOfBehaviors() > 0 {
          if controller.getCareAlarmMode() == CareAlarmMode.on {
            viewModel.status = "On"
          } else {
            viewModel.status = "Off"
          }
        }
        _ = controller
          .careActivityDetails(withLimit: 1, withToken: "", withDevices: controller.activeDeviceIds())
          .swiftThenInBackground({ modelAnyObject in
            if let activityDetails = modelAnyObject as? [AnyHashable: Any],
              let results = activityDetails["results"] as? [[AnyHashable: Any]],
              let info: [AnyHashable: Any] = results.first,
              let timestamp = info["timestamp"] as? Double {

              let date: String = (Date(milliseconds: timestamp) as NSDate).formatDeviceLastEvent()!
              let dateComponents: [String] = date.components(separatedBy: " ")

              if dateComponents.count > 0 {
                if dateComponents.count == 1 {
                  viewModel.relativeTime = date
                  viewModel.timePeriod = ""
                } else if dateComponents.count >= 3 {
                  if dateComponents[0] == "at" {
                    viewModel.relativeTime = dateComponents[1]
                    viewModel.timePeriod = dateComponents[2].uppercased()
                  } else {
                    var monthDateComponents = date.components(separatedBy: ",")
                    viewModel.relativeTime = "\(monthDateComponents[0])"
                  }
                } else {
                  var monthDateComponents = date.components(separatedBy: ",")
                  viewModel.relativeTime = "\(monthDateComponents[0])"
                }
              }
            }
            self.storeViewModel(viewModel)
            return nil
          })
      }
    }
  }
}
