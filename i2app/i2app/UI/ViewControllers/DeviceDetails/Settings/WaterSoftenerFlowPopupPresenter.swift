//
//  WaterSoftenerFlowPopupPresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/20/17.
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

/*
 `WaterFlowPopupPresenter` defines the expected properties of a presenter used by a `PopupSelectionBaseContainer` for Water Flow Popups.
 **/
protocol WaterFlowPopupPresenter {
  weak var delegate: WaterFlowPopupPresenterDelegate? { get set }

  var device: DeviceModel { get set }
  var settingItems: [WaterFlowViewModel] { get }
  var selectedIndex: Int { get }

  /**
   Update Continuous Water Flow alerts.

   - Parameter alertLevel:  Double indicating the level of flow for alerts.
   */
  func updateContinuous(_ alertLevel: Double)
}

/*
 `WaterFlowPopupPresenterDelegate` defines the expected behavior of a class that implements `WaterFlowPopupPresenter`
 **/
protocol WaterFlowPopupPresenterDelegate: class {
  /**
   Used to update the layout of WaterFlowPopupPresenterDelegate.
   */
  func updateLayout()
}

class WaterSoftenerFlowPopupPresenter: WaterFlowPopupPresenter, EcoWaterController {
  weak var delegate: WaterFlowPopupPresenterDelegate?
  var device: DeviceModel

  var settingItems: [WaterFlowViewModel] {
    return [WaterFlowViewModel("Off",
                               description: "Disable Push Notification and Email",
                               value: 0.0),
            WaterFlowViewModel("Low (0.3 GPM or more)",
                               description: "Faucet Trickeling",
                               value: 0.3),
            WaterFlowViewModel("Medium (2.0 GM or more)",
                               description: "Faucet Left Running",
                               value: 2.0),
            WaterFlowViewModel("High (8.0 GPM or more)",
                               description: "Several Faucets Left Running or a Burst Pipe",
                               value: 8.0)]

  }

  var selectedIndex: Int {
    let rate = getContinuousRate(device)
    let index = settingItems.index(where: { (vm) -> Bool in
      vm.value == rate
    })

    if index != nil {
      return index!
    }
    return 0
  }

  required init(_ delegate: WaterFlowPopupPresenterDelegate?,
                device: DeviceModel) {
    self.delegate = delegate
    self.device = device
  }

  func updateContinuous(_ alertLevel: Double) {
    DispatchQueue.global(qos: .background).async {
      _ = self.setContinuous(self.device, rate: alertLevel)
        .swiftThenInBackground {
          _ in
          _ = self.setContinuousFlow(self.device, alert: (alertLevel > 0.0))
            .swiftThen {
              _ in
              self.delegate?.updateLayout()
              return nil
          }
          return nil
      }
    }
  }
}

/*
 `WaterFlowViewModel` defines the viewModel to be used to represent different flow levels
 of a Water Softener.
 **/
struct WaterFlowViewModel {
  var title: String
  var description: String
  var value: Double

  init(_ title: String, description: String, value: Double) {
    self.title = title
    self.description = description
    self.value = value
  }
}
