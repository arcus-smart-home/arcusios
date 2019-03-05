//
//  PresmokeAlertModalPresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/20/16.
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

import UIKit
import Cornea

class PresmokeModalAlertPresenter: ModalAlert, ModalAlertPresenter {
  var alertIdentifier: String = "Presmoke"

  required init(placeModel: PlaceModel,
                alertPriority: ModalAlertPriority,
                alertedDeviceInfo: [[String : AnyObject]],
                date: Date) {
    super.init(placeModel: placeModel,
               alertPriority: alertPriority,
               alertedDeviceInfo: alertedDeviceInfo, date: date)
    configureAlertInfoWithPresmokeTitle()
  }

  required init(placeModel: PlaceModel,
                alertPriority: ModalAlertPriority,
                alertedDeviceInfo: [[String : AnyObject]],
                date: NSDate) {
      fatalError("init(placeModel:alertPriority:alertedDeviceInfo:date:) has not been implemented")
  }

  func navigationTitle() -> String {
    return "Early Smoke Warning"
  }

  func navigationBarColor() -> UIColor {
    return UIColor(red: 252.0/255.0,
                   green: 182.0/255.0,
                   blue: 0.0/255.0,
                   alpha: 1.0)
  }

  func place() -> PlaceModel {
    return placeModel
  }

  func iconName() -> String {
    return "hush"
  }

  // NOTE: PreSmoke description currently has Halo specific instructions.
  func description() -> String {
    return "If smoke levels increase, the Safety Alarm will\n"
      + "trigger, and your Alarm Notification\n"
      + "List will be contacted.\n\n"
      + "Silence the triggered device by\n"
      + "pressing the center Halo button."
  }

  func showDoneButton() -> Bool {
    return true
  }

  func doneButtonTitle() -> String? {
    return "Done"
  }

  func descriptionTextForDevice(_ deviceModel: DeviceModel) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = "h:mm a"

    return dateFormatter.string(from: alertDate as Date)
  }

  override func updatePresenterModels(_ place: PlaceModel,
                                      deviceInfo: [[String : AnyObject]],
                                      date: Date) {
    super.updatePresenterModels(place,
                                deviceInfo: deviceInfo,
                                date: date)
    configureAlertInfoWithPresmokeTitle()
  }

  // MARK: Private Methods

  fileprivate func alertTitle() -> String {
    return "Early Smoke Warning Detected."
  }

  fileprivate func configureAlertInfoWithPresmokeTitle() {
    if alertedDeviceInfo.count > 0 {
      var alertInfo: [String : AnyObject] = alertedDeviceInfo[0]
      alertInfo["alertTitle"] = alertTitle() as AnyObject?
      alertedDeviceInfo = [alertInfo]
    }
  }
}
