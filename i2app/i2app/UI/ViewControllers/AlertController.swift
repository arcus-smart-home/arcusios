//
//  AlertController.swift
//  i2app
//
//  Created by Arcus Team on 11/1/16.
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

protocol AlertControllerDelegate: class {
  func showAlertModal(_ modalAlertPresenter: ModalAlertPresenter)
  func dismissAlertModal(_ modalAlertPresenter: ModalAlertPresenter)
}

protocol AlertControllerProtocol {
  weak var delegate: AlertControllerDelegate? { get set }
  var currentPlace: PlaceModel { get set }
  var preventAlertDisplay: Bool { get set }

  func observeAlertNotifications(_ notificationNames: [String], selector: Selector)
  func removeAlertNotificationObservers(_ notificationNames: [String])
  func removeAllAlertNotificationObservers()
  func alertNotificationReceived(_ notification: Notification)
  func processAlertEvent(_ notification: Notification)
  func processExistingAlertEvents()
  func alertInfoFromSubsystem(_ subsystem: SubsystemModel) ->
    (alertState: String?, alertDate: Date?, alertInfo: [[String : AnyObject]]?)
  func alertedDevicesForSubsytem(_ subsystem: SubsystemModel) -> [[String : AnyObject]]
  func configurePresenter(_ placeModel: PlaceModel,
                          alertInfo: [[String : AnyObject]],
                          alertDate: Date)
  func showAlertWithPresenter(_ presenter: ModalAlertPresenter?)
  func dismissAlertWithPresenter(_ presenter: ModalAlertPresenter?)
  func processPriorityAlarm() -> Bool
  func isNewCountGreaterThanOldCount(_ old: [[String : AnyObject]]?,
                                     new: [[String : AnyObject]]?) -> Bool
}

extension AlertControllerProtocol {
  func showAlertWithPresenter(_ presenter: ModalAlertPresenter?) {
    if presenter != nil {
      if preventAlertDisplay != true {
        delegate?.showAlertModal(presenter!)
      }
    }
  }

  func dismissAlertWithPresenter(_ presenter: ModalAlertPresenter?) {
    if presenter != nil {
      delegate?.dismissAlertModal(presenter!)
    }
  }

  /// Return true if a higher level alarm is active
  func processPriorityAlarm() -> Bool {
    return NavigationBarAppearanceManager.sharedInstance.currentColorScheme != .none
      || NavigationBarAppearanceManager.sharedInstance.currentIncidentState != .complete
  }
}

/**
 * Temporary class used to help get around issues with extending protocol in Swift 2.3
 * Will refactor once we are using Swift 3
 **/
class AlertController: NSObject {
  weak var delegate: AlertControllerDelegate?
  var currentPlace: PlaceModel
  var preventAlertDisplay: Bool = false

  // MARK: Life Cycle

  required init(delegate: AlertControllerDelegate, currentPlace: PlaceModel) {
    self.delegate = delegate
    self.currentPlace = currentPlace
    super.init()
  }

  deinit {
    removeAllAlertNotificationObservers()
  }

  // MARK: AlertControllerProtocol

  func observeAlertNotifications(_ notificationNames: [String], selector: Selector) {
    for name in notificationNames {
      NotificationCenter.default
        .addObserver(self,
                     selector: selector,
                     name: Notification.Name(rawValue: name),
                     object: nil)
    }
  }

  func removeAlertNotificationObservers(_ notificationNames: [String]) {
    for name in notificationNames {
      NotificationCenter.default
        .removeObserver(self, name: Notification.Name(rawValue: name), object: nil)
    }
  }

  func removeAllAlertNotificationObservers() {
    NotificationCenter.default
      .removeObserver(self)
  }

}
