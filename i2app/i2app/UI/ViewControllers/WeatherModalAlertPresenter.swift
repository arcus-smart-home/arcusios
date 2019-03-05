//
//  WeatherModalAlertPresenter.swift
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

let kWeatherAlertDontShowAgain: String = "WeatherModalAlertDontShowAgain"

class WeatherModalAlertPresenter: ModalAlert, ModalAlertPresenter, ModalAlertInfoPresenter {
  var alertIdentifier: String = "Weather"

  required init(placeModel: PlaceModel,
                alertPriority: ModalAlertPriority,
                alertedDeviceInfo: [[String : AnyObject]],
                date: Date) {
    super.init(placeModel: placeModel,
               alertPriority: alertPriority,
               alertedDeviceInfo: alertedDeviceInfo,
               date: date)
  }

  required init(placeModel: PlaceModel,
                alertPriority: ModalAlertPriority,
                alertedDeviceInfo: [[String : AnyObject]],
                date: NSDate) {
      fatalError("init(placeModel:alertPriority:alertedDeviceInfo:date:) has not been implemented")
  }

  // MARK: ModalAlertPresenter

  func navigationTitle() -> String {
    return "Weather Radio Alert"
  }

  func navigationBarColor() -> UIColor {
    return UIColor(red: 0.0/255.0,
                   green: 0.0/255.0,
                   blue: 255.0/255.0,
                   alpha: 1.0)
  }

  func navigationTextColor() -> UIColor {
    return UIColor.white
  }

  func place() -> PlaceModel {
    return placeModel
  }

  func iconName() -> String {
    return "weather_hush"
  }

  func description() -> String {
    return "Tap Snooze to stop the\n"
      + "audible notifications.\n\n"
      + "Pressing the center Halo button will\n"
      + "also snooze the device.\n\n"
      + "To unsubscribe from this weather alert,\n"
      + "go to Halo's detail page under More."
  }

  func cellIdentifier() -> String {
    return "titleOnlyCell"
  }

  func showDoneButton() -> Bool {
    return false
  }

  func doneButtonTitle() -> String? {
    return nil
  }

  func primaryActionTitle() -> String? {
    return "Continue Playing"
  }

  func secondaryActionTitle() -> String? {
    return "Snooze Alert"
  }

  func primaryAction() {
    NotificationCenter.default
      .post(name: Notification.Name.dismissModalAlert, object: nil)
  }

  func secondaryAction() {
    DispatchQueue.global(qos: .background).async {
      _ = SubsystemsController.sharedInstance()
        .weatherSubsystemController.snoozeAllWeatherAlerts()
        .swiftThen { _ in
          if self.dontShowSnoozeInfo() == false {
            self.delegate?.executeSegue("ModalAlertInfoSegue")
          } else {
            NotificationCenter.default
              .post(name: Notification.Name.dismissModalAlert, object: nil)
          }
          return nil
      }
    }
  }

  func descriptionTextForDevice(_ deviceModel: DeviceModel) -> String? {
    return nil
  }

  func modalAlertInfoPresenter() -> ModalAlertInfoPresenter? {
    return self
  }

  // MARK: ModalAlertInfoPresenter

  func titleLabelText() -> String {
    return "Alarm Snoozed"
  }

  func descriptionLabelText() -> String {
    return "If anything changes about this alert,\n" +
      "(i.e. End time, type of alert) the device's\n" +
    "speaker will let you know."
  }

  func optionLabelText() -> String {
    return "Don't show me this again"
  }

  func optionAction(_ selected: Bool) {
    let prefs = UserDefaults.standard
    prefs.set(selected, forKey: kWeatherAlertDontShowAgain)
    prefs.synchronize()
  }

  func optionEnabled() -> Bool {
      return true
  }

  func doneAction() {
    if checkForCachedSnoozeValue() == false {
      setDefaultSnoozeValue()
    }
    NotificationCenter.default
      .post(name: Notification.Name.dismissModalAlert, object: nil)
  }

  // MARK: Private Methods

  func dontShowSnoozeInfo() -> Bool {
    let prefs = UserDefaults.standard
    return prefs.bool(forKey: kWeatherAlertDontShowAgain)
  }

  func checkForCachedSnoozeValue() -> Bool {
    let prefs = UserDefaults.standard
    return prefs.object(forKey: kWeatherAlertDontShowAgain) != nil
  }

  func setDefaultSnoozeValue() {
    optionAction(true)
  }
}
